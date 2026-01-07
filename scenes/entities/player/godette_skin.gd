class_name GodetteSkin
extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var move_state_machine = animation_tree.get("parameters/MoveStateMachine/playback")

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func attack():
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
 
