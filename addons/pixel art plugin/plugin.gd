@tool
extends EditorPlugin

var main_panel_instance

func _enter_tree():
	# Load the scene and add it to the editor's main screen
	main_panel_instance = preload("res://addons/pixel art plugin/pixelart.tscn").instantiate()
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)

func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name():
	return "PixelArtEditor"
