extends Button

var parent

func _init(parent, text):
	self.parent = parent
	self.text = text

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:	
# func _pressed():
		parent.button_click(self.text, self)