extends Node

@export var mob_scene: PackedScene
var score


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready !")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate() # new instance of the scene
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() # random loc from path 2D
	
	var direction = mob_spawn_location.rotation + PI / 2 # Mob direction perp to path
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4) # randomness to the direction
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(50.0, 500), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob) # spawn mobs to the main scene

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _ready():
	pass


func _on_hud_start_game():
	pass # Replace with function body.
