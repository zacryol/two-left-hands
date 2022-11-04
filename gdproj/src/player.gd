class_name Player
extends CharacterBody2D

## Movement Speed.
@export var speed: float = 150.0

@onready var _anim_tree := $AnimationTree as AnimationTree
@onready var _state_machine := _anim_tree.get(&"parameters/playback") as AnimationNodeStateMachinePlayback

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		_state_machine.travel(&"Attack")
		pass


func _physics_process(_delta: float) -> void:
	match _state_machine.get_current_node():
		&"Standard":
			var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
			set_blend_position(input_dir)
			velocity = input_dir * speed
			var _r := move_and_slide()
		_:
			pass


## Sets the blend position used for various animations.
## The movement direction is set, and if the vector is not Zero, attack dir is set
func set_blend_position(pos: Vector2):
	_anim_tree.set(&"parameters/Standard/blend_position", pos)
	if pos.length_squared() > 0.1:
		_anim_tree.set(&"parameters/Attack/dir/blend_position", pos)
