extends Node

const Stats = preload('res://source/Stats.gd')

func _init():
	var st = Stats.new()
	
	st.modifiers['test'] = Stats.Modifier.new({
		"route_a": 10
	})

	st.modifiers['test_2'] = Stats.Modifier.new({
		"route": "route_a",
		"effect": { "add": 10 },
		"priority": 1
	})
	
	print(st.route_a)
