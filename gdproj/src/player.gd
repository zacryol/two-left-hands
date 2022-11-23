## Player class, as a part of the Player scene
class_name Player
extends CharacterBody2D

signal died

var KnifeScene := preload("res://src/knife.tscn") as PackedScene

## Movement Speed.
@export var speed: float = 150.0
## Dash Speed.
@export var dash_speed: float = 500.0
var _dash_dir := Vector2.RIGHT

@onready var _anim_tree := $AnimationTree as AnimationTree
@onready var _state_machine := _anim_tree.get(&"parameters/playback") as AnimationNodeStateMachinePlayback
@onready var iframes := $InvulnTimer as Timer
@onready var hurtbox := $Hurtbox/CollisionShape2D as CollisionShape2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var health_bar := $UI/HealthBar as ProgressBar
@onready var potion_grabber := $PotionGrabber as Area2D

var _max_hp := 100
var _hp := _max_hp:
	set(new_hp):
		_hp = mini(new_hp, _max_hp)
		health_bar.value = new_hp
		if _hp <= 0:
			die()

func _ready() -> void:
	health_bar.max_value = _max_hp
	health_bar.min_value = 0
	health_bar.value = _hp


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"action1"):
		_state_machine.travel(&"Attack")
	elif event.is_action_pressed(&"action2") and \
			_state_machine.get_current_node() == &"Standard":
		_throw_knife()
	elif event.is_action_pressed(&"action3"):
		_state_machine.travel(&"AxeAttack")
	elif event.is_action_pressed(&"dash"):
		_state_machine.travel(&"dash")
	elif event.is_action_pressed(&"action4"):
		pass
	elif event.is_action_pressed(&"action5"):
		for a in potion_grabber.get_overlapping_areas():
			if not a.is_in_group(&"potion"):
				continue
			_hp = _max_hp
			a.queue_free()
			break


func _physics_process(delta: float) -> void:
	match _state_machine.get_current_node():
		&"Standard":
			var input_dir := Input.get_vector(&"move_left", &"move_right",
					&"move_up", &"move_down")
			set_blend_position(input_dir)
			velocity = input_dir * speed
			var _r := move_and_slide()
		&"dash":
			var move := _dash_dir * dash_speed * delta
			var _c := move_and_collide(move)
		_:
			pass


func die() -> void:
	died.emit()


func hit() -> void:
	if not iframes.is_stopped(): return
	if _state_machine.get_current_node() == &"dash": return
	#print("ouch")
	#print(Engine.get_physics_frames())
	hurtbox.set_deferred(&"disabled", true)
	sprite.self_modulate.a8 = 128
	iframes.start()
	_hp -= 1


## Sets the blend position used for various animations.
## The movement direction is set, and if the vector is not Zero, attack dir is set
func set_blend_position(pos: Vector2) -> void:
	_anim_tree.set(&"parameters/Standard/blend_position", pos)
	if pos.length_squared() > 0.1:
		_anim_tree.set(&"parameters/Attack/dir/blend_position", pos)
		_anim_tree.set(&"parameters/AxeAttack/dir/blend_position", pos)
		_dash_dir = pos.normalized()


## Returns the direction to attack in, determined by the Attack blend position
## in the Animation Tree
func get_attack_dir() -> Vector2:
	return _anim_tree.get(&"parameters/Attack/dir/blend_position") as Vector2


func _throw_knife() -> void:
	var knife := KnifeScene.instantiate() as Knife
	(owner if owner else get_parent()).add_child(knife)
	var knife_dir := get_attack_dir()
	knife.global_position = global_position
	knife.global_rotation = knife_dir.angle()


func _on_invuln_timer_timeout() -> void:
	hurtbox.set_deferred(&"disabled", false)
	sprite.self_modulate.a8 = 255


func _on_hurtbox_area_entered(area: Enemy) -> void:
	if not area: return
	hit()
