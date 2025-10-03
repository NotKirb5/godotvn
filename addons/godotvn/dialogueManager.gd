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
		'however this wasnt originally going to have this so it is kinda scuffed',
		'/c branch continue'
	],
	'branch3':[
		'Yep a third button',
		'/c changesprite cafe res://addons/godotvn/cafe.png',
		'you can have lots of buttons too',
		'not sure how a lot of buttons will react though',
		'/c branch continue'
		
	],
	'continue':[
		'now lets get back on track',
		'/c inst res://addons/godotvn/tach.png tach 1400 500',
		'/c name Agnes Tachyon',
		'/c defocus cafe',
		'Henlo!!!',
		'miss me?',
		'/c name Manhatten Cafe',
		'/c focus cafe',
		'/c defocus tach',
		'oh hell nah',
		'/c delete cafe',
		'/c wait 1.5',
		'/c name Agnes Tachyon',
		'/c focus tach',
		'awww she left',
		'/c move tach 900 500',
		'/c wait .3',
		'i guess its just me to steal the show',
		'i can also teleport watch me',
		'/c delete tach',
		'/c inst res://addons/godotvn/tach.png tach 500 500',
		'fancy is it not',
		'let me face the correct side real quick',
		'/c flip tach',
		'thats better,'
		
	]
}

var options = {
	'font': '',
	'fontcolor': 'white',
	'namefontsize': 40,
	'dialoguefontsize': 24, 
	'textspeed': .05,
	'fasttextspeed': 0
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
