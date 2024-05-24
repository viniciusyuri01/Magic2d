extends KinematicBody2D

var direction = 1
var velocity = Vector2.ZERO
var move_speed = 200 
var gravity = 1800
var jump_force = -500
var on_ground = false
var animated_Sprite
var atacando = false
var health: int = 100

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = move_speed * move_direction

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_force

	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true

	if not atacando:
		if is_on_floor():
			if velocity.x != 0:
				$AnimatedSprite.play("correndo")
			else:
				$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("pulando")

	velocity = move_and_slide(velocity, Vector2.UP)

func _ready():
	animated_Sprite = $AnimatedSprite

func _input(event):
	if event.is_action_pressed("atacar") and not atacando:
		atacando = true
		animated_Sprite.play("atacando")

func idle_finished():
	if $AnimatedSprite.animation == "atacando":
		atacando = false
		if is_on_floor():
			if velocity.x != 0:
				animated_Sprite.play("correndo")
			else:
				animated_Sprite.play("idle")
		else:
			animated_Sprite.play("pulando")
