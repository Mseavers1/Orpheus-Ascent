## This script is for all math functions ##

# Distance formula
func _distance(p1, p2):
	return abs(pow(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2), 0.5))
	
	
## From https://www.geeksforgeeks.org/find-two-rectangles-overlap/
# Returns true if two rectangles(l1, r1) and (l2, r2) overlap
func do_overlap(l1, r1, l2, r2):
	
	# if rectangle has area 0, no overlap
	if l1.x == r1.x or l1.y == r1.y or r2.x == l2.x or l2.y == r2.y:
		return false
	 
	# If one rectangle is on left side of other
	if l1.x > r2.x or l2.x > r1.x:
		return false

	# If one rectangle is above other (fixed for godot plane as y is increasing downwards)
	if r1.y < l2.y or r2.y < l1.y:
		return false

	return true

# LINE/RECTANGLE -- https://www.jeffreythompson.org/collision-detection/line-rect.php -- Altered by Michael Seavers
func lineRect(x1, y1, x2, y2, rx, ry, rw, rh):
	
	# check if the line has hit any of the rectangle's sides
	# uses the Line/Line function below
	var left = lineLine(x1,y1,x2,y2, rx,ry,rx, ry+rh);
	var right = lineLine(x1,y1,x2,y2, rx+rw,ry, rx+rw,ry+rh);
	var top = lineLine(x1,y1,x2,y2, rx,ry, rx+rw,ry);
	var bottom = lineLine(x1,y1,x2,y2, rx,ry+rh, rx+rw,ry+rh);

	# if ANY of the above are true, the line
	# has hit the rectangle
	if (left || right || top || bottom):
		return true;
	return false;

# LINE/LINE -- https://www.jeffreythompson.org/collision-detection/line-rect.php -- Altered by Michael Seavers
func lineLine(x1, y1, x2, y2, x3, y3, x4, y4) :

	# calculate the direction of the lines
	var uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
	var uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

	# if uA and uB are between 0-1, lines are colliding
	if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1):
		return true;
		
	return false;
	
func solve_quad(mat, x):
	return (pow(x, 2) * mat[0]) + (mat[1] * x) + mat[2]

## Matrix code from https://www.geeksforgeeks.org/system-linear-equations-three-variables-using-cramers-rule/ -- updated by michael to fit godot ##

# This functions finds the 
# determinant of Matrix
func determinantOfMatrix(mat):
	
	var ans = (mat[0][0] * (mat[1][1] * mat[2][2] - mat[2][1] * mat[1][2]) - mat[0][1] * (mat[1][0] * mat[2][2] - mat[1][2] * mat[2][0]) + mat[0][2] * (mat[1][0] * mat[2][1] - mat[1][1] * mat[2][0]))
	return ans
 
# This function finds the solution of system of
# linear equations using cramer's rule
func findSolution(coeff):
 
	# Matrix d using coeff as given in 
	# cramer's rule
	var d = [[coeff[0][0], coeff[0][1], coeff[0][2]], [coeff[1][0], coeff[1][1], coeff[1][2]], [coeff[2][0], coeff[2][1], coeff[2][2]]]
	 
	# Matrix d1 using coeff as given in 
	# cramer's rule
	var d1 = [[coeff[0][3], coeff[0][1], coeff[0][2]],
	[coeff[1][3], coeff[1][1], coeff[1][2]],
	[coeff[2][3], coeff[2][1], coeff[2][2]]]
	 
	# Matrix d2 using coeff as given in 
	# cramer's rule
	var d2 = [[coeff[0][0], coeff[0][3], coeff[0][2]],
	[coeff[1][0], coeff[1][3], coeff[1][2]],
	[coeff[2][0], coeff[2][3], coeff[2][2]]]
	 
	# Matrix d3 using coeff as given in 
	# cramer's rule
	var d3 = [[coeff[0][0], coeff[0][1], coeff[0][3]], [coeff[1][0], coeff[1][1], coeff[1][3]], [coeff[2][0], coeff[2][1], coeff[2][3]]]
 
	# Calculating Determinant of Matrices 
	# d, d1, d2, d3
	var D = determinantOfMatrix(d)
	var D1 = determinantOfMatrix(d1)
	var D2 = determinantOfMatrix(d2)
	var D3 = determinantOfMatrix(d3)
		
	# print("D is : ", D)
	# print("D1 is : ", D1)
	# print("D2 is : ", D2)
	# print("D3 is : ", D3)
 
	# Case 1
	if (D != 0):
	   
		# Coeff have a unique solution. 
		# Apply Cramer's Rule
		var x = D1 / D
		var y = D2 / D
			
		# calculating z using cramer's rule
		var z = D3 / D  
			
		# print("Value of x is : ", x)
		# print("Value of y is : ", y)
		# print("Value of z is : ", z)
		
		return Vector3(x, y, z)
 
	# Case 2
	else:
		if (D1 == 0 and D2 == 0 and
			D3 == 0):
			# print("Infinite solutions")
			return null
		elif (D1 != 0 or D2 != 0 or
			D3 != 0):
			# print("No solutions")
			return null


## Quick Sort Code From https://www.geeksforgeeks.org/quick-sort/ ##
# Modified by Michael for godot

# Function to find the partition position
func partition(array, low, high):
	
	# Choose the rightmost element as pivot
	var pivot = array[high]

	# Pointer for greater element
	var i = low - 1

	# Traverse through all elements
	# compare each element with pivot
	for j in range(low, high):
		if array[j] <= pivot:
			
			# If element smaller than pivot is found
			# swap it with the greater element pointed by i
			i = i + 1

			# Swapping element at i with element at j
			swap(i, j, array)

	# Swap the pivot element with
	# the greater element specified by i
	swap(i + 1, high, array)

	# Return the position from where partition is done
	return i + 1

func swap(i, j, arr):
	var temp = arr[i]
	arr[i] = arr[j]
	arr[j] = temp

# Function to perform quicksort
func quicksort(array, low, high):
	if low < high:
		
		# Find pivot element such that
		# element smaller than pivot are on the left
		# element greater than pivot are on the right
		var pi = partition(array, low, high)
		
		# Recursive call on the left of pivot
		quicksort(array, low, pi - 1)
		
		# Recursive call on the right of pivot
		quicksort(array, pi + 1, high)
