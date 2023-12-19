extends Button

var parent

func _init(parent_, text_):
	self.parent = parent_
	self.text = text_

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:	
# func _pressed():
		parent.button_click(self.text, self)
