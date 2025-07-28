@tool
extends WorldEnvironment

@export var light : float = 1.0
@export var sky_grad : Gradient
@export var sky_light_grad : Gradient
@export var day_cycle_speed : float = 1.0
@export_range(-85.0, 85.0, 0.1) var cycle_rotation : float = -85.0
@onready var sun_moon : Node3D = $SunMoon
@onready var sun : MeshInstance3D = $SunMoon/Sun
@onready var moon : MeshInstance3D = $SunMoon/Moon
@onready var sun_light : DirectionalLight3D = $SunMoon/Sun/SunLight
@onready var sky : WorldEnvironment = $"."
@onready var curr_time : float = cycle_rotation




func _process(delta: float) -> void:

	var sun_pos_x = sun.global_position.x
	var sun_pos_y = sun.global_position.y/2.0 + 0.5
	var sky_material : ShaderMaterial = self.environment.sky.sky_material
	sun_moon.rotation_degrees.x = cycle_rotation
	sky_material.set_shader_parameter("baseColor", sky_grad.sample(sun_pos_y))
	sky_material.set_shader_parameter("cloudAmount", sun_pos_y)
	sky_material.set_shader_parameter("starAmount", 0.3-sun_pos_y)
	sky_material.set_shader_parameter("sunPosx", sun_pos_x)
	sky_material.set_shader_parameter("sunPosy", sun.global_position.y)
	sky_material.set_shader_parameter("skyColor", sky_light_grad.sample(sun_pos_y))
	
	sun_light.light_energy = 0.0 if sun_pos_y <= 0.52 else (sin(sun_pos_y) * light)
	#if(cycle_rotation < 80.0):
		#print(sun_pos_y)
		#cycle_rotation += day_cycle_speed * delta
