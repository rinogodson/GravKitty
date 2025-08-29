extends Node2D

@onready var camera = $Camera2D
@onready var kitty = $kitty
@onready var tilemap = $TileMapLayer
@onready var info = $Info

var acid1 = preload("res://scenes/acid1.tscn")
var acid2 = preload("res://scenes/acid2.tscn")
var pipe = preload("res://scenes/pipe.tscn")

var obstacle_types = [acid1, acid2, pipe]
var obstacles: Array = []

var screen_size: Vector2i
var chunk_width: float
var lev: bool

@export var gamerunning: bool

var score = 0

var last_obs: Node2D = null
var min_gap: float = 100.0  
var max_gap: float = 150.0 

func _ready() -> void:
	gamerunning = false
	$kitty.gamerunning = gamerunning
	screen_size = get_window().size
	var used_rect = tilemap.get_used_rect()
	var cell_size = tilemap.tile_set.tile_size
	chunk_width = float(used_rect.size.x) * cell_size.x

func _process(delta: float) -> void:
	if gamerunning:
		var speed = 130.0 * delta
		kitty.position.x += speed
		camera.position.x += speed
		$scorelabel.position.x += speed
		score += speed
		$scorelabel.text = str(floor(score) / 10)
		
		generate_obs()
		
		if info:
			if info.position.x > 280:
				info.queue_free()
				info = null  
			else:
				info.position.x += 0.5 * speed

		if camera.position.x - tilemap.position.x > chunk_width * 0.5:
			tilemap.position.x += chunk_width * 0.5
	else:
		if Input.is_action_just_pressed("jump"):
			gamerunning = true
			score = 0.0

func generate_obs():
	if last_obs == null or (last_obs.position.x < camera.position.x + screen_size.x - randi_range(min_gap, max_gap)):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs = obs_type.instantiate()
		
		obs.z_index = 4
		add_obs(obs, obs_type)
		last_obs = obs

func add_obs(obs: Node2D, obs_type: PackedScene):
	var spawn_x = camera.position.x + screen_size.x + 50
	obs.body_entered.connect(game_over)
	if obs_type == pipe:
		obs.position = Vector2(spawn_x, -10)
	else:
		obs.position = Vector2(spawn_x, 98)

	add_child(obs)
	obstacles.append(obs)
	
func game_over(body):
	if body.name == "kitty":
		gamerunning = false
		$kitty.gamerunning = gamerunning
		kitty.position.x = 20.0
		kitty.position.y = 66.0
		camera.position.y = -1.0
		camera.position.x = 0.0
		tilemap.position.x = 0.0
		$scorelabel.position.x = 148
