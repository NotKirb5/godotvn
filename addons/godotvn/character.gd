extends Node2D

@onready var spritenode = $Sprite2D
var spawning = true
var focusing = false
var defocusing = false
var removing = false
var moving = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawning:
		self.modulate.a = move_toward(self.modulate.a, 1, 3*delta)
		if self.modulate.a >= 1:
			spawning = false
	#i feel like theres a better way to do this but it loosk nicer in the game so it dont matter
	if defocusing:
		self.modulate.a = move_toward(self.modulate.a,0.7,3*delta)
		self.scale.x = move_toward(self.scale.x,0.9,3*delta)
		self.scale.y = move_toward(self.scale.y,0.9,3*delta)
		if self.modulate.a <= 0 and self.scale.x <= 0.8 and self.scale.y <= 0.8:
			defocusing = false
	elif focusing:
		self.modulate.a = move_toward(self.modulate.a,1,3*delta)
		self.scale.x = move_toward(self.scale.x,1,1*delta)
		self.scale.y = move_toward(self.scale.y,1,1*delta)
		if self.modulate.a >= 1 and self.scale.x >= 1 and self.scale.y >= 1:
			defocusing = false
	
	if removing:
		self.modulate.a = move_toward(self.modulate.a,0,10*delta)
		if self.modulate.a <= 0:
			self.queue_free()
	
	if moving != Vector2(0,0):
		print('moving')
		self.global_position.x = move_toward(self.global_position.x,moving.x,750*delta)
		self.global_position.y = move_toward(self.global_position.y,moving.y,750*delta)
		
		if self.global_position == moving:
			moving = Vector2(0,0)
		



func addsprite(sprite):
	spritenode.texture = sprite

func defocus()->void:
	focusing = false
	spawning = false
	defocusing = true

func focus()->void:
	defocusing = false
	focusing = true

func flipsprite()->void:
	spritenode.flip_h = !spritenode.flip_h

func remove()->void:
	removing = true
	defocusing = false
	focusing = false

func move(pos:Array)->void:
	print(pos)
	moving = Vector2(int(pos[1]),int(pos[2]))
