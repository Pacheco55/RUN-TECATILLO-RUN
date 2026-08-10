extends Node2D

func _ready():
	$AnimationPlayer.play("fade_out")
	await(get_tree().create_timer(3).timeout)
	$AnimationPlayer.play("fade_in")
	await(get_tree().create_timer(1).timeout)
	get_tree().change_scene_to_file("res://scenes/inicioymenus/bye_anita_2.tscn")
