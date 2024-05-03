extends Area2D

signal hit

@export var speed = 400 # player speed
var screen_size # game window size

func _ready():
	screen_size = get_viewport_rect().size
	hide() # hide player
	
func _process(delta):
	var velocity = Vector2.ZERO # our movement vectors
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # animation sprites


func _on_body_entered(body):
	hide() # vanish after hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true) # disable after hit to prevent multiple signals
	# set_deferred tells Godot to wait until it's safe to disable before doing so
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false # reset the player
