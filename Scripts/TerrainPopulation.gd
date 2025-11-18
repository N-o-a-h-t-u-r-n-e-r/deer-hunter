@tool
extends MultiMeshInstance3D

@export var source_tree_path : NodePath
@export var shader_material : ShaderMaterial
@export var instance_count : int = 200
@export var raycast_height : float = 100.0
@export var max_scale : float = 1.0
@export var min_scale : float = 1.0
@export var collisions : bool = false
@export var seedy : int = 1

var chunk_size : int

# Collision layer bits (Godot: Layer 1 -> bit 0, Layer 2 -> bit 1, Layer 4 -> bit 3)
const LAYER_TERRAIN := 1 << 1        # layer 2 in the editor
const LAYER_WATER_BLOCKER := 1 << 3  # layer 4 in the editor

func _ready() -> void:
	var parent = get_parent_node_3d()
	chunk_size = parent.chunk_size
	var rng = RandomNumberGenerator.new()
	rng.seed = parent.global_seed + parent.seed_offset[0] + parent.seed_offset[1] + seedy

	var mm = MultiMesh.new()
	var tree = get_node(source_tree_path) as MeshInstance3D

	material_override = shader_material
	mm.transform_format = MultiMesh.TRANSFORM_3D
	
	# Use custom data so shaders can be applied
	mm.use_custom_data = true
	mm.instance_count = instance_count
	mm.mesh = tree.mesh
	
	# Set the multimesh to the one we just created
	multimesh = mm

	var space_state = get_world_3d().direct_space_state
	
	for i in range(instance_count):
		var x = rng.randf_range(-chunk_size, chunk_size)
		var z = rng.randf_range(-chunk_size, chunk_size)

		var from = global_transform.origin + Vector3(x, raycast_height, z)
		var to = global_transform.origin + Vector3(x, -raycast_height, z)

		var query = PhysicsRayQueryParameters3D.create(from, to)
		# Hit terrain + water blocker
		query.collision_mask = LAYER_TERRAIN | LAYER_WATER_BLOCKER
		query.collide_with_bodies = true
		query.collide_with_areas = true  # in case water is an Area3D

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
			
		var correction = Basis(Vector3.RIGHT, PI * 0.5)
		var pos = to_local(result["position"])

		var scales = Vector3(
			rng.randf_range(min_scale, max_scale), 
			rng.randf_range(min_scale, max_scale), 
			rng.randf_range(min_scale, max_scale)
		)
							
		var final = Transform3D(
			(Basis(Vector3.UP, rng.randf() * TAU) * correction).scaled(scales),
			pos
		)

		multimesh.set_instance_custom_data(i, Color(rng.randf(), rng.randf(), rng.randf(), rng.randf()))
		multimesh.set_instance_transform(i, final)

		# Add simple collision box at base
		if collisions:
			var static_body = StaticBody3D.new()
			var box = BoxShape3D.new()
			box.size = Vector3(0.1, 0.1, 1)
			var coll = CollisionShape3D.new()
			coll.shape = box
			static_body.add_child(coll)
			var inst_xform = multimesh.get_instance_transform(i)
			static_body.transform = inst_xform
			add_child(static_body)

	multimesh.visible_instance_count = instance_count
