extends Node

var ufo = preload("res://scenes/obstacle_0.tscn")
var robot1 = preload("res://scenes/obstacle_1.tscn")
var robot2 = preload("res://scenes/obstacle_2.tscn")
var flying = preload("res://scenes/obstacle_3.tscn")
var shark = preload("res://scenes/obstacle_4.tscn")
var obstacle_types := [robot1, robot2, ufo, shark]
var obstacles : Array
var flying_height : = [150, 350]  #parametro de alturas para este objeto  [x, y]


const PLYR_STRTPOS := Vector2(250,480)  #(400, 480)
const CAM_STRTPOS := Vector2i(576, 324)
var dificulty 
const MAX_DYF : int = 2   #cantidad de obstaculos que saldran conforme aumente la dyficultad
var speed : float
const SPEED_MOD : int = 700  # cada cuantos puntos aumentara la velocidad pero segun el marcado sin la division 4000 - 5000 esta bien
const STRT_speed : float = 30.0  #velocidad con la que inicia el juego
const MAX_SPEED : int = 90   #velocidad maxima que alcanzara el juego
var screen_size : Vector2i
var ground_height : int
var score : int
const SCORE_MOD : int = 70  # 50 para que el puntaje no salga en numero tan altos se divide entre mas alto sea este valor mas lento sera la suma del puntaje
var high_score : int
var game_runing : bool
var last_obs
# Called when the node enters the scene tree for the first time.
func _ready():
	MusicGrl._play_music_level()
	screen_size = get_window().size
	ground_height = $Floor.get_node("Sprite2D").texture.get_height() 
	$GameOver.get_node("RestartGO").pressed.connect(new_game)
	new_game()
	$GameOver.get_node("ExitGO").pressed.connect(quit)
	
	
func quit():
	get_tree().change_scene_to_file("res://scenes/inicioymenus/present_scene.tscn")
	
func new_game():
	MusicGrl.get_stream_playback()  # = true
	$HUD.get_node("Opciones").show()
	$HUD.get_node("Restart").show()
	score = 0
	show_score()
	game_runing = false
	get_tree().paused = false
	dificulty = 0
	#$ColorRect.hide()
	
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	$Player.position = PLYR_STRTPOS
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_STRTPOS
	$Floor.position = Vector2i(0,0)
	#reset hud
	$HUD.get_node("Start").show()
	$GameOver.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_runing:
		speed = STRT_speed + score / SPEED_MOD
		#print(speed)
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_dif()
			
		generate_obs()
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		score += speed
		#print(score)
		show_score()
		
		if $Camera2D.position.x - $Floor.position.x > screen_size.x * 1.28 : # rango de regeenracion del piso  1.5 
			$Floor.position.x += screen_size.x
			
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_runing = true
			$HUD.get_node("Start").hide()
			
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randf_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = dificulty + 1
		for i in range(randi() % max_obs + 1):	
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var  obs_scale = obs.get_node("Sprite2D").scale   #la linea de abajo tambien podria ser la dificultad con la que apareceran los obsatculos
			var obs_x : int = screen_size.x + score + 200 +(i * 80) #  (i * 100 ) que tan variado sera la posicion entre la generacion de obstaculos 1 = espacio igual entre cada instanciacion , mas alto valor mas variado sera 100 esta bien
			var obs_y : int = screen_size.y - ground_height - ( obs_height * obs_scale.y / 2.5) + 550 # ...y / 3 ) +5 , es para darle altura a los obstaculos , el 5 el donde se le agrega la variacion 
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
			#los flying
			
		if dificulty == MAX_DYF:     #instanciacion del objeto volador al alcanzar la maxima dificultad
			if(randi( ) % 1) == 0 : #.... % 2 la posibilidad de que aparesca la instanciacion
				obs = flying.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = flying_height[randi() % flying_height.size()]
				add_obs(obs, obs_x, obs_y)

func  add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)
	
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)


func hit_obs(body):
	if body.name == "Player":
		#print("collide")
		game_over()
	
func show_score():
	$HUD.get_node("Score").text = "score : " + str(score / SCORE_MOD)
	
func check_highscore():
	if score > high_score:
		high_score = score
		$HUD.get_node("HScore").text = "HIGH SCORE : " + str(high_score / SCORE_MOD)
	
func adjust_dif():
	dificulty = score / SPEED_MOD
	if dificulty > MAX_DYF:
		dificulty = MAX_DYF 
		
func game_over():  #se pone solo en pausa por que se pone en el inspector su PROCESS en WHEN PAUSED y el .hide() en func ready() para que se esconda 
	check_highscore()
	get_tree().paused = true
	game_runing = false
	$GameOver.show()
	$HUD.get_node("Opciones").hide()
	$HUD.get_node("Restart").hide()
