## Knife projectile object thrown by [Player], as part of the Knife scene
class_name Knife
extends Area2D

## Speed of the knife. Should be faster than the [member Player.speed]
@export var speed := 250.0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
