class_name Microwave extends Node3D

@export var what_is_inside: RawFood = null
@export var temperature: int = 0
@export var door_open: bool = true
@export var started: bool = false

@onready var plate: CSGCylinder3D = $Plate
@onready var light: SpotLight3D = $Light
@onready var door: Node3D = $Door
@onready var timer: Timer = $Timer

var rotation_speed: float = 90.0  # degrees per second

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	_handle_rotate_plate(delta)
	_handle_light(delta)

func _handle_rotate_plate(delta: float) -> void:
	if started and !door_open and what_is_inside != null:
		plate.rotate_y(deg_to_rad(rotation_speed * delta))

func _handle_light(_delta: float) -> void:
	if started and !door_open:
		light.visible = true
	else:
		light.visible = false

func start_cooking() -> void:
	if what_is_inside == null or door_open or !started:
		return
	started = true
	timer.start(what_is_inside.time_to_cook)

func _on_timer_timeout() -> void:
	if what_is_inside == null:
		return
	Signalbus.food_cooked.emit(what_is_inside.food)
	what_is_inside = null
	started = false
	door_open = true
	timer.stop()