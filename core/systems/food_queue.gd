class_name FoodQueue extends Node

@onready var microwave: Microwave = $"../Microwave"

@export var queue: Array[Food] = []

func _ready():
	Signalbus.food_cooked.connect(self._on_food_cooked)

func _on_food_cooked(food: Food):
	queue.append(food)
