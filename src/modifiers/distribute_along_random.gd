tool
extends "base_modifier.gd"


export(bool) var override_global_seed = false
export(int) var custom_seed = 0
export(int) var instance_count = 10
export(bool) var align_to_path = false

var display_name := "Distribute Along Path (Random)"

var _rng: RandomNumberGenerator


func process_transforms(transforms, global_seed) -> void:
	var path = transforms.path
	if path.curve.get_point_count() == 0:
		return

	transforms.resize(instance_count)
	_rng = RandomNumberGenerator.new()

	if override_global_seed:
		_rng.set_seed(custom_seed)
	else:
		_rng.set_seed(global_seed)

	var length: float = path.curve.get_baked_length()
	for i in transforms.list.size():
		var data = path.get_pos_and_normal(_rng.randf() * length)
		var pos: Vector3 = data[0]
		var normal: Vector3 = data[1]
		var t : Transform = transforms.list[i]
		
		if align_to_path:
			t = t.rotated(Vector3.UP, atan2(normal.x, normal.z))
		
		t.origin = pos
		transforms.list[i] = t
