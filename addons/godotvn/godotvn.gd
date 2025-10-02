@tool
extends EditorPlugin

@export var autoloadName = "godotvn"

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton(autoloadName,"res://addons/godotvn/dialogueManager.gd")


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton(autoloadName)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
