#"class_name" is used to name the class being created. Remember, a class is like
#a recipe. That's what this is. The "extends" keyword informs Godot that this class
#being created inherits from an existing class. 

#control flow determines the order in which code is executed.

#Every GDScript file is a class.

#Dark Green script is base types. They are collections of data. (Vector2.)
#Light Green is engine types. They are classes defined by Godot. (CharacterBody2D.)
#Extra Light Green types are user-defined. (Player, HurtBox.)
#Red is for non control flow keywords. This means their order does not matter. (class_name, signal.)
#Very Light Blue is a member variable. Think "(self.some_property)."
#Dark Blue is the function call color; a function created elewhere is being called, not defined.
#White text is just text. No syntax rules.
#Any string that restricts itself to alphabetic characters (a to z and A to Z), 
#digits (0 to 9) and _ qualifies as an identifier. Additionally, identifiers must
#not begin with a digit. Identifiers are case-sensitive. 

class_name Player extends CharacterBody2D 
#The class being created is Player. It inherits from the existing class CharacterBody2D.


signal DirectionChanged( new_direction : Vector2 )
signal player_damaged( hurt_box : HurtBox )

#The signal "DirectionChanged" establishes the variable "new_direction" as a Vector2 data type. 
#The signal "player_damaged" establishes the variable "hurt_box" as the user-defined HurtBox class/file. 

#A signal in Godot is a message with the potential of being emitted by this node when a specific 
#requirement, like a button press, is fulfilled. Other nodes can connect to that signal. Signals 
#transfer information between nodes without requiring them to reference one another. This limits 
#"coupling," or excessive interdependence.

#This syntax is the signal keyword, signal variable, and the parameters of the signal, which 
#defines the variable before the colon. 


const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

#const is a constant; a variable that cannot be changed by the application during runtime.
#This constant is named DIR_4, and is defined as an Array by the brackets. Arrays hold sequences 
#of elements of any variable type. As with all code, variable 1 is 0, variable 2 is one, and so-on.
#This is read as, the constant "DIR_4" is an Array. That array is the four possible directions of a
#2D environment, set as light blue member variables. White text is just text. No syntax rules.

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

#Remeber that == is "equal to," and = is "assigns value."
#created the variable "cardinal_direction," declared its type as Vector2, and assigned the value Vector2.DOWN.
#created the variable "direction," declared the type as Vector2, and assigned the value as Vector2.ZERO.
#Created, Declared, Assigned. Red, White, colon, Green. 

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

#created the variable "invunerable," declared it a boolean operaton (true/false), assigned it as false.
#created the variable "hp," declared it an int (integer, or whole number), assigned it as 6.
#created the variable "max_hp," declared it an int, assigned it as 6. 

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box : HitBox = $HitBox
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var audio : AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D

#@onready is code initated when this node enters the tree, and  has a script wide scope. 
#This is unlike _ready, whose scope is function-wide.

#When this code enters the tree, create the variable "animation_player," declare it the Godot class 
#AnimationPlayer, and fetch/assign it the value of the node AnimationPlayer.
#When this code enters the tree, create the variable "effect_animation_player," declare it the Godot 
#class AnimationPlayer, and featch/assign it the value of the node EffectAnimationPlayer.
#When this code enters the tree, create the variable hit_box, declare it to be the user-defined
#HitBox class/file, and assign it the valuse of the node HitBox.
#When this code enters the tree, create the variable "sprite," declare it the Godot class Sprite2D,
#and assign it the value of the node Sprite2D.
#When this code enters the tree, create the variable "state machine," declare it to be the user-defined
#class/script PlayerStateMachine, and assign it the value of the node StateMachine.

#If it has a $ sign, it is in the scene tree, NOT the file system. 

func _ready():
	# _ready means this is called when the function enters the scene tree for the first time.
	PlayerManager.player = self
	#This references the PlayerManager Autoload and assigns its member variable, accessed 
	#with the period, to this script.
	state_machine.Initialize(self)
	#this references the state_machien varibale defined in the @onready entry as the 
	#PlayerStateMachine in the scene tree, and uses the accessor Initialize in that file's code to
	#assign it to this script.
	hit_box.damaged.connect ( _take_damage )
	#This accesses the "damaged" signal from the hit_box variable defined in @onready and
	#connects it to "_take_damage."
	update_hp(99)
	pass 


# Called every frame. 'delta' is the time it took Godot to compelte the previous frame.
# To apply delta, you need to multiply your speed by it.
#Multiplying by delta makes things time dependent instead of speed dependent.
func _process( _delta ):
	direction = Vector2(
		Input.get_axis( "left" , "right" ),
		Input.get_axis( "up" , "down")
	).normalized()
	direction = direction.normalized()
	pass
	
	
func _physics_process( _delta ):
		move_and_slide()
		
		
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]

	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true



func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass
	
	
func AnimDirection() -> String:
		if cardinal_direction == Vector2.DOWN:
			return "down"
		elif cardinal_direction == Vector2.UP:
			return "up"
		else:
			return "side"



func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp( 99 )
	pass


func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
