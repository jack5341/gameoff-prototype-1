class_name RawFoodQueue extends Node

@onready var microwave: Microwave = $"../Microwave"

@export var max_queue_size: int = 5
@export var cycles_to_run: int = 5

var completed_cycles: int = 0
@export var available_raw_foods: Array[RawFood] = []

var _spawn_timer: Timer
var awaiting_finish: bool = false

func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.wait_time = 0.25
	add_child(_spawn_timer)
	_spawn_timer.timeout.connect(_on_spawn_tick)
	_spawn_timer.start()
	Signalbus.cooking_cycle_completed.connect(_on_cooking_cycle_completed)
	set_process(true)

func _on_spawn_tick() -> void:
	if completed_cycles >= cycles_to_run:
		_spawn_timer.stop()
		return
	if awaiting_finish:
		return
	if microwave == null or not is_instance_valid(microwave):
		microwave = get_node_or_null("../Microwave")
		return
	# Skip if microwave is busy
	if microwave.started or microwave.what_is_inside != null:
		return
	if available_raw_foods.is_empty():
		return
	var raw: RawFood = available_raw_foods.pick_random()
	Signalbus.request_raw_food_cook.emit(raw)
	completed_cycles += 1

func _on_cooking_cycle_completed() -> void:
	awaiting_finish = true
	Signalbus.waiting_for_finish_changed.emit(true)

func _process(_delta: float) -> void:
	if awaiting_finish and Input.is_action_just_pressed("finish"):
		awaiting_finish = false
		Signalbus.waiting_for_finish_changed.emit(false)
