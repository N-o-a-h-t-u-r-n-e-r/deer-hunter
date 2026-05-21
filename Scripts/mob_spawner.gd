extends Node3D

@export var stag_scene: PackedScene
@export var bunny_scene: PackedScene
@export var deer_spawn_count: int = 8
@export var bunny_spawn_count: int = 8
@export var spawn_radius: int = 100
@export var raycast_height: float = 100.0
@export var deer_count: Label
@export var bunny_count: Label

var deer_current_count: int = 0
var bunny_current_count: int = 0

const LAYER_TERRAIN := 1 << 1
const LAYER_WATER_BLOCKER := 1 << 3

func _ready() -> void:
	deer_current_count = spawn_entity(stag_scene, deer_spawn_count, deer_count)
	bunny_current_count = spawn_entity(bunny_scene, bunny_spawn_count, bunny_count)
	update_label(deer_count, deer_current_count)
	update_label(bunny_count, bunny_current_count)

func _on_npc_died(label: Label, animal_type: String) -> void:
	if animal_type == "deer":
		deer_current_count -= 1
		update_label(label, deer_current_count)
	elif animal_type == "bunny":
		bunny_current_count -= 1
		update_label(label, bunny_current_count)

func update_label(label: Label, count: int) -> void:
	if label:
		label.text = str(count)

func _process(_delta: float) -> void:
	pass

func spawn_entity(entity_scene: PackedScene, spawn_count: int, label: Label) -> int:
	if entity_scene == null:
		return 0

	var animal_type := "deer"
	if entity_scene == bunny_scene:
		animal_type = "bunny"

	var rng = RandomNumberGenerator.new()
	rng.seed = 100

	var space_state = get_world_3d().direct_space_state
	var spawned_count := 0

	while spawned_count < spawn_count:
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

		if (collider.collision_layer & LAYER_WATER_BLOCKER) != 0:
			continue

		if (collider.collision_layer & LAYER_TERRAIN) == 0:
			continue

		var pos = to_local(result["position"]) + Vector3.UP

		var entity: CharacterBody3D = entity_scene.instantiate()
		entity.player = get_node("../Player")
		entity.transform = Transform3D(Basis(Vector3.UP, rng.randf() * TAU), pos)
		entity.scale = Vector3(0.7, 0.7, 0.7)

		add_child(entity)

		spawned_count += 1
		update_label(label, spawned_count)

		if entity.has_signal("died"):
			entity.died.connect(_on_npc_died.bind(label, animal_type))

	return spawned_count
