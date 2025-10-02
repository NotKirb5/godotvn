extends Node



@onready var overlay = preload("res://addons/godotvn/dialogueOverlay.tscn")
var sceneplaying = false

var currentscene = null

var testscript = {
	'root':[
	'/c inst res://addons/godotvn/cafe.png cafe 500 500',
	'/c name Manhatten Cafe',
	'hello this is a visual novel',
	'visual novels can be hard to make',
	'thanks to godotvn not only is it easier to create.',
	'Its also easier to add on to this game!',
	"/c changesprite cafe res://addons/godotvn/cafe2.png",
	'look at this expression switch',
	'/c options WOOW_SO_COOL branch1 No_way branch2 look_a_third_button branch3'],
	'branch1':[
		'/c changesprite cafe res://addons/godotvn/cafe.png',
		'ikr look at this branching dialogue',
		'/c branch continue'
	],
	'branch2':[
		'Now there is a way',
		'/c changesprite cafe res://addons/godotvn/cafe.png',
		'however this wasnt originally going to have this so it is kinda scuffed'
	],
	'branch3':[
		'Yep a third button',
		'/c changesprite cafe res://addons/godotvn/cafe.png',
		'you can have lots of buttons too',
		'not sure how a lot of buttons will react though'
	],
	'continue':[
		'now lets get back on track',
		'/c inst res://addons/godotvn/tach.png tach 1400 500',
		'/c name Agnes Tachyon',
		'Henlo!!!',
		'miss me?'
	]

}
func playscene(s:String)->void:
	if not sceneplaying:
		sceneplaying = true
		var inst = overlay.instantiate()
		add_child(inst)
		currentscene = inst
		var t = Timer.new()
		add_child(t)
		t.start(.5)
		await t.timeout
		inst.playscene(testscript)
		#inst.playdialogue(result[scene])
