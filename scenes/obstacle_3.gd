extends Area2D



func _process(delta):
	position.x -= get_parent().speed / 3  #velocidad con la que recorre en sentido contrario ,osea avanza hacia el player
