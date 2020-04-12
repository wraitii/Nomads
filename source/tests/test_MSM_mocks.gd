extends 'res://source/Interface.gd'

func _init(parent).(parent):
	pass

class FakeState extends 'res://source/MSMState.gd':
	func get_class():
		return ["fake", "a"]

class OtherFakeState extends 'res://source/MSMState.gd':
	func get_class():
		return ["fake", "b"]
