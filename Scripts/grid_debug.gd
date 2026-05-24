extends Node2D

@export var draw_labels := true

var font := ThemeDB.fallback_font


func _process(delta):
	queue_redraw()


func _draw():
	var rows = Grid.rows
	var cols = Grid.cols
	var tile_size = Grid.tile_size

	for row in range(rows):
		for col in range(cols):

			var world_pos = Grid.tile_to_world(row, col)

			var rect = Rect2(
				world_pos,
				Vector2(tile_size, tile_size)
			)

			# =========================
			# COLORS
			# =========================

			var color = Color(0.35, 0.4, 0.35)

			# Safe path
			if Grid.is_safe_tile(row, col):
				color = Color(0.3, 0.55, 0.3)

			# Occupied tile
			if not Grid.is_tile_free(row, col):
				color = Color(0.6, 0.35, 0.35)

			draw_rect(rect, color)

			# Grid border
			draw_rect(rect, Color.WHITE, false, 2)

			# =========================
			# TILE LABELS
			# =========================

			if draw_labels:
				var label = "(%d,%d)" % [row, col]

				draw_string(
					font,
					world_pos + Vector2(10, 24),
					label,
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					16,
					Color(0.9, 0.9, 0.9)
				)
