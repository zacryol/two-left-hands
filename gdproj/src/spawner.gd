class_name EnemySpawner
extends PathFollow2D

const _SPAWN_THRESHOLD := 100.0
var spawn_rate := 20.0

@onready var score_label := $Score/Label as Label

var EnemyScene = preload("res://src/enemy.tscn") as PackedScene

var _spawn_tick := 0.0

var _enemies_spawned := 0
var _spawn_potion_at := 8

func _init() -> void:
	randomize()


func _process(delta: float) -> void:
	score_label.text = "Score: %d" % _enemies_spawned
	spawn_rate = minf(spawn_rate, 6000.0)
	_spawn_tick += spawn_rate * delta
	while _spawn_tick > _SPAWN_THRESHOLD and\
			get_tree().get_nodes_in_group(&"enemy").size() < 500:
		_spawn_tick -= _SPAWN_THRESHOLD
		spawn_enemy()


## Spawn enemy at random point along path
func spawn_enemy() -> void:
	spawn_rate += 1
	progress_ratio = randf()
	var enemy := EnemyScene.instantiate() as Enemy
	enemy.aggression = randf() * randf()
	(owner if owner else get_parent()).add_child(enemy)
	enemy.global_position = global_position
	var _err := enemy.died.connect(Callable(self, &"_enemy_died"))
	_enemies_spawned += 1
	if _enemies_spawned > _spawn_potion_at:
		_spawn_potion_at *= 2
		enemy.has_potion = true


func _enemy_died():
	spawn_rate += 1
