class_name CameraController
extends Node3D

@export var min_limit_x: float
@export var max_limit_x: float
@export var horizontal_acc := 2.0
@export var vertical_acc := 2.0
@export var mouse_acc :=0.005

#func _process(delta: float) -> void:
	#var joy_dir = Input.get_vector("pan_left","pan_right","pan_up","pan_down")
	#rotate_from_vector(joy_dir * delta * Vector2(horizontal_acc, vertical_acc))
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * mouse_acc)

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	rotation.y -= v.x
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x,max_limit_x)
