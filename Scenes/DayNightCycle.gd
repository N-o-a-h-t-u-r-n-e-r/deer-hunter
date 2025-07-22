@tool
extends WorldEnvironment

@export var grad : Gradient
@export_range(0.0, 2400.0, 0.1) var time_of_day : float = 1200.0
@export_range(-90.0, 90.0, 0.1) var cycle_rotation : float = -90.0
@onready var sun_moon : Node3D = $SunMoon
@onready var sun : MeshInstance3D = $SunMoon/Sun
@onready var moon : MeshInstance3D = $SunMoon/Moon
@onready var sun_light : DirectionalLight3D = $SunMoon/Sun/SunLight
@onready var sky : WorldEnvironment = $"."
@onready var curr_time : float = cycle_rotation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var sun_pos = sun.global_position.y/2.0 + 0.5
	var sky_material : ShaderMaterial = self.environment.sky.sky_material
	sun_moon.rotation_degrees.x = cycle_rotation
	sky_material.set_shader_parameter("baseColor", grad.sample(sun_pos))
	var col : Color = sky_material.get_shader_parameter("cloudColor")
	col.a = sun_pos
	sky_material.set_shader_parameter("cloudColor", col)
	sun_light.light_energy = sun_pos
