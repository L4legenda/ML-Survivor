extends Control

@onready var hp_progress_bar: TextureProgressBar = $HPProgressBar
@onready var hungry_progress_bar: TextureProgressBar = $HungryProgressBar

func _ready() -> void:
	update_hp()
	update_hungry()

func _process(delta: float) -> void:
	update_hp()
	update_hungry()

func update_hp() -> void:
	hp_progress_bar.max_value = owner.healpoint_max
	hp_progress_bar.value = owner.healpoint

func update_hungry() -> void:
	hungry_progress_bar.max_value = owner.hungry_max
	hungry_progress_bar.value = owner.hungry
