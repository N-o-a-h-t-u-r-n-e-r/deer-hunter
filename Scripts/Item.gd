class_name Item extends Node3D

var id : String
var is_useable: bool


func _init(id, is_useable) -> void:
	self.id = id
	self.is_useable = is_useable
	
