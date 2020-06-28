/datum/computer_file/program/antag_uplink
	filename = "scalesbrwsr"
	filedesc = "Scales'n'Stuff Browser"
	extended_desc = "A browser that connects the user directly to the Scales'n'Stuff network!"
	program_icon_state = "generic"
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 0
	available_on_ntnet = FALSE
	requires_ntnet = FALSE
	var/uplink_password = ""

/datum/computer_file/program/antag_uplink/New(obj/item/modular_computer/comp, var/assigned_password)
	..()
	uplink_password = assigned_password

/datum/computer_file/program/antag_uplink/run_program(mob/user)
	if(!computer.hidden_uplink)
		to_chat(user, SPAN_WARNING("\The [computer] beeps and forcefully shuts down the program."))
		return
	var/password_input = input(user, "Please enter the password!", "Restricted Access") as text|null
	if(!password_input || password_input == "")
		return
	if(password_input == uplink_password)
		to_chat(user, SPAN_NOTICE("\The [computer] dings, and a new UI opens..."))
		computer.hidden_uplink.trigger(user)
	else
		to_chat(user, SPAN_WARNING("\The [computer] buzzes."))