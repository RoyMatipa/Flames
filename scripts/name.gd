extends LineEdit

func _on_Name_focus_entered():
	$AnimationPlayer.play("Scale")

func _on_Name_focus_exited():
	$AnimationPlayer.play_backwards("Scale")
