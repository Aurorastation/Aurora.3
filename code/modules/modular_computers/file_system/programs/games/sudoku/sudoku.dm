/datum/computer_file/program/game/sudoku
	filename = "sudoku"					// File name, as shown in the file browser program.
	filedesc = "Sudoku"				// User-Friendly name. In this case, we will generate a random name in constructor.
	program_icon_state = "sudoku"				// Icon state of this program's screen.
	extended_desc = "A game of numbers, logic, and deduction. Popular for centuries to keep the mind sharp."		// A nice description.
	size = 5								// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = FALSE					// This particular program does not require NTNet network conectivity...
	available_on_ntnet = TRUE				// ... but we want it to be available for download.
	nanomodule_path = /datum/nano_module/program/sudoku	// Path of relevant nano module. The nano module is defined further in the file.
	usage_flags = PROGRAM_ALL_REGULAR

/datum/nano_module/program/sudoku
	var/list/grid = null
	var/building = FALSE
	var/list/solution = list()

	var/cheated = FALSE

	var/list/boxes = list(//Most efficient way i could think to do this
	"11" = list(1,2,3,10,11,12,19,20,21),
	"12" = list(4,5,6,13,14,15,22,23,24),
	"13" = list(7,8,9,16,17,18,25,26,27),
	"21" = list(28,29,30,37,38,39,46,47,48),
	"22" = list(31,32,33,40,41,42,49,50,51),
	"23" = list(34,35,36,43,44,45,52,53,54),
	"31" = list(55,56,57,64,65,66,73,74,75),
	"32" = list(58,59,60,67,68,69,76,77,78),
	"33" = list(61,62,63,70,71,72,79,80,81)
	)
	var/message = ""//Error or informational message shown on screen.
	var/last_message = ""
	var/message_sent = FALSE
	var/list/clues = list("Easy" = 36, "Medium" = 31,"Hard" = 26,"Robust" = 17)
	var/last_user
	var/won_game = FALSE
	var/datum/computer_file/program/game/sudoku

	var/new_difficulty = "Easy" //The selected difficulty mode for generating the next grid

	var/collapse = FALSE
	var/width = 900

/datum/nano_module/program/sudoku/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = FALSE, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if (!grid)
		create_grid()
	data["grid"] = grid
	data["src"] = "\ref[src]"
	data["collapse"] = collapse
	data["message"] = message
	data["difficulty"] = new_difficulty
	if (message != last_message)
		last_message = message
		message_sent = world.time
	else if ((world.time - message_sent) > 100)//Make sure that messages show onscreen for at least 10 seconds
		message = ""//Displays for one refresh only
	last_user = user

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sudoku.tmpl", "Sudoku", width, 557, state = state)
		//if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(FALSE)

/datum/nano_module/program/sudoku/Topic(var/href, var/list/href_list)
	..()

	if(href_list["save"])//This is called with every keypress
		save_grid(href_list)
		return//No refreshing for every input
	else if(href_list["check"])
		save_grid(href_list)
		check_validity()
	else if(href_list["hint"])//Reveals one tile
		var/response = alert(usr, "Are you sure you want a hint? This will reveal the correct number for one tile. But you'll lose the pride of having figured it out yourself...", "Ask for a hint", "Help me.", "I can do it myself.")
		if(response == "Help me.")
			solver(1)
		else
			return
	else if(href_list["solve"])
		solver(81)
	else if(href_list["clear"])
		var/response = alert(usr, "Are you sure you want to clear the grid? This will remove all the numbers you've typed in. The starting clues will remain.", "Clear board", "Clear it.", "Wait no!")
		if(response == "Clear it.")
			clear_grid(FALSE)
		else
			return
	else if(href_list["purge"])
		clear_grid(TRUE)
	else if(href_list["difficulty"])
		new_difficulty = href_list["difficulty"]
	else if(href_list["newgame"])
		var/response = alert(usr, "Are you sure you want to start a new game? All progress on this one will be lost. Be sure to pick your desired difficulty first.", "New Puzzle", "Start Anew.", "Wait no!")
		if(response == "Start Anew.")
			advanced_populate_grid(clues[new_difficulty])
		else
			return
	else if(href_list["collapse"])
		collapse = !collapse
		set_width(usr)
		return

	if(usr)
		ui_interact(usr)

/datum/nano_module/program/sudoku/proc/set_width(var/mob/user)
	if(collapse)
		width = 400
	else
		width = 900

	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")
	if(ui)
		ui.close()
		ui_interact(user, force_open = TRUE)

/datum/nano_module/program/sudoku/proc/save_grid(var/list/inputdata)
	var/i = 1
	for(i = 1, i <= 81, i++)
		var/list/cell = grid[i]
		var/v = text2num(inputdata["[i]"])
		if(inputdata["[i]"] == "" || (v > 0 && v < 10))
			cell["value"] = inputdata["[i]"]

/datum/nano_module/program/sudoku/proc/create_grid()
	if(grid)
		grid.Cut()
	grid = list()

	var/n = 81
	var/list/numbers = list()
	while (n)
		n--
		numbers += rand(1,9)
	var/row = 1
	var/column = 0
	n = 1//reuse this
	for (var/a in numbers)
		var/list/number = list()
		number["value"] = ""
		//if (prob(20))
			//number["static"] = 1

		column++
		if (column > 9)
			row++
			column = 1

		number["id"] = "[row][column]"
		number["row"] = row
		number["column"] = column
		number["index"] = n
		number["tried"] = list()//used in grid generation
		n++
		grid.Add(list(number))

		var/box = ""
		switch (row)
			if (1 to 3)
				box += "1"
			if (4 to 6)
				box += "2"
			if (7 to 9)
				box += "3"

		switch (column)
			if (1 to 3)
				box += "1"
			if (4 to 6)
				box += "2"
			if (7 to 9)
				box += "3"

		number["box"] = box

	advanced_populate_grid()



/datum/nano_module/program/sudoku/proc/id_num(var/index)
	var/row = 1
	var/column = 1

	if(index <= 9)
		column = index
	else
		while(index > 9)
			index -= 9
			row++
		column = index

	return "[row][column]"

//Clears the grid:
//With an input of 0, clears all user input and restores the grid to just the generated clues
//With input of 1, clears every cell, grid becomes empty
/datum/nano_module/program/sudoku/proc/clear_grid(var/full = 0)
	for (var/t in grid)
		var/list/tile = t
		if (full || !tile["static"])
			tile["value"] = ""
			tile["static"] = 0
			tile["highlight"] = 0
	if(full)
		cheated = FALSE
		won_game = FALSE