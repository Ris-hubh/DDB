extends Node

# Grid setup (size and tile spacing)
@export var rows: int = 7
@export var cols: int = 4
@export var tile_size: int = 64

# Stores what is placed on the grid and which tiles are safe
var grid := {}
var safe_path := {}

# Tracks how far the grid has scrolled down over time
var scroll_offset_rows: int = 0


# Checks if a tile is empty and available
func is_tile_free(row: int, col: int) -> bool:
	return not grid.has(Vector2i(row, col))


# Marks a tile as occupied by an object
func claim(row: int, col: int, entity: Node) -> void:
	grid[Vector2i(row, col)] = entity


# Removes an object from a tile
func relinquish(row: int, col: int) -> void:
	grid.erase(Vector2i(row, col))


# Returns the object stored at a tile (if any)
func get_tile(row: int, col: int) -> Node:
	return grid.get(Vector2i(row, col), null)


# Creates a safe path that the player can use
func generate_safe_path(path_width: int) -> void:
	safe_path.clear()

	var current_col = randi_range(0, cols - 1)

	for row in range(rows):
		current_col = clamp(current_col + randi_range(-1, 1), 0, cols - 1)

		for w in range(path_width):
			var col = clamp(current_col + w, 0, cols - 1)
			safe_path[Vector2i(row, col)] = true


# Checks if a tile is part of the safe path
func is_safe_tile(row: int, col: int) -> bool:
	return safe_path.has(Vector2i(row, col))


# Prints the safe path layout in the console for debugging
func debug_print_safe_path():
	for row in range(rows):
		var line = ""
		for col in range(cols):
			line += "S " if safe_path.has(Vector2i(row, col)) else ". "
		print(line)


# Moves the grid downward (used for scrolling effect)
func scroll_down():
	scroll_offset_rows += 1


# Converts scroll offset into world movement
func get_scroll_offset_world() -> Vector2:
	return Vector2(0, scroll_offset_rows * tile_size)


# Converts grid position (row, col) into world position
func tile_to_world(row: int, col: int) -> Vector2:
	var offset_x = (cols * tile_size) * 0.5
	var offset_y = (rows * tile_size) * 0.5

	return Vector2(
		col * tile_size - offset_x,
		row * tile_size - offset_y
	)


# Converts world position back into grid coordinates
func world_to_tile(pos: Vector2) -> Vector2i:
	var offset_x = (cols * tile_size) * 0.5
	var offset_y = (rows * tile_size) * 0.5

	var col = int((pos.x + offset_x) / tile_size)
	var row = int((pos.y + offset_y) / tile_size)

	return Vector2i(row, col)
