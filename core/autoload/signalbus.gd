extends Node

@warning_ignore("UNUSED_SIGNAL")
signal food_cooked(food: Food)
@warning_ignore("UNUSED_SIGNAL")
signal cooking_cycle_completed()
@warning_ignore("UNUSED_SIGNAL")
signal score_changed(score: int)
@warning_ignore("UNUSED_SIGNAL")
signal time_remaining_changed(seconds: int)
@warning_ignore("UNUSED_SIGNAL")
signal request_raw_food_cook(raw: RawFood)
@warning_ignore("UNUSED_SIGNAL")
signal waiting_for_finish_changed(active: bool)
