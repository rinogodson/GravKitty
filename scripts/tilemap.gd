extends TileMapLayer


@export var scroll_speed: float = -200.0

func _process(delta):
	position.x += scroll_speed * delta
	var tile_width = tile_set.tile_size.x * get_used_rect().size.x
	if position.x < -tile_width/2:
		position.x += tile_width
