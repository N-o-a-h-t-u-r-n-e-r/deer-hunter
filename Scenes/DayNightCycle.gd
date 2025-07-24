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

	var sun_pos_x = sun.global_position.x
	var sun_pos_y = sun.global_position.y/2.0 + 0.5
	var sun_pos_z = sun.global_position.z
	var sky_material : ShaderMaterial = self.environment.sky.sky_material
	sun_moon.rotation_degrees.x = cycle_rotation
	sky_material.set_shader_parameter("baseColor", grad.sample(sun_pos_y))
	sky_material.set_shader_parameter("cloudAmount", sun_pos_y)
	sky_material.set_shader_parameter("starAmount", 0.3-sun_pos_y)
	sky_material.set_shader_parameter("sunPosx", sun_pos_x)
	sky_material.set_shader_parameter("sunPosy", sun.global_position.y)
	sky_material.set_shader_parameter("sunPosz", sun_pos_z)
	
	sun_light.light_energy = sun_pos_y
	#cycle_rotation += 1.0 * delta
