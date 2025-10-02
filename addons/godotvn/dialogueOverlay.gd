extends CanvasLayer


@onready var panel = $Panel
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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dlabel.text = ''
	nlabel.text = ''
	var windowSize = DisplayServer.window_get_size()
	panel.set_size(windowSize)
	dbox.set_size(Vector2(windowSize.x/1.5,windowSize.y/2.5))
	dbox.global_position.y = windowSize.y - dbox.size.y
	dbox.global_position.x = windowSize.x/2 - dbox.size.x/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and not talking:
		index += 1
		if index < len(section):
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
			#if you hold spacebar the text displays faster
			if Input.is_action_pressed("ui_accept"):
				textTimer.start(.01)
			else:
				textTimer.start(.05)
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
		'options':
			# for every 2 text, route
			var button = null
			var buttons = []
			var yoffset = 0
			for i in arg:
				if button == null:
					var inst = dialoguebutton.instantiate()
					var text = ' '.join(i.split('_'))
					add_child(inst)
					inst.settext(text)
					
					button = inst
					buttons.append(inst)
					yoffset += 1
				else:
					button.setroute(i)
					button = null
			var idex = 1
			for b in buttons:
				b.sety(len(buttons) + 1,idex)
				idex += 1


func _on_loaded() -> void:
	pass # Replace with function body.
