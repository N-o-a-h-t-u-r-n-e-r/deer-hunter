extends Node3D

@export var global_size : int
@export var chunk_size : int
@export var global_seed := 1
@export var render_distance := 4
@export var player : CharacterBody3D

var chunks := {}

func _ready() -> void:
	#Make sure total coverage stays consistent with different chunk sizes
	var size = ceil(global_size/chunk_size)
	for x in range(-size, size+1):
		for z in range(-size, size+1):
			var key = Vector2(x, z)
			
			if(not chunks.has(key)):
				var chunk = preload("res://Scenes/FeatureChunk.tscn").instantiate() as Node3D				
				chunk.position = Vector3(x * chunk_size + chunk_size/2.0, 0, z * chunk_size + chunk_size/2.0)
				chunk.seed_offset = key
				chunks[key] = chunk
				add_child(chunk)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Divide by the chunk size and floor so we get the chunk the player is in
	var player_x = floor(player.global_position.x / chunk_size)
	var player_z = floor(player.global_position.z / chunk_size)

	var player_chunk_x : int
	var player_chunk_z : int

	if(player_chunk_z != player_z or player_chunk_x != player_x):	
		for x in range(player_x - render_distance, player_x + render_distance + 1):
			for z in range(player_z - render_distance, player_z + render_distance + 1):
				var key = Vector2(x, z)
				if(chunks.get(key)):
					chunks.get(key).visible = true
		
		for key in chunks.keys():		
			if(abs(key[0] - player_x) > render_distance or abs(key[1] - player_z) > render_distance):
				chunks.get(key).visible = false
				
		player_chunk_z = player_z
		player_chunk_x = player_x		
				
			
