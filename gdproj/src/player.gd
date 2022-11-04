class_name Player
extends CharacterBody2D

@export var speed: float = 150.0

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	var _r := move_and_slide()
