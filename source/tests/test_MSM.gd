extends Node

const FSM = preload('res://source/MultiStateMachine.gd')
const MOCKS = preload('res://source/tests/test_MSM_mocks.gd')

var fsm = null

func _init():
	fsm = FSM.new(self)
	MOCKS.new(self)
	
	assert('fake' in fsm._state_slots)
	assert(len(fsm._state_slots) == 1)
	
	fsm.switch_state("fake_a")
	assert(len(fsm._state_slots["fake"]) == 1)
	fsm.switch_state("fake_b")
	assert(len(fsm._state_slots["fake"]) == 1)
