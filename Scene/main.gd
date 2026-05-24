extends Node2D

func _ready():
	print(Grid.is_tile_free(2, 2))

	var pos = Grid.tile_to_world(2, 2)
	print("World:", pos)

	var tile = Grid.world_to_tile(pos)
	print("Tile:", tile)
