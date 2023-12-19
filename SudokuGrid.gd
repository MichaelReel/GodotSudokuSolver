extends GridContainer

var ranks = []
var files = []
var boxes = []

var Cell = load("res://SudokuCell.gd")

var clear_value = "  "
var delete_value = "X"
var current_value = self.clear_value

var symbols = ["1","2","3","4","5","6","7","8","9"]
var button_symbols = []

var info_box

func _ready():
	
	info_box = self.get_parent().get_node("Info")
	
	# In 3.1 this should be doable with slicing: symbols[1:9] + "X"
	button_symbols = [] + symbols
	button_symbols.append(self.delete_value)
	
	for i in 9:
		ranks.append([])
		files.append([])
		boxes.append([])
		ranks[i].resize(9)
		files[i].resize(9)
		boxes[i].resize(9)
	
	for box_x in 3:
		for box_y in 3:
			# Create each 3x3 sub-grid
			var box = GridContainer.new()
			box.columns = 3
			add_child(box)
			
			# put in separators
			if box_y < 2: add_child(VSeparator.new())
			if box_y == 2 && box_x < 2: 
				add_child(HSeparator.new())
				add_child(Control.new())
				add_child(HSeparator.new())
				add_child(Control.new())
				add_child(HSeparator.new())
				
			# populate each sub-grid with cells
			for cell_x in 3:
				for cell_y in 3:
					var x = box_x * 3 + cell_x
					var y = box_y * 3 + cell_y
					
					# Gather association groups
					var groups = [ranks[y], files[x], boxes[box_y * 3 + box_x]]
					
					var cell = Cell.new(self, Vector2(x, y), groups)
					cell.text = self.clear_value
					box.add_child(cell)
					
					# Store associations
					ranks[y][x] = cell
					files[x][y] = cell
					boxes[box_y * 3 + box_x][cell_y * 3 + cell_x] = cell

func cell_click(pos, cell):
	# if clearing cell, reset existing value in cells
	if self.current_value == self.clear_value:
		cell.text = self.current_value
	else:
		# Check groups for matching values
		var text_cell = find_current_in_groups(cell)
		if text_cell != null:
			print (self.current_value, " is already in cell ", text_cell.pos)
		else:
			cell.text = self.current_value
	
	var certain_ret = scan_for_certainties()
	while certain_ret != null:
		certain_ret[0].text = certain_ret[1]
		certain_ret = scan_for_certainties()
		
	self.update_info()

func set_value(text):
	if text == self.delete_value:
		self.current_value = self.clear_value
	else:
		self.current_value = text

func find_current_in_groups(cell):
	for group in cell.groups:
		for oth_cell in group:
			if oth_cell.text == self.current_value:
				return oth_cell
	return null
			
func scan_for_certainties():
	# If there is a cell with only one possible, then that is a certainty
	for rank in self.ranks:
		for cell in rank:
			if cell.text == self.clear_value && cell.get_possibles().size() == 1:
				return [cell, cell.get_possibles()[0]]

	# if there is a value that appears only once in a entire group of cells possibles, 
	# for a cell that is does not have a text value already set,
	# then that is a certainty for that cell
	for group in self.ranks + self.files + self.boxes:
		var scores = {}
		for cell in group:
			if cell.text != self.clear_value: continue
			for symbol in cell.get_possibles():
				if not scores.keys().has(symbol): scores[symbol] = []
				scores[symbol].append(cell)

		for symbol in scores.keys():
			if scores[symbol].size() == 1:
				return [scores[symbol][0], symbol]
	
	return null

func update_info():
	var info_str = ""
	for rank in self.ranks:
		for cell in rank:
			info_str += str(cell.pos) + ":" + str(cell.get_possibles()) + "\n"
	info_box.text = info_str
