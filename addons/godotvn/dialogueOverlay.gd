extends CanvasLayer


@onready var panel = $Panel
@onready var dpanel = $dialoguepanel
@onready var btncontainer = $buttoncontainer
@onready var dbox = $dialogueBox
@onready var nlabel = $dialogueBox/namelabel
@onready var dlabel = $dialogueBox/dialoguelabel
@onready var character = preload("res://addons/godotvn/character.tscn")
@onready var dialoguebutton = preload("res://dialogueOptions.tscn")
@onready var textTimer = $textTimer
var index = 0
var scene = {}
var section = []
var talking = false
var waiting = false
var selecting = false
var new = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dlabel.text = ''
	nlabel.text = ''
	var windowSize = DisplayServer.window_get_size()
	panel.set_size(windowSize)
	dbox.set_size(Vector2(windowSize.x/1.5,windowSize.y/2.5))
	dbox.global_position.y = windowSize.y - dbox.size.y
	dbox.global_position.x = windowSize.x/2 - dbox.size.x/2
	dpanel.set_size(Vector2(windowSize.x/1.5,windowSize.y/2.5))
	dpanel.global_position.y = windowSize.y - dbox.size.y
	dpanel.global_position.x = windowSize.x/2 - dbox.size.x/2
	btncontainer.size = Vector2(windowSize.x/3, windowSize.y)
	btncontainer.global_position = Vector2(windowSize.x/2 - btncontainer.size.x/2, 0)
	nlabel.add_theme_font_size_override("font_size",dman.options['namefontsize'])
	dlabel.add_theme_font_size_override("font_size",dman.options['dialoguefontsize'])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		new = false
	if Input.is_action_just_pressed("ui_accept") and not talking and not waiting and not selecting:
		index += 1
		if index < len(section):
			new = true
			play(section[index])
		else:
			dman.sceneplaying = false
			self.queue_free()
	

func addcharacter(list:Array)->void:
	var inst = character.instantiate()
	var body = load(list[0])
	inst.add_to_group(list[1])
	inst.global_position = Vector2(int(list[2]),int(list[3]))
	add_child(inst)
	inst.addsprite(body)

func nextline()->void:
	index += 1
	if index < len(section):
		play(section[index])
	else:
		dman.sceneplaying = false
		self.queue_free()

func play(line:String)->void:
	if line.begins_with('/c'):
		var commands = line.split(' ')
		commands.remove_at(0)
		var command = commands[0]
		commands.remove_at(0)
		print(command,commands)
		exec(command,commands)
		
	else:
		talking = true
		
		dlabel.text = ''
		for i in line:
			dlabel.text = dlabel.text + i
			var fastspeed = dman.options['fasttextspeed']
			var normspeed = dman.options['textspeed']
			#if you hold spacebar the text displays faster
			if Input.is_action_pressed("ui_accept") and not new:
				
				if fastspeed != 0:
					
					textTimer.start(fastspeed)
					await textTimer.timeout
			else:
				if  normspeed != 0:
					
					textTimer.start(normspeed)
					await textTimer.timeout
		talking = false

func playscene(s:Dictionary)->void:
	scene = s
	print(s)
	playsection(s['root'])

func playsection(s:Array)->void:
	index = 0
	section = s
	play(section[index])
	

func changebranch(branch:String)->void:
	index = 0
	selecting = false
	for i in get_tree().get_nodes_in_group('dialogueButtons'):
		i.queue_free()
	playsection(scene[branch])

func exec(c,arg):
	match c:
		'inst':
			addcharacter(arg)
			nextline()
		'name':
			nextline()
			nlabel.text = ' '.join(arg)
		'changesprite':
			var chara = get_tree().get_first_node_in_group(arg[0])
			chara.addsprite(load(arg[1]))
			nextline()
		'branch':
			changebranch(arg[0])
		'delete':
			var chara = get_tree().get_first_node_in_group(arg[0])
			chara.remove()
			nextline()
		'focus':
			var chara = get_tree().get_first_node_in_group(arg[0])
			chara.focus()
			nextline()
		'defocus':
			var chara = get_tree().get_first_node_in_group(arg[0])
			chara.defocus()
			nextline()
		'wait':
			var t = Timer.new()
			add_child(t)
			t.start(float(arg[0]))
			waiting = true
			await t.timeout
			t.queue_free()
			waiting = false
			nextline()
		'move':
			var chara = get_tree().get_first_node_in_group(arg[0])
			chara.move(arg)
			nextline()
		'flip':
			var chara = get_tree().get_first_node_in_group(arg[0])
			chara.flipsprite()
		'options':
			# for every 2 text, route
			var button = null
			var buttons = []
			var yoffset = 0
			selecting = true
			for i in arg:
				if button == null:
					var inst = dialoguebutton.instantiate()
					var text = ' '.join(i.split('_'))
					btncontainer.add_child(inst)
					inst.settext(text)
					
					button = inst
					buttons.append(inst)
					yoffset += 1
				else:
					button.setroute(i)
					button = null
			var idex = 1
			for b in buttons:
				#b.sety(len(buttons) + 1,idex)
				idex += 1


func _on_loaded() -> void:
	pass # Replace with function body.
