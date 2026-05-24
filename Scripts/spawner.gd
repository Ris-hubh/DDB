extends Node2D

@export var obstacle_scene: PackedScene
@export var duck_scene: PackedScene

@export var spawn_delay: float = 2.5

var rows: int
var cols: int

# Game difficulty starts normal and slowly increases over time
var difficulty: float = 1.0
var difficulty_increase_rate: float = 0.05

# Turn this on to print extra information for debugging
var debug_mode: bool = true


func _ready():
	rows = Grid.rows
	cols = Grid.cols
	start_loop()


# Main loop that keeps the game running in waves
func start_loop():
	while true:
		await get_tree().create_timer(get_dynamic_delay()).timeout

		scroll_and_spawn()
		increase_difficulty()


# Updates the world: moves grid, creates safe path, and spawns new objects
func scroll_and_spawn():
	Grid.scroll_down()

	# Safe path gets narrower as difficulty increases
	var path_width = max(1, int(2 - difficulty * 0.1))
	Grid.generate_safe_path(path_width)

	# Print debug info if enabled
	if debug_mode:
		print("\n--- WAVE DEBUG ---")
		print("Difficulty:", difficulty)
		print("Path Width:", path_width)

		Grid.debug_print_safe_path()

	# More difficulty = more obstacles and ducks
	var obstacle_count = int(clamp(4 + difficulty * 0.5, 4, 12))
	var duck_count = int(clamp(4 + difficulty * 0.4, 4, 10))

	if debug_mode:
		print("Obstacles:", obstacle_count, " Ducks:", duck_count)

	spawn_group(obstacle_scene, obstacle_count)
	spawn_group(duck_scene, duck_count)


# Spawns a group of objects randomly on valid grid tiles
func spawn_group(scene: PackedScene, count: int):
	var spawned = 0
	var attempts = 0

	while spawned < count and attempts < 50:
		attempts += 1

		var row = randi_range(0, rows - 1)
		var col = randi_range(0, cols - 1)

		# Only spawn on empty tiles that are not part of the safe path
		if Grid.is_tile_free(row, col) and not Grid.is_safe_tile(row, col):

			var obj = scene.instantiate()
			add_child(obj)

			obj.position = (
	Grid.tile_to_world(row, col)
	+ Vector2(Grid.tile_size / 2, Grid.tile_size / 2)
	- Grid.get_scroll_offset_world()
)

			Grid.claim(row, col, obj)

			obj.set("grid_pos", Vector2i(row, col))

			spawned += 1


# Controls how fast new waves appear based on difficulty
func get_dynamic_delay() -> float:
	return max(0.6, spawn_delay / difficulty)


# Gradually makes the game harder over time
func increase_difficulty():
	difficulty += difficulty_increase_rate
	difficulty = min(difficulty, 20)
