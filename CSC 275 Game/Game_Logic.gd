extends Node

var currentTurn = 0 # 0 - Top | 1 - Bottom
var scores = [0, 0]

var board

func _startMatch():
	board = [[4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4]]
	$Board._setupBoard()
	$Game_HUD._starting_score()
	print(board)
			

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

func _ready():
	_startMatch()

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
	
	# Prepare to animate marble
	var marbles = $Board.visual_cells[selectedIndex][0]
	
	# Continue through cells until all marbles from the selected cell are dispersed
	for i in range(count):
		
		# Get a marble in the cell
		var marble = marbles[i]
		
		# Move marble up
		var tween = create_tween()
		tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y - 50), 0.1).from(marble.position)
		
		await tween.finished
		tween.stop()
		
		# Find the index for the next cell
		var nextIndex = selectedIndex - 1 - (i % 13)
		
		# At the end of the list, revert back to the start at cell 5 -- ** Couldn't find alternative solution without using this **
		if i == 12:
			nextIndex = 5
		
		# Logic for when the marble lands in home spot (-1)
		if nextIndex == -1:
			scores[0] += 1
			$Game_HUD._set_top_score(scores[0])
			
			# Move the marble visibly
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2($Board.top_home.position.x, marble.position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Move the marble down
			# TODO - Move in random positions along the y-axis
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y + 50), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Check if the user plays again
			if i + 1 == count:
				_repeatTurn()
				return
			
		# Logic for when the marble lands past the home spot
		elif nextIndex < -1:
			# Indices -2 to -7 refer to the bottom cells
			# -- +2 due to the score index and since index 0 is the start of the bottom) -- 
			board[abs(nextIndex + 2)][1] += 1
			
			# Move the marble visibly
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2($Board.cells[abs(nextIndex + 2)][1].position.x, marble.position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Move the marble down
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2(marble.position.x, $Board.cells[abs(nextIndex + 2)][1].position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Adds the marble to the next cell in the array
			$Board.visual_cells[abs(nextIndex + 2)][1].push_back(marble)
			
		# Logic for when the marble is before the home spot (5 to 0)
		else:
			# Move to next cell and add a marble
			board[nextIndex][0] += 1
			
			# Move the marble visibly
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2($Board.cells[nextIndex][0].position.x, marble.position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Move the marble down
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y + 50), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
		
			# Adds the marble to the next cell in the array
			$Board.visual_cells[nextIndex][0].push_back(marble)
		
	
	$Board.visual_cells[selectedIndex][0] = []
			
	_nextTurn()
			
# Called when the bottom user selects a cell
func _movePieceBottom(selectedIndex):
	
	# Get all marbles from selected cell
	var count = board[selectedIndex][1]
	
	# Empty current cell
	board[selectedIndex][1] = 0
	
	# Prepare to animate marble
	var marbles = $Board.visual_cells[selectedIndex][1]
	
	# Continue through cells until all marbles from the selected cell are dispersed
	for i in range(count):
		
		# Get a marble in the cell
		var marble = marbles[i]
		
		# Move marble down
		var tween = create_tween()
		tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y + 50), 0.1).from(marble.position)
		
		await tween.finished
		tween.stop()
		
		# Find the index for the next cell
		var nextIndex = selectedIndex + 1 + (i % 13)
		
		# At the end of the list, revert back to the start at cell 0 -- ** Couldn't find alternative solution without using this **
		if i == 12:
			nextIndex = 0
		
		# Logic for when the marble lands in home spot (6)
		if nextIndex == 6:
			scores[1] += 1
			$Game_HUD._set_bottom_score(scores[1])
			
			# Move the marble visibly
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2($Board.bottom_home.position.x, marble.position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Move the marble up
			# TODO - Move in random positions along the y-axis
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y - 50), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
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
			
			# Move the marble visibly
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2($Board.cells[findBottomIndex][0].position.x, marble.position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Move the marble up
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2(marble.position.x, $Board.cells[findBottomIndex][0].position.y), 0.1).from(marble.position)
			
			# Adds the marble to the next cell in the array
			$Board.visual_cells[findBottomIndex][0].push_back(marble)
			
		# Logic for when the marble is before the home spot (0 to 5)
		else:
			# Move to next cell and add a marble
			board[nextIndex][1] += 1
			
			# Move the marble visibly
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2($Board.cells[nextIndex][1].position.x, marble.position.y), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
			
			# Move the marble up
			tween = create_tween()
			tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y - 50), 0.1).from(marble.position)
			
			await tween.finished
			tween.stop()
		
			# Adds the marble to the next cell in the array
			$Board.visual_cells[nextIndex][1].push_back(marble)
		
	
	$Board.visual_cells[selectedIndex][1] = []
	_nextTurn()
	
