class_name Player
extends CharacterBody3D

#region jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
# source: https://youtu.be/IOe1aGY6hXA?feature=shared
#endregion

@export var base_speed := 4.0

@onready var camera = $CameraController/Camera3D
@onready var godette_skin: GodetteSkin = $GodetteSkin

var movement_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_jump(delta)
	handle_abilities()
	move_and_slide()

func handle_movement(delta: float)->void:
	movement_input = Input.get_vector("left", "right","forward","backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	if movement_input != Vector2.ZERO:
		vel_2d += movement_input * base_speed * delta
		vel_2d = vel_2d.limit_length(base_speed)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		godette_skin.set_move_state("Running")
		var target_angle = -movement_input.angle() + PI / 2 
		godette_skin.rotation.y = rotate_toward(godette_skin.rotation.y, target_angle, 6 * delta)
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		godette_skin.set_move_state("Idle")


func handle_jump(delta: float)->void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	else:
		godette_skin.set_move_state("Jump")

	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta

func handle_abilities() -> void:
	if Input.is_action_just_pressed("ability"):
		godette_skin.attack()
