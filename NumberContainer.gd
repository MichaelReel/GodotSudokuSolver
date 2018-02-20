extends GridContainer

var NumberButton = load("res://NumberButton.gd")
var sudokuGrid

func _ready():
	sudokuGrid = get_parent().get_node("EntryContainer")
	var symbols = sudokuGrid.button_symbols
	
	for i in symbols:
		var button = NumberButton.new(self, i)
		button.toggle_mode = true
		add_child(button)

func button_click(text, button):
	for b in get_children():
		if b != button: b.pressed = false
	if button.pressed: button.pressed = false
	sudokuGrid.set_value(text)