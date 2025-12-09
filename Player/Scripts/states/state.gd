class_name State extends Node

##Stores a reference to the player that this state belongs to.
static var player : Player
static var state_machine : PlayerStateMachine

func _ready() -> void:
	pass # Replace with function body.


##What happens when we initialize this state?
func Init() -> void:
	pass
	

##What happens when the player enters this state?
func Enter() -> void:
	pass


##What happens when the player exits this state?
func Exit() -> void:
	pass
	
	
##What happens during the _process update of this state?
func Process( _delta : float ) -> State:
	return null


##What happens during the _physics_process update of this state?
func Physics( _delta : float) -> State:
	return null
	
	
##What happens with input events in this state?
func HandleInput( _event : InputEvent ) -> State:
	return null
