extends CanvasLayer

@onready var qbutton := $ColorRect/VBoxContainer/Quit as Button

func _ready() -> void:
	if OS.get_name() == "Web":
		qbutton.hide() # don't allow "quitting" a web version


func _on_player_died() -> void:
	show()
	get_tree().paused = true


func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	if get_tree().reload_current_scene() != OK:
		push_error("Failed to reload scene.")
		get_tree().quit(1)


func _on_quit_pressed() -> void:
	get_tree().quit()
