extends Node

var currentTurn = 0 # 0 - Top | 1 - Bottom
var scores = [0, 0]

var board

func _startMatch():
	board = [[4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4]]

# Called when its the next user's turn (No repeats)
func _nextTurn():
	currentTurn = (currentTurn + 1) % 2
	
	# Animation to display the next turn?
	# Update turn counter display
	$Game_HUD._updateTurnDisplay(_getCurrentTurnName())
	
	# Await User Input or AI Input
	
# Returns the name of the user of whoever turn it is
func _getCurrentTurnName():
	# TODO - Determine if it players or bots
	
	# Top
	if currentTurn == 0:
		return "P1"
	
	# Bottom
	return "P2"

# Called when the user gets to play again
func _repeatTurn():
	
	# Animation to tell it the player turn again?
	# Small text that tells its the player turn?
	
	pass

func _init():
	_startMatch()
	
	# Temp
	#_movePieceBottom(4)
	#_print()

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Temp	
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
			
			# Check if the user plays again
			if i + 1 == count:
				_repeatTurn()
				return
			
		# Logic for when the marble lands past the home spot
		elif nextIndex < -1:
			# Indices -2 to -7 refer to the bottom cells
			# -- +2 due to the score index and since index 0 is the start of the bottom) -- 
			board[abs(nextIndex + 2)][1] += 1
			
		# Logic for when the marble is before the home spot (5 to 0)
		else:
			# Move to next cell and add a marble
			board[nextIndex][0] += 1
			
	_nextTurn()
			
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
			
			# Check if the user plays again
			if i + 1 == count:
				_repeatTurn()
				return
			
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
	_nextTurn()
	
