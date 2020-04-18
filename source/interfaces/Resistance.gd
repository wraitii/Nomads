extends ComponentInterface

const _INTERFACE = "resistance"

## Resistance
## Basically armor but with a more generic name

func _init(p, data=null).(p, data):
	pass

# Damage function
# Bit of a complex formula, just plot it if you want to understand.
# The core idea is if attack ~ defense, then damage is about 50%.
# This value changes slower than linearly around an equal value, so small
# deltas aren't a huge deal.
# However when difference goes up, this catches up to linearity and basically
# a 50% difference means damage is either full or none.
# This is slightly flatter at low levels, so an attack of 2 still damages a defense of 8
# but an attack of 20 doesn't damage a defense of 80.
# The intention of this system is to make small numerical differences mostly irrelevant
# so HP is easier to figure out.
# I am _not_ sure how it'll handle in practice.

func _ratio(a):
	return max(1.3, 8 * exp(- a/15))

func _red(a,d):
	var lin_component = (a-d)/_ratio(a) * 2.0 + a
	var sig_component = a / (1 + exp(-(a-d)/ (a/7*_ratio(a)) )) 
	return min(a, max(0, lin_component - sig_component))

# Reduce damage. If no resistance, full damage.
func _reduce_damage(damage):
	var temp = damage.duplicate()
	for type in temp:
		var resist = _entity.stats["resistance_" + type]
		if not resist:
			continue
		temp[type] = _red(temp[type], resist)
	return temp
