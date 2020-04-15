extends Node

const Stats = preload('res://source/Stats.gd')

func _init():
	var st = Stats.new()
	
	st.add('test', {
		"route_a": 10
	})

	st.add('test_2', {
		"route": "route_a",
		"effect": { "add": 10 },
		"priority": 1
	})
	
	print(st.route_a)
