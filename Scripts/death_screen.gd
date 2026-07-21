extends CanvasLayer
@onready var DeathScrn = $"."

func _ready() -> void:
	DeathScrn.visible = false
	get_tree().paused = false

func _on_main_menu_pressed() -> void:
	DeathScrn.visible = false
	get_tree().paused = false
	Globals.PlrHealth = 100
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
