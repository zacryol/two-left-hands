extends Area2D


@onready var player := get_tree().get_first_node_in_group(&"player") as Player
@onready var sprite := $Sprite2D as Sprite2D

@export var base_speed := 65.0

var aggression := 0.5

func _ready() -> void:
	modulate = Color.WHITE.lerp(Color.RED, aggression)


func _physics_process(delta: float) -> void:
	if not player: return
	global_position = global_position.move_toward(player.global_position, 
			base_speed * aggression * delta)
	sprite.flip_h = player.global_position.x < global_position.x
