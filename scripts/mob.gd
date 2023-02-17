extends KinematicBody2D

export var UP = Vector2(0, -1)
export var GRAVITY = 40
export var MAX_FALL_SPEED = 1200
export var MAX_SPEED = 300
export var MAX_JUMP_VELOCITY = 1300

var motion = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	motion.y = -MAX_JUMP_VELOCITY



func _physics_process(delta):
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	
	motion = move_and_slide(motion, UP)
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
