extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY = -300.0
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
var is_wall_sliding = false
var wall_slide_gravity = 100
var wall_pushback = 300

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	wall_slide(delta)

	# Handle Jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print(velocity.y)
	if Input.is_action_pressed("ui_accept") and not is_on_floor() and is_on_wall():
		velocity.y = WALL_JUMP_VELOCITY
		velocity.x = -wall_pushback
		
	if velocity.y < 0 and not is_on_floor():
		anim.play("jump")
	elif not is_on_floor():
		anim.play("fall")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			sprite.flip_h = -1
		else:
			sprite.flip_h = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x != 0 and is_on_floor():
		anim.play("run")
	elif velocity.x == 0 and is_on_floor():
		anim.play("idel")
	
	move_and_slide()

func wall_slide(delta):
	if is_on_wall() and not is_on_floor():
		if Input.get_axis("left", "right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += wall_slide_gravity * delta
		velocity.y = min(velocity.y, wall_slide_gravity)
