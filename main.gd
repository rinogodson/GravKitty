extends Node2D

@onready var camera = $Camera2D
@onready var kitty = $kitty
@onready var tilemap = $TileMapLayer
@onready var info = $Info

var screen_size : Vector2i
	
var chunk_width : float
var lev : bool

@export var gamerunning : bool

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
