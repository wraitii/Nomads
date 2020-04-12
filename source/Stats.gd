extends Node

var _modifiers = {}

var stats = StatHelper.new()

func add(id, x):
	_modifiers[id] = Modifier.new(x)
	stats._compute_stats(_modifiers)

func _get(x):
	if x == "_modifiers":
		return _modifiers
	elif x in stats:
		return stats[x]
	else:
		return null

class Modifier:
	var definition = {} setget _set_def, _get_def
	
	var route = null
	var priority = null
	var effect = null

	func _init(spec):
		_set_def(spec)

	func _get_def():
		return definition

	func _set_def(def):
		definition = def
		route = _get_route()
		priority = _get_priority()
		effect = _get_effect()

	# Which stat is affected by this modifier
	func _get_route():
		if 'route' in definition:
			return definition['route']
		assert(definition.size() == 1)
		return definition.keys()[0]

	func _get_priority():
		if 'priority' in definition:
			return definition['priority']
		return 0;
	
	func _get_effect():
		if 'effect' in definition:
			return definition['effect']
		assert(definition.size() == 1)
		return { "add": definition.values()[0] }


class StatHelper:
	var modifiersList = {}
	
	var statsCache = {}
	
	func _init(specs = null):
		if specs:
			_compute_stats(specs)
	
	func _get(key):
		if key == 'modifiersList':
			return modifiersList
		if key == 'statsCache':
			return statsCache
		
		# Not necessarily a problem so return null
		if not (key in statsCache):
			return null

		return statsCache[key]
	
	func _sort_modifiers(a, b):
		return a.priority <= b.priority
	
	func _modify_value(modifier_def, value):
		match modifier_def:
			{ 'add': var v }:
				return value + v
			_:
				print("Unrecognized pattern in modifier:" + str(modifier_def))
				return value

	func _compute_stats(specs):
		modifiersList = {};
		statsCache = {};
	
		for modifier in specs:
			var se = specs[modifier].route
			if !(se in modifiersList):
				modifiersList[se] = [];
			modifiersList[se].push_back(specs[modifier])
	
		for route in modifiersList:
			modifiersList[route].sort_custom(self, '_sort_modifiers');
			var val = 0;
	
			for modifier in modifiersList[route]:
				val = _modify_value(modifier.effect, val)
			statsCache[route] = val;
