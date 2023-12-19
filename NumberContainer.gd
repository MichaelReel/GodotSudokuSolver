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

func button_click(text: String, button: Button):
	for b in get_children():
		if b != button: b.set_pressed_no_signal(false)
	if button.pressed:
		button.set_pressed_no_signal(false)
	sudokuGrid.set_value(text)
