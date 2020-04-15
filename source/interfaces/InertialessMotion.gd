extends 'res://source/Interface.gd'

## InertialessMotion
# Objects having this component are able to move like a villager.

const _INTERFACE = "motion"

func _init(p, data=null).(p, data):
	assert(p._i("physics"))

func _get_possible_actions(target):
	return [["move_to", 0]]

func move_to(target):
	return _entity.fsm.switch_state("motion_moving", {
		"target": target.translation
	})

func move_to_position(pos):
	return _entity.fsm.switch_state("motion_moving", {
		"target": pos
	})

func t__motion_idle__motion_moving():
	pass

class Idle extends 'res://source/MSMState.gd':
	func get_class():
		return ["motion", "idle"]
	
	func is_default_state():
		return true

	var held_position = null

	func enter_state():
		held_position = parent._i('physics')._body.translation
		return fsm.ORDER.OK
	
	func _integrate_forces(state):
		if state.linear_velocity.length_squared() < 2*2:
			state.linear_velocity = Vector3(0,0,0)
		return fsm.ORDER.IGNORE


class Moving extends 'res://source/MSMState.gd':
	func get_class():
		return ["motion", "moving"]

	var target = null

	func debug():
		return identifier() + " " + str(target)

	func enter_state():
		target = order_data.target
		return fsm.ORDER.OK

	func look_follow(state, current_transform, target_position):
		var up_dir = Vector3(0, 1, 0)
		var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
		var target_dir = (target_position - current_transform.origin).normalized()
		var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
		state.set_angular_velocity(up_dir * (rotation_angle / (state.get_step()*10)))

	func _physics_process(delta):
		if target == null:
			return fsm.ORDER.IGNORE
		
		if (target - parent.body.translation).length() < 2:
			var ret = fsm.process("on_at_destination")
			if ret == fsm.ORDER.IGNORE:
				pop_if_active()
			return fsm.ORDER.IGNORE
		var dir = (target - parent.body.translation).normalized() * 10
		parent.body.move_and_collide(Vector3(0, -1, 0), false)
		parent.body.move_and_slide_with_snap(dir, Vector3(0,1,0), Vector3(0,1,0), false, 4, 1.0, false)
		
		return fsm.ORDER.IGNORE

	func _integrate_forces(state):
		return fsm.ORDER.IGNORE
