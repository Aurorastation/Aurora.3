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
	P.set_content("Revised Corporate Board Orders", fax_body)

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


/obj/item/weapon/implant/loyalty/eridani
	name = "Eridani loyalty implant"
	desc = "Makes you loyal or such."

/obj/item/weapon/implant/loyalty/eridani/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Eridani Federal Navy Personnel Management Implant<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/weapon/implant/loyalty/eridani/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))	return 0
	var/mob/living/carbon/human/H = M
	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of Eridani Corporate Federation try to invade your mind!")
		return 0
	else
		clear_antag_roles(H.mind, 1)
		H << "<span class='notice'>You feel a surge of loyalty towards the members of the Eridani Corporate Federation's Board of Five.</span>"
	return 1

/mob/living/carbon/human/proc/implant_loyalty_eridani(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	var/obj/item/weapon/implant/loyalty/eridani/L = new/obj/item/weapon/implant/loyalty/eridani(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/item/organ/external/affected = M.organs_by_name["head"]
	affected.implants += L
	L.part = affected
	L.implanted(src)
