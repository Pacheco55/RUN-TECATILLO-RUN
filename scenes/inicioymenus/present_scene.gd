extends Node2D


func _ready():
	$AnimationPlayer.play("fade_in")
	await(get_tree().create_timer(1.5).timeout)
	$AnimationPlayer.play("fade_out")
	await(get_tree().create_timer(1).timeout)
	get_tree().change_scene_to_file("res://scenes/inicioymenus/greattings.tscn") #version de salida normal con tester y grphics credits
	#get_tree().change_scene_to_file("res://scenes/inicioymenus/bye_anita.tscn")  #version de salida para anna padilla
