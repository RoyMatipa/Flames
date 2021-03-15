extends Control

const MAX_POINT = 5

var posNumber = 0
var customPosNumber = 0


var trackID = 0
var currentTrackTime = 0

var initialInputPosition = Vector2()
var initialPlayerPosition = Vector2()

var titleImages = [
	preload("res://assets/title_images/friends.png"),
	preload("res://assets/title_images/lovers.png"),
	preload("res://assets/title_images/admirers.png"),
	preload("res://assets/title_images/married.png"),
	preload("res://assets/title_images/enemies.png"),
	preload("res://assets/title_images/secret_admirers.png"),
]

var titleText = [
	"Friends",
	"Lovers",
	"Admirers",
	"Married",
	"Enemies",
	"Secret Admirers"
]

var tracks = [
	preload("res://audio/Keys - Constellations.ogg"),
	preload("res://audio/Oceanus - Caffeine.ogg"),
	preload("res://audio/SoLush - Waiting.ogg"),
	preload("res://audio/Vadium - 3am In The Morning.ogg"),
	preload("res://audio/Vadium - PAIN!.ogg"),
	preload("res://audio/Y - MY PRESENCE.ogg")
]

func pulse(object, end, alt_end):
	var alt_objects = ["PlayPause", "Check"]
	
	if object.name in alt_objects:
		$ButtonAnimation.interpolate_property(object, "rect_scale", object.rect_scale, alt_end, 0.03, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$ButtonAnimation.start()
	
	else:
		$ButtonAnimation.interpolate_property(object, "rect_scale", object.rect_scale, end, 0.03, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$ButtonAnimation.start()
	
func button_pressed(button):
	pulse(button, Vector2(1.3, 1.3), Vector2(1.03, 1.03))
	
func center_pivot(c_node):
	c_node.rect_pivot_offset.x = c_node.rect_size.x / 2
	c_node.rect_pivot_offset.y = c_node.rect_size.y / 2
	
func load_bar():
	$Player/Elements/Progress/Bar/Tween.interpolate_property($Player/Elements/Progress/Bar, "value", $Player/Elements/Progress/Bar.value, $Player/Elements/Progress/Bar.max_value, $Player/Music.stream.get_length(), Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Player/Elements/Progress/Bar/Tween.start()

func set_track_details():
	var details = $Player/Music.stream.resource_path
	
	details = details.lstrip("res://audio/")
	details = details.rstrip(".ogg")
	
	$Player/Elements/NowPlaying.text = details
	$Output/Elements/Bars/TrackDetails/Background/Label.text = details

func change_track(direction, shuffle):
	if shuffle:
		#Set ID to a random number in range of tracks   
		trackID = randi() % len(tracks)
		#--------------------------------------------
		
	else:
		if direction == "next":
			if trackID < len(tracks) - 1:
				#Increase trackID by 1
				trackID += 1
				#---------------------
				
			else:
				#Set ID to first track
				trackID = 0
				#---------------------
		else:
			if trackID > 0:
				#Increase trackID by 1
				trackID -= 1
				#---------------------
				
			else:
				#Set ID to first track
				trackID = 0
				#---------------------
				
	#Set stream to current set track
	$Player/Music.stream = tracks[trackID]
	#-------------------------------
	
	#Play track
	$Player/Music.play()
	#----------
	
	#Display all track details(Artist and Song)
	set_track_details()
	#------------------------------------------
	
	#Set the bar value to 0
	$Player/Elements/Progress/Bar.value = 0
	#----------------------
	
	#Set the progress bar maximum value based on length of song multiplied by 1000
	$Player/Elements/Progress/Bar.max_value = $Player/Music.stream.get_length() * 1000
	#----------------------------------------------------------
	
	#Set length of track
	$Player/Elements/Progress/Time/End.text = to_timestamp($Player/Music.stream.get_length())
	#-------------------
	
	load_bar()

func to_timestamp(sec):
	var seconds
	var minutues
	
	minutues = round(sec) / 60
	minutues = int(minutues)
	
	seconds = (round(sec) / 60) - int(round(sec) / 60)
	seconds = seconds * 60
	
	if seconds > 9:
		return (str(minutues) + ":" + str(seconds))
		
	else:
		return (str(minutues) + ":" + "0" + str(seconds))
	
func choose_title():
	var name1 = []
	var name2 = []
	
	#Change names to lowercase and adds to array
	for letter in $Input/Elements/NameInput/Name1.text:
		name1.append(letter.to_lower())
		
	for letter in $Input/Elements/NameInput/Name2.text:
		name2.append(letter.to_lower())
	#--------------------------------------------
		
	#Check names for similarities
	#Removes letters appearing in both names
	for letter in name1:
		if letter in name2:
			name1.erase(letter)
			name2.erase(letter)
			
	for letter in name2:
		if letter in name1:
			name1.erase(letter)
			name2.erase(letter)
	#----------------------------
	#---------------------------------------
	
	#Sets a custom position for title and pill 
	customPosNumber = (len(name1) + len(name2)) - 1
	#-----------------------------------------
			
func change_title(isCustom, num, text):
	#Moves point to next position
	move_point(isCustom, num)
	#----------------------------
	
	#Sets the label
	$Output/Elements/Title/Label.text = text + titleText[posNumber]
	#--------------
	
	#Sets the image
	$Output/Elements/Title/Image.texture = titleImages[posNumber]
	#------------------------
		
	#Brings in new title
	$OutputAnimation.play("FadeIn")
	#-------------------

func slide_object(node, object, stop):
	#Interpolation of the position
	node.interpolate_property(object, "rect_position",
		Vector2(object.rect_position.x, object.rect_position.y), stop, 1,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
	node.start()
	#-----------------------------

func move_point(custom:bool, num):
	#Update point position number
	if custom:
		posNumber = 0
		
		#Set posNumber to given number
		for i in range(num):
			if posNumber < MAX_POINT:
				posNumber += 1
				
			else:
				posNumber = 0
				
			print(posNumber)
		#-----------------------------
		
	else:
		if posNumber < MAX_POINT:
			#Add 1 to point number to increase position
			posNumber += 1
			#-----------------------------------------
			
		else:
			#Reset point number 
			posNumber = 0
		#------------------
	#----------------------------
	
	for point in $Output/Elements/Bars/PositionPoints.get_children():
		#Active point if point number and point have similarities
		if str(posNumber + 1) in point.name:
			#Change point's variable to active
			point.isActive = true
			#---------------
		
		else:
			#Change point's variable to inActive
			point.isActive = false
			#-----------------------------------
		
		#Update point
		point.emit_signal("update")
		#------------
		
		#Start timer
		$ChangeTitle.start()
		#-----------
		#---------------------------------------------------------

func _ready():
	for button in get_tree().get_nodes_in_group("Buttons"):
		center_pivot(button)
		button.connect("pressed", self, "button_pressed", [button])
	
	randomize()
	
	#Gets the initial position of the input window
	initialInputPosition = $Input.rect_position
	#---------------------------------------------
	
	#Gets the initial position of the input window
	initialPlayerPosition = $Player.rect_position
	#---------------------------------------------
	
	slide_object($Player/Elements/Progress/Bar/Tween, $Player, Vector2($Player.rect_position.x, 3000))
	
	change_track("next", true)
	
func _process(delta):
	#Set current time stamp value
	$Player/Elements/Progress/Time/Current.text = to_timestamp($Player/Music.get_playback_position())
	#---------------------------- 
	
func _on_ChangeTitle_timeout():
	#Removes title
	$OutputAnimation.play("FadeOut")
	#-------------
	
func _on_OutputAnimation_animation_finished(anim_name):
	if $Output.rect_position == Vector2.ZERO:
		#Change title without any customisation
		if anim_name == "FadeOut":
			change_title(false, null, "")
		#--------------------------------------
			
		if anim_name == "FadeIn":
			#Starts time for how long the new title should last
			$ChangeTitle.start()
			#--------------------------------------------------
			
	else:
		#Change title with some customisation
		if anim_name == "FadeOut":
			change_title(true, customPosNumber, "You are ")
		#------------------------------------
		
		if anim_name == "FadeIn":
			#Stop title timer changer
			$ChangeTitle.stop()
			#------------------------
			
			#Removes position points
			$OutputAnimation.queue("FadePoints")
			#-----------------------
			
			if $Back.modulate.a8 < 255:
				#Make back button visible
				$InputAnimation.play("ShowBack")
				#------------------------
			
func _on_Input_Tween_tween_completed(object, key):
	if $Input.rect_position == Vector2(20, 3000):
		#Slides the output node down
		slide_object($Output/Tween, $Output, Vector2(0, (1920/2) - ($Output.rect_size.y/2)))
		#---------------------------
		
	else:
		#Fades title
		$OutputAnimation.play("FadeOut")
		#-----------

func _on_Output_Tween_tween_completed(object, key):
	if $Output.rect_position == Vector2.ZERO:
		#Slides the input node down
		slide_object($Input/Tween, $Input, initialInputPosition)
		#--------------------------
		
	else:
		#Fades title
		$OutputAnimation.play("FadeOut")
		#-----------

func _on_Check_pressed():
	choose_title()
	
	#Stop timer
	$ChangeTitle.stop()
	#----------
	
	#Slides the input node down
	slide_object($Input/Tween, $Input, Vector2(20, 3000))
	#---------------------------------
	
func _on_Back_pressed():
	#Removes back button
	$InputAnimation.play_backwards("ShowBack")
	#-------------------
	
	#Makes position points visible
	$OutputAnimation.play_backwards("FadePoints")
	#-----------------------------
	
	#Slides the input node down
	slide_object($Output/Tween, $Output, Vector2.ZERO)
	#---------------------------------

func _on_Name_focus_entered():
	#Moves input above to prevent it from being covered by keyboard
	slide_object($Input/Tween, $Input, Vector2(20, 136))
	#--------------------------------------------------------------
func _on_Player_pressed():
	slide_object($Player/Elements/Progress/Bar/Tween, $Player, initialPlayerPosition)
	
func _on_Flames_pressed():
	slide_object($Player/Elements/Progress/Bar/Tween, $Player, Vector2($Player.rect_position.x, 3000))
	
func _on_Previous_pressed():
	change_track("previous", $Player/Elements/Buttons/Shuffle.pressed)

func _on_PlayPause_pressed():
	if $Player/Music.playing == true:
		$Player/Music.playing = false
		$Player/Elements/Progress/Bar/Tween.stop($Player/Elements/Progress/Bar)
	
	else:
		$Player/Music.play($Player/Music.get_playback_position())
		load_bar()

func _on_Next_pressed():
	change_track("next", $Player/Elements/Buttons/Shuffle.pressed)

func _on_Music_finished():
	if $Player/Elements/Buttons/PlayPause.pressed == false:
		if $Player/Elements/Buttons/Loop.pressed:
			$Player/Music.playing = true
			load_bar()
			
		else:
			change_track("next", $Player/Elements/Buttons/Shuffle.pressed)

func _on_ButtonAnimation_tween_completed(object, key):
	if object.rect_scale != Vector2.ONE:
		pulse(object, Vector2.ONE, Vector2.ONE)
