class_name Enemy
extends Area2D

signal died

@onready var player := get_tree().get_first_node_in_group(&"player") as Player
@onready var sprite := $Sprite2D as Sprite2D

## Base Speed, modified by aggression for actual speed
@export var base_speed := 65.0

## How fast this one moves
## Final speed is [code](aggression + 0.5) * base_speed[/code]
var aggression := 0.5

func _ready() -> void:
	var redness := maxf(remap(aggression, 0.5, 1, 0, 1), 0)
	modulate = Color.WHITE.lerp(Color.RED, redness)


func _physics_process(delta: float) -> void:
	if not player: return
	global_position = global_position.move_toward(player.global_position, 
			base_speed * (aggression + 0.5) * delta)
	sprite.flip_h = player.global_position.x < global_position.x


func die() -> void:
	died.emit()
	queue_free()


func _on_body_entered(body: Player) -> void:
	if not body: return
	body.hit()


func _on_area_entered(_area: Area2D) -> void:
	die()
