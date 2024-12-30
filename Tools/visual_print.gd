extends Control

var log : String = ""


func _ready():
	if !OS.is_debug_build():
		#self.queue_free()
		self.hide()


func vprint(x):
	log = str(x) + "\n" + log
	$Label.text = log
