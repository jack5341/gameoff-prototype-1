extends Control
class_name BalanceBar

@export var arrow_speed: float = 500.0
@export var drift_speed: float = 60.0

@onready var bar_content: Control = $"Center/BarContent"
@onready var zone: ColorRect = $"Center/BarContent/ZoneHBox/Zone"
@onready var arrow: ColorRect = $"Center/BarContent/ArrowLayer/Arrow"

var arrow_ratio: float = 0.5
var drift_dir: float = 1.0
var zone_left_global: float = 0.0
var zone_right_global: float = 0.0

func _ready() -> void:
	_update_zone_bounds()
	_update_arrow_position()
	set_process(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_zone_bounds()
		_update_arrow_position()

func _process(delta: float) -> void:
	var input_dir: float = 0.0
	if Input.is_physical_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		input_dir -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		input_dir += 1.0
	
	var bar_width: float = max(1.0, bar_content.size.x)
	var pixels_per_second: float = input_dir * arrow_speed + drift_dir * drift_speed
	var delta_ratio: float = pixels_per_second * delta / bar_width
	arrow_ratio = clamp(arrow_ratio + delta_ratio, 0.0, 1.0)
	
	if is_equal_approx(arrow_ratio, 0.0) or is_equal_approx(arrow_ratio, 1.0):
		drift_dir *= -1.0
	
	_update_arrow_position()
	_update_arrow_color()

func _update_zone_bounds() -> void:
	if zone == null:
		return
	zone_left_global = zone.global_position.x
	zone_right_global = zone_left_global + zone.size.x

func _update_arrow_position() -> void:
	if arrow == null or bar_content == null:
		return
	var x: float = bar_content.global_position.x + arrow_ratio * bar_content.size.x - arrow.size.x * 0.5
	arrow.global_position.x = x
	# Vertically center the arrow in BarContent
	arrow.global_position.y = bar_content.global_position.y + (bar_content.size.y - arrow.size.y) * 0.5

func _update_arrow_color() -> void:
	if arrow == null:
		return
	var arrow_center_x: float = arrow.global_position.x + arrow.size.x * 0.5
	var inside: bool = arrow_center_x >= zone_left_global and arrow_center_x <= zone_right_global
	arrow.color = Color(0.95, 0.95, 0.95, 1.0) if inside else Color(1.0, 0.4, 0.4, 1.0)
