extends Control 

func _on_Timer_timeout():
	#Change scene when timer times out
	get_tree().change_scene("res://scenes/game.tscn")
	#---------------------------------
