extends Control

const NEXT_SCENE_PATH := "res://Scenes/Terrain.tscn"

var _progress: Array = []

func _ready() -> void:
	# Start loading the next scene in a background thread
	ResourceLoader.load_threaded_request(NEXT_SCENE_PATH)


func _process(_delta: float) -> void:
	var status := ResourceLoader.load_threaded_get_status(NEXT_SCENE_PATH, _progress)

	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if has_node("ProgressBar"):
				$ProgressBar.value = _progress[0] * 100.0

		ResourceLoader.THREAD_LOAD_LOADED:
			var packed_scene := ResourceLoader.load_threaded_get(NEXT_SCENE_PATH)
			if packed_scene:
				get_tree().change_scene_to_packed(packed_scene)
			else:
				push_error("Loaded resource is null for: %s" % NEXT_SCENE_PATH)

		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed to load scene: %s" % NEXT_SCENE_PATH)
