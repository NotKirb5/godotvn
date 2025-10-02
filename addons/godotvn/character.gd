extends Node2D

@onready var spritenode = $Sprite2D
var spawning = true
var focusing = false
var defocusing = false
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
		if self.modulate.a <= 180 and self.scale.x <= 0.8 and self.scale.y <= 0.8:
			defocusing = false
	elif focusing:
		self.modulate.a = move_toward(self.modulate.a,1,3*delta)
		self.scale.x = move_toward(self.scale.x,1,1*delta)
		self.scale.y = move_toward(self.scale.y,1,1*delta)
		if self.modulate.a >= 255 and self.scale.x >= 1 and self.scale.y >= 1:
			defocusing = false



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
