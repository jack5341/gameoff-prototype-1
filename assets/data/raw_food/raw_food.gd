class_name RawFood extends Base

@export_group("Cooking")
@export var time_to_cook: float = 10.0
@export var difficulty_to_cook: int = 1
@export var base_points: int = 10

@export_group("Cooking Rates")
@export var blue_rate: float = 0.6
@export var green_rate: float = 1.0
@export var red_rate: float = 1.7
@export var burn_time_threshold: float = 2.5

@export_group("Temperature")
@export var burn_temprature: int = 100
@export var raw_temprature: int = 0

@export_group("Microwave")
@export var plate_rpm: float = 90.0
@export var power_level: float = 1.0
@export var temperature_level: float = 1.0

@export_group("Gameplay")
@export var dialogue_lines: Array[String] = []
@export var food: Food = null

@export_group("Balance Bar")
@export var balance_speed: float = 1.0  # Speed of arrow movement (units per second)
@export var balance_direction: int = 1  # 1 = left to right, -1 = right to left (for future use)