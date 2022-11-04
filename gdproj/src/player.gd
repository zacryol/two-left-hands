class_name Player
extends CharacterBody2D

## Movement Speed.
@export var speed: float = 150.0

@onready var _anim_tree := $AnimationTree as AnimationTree

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		pass

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_blend_position(input_dir)
	velocity = input_dir * speed
	var _r := move_and_slide()


## Sets the blend position used for movement direction animations
func set_blend_position(pos: Vector2):
	_anim_tree.set("parameters/Standard/blend_position", pos)
