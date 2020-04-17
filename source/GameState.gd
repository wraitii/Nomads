extends Node

const Sel = preload('res://source/Selection.gd')
const ActMgr = preload('res://source/ActionManager.gd')

var selection = Sel.new()
var action = ActMgr.new()
var world = null

var map_data = null
