@tool
extends Node3D

@export var stag_scene: PackedScene
@export var spawn_count: int = 8
@export var spawn_radius: int = 100
@export var raycast_height : float = 100.0
@export var deer_count: Label
var curr_count:int
const LAYER_TERRAIN := 1 << 1
const LAYER_WATER_BLOCKER := 1 << 3 

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = 100
	var space_state = get_world_3d().direct_space_state
	spawn_count = 20
	curr_count = 0
	
	if stag_scene:
		while spawn_count > 0:
			
			var x = rng.randf_range(-spawn_radius, spawn_radius)
			var z = rng.randf_range(-spawn_radius, spawn_radius)

			var from = global_transform.origin + Vector3(x, raycast_height, z)
			var to = global_transform.origin + Vector3(x, -raycast_height, z)

			var query = PhysicsRayQueryParameters3D.create(from, to)

			query.collision_mask = LAYER_TERRAIN | LAYER_WATER_BLOCKER
			query.collide_with_bodies = true
			query.collide_with_areas = true 

			var result = space_state.intersect_ray(query)
		
			if not result:
				continue

			var collider = result["collider"]

			# Skip water blocker hits
			if (collider.collision_layer & LAYER_WATER_BLOCKER) != 0:
				continue

			# Only accept terrain hits
			if (collider.collision_layer & LAYER_TERRAIN) == 0:
				continue
				

			var pos = to_local(result["position"]) + Vector3.UP
			
			
			var stag:CharacterBody3D = stag_scene.instantiate()
			stag.player = get_node("../FPSCharacter/Player")
			stag.transform = Transform3D((Basis(Vector3.UP, rng.randf() * TAU)),pos)
			stag.scale = Vector3(0.7,0.7,0.7)
			add_child(stag)
			curr_count+=1
			stag.died.connect(_on_npc_died)
			update_label()
			spawn_count-=1

func _on_npc_died():
	curr_count -= 1
	update_label()

func update_label():
	deer_count.text = str( curr_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
