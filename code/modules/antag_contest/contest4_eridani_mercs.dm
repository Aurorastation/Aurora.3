/hook/roundstart/proc/schedule_eridani_fax()
	addtimer(CALLBACK(GLOBAL_PROC, /proc/send_eridani_fax), rand(1, 10) MINUTES)
	return TRUE

/proc/send_eridani_fax()
	var/obj/machinery/photocopier/faxmachine/F = null

	for (var/fx in allfaxes)
		var/obj/machinery/photocopier/faxmachine/FX = fx
		if (FX.department == "Head of Security's Office")
			F = FX
			break

	if (!F)
		return

	var/list/objectives = list(
		"A general alert exercise is to be carried out. Ensure the crew successfully carry out the correct procedure for each alert level for the shift." = 1,
		"We believe [pick(station_departments - "Command")] department contains known regulation breakers. Investigate using any means available." = 1,
		"A simulated [pick("hostile nation", "hostile corporation", "unknown life-form")] attack is to be carried out. Ensure the crew obey proper procedure and regulations." = 1,
		"The [pick(station_departments - "Command")] department has been over funded. Acquire [rand(500, 5000)] credits from their departmental account. Ensure this is done legally through security fines of the department's staff." = 1,
		"Ensure the station is secure. There are no special objectives at this time." = 6
	)
	var/objective = pickweight(objectives)

	var/fax_body = {"\[center\]\[logoeridani\]\[/center\]
\[center\]\[b\]ERIDANI CORPORATE BOARD ENCODED TRANSMISSION\[/b\]\[/center\]
\[center\]\[u\]\[small\]FOR USE BY ERIDANI CORPORATE ENFORCEMENT TROOPS ONLY\[/small\]\[/u\]\[/center\]

The Corporate Board has decided to issue you the following objective for today's shift:

[objective]

Ensure that you present yourself professionally."}

	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(null)
	P.name = "Revised Corporate Board Orders"
	P.info = fax_body
	P.update_icon()

	if (!F.recievefax(P))
		qdel(P)


/obj/item/clothing/under/rank/security/eridani
	desc = "The jumpsuit of a PMC contracted from the Eridani Corporate Federation by NanoTrasen to keep the peace."
	name = "Eridani PMC uniform"
	icon = 'icons/obj/clothing/eridani_pmcs.dmi'
	icon_state = "pmc_officer"
	item_state = "pmc_officer"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/head_of_security/eridani
	desc = "The jumpsuit of a PMC commander contracted from the Eridani Corporate Federation by NanoTrasen to keep the peace."
	name = "Eridani PMC commander's uniform"
	icon = 'icons/obj/clothing/eridani_pmcs.dmi'
	icon_state = "pmc_commander"
	item_state = "pmc_commander"
	contained_sprite = TRUE
