extends TextureRect

signal update

#Showing in editor
export var isActive = false
#-----------------

var previousState = false

func _ready():
	#This is for the first point,its set to active initially in editor
	if isActive:
		$AnimationPlayer.play("On")
	#-----------------------------------------------------------------
		
func _on_Point1_update():
	#Only updates if the state changed
	if previousState != isActive:
		if isActive:
			#Switches on
			$AnimationPlayer.play("On")
			#-----------
			
		else:
			#Switches off
			$AnimationPlayer.play("Off")
			#------------
	#----------------------------------

func _on_AnimationPlayer_animation_finished(_anim_name):
	#Updates previous state
	previousState = isActive
	#----------------------
