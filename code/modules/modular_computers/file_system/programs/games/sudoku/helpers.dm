//This proc checks the validity of the current boardstate
//It will analyse all the tiles in sequence, and halt if it finds an invalid one.
//Tiles will be checked for conflicts along the row, border and 3x3 box
/datum/nano_module/program/sudoku/proc/check_validity()

	//This result will be returned at the end
	. = 0
	//Return var of 0 is normal, that means the game is unfinished and the boardstate is valid
	//Any return var > zero indicates invalid, with that number being the index of the first invalid tile
	//Return var of -1 indicates all tiles filled and boardstate valid. IE: Game over, you win!

	var/empty = 0
	var/conflict = 0
	for (var/t in grid)
		var/list/tile = t
		if (tile["static"])
			continue
		var/v = tile["value"]
		var/i = tile["index"]
		if (!v)
			empty++
			continue

		var/list/group
		group = get_row(i)
		for (var/n in group)
			if(n == v)//CONFLICT
				conflict = i
				break

		group = get_column(i)
		for (var/n in group)
			if(n == v)//CONFLICT
				conflict = i
				break

		group = get_box(i)
		for (var/n in group)
			if(n == v)//CONFLICT
				conflict = i
				break

		if (conflict)
			break

	if (conflict)
		message = "Error: Invalid tile found! The problem is highlighted"
		highlight(list(conflict))
		.=conflict

	else if (empty > 0)
		message = "Everything looks fine so far! You have [empty] tiles left to fill"
		highlight()


	//If we havent found any conflict and all tiles are filled, then the user has won the game.
	else if (empty == 0)
		message = "Congratulations! You win the game!"
		if (!won_game)
			playsound(get_turf(program.computer), 'sound/magic/light.ogg', 50, 1)
		won_game = 1
		.=-1




//Attempts to solve the board using simple single-tile logic. This will solvve most easier boards
//May implement split timelines for solving boards where the answer isnt simple
//Number of steps indicates how many tiles to solve. Passing 1 can serve as a hint function
/datum/nano_module/program/sudoku/proc/solver(var/steps = 81)
	if (check_validity() != 0) //Can't build on quicksand. The boardstate must be valid before we attempt to progress
		return

	var/done = 0
	var/list/emptytiles = list()


	for (var/t in grid)
		var/list/tile = t
		var/v = tile["value"]

		if (v)//Already has a valid value, next tile
			continue

		emptytiles += text2num(tile["index"])



	if(emptytiles.len)
		while (steps > 0 && !done)

			if (emptytiles.len <= 0 )
				done = 1//If we get here then the solver has won the game.
			var/i = pick_n_take(emptytiles)
			var/list/tile = grid[i]
			tile["value"] = solution[i]//Solution is the pre-saved correct solution for the puzzle
			tile["static"] = 1
			steps--
			cheated++//Cheated var indicates the user had help
			message = "A tile has been revealed for you. You've now had [cheated] hints"
			highlight(list(i))


//Returns all possible values for a tile
//If this ever returns nothing then the game is in an unwinnable state, a mistake has been made
/datum/nano_module/program/sudoku/proc/get_options(var/index)
	. = list(1,2,3,4,5,6,7,8,9)
	. -= get_row(index)
	. -= get_column(index)
	. -= get_box(index)


//Returns all tiles in the same row as index, excluding index
/datum/nano_module/program/sudoku/proc/get_row(var/index)
	var/list/tile = grid[index]
	//We get the row number from this

	var/rowstart = (((tile["row"]-1)*9) + 1)//Index of the first tile on the row we want

	var/i
	var/list/indices = list()
	for (i = 0, i <= 8, i++)
		indices += rowstart+i

	indices -= index

	return get_tile_values(indices)

//Returns all tiles in the same row as index, excluding index
/datum/nano_module/program/sudoku/proc/get_column(var/index)
	var/list/tile = grid[index]
	//We get the row number from this

	var/columnstart = tile["column"]//Index of the first tile on the row we want
	var/i
	var/list/indices = list()
	for (i = 0, i <= 8, i++)
		indices += columnstart+(i*9)

	indices -= index


	return get_tile_values(indices)

/datum/nano_module/program/sudoku/proc/get_box(var/index)
	var/list/tile = grid[index]
	var/list/temp = boxes[tile["box"]]
	var/list/boxind = temp.Copy()
	boxind -= index
	return get_tile_values(boxind)


//Takes a list of indexes, returns the grid tiles with those indexes.
/datum/nano_module/program/sudoku/proc/get_tiles(var/list/indexes)
	. = list()
	for (var/i in indexes)
		. += list(grid[i])

/datum/nano_module/program/sudoku/proc/get_tile_values(var/list/indexes)
	. = list()
	for (var/i in indexes)
		var/list/tile = grid[i]
		. += tile["value"]




//A not so simple grid builder which uses a backtracking algorithm.
//Attempts to build the grid linearly with random numbers, backtracking and trying again whenever a
//collision is found
/datum/nano_module/program/sudoku/proc/advanced_populate_grid(var/clues = 36)
	set background = 1
	if (building)
		return

	building = 1
	clear_grid(1)
	var/iterations = 0
	var/i = 1
	for (i = 1, i <= 81, i++)
		var/list/tile = grid[i]
		iterations++

		var/list/tried = tile["tried"]
		var/list/options = get_options(i)

		options.Remove(tried)//The list of tried numbers is used when we backtrack

		//So long as we have any options left, we'll pick a random one and keep going
		if (options.len > 0)
			tile["value"] = pick(options)
			tile["static"] = 1
		else
			//If there are no valid, non-colliding numbers for this tile, then things get interesting.
			var/list/prev = grid[i-1]//Get the previous tile
			var/list/t = prev["tried"]
			t += prev["value"]//The value for the previous tile is now blacklisted
			prev["value"] = ""
			//grid[i-1] = prev

			//Now we wipe our own tried list since we're stepping back. How we've branched forward
			//from this point is no longer relevant
			tile["tried"] = list()
			//And finally we set i back two decrements, so in the next cycle of the loop
			//it will look at the previous cell
			i -= 2
		if (iterations == 100)
			iterations = 0
			sleep(1)

	//Now we copy over the solution
	solution = list()
	for (var/t in grid)
		var/list/tile = t
		solution += tile["value"]



	//And finally we start removing stuff until we have only the clues left
	var/toremove = 81 - clues
	var/list/filledtiles = list()
	for (i = 1, i <= 81, i++)
		filledtiles += i
	while (toremove > 0)
		i = pick_n_take(filledtiles)
		toremove--
		var/list/tile = grid[i]
		tile["value"] = ""
		tile["static"] = 0
		tile["tried"] = list()//to prevent any cheating


	building = 0


//Highlights all indices in the list. Unhighlights every other cell
/datum/nano_module/program/sudoku/proc/highlight(var/list/indices)
	if (!indices)
		indices = list()
	for (var/i = 1, i <= 81, i++)
		var/list/tile = grid[i]
		if (indices.len && (i in indices))
			tile["highlight"] = 1
		else
			tile["highlight"] = 0
