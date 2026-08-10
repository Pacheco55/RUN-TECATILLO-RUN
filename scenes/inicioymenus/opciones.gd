extends Control



func _on_master_slidr_value_changed(value):
	if value == 45 : 
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0,value)
		



func _on_check_button_toggled(button_pressed):
	if button_pressed == true :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_atras_btn_pressed():
	get_tree().change_scene_to_file("res://.godot/exported/133200997/export-8e772cc707a134639cc74e7952a545cc-inicio_menu.scn")
