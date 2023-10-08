//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	desc = "A console that displays information on the status of the patient on an adjacent operating table."
	density = TRUE
	anchored = TRUE
	icon_screen = "crew"
	icon_keyboard = "teal_key"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/operating
	var/obj/machinery/optable/table = null

	var/list/bodyscans = list()
	var/selected = 0

/obj/machinery/computer/operating/New()
	..()
	for(var/obj/machinery/optable/T in orange(1,src))
		table = T
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)


/obj/machinery/computer/operating/attack_hand(mob/user)
	if(..())
		return

	ui_interact(user)

/obj/machinery/computer/operating/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Operating", "Patient Monitoring Console", 450, 500)
		ui.open()

/obj/machinery/computer/operating/process()
	if(operable())
		updateDialog()

/obj/machinery/computer/operating/ui_data(mob/user)
	var/list/data = list(
		"noscan" = null,
		"nocons" = null,
		"occupied" = null,
		"invalid" = null,
		"ipc" = null,
		"stat" = null,
		"name" = null,
		"species" = null,
		"brain_activity" = null,
		"pulse" = null,
		"blood_pressure" = null,
		"blood_pressure_level" = null,
		"blood_volume" = null,
		"blood_o2" = null,
		"blood_type" = null
	)

	var/mob/living/carbon/human/occupant
	if(table)
		occupant = table.occupant

		data["noscan"] = !!table.check_species()
		data["nocons"] = !table
		data["occupied"] = !!table.occupant
		data["invalid"] = !!table.check_species()
		data["ipc"] = occupant && isipc(occupant)

	if(!data["invalid"])
		var/brain_result = occupant.get_brain_result()
		var/pulse_result
		if(occupant.should_have_organ(BP_HEART))
			var/obj/item/organ/internal/heart/heart = occupant.internal_organs_by_name[BP_HEART]
			if(!heart)
				pulse_result = 0
			else if(BP_IS_ROBOTIC(heart))
				pulse_result = -2
			else if(occupant.status_flags & FAKEDEATH)
				pulse_result = 0
			else
				pulse_result = occupant.get_pulse(GETPULSE_TOOL)
		else
			pulse_result = -1

		if(pulse_result == ">250")
			pulse_result = -3

		var/displayed_stat = occupant.stat
		var/blood_oxygenation = occupant.get_blood_oxygenation()
		if(occupant.status_flags & FAKEDEATH)
			displayed_stat = DEAD
			blood_oxygenation = min(blood_oxygenation, BLOOD_VOLUME_SURVIVE)

		data["stat"] = displayed_stat
		data["name"] = occupant.name
		data["species"] = occupant.get_species()
		data["brain_activity"] = brain_result
		data["pulse"] = text2num(pulse_result)
		data["blood_pressure"] = occupant.get_blood_pressure()
		data["blood_pressure_level"] = occupant.get_blood_pressure_alert()
		data["blood_volume"] = occupant.get_blood_volume()
		data["blood_o2"] = blood_oxygenation
		data["blood_type"] = occupant.dna.b_type

	return data
