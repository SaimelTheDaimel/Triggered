extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -500.0
const jump_is_charging = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_right: CollisionShape2D = $CollisionShapeRight
@onready var collision_shape_left: CollisionShape2D = $CollisionShapeLeft


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if is_on_floor():
		if direction != 0:
			animated_sprite.play("run")
			animated_sprite.flip_h = direction < 0
			collision_shape_right.disabled = direction < 0
			collision_shape_left.disabled = direction > 0
			velocity.x = direction * SPEED
		else:
			animated_sprite.play("idle")
			velocity.x = 0
		
	# Handle jump.
	if Input.is_action_pressed("Trigger_right"):
		var value = Input.get_action_strength("Trigger_right")
		if Input.is_action_just_pressed("jump"):
			velocity.y += value * JUMP_VELOCITY
			velocity.x += 0.5 * value * JUMP_VELOCITY
			
	

	

	move_and_slide()
