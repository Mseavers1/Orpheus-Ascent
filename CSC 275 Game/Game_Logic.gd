extends Sprite2D

var scores = [0, 0]

var board = [[0, 14], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Temp - testing only
	_movePieceBottom(0)
	_print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _print():
	print(board)
	print(scores)

# Called when the top user selects a cell
func _movePieceTop(selectedIndex):
	
	# Get all marbles from selected cell
	var count = board[selectedIndex][0]
	
	# Empty current cell
	board[selectedIndex][0] = 0
	
	# Continue through cells until all marbles from the selected cell are dispersed
	for i in range(count):
		
		# Find the index for the next cell
		var nextIndex = selectedIndex - 1 - (i % 13)
		
		# At the end of the list, revert back to the start at cell 5 -- ** Couldn't find alternative solution without using this **
		if i == 12:
			nextIndex = 5
		
		# Logic for when the marble lands in home spot (-1)
		if nextIndex == -1:
			scores[0] += 1
			
		# Logic for when the marble lands past the home spot
		elif nextIndex < -1:
			# Indices -2 to -7 refer to the bottom cells
			# -- +2 due to the score index and since index 0 is the start of the bottom) -- 
			board[abs(nextIndex + 2)][1] += 1
			
		# Logic for when the marble is before the home spot (5 to 0)
		else:
			# Move to next cell and add a marble
			board[nextIndex][0] += 1
			
			
# Called when the bottom user selects a cell
func _movePieceBottom(selectedIndex):
	
	# Get all marbles from selected cell
	var count = board[selectedIndex][1]
	
	# Empty current cell
	board[selectedIndex][1] = 0
	
	# Continue through cells until all marbles from the selected cell are dispersed
	for i in range(count):
		
		# Find the index for the next cell
		var nextIndex = selectedIndex + 1 + (i % 13)
		
		# At the end of the list, revert back to the start at cell 0 -- ** Couldn't find alternative solution without using this **
		if i == 12:
			nextIndex = 0
		
		# Logic for when the marble lands in home spot (6)
		if nextIndex == 6:
			scores[1] += 1
			
		# Logic for when the marble lands past the home spot
		elif nextIndex > 6:
			# Indices 7 to 12 refer to the top cells
			# -- -6 :: -2 due to the score index and since index 5 is the start of the top) and -4 to get the math to work for the 2 multiplications ** to get it to count down from 5 to 0 --
			var findBottomIndex = nextIndex - (2 * (nextIndex - 6))
			
			board[findBottomIndex][0] += 1
			
		# Logic for when the marble is before the home spot (0 to 5)
		else:
			# Move to next cell and add a marble
			board[nextIndex][1] += 1
	
	
