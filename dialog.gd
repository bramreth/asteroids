extends Control

onready var richText = get_node("VSplitContainer/backdrop/VBoxContainer/HSplitContainer/CenterContainer/RichTextLabel")
var text_queue = []
signal exit_dialog()
# Called when the node enters the scene tree for the first time.
func _ready():
	text_queue = ["woah, what's going on here?", "captains log, leaving hyperspace", "cargo ship two clicks galactic east."]
	write_text(text_queue.pop_front())
	$VSplitContainer/backdrop/VBoxContainer/interactions/VBoxContainer/Button.grab_focus()

func write_text(text_in):
	richText.text = text_in
	
func handle_queue():
	if not text_queue.empty():
		write_text(text_queue.pop_front())
	else:
		exit_dialog()
		
func exit_dialog():
	emit_signal("exit_dialog")
	self.queue_free()

func _on_Button_pressed():
	handle_queue()
