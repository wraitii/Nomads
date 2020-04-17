extends ComponentInterface

## Mimics the life-cycle of a supply.
# Supplies disappear when the last of their carry disappears

const _INTERFACE = "lifecycle"

func _init(p, data=null).(p, data):
	assert(p._i("carry"))
	p._i("carry").connect("unload", self, "_on_unload")

func _on_unload(ent_carry, item_type, amount):
	if ent_carry._empty():
		_entity.destroy()
