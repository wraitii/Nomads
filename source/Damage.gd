extends Reference
class_name Damage

## Simple wrappers around damage types.

static func mul(dmg, x):
	var t = dmg.duplicate()
	for k in t:
		t[k] *= x
	return t
