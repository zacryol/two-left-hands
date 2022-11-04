class_name Player
extends CharacterBody2D

@export var speed: float = 150.0
@onready var anim_tree := $AnimationTree as AnimationTree

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_blend_position(input_dir)
	velocity = input_dir * speed
	var _r := move_and_slide()


func set_blend_position(pos: Vector2):
	anim_tree.set("parameters/BlendSpace2D/blend_position", pos)
