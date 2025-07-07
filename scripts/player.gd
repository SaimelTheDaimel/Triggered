extends CharacterBody2D


const SPEED = 200.0
const MAX_JUMP = -500
const MIN_JUMP = -100

var jump_is_charging = false
var jump_released = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_right: CollisionShape2D = $CollisionShapeRight
@onready var collision_shape_left: CollisionShape2D = $CollisionShapeLeft


func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		jump_released = false
		
	if jump_released:
		velocity += get_gravity() * delta
		move_and_slide()
		return

	if !jump_released:
		trigger_jump()
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if is_on_floor() && !jump_is_charging:
		if direction != 0:
			animated_sprite.play("run")
			animated_sprite.flip_h = direction < 0
			collision_shape_right.disabled = direction < 0
			collision_shape_left.disabled = direction > 0
			velocity.x = direction * SPEED
		else:
			animated_sprite.play("idle")
			velocity.x = 0
		
	velocity += get_gravity() * delta
	move_and_slide()

func trigger_jump():
	# Handle jump.
	if Input.is_action_pressed("Trigger_right"):
		jump_is_charging = true
		velocity.x = 0
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			var jump_intensity = Input.get_action_strength("Trigger_right")
			var horizontal = Input.get_action_strength("Trigger_left")
			velocity.y = lerp(MIN_JUMP, MAX_JUMP, jump_intensity)
			velocity.x = lerp(-50, 50, horizontal * 2 - 1)
			jump_released = true
			jump_is_charging = false
	else:
		jump_is_charging = false
