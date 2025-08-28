extends Node2D

@onready var camera = $Camera2D
@onready var kitty = $kitty
@onready var tilemap = $TileMapLayer

var screen_size : Vector2i
	
var chunk_width : float
var lev : bool

func _ready() -> void:
	screen_size = get_window().size
	var used_rect = tilemap.get_used_rect()
	var cell_size = tilemap.tile_set.tile_size
	chunk_width = float(used_rect.size.x) * cell_size.x

func _process(delta: float) -> void:
	var speed = 130.0 * delta
	kitty.position.x += speed
	camera.position.x += speed
	print(camera.position.x - tilemap.position.x)
	print(chunk_width)
	if camera.position.x - tilemap.position.x > chunk_width * 0.5:
		tilemap.position.x += chunk_width * 0.5
