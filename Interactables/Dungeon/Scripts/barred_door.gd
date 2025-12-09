class_name BarredDoor extends Node2D

@onready var animmation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

func open_door() -> void:
	animmation_player.play("open_door")
	pass

func close_door() -> void:
	animmation_player.play("close_door")
	pass
