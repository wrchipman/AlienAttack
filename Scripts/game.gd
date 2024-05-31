extends Node2D

var lives = 3
var score = 0
@onready var player = $Player
@onready var hud = $UI/HUD
@onready var ui = $UI

@onready var enemy_hit_sound = $EnemyHitSound
@onready var player_take_damage = $PlayerTakeDamage

var game_over_screen = preload("res://Scenes/game_over_screen.tscn")

func _ready():
	hud.set_score_label(score)
	hud.set_lives(lives)
	
func _on_deathzone_area_entered(area):
	lives -= 1
	hud.set_lives(lives)
	area.queue_free()
	check_game_over()


func _on_player_took_damage():
	player_take_damage.play()
	lives -= 1
	hud.set_lives(lives)
	check_game_over()

func check_game_over():
	if lives == 0:
		game_over()

func game_over():
	player.die()
	await get_tree().create_timer(1).timeout
	var gos = game_over_screen.instantiate()
	gos.set_score(score)
	ui.add_child(gos)

func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", _on_enemy_died)
	add_child(enemy_instance)

func _on_enemy_died():
	enemy_hit_sound.play()
	score += 100
	hud.set_score_label(score)

func _on_enemy_spawner_path_enemy_spawned(path_enemy_instance):
	add_child(path_enemy_instance)
	path_enemy_instance.enemy.connect("died", _on_enemy_died)
