extends KinematicBody2D

export var UP = Vector2(0, -1)
export var GRAVITY = 40
export var MAX_FALL_SPEED = 900
export var MAX_SPEED = 300
export var MAX_JUMP_VELOCITY = 1000
export var ACCELERATION = 80
var jump_hold = false
var facing_right = true
var screen_size


var motion = Vector2()

func start(pos):
	position = pos
	show()

func _ready():
	screen_size = _get_camera_center()

func _get_camera_center():
	var vtrans = get_canvas_transform()
	var top_left = -vtrans.get_origin() / vtrans.get_scale()
	var vsize = get_viewport_rect().size
	return top_left + 0.5*vsize/vtrans.get_scale()


func _physics_process(delta):
	
	# Capping fall speed at MAX_FALL_SPEED
	motion.y += GRAVITY * 1.5
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
		
	if facing_right:
		$AnimatedSprite.scale.x = 1
	else:
		$AnimatedSprite.scale.x = -1
	
	# Capping accel speed at 
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("right"):
		motion.x += ACCELERATION
		$AnimatedSprite.play("run")
		facing_right = true
	elif Input.is_action_pressed("left"):
		motion.x -= ACCELERATION
		$AnimatedSprite.play("run") 
		facing_right = false
	else:
		motion.x = 0
		if is_on_floor():
			$AnimatedSprite.play("idle")
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			jump_hold = true
		else:
			jump_hold = false
		if jump_hold:
			motion.y = -MAX_JUMP_VELOCITY
	
	if motion.y < 0:
		$AnimatedSprite.play("jump")
		
	position.x = clamp(position.x, -500, 500)
	position.y = clamp(position.y, -250, 250)
		
	
	motion = move_and_slide(motion, UP)
