extends Node

@export var microwave: Microwave

var _dialogue_timer: Timer = null
var _dialogue_lines: Array[String] = []

func _ready() -> void:
	if microwave == null:
		microwave = get_parent() as Microwave

func start_dialogue_loop(dialogue_lines: Array[String]) -> void:
	if dialogue_lines == null or dialogue_lines.is_empty():
		_emit_dialogue("")
		return
	_dialogue_lines = dialogue_lines
	_emit_dialogue(_dialogue_lines[randi() % _dialogue_lines.size()])
	if _dialogue_timer == null:
		_dialogue_timer = Timer.new()
		_dialogue_timer.one_shot = false
		_dialogue_timer.wait_time = 2.5
		add_child(_dialogue_timer)
		_dialogue_timer.timeout.connect(_on_dialogue_timer_timeout)
	_dialogue_timer.start()

func stop_dialogue_loop() -> void:
	if _dialogue_timer != null:
		_dialogue_timer.stop()
		_dialogue_timer.queue_free()
		_dialogue_timer = null
	_emit_dialogue("")
	_dialogue_lines.clear()

func _on_dialogue_timer_timeout() -> void:
	if microwave == null or not microwave.started or microwave.what_is_inside == null:
		stop_dialogue_loop()
		return
	if _dialogue_lines.is_empty():
		_emit_dialogue("")
		return
	_emit_dialogue(_dialogue_lines[randi() % _dialogue_lines.size()])

func _emit_dialogue(text: String) -> void:
	Signalbus.food_talked.emit(text)
