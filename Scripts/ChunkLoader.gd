@tool
extends Node3D

@export var global_size: int = 128
@export var chunk_size: int = 16
@export var global_seed := 1
@export var render_distance := 4
@export var player: CharacterBody3D
@export var chunk_scene: PackedScene

var player_chunk_x := 999999
var player_chunk_z := 999999
var chunks := {}

@export var bake_chunks := false:
	set(value):
		if value:
			bake()
		bake_chunks = false

func bake() -> void:
	if not Engine.is_editor_hint():
		return

	if chunk_scene == null:
		return

	for child in get_children():
		if child.name.begins_with("Chunk_"):
			child.queue_free()

	await get_tree().process_frame

	chunks.clear()

	var size := ceili(float(global_size) / float(chunk_size))

	for x in range(-size, size + 1):
		for z in range(-size, size + 1):
			var key := Vector2i(x, z)
			var chunk := chunk_scene.instantiate() as Node3D

			chunk.name = "Chunk_%s_%s" % [x, z]
			chunk.position = Vector3(
				x * chunk_size + chunk_size / 2.0,
				0,
				z * chunk_size + chunk_size / 2.0
			)

			chunk.set("seed_offset", Vector2(x, z))

			if key not in chunks:
				add_child(chunk)
				chunk.owner = get_tree().edited_scene_root
				chunks[key] = chunk

func _ready() -> void:
	rebuild_chunk_dictionary()

	if player == null:
		return

	player_chunk_x = floori(player.global_position.x / float(chunk_size))
	player_chunk_z = floori(player.global_position.z / float(chunk_size))

	update_chunk_visibility()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if player == null:
		return

	var new_player_chunk_x := floori(player.global_position.x / float(chunk_size))
	var new_player_chunk_z := floori(player.global_position.z / float(chunk_size))

	if new_player_chunk_x != player_chunk_x or new_player_chunk_z != player_chunk_z:
		player_chunk_x = new_player_chunk_x
		player_chunk_z = new_player_chunk_z
		update_chunk_visibility()

func rebuild_chunk_dictionary() -> void:
	chunks.clear()

	for child in get_children():
		if not child is Node3D:
			continue

		if not child.name.begins_with("Chunk_"):
			continue

		var chunk := child as Node3D
		var chunk_x := floori((chunk.position.x - chunk_size / 2.0) / float(chunk_size))
		var chunk_z := floori((chunk.position.z - chunk_size / 2.0) / float(chunk_size))
		var key := Vector2i(chunk_x, chunk_z)

		chunks[key] = chunk

func update_chunk_visibility() -> void:
	for key in chunks.keys():
		var chunk := chunks[key] as Node3D

		chunk.visible = (
			abs(key.x - player_chunk_x) <= render_distance
			and abs(key.y - player_chunk_z) <= render_distance
		)
