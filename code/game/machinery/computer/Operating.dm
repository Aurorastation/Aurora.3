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
	var/mob/living/carbon/human/victim = null
	var/obj/machinery/optable/table = null
	var/obj/machinery/body_scanconsole/internal_bodyscanner = null
	var/obj/item/paper/medscan/input_scan = null
	var/scan_slot = FALSE

	var/backup_victim = null // Backup data
	var/backup_data = null

	var/last_critical	// Spam checks for the alarms
	var/last_ba 		// Brain Activity
	var/last_bo 		// Blood Oxygenation

/obj/machinery/computer/operating/Initialize()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, get_step(src, dir))
		if (table)
			table.computer = src
			break
	if(!internal_bodyscanner) // So it can scan correctly
		var/obj/machinery/body_scanconsole/S = new (src)
		S.forceMove(src)
		S.update_use_power(POWER_USE_OFF)
		internal_bodyscanner = S

/obj/machinery/computer/operating/Destroy()
	QDEL_NULL(table.computer)
	QDEL_NULL(internal_bodyscanner)
	QDEL_NULL(input_scan)
	return ..()

/obj/machinery/computer/operating/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/operating/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/operating/attackby(obj/item/O as obj, mob/user)
	if(!istype(O, /obj/item/paper/medscan))
		return ..()
	else if(scan_slot)
		if(input_scan)
			to_chat(usr, SPAN_NOTICE("You try to insert \the [O], but \the [src] buzzes. There is already a [O] inside!"))
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
			return TRUE
		user.drop_from_inventory(O, src)
		input_scan = O
		input_scan.color = "#272727"
		input_scan.set_content_unsafe("Scan ([victim])", operating_format(get_medical_data(victim)))
		usr.visible_message("\The [src] pings, displaying \the [input_scan].")
		to_chat(usr, SPAN_NOTICE("You insert \the [O] into [src]."))
		playsound(src, 'sound/bureaucracy/scan.ogg', 50, 1)
		return TRUE
	else
		to_chat(usr, SPAN_WARNING("\The [src]'s scan slot is closed! Please put in a valid patient on the table to open it!"))
		return TRUE

/obj/machinery/computer/operating/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=op")
			return

	user.set_machine(src)
	var/dat = "<HEAD><TITLE>Operating Computer</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	if(src.table && (src.table.check_victim()))
		src.victim = src.table.victim
		dat += {"
	<B>Patient Information:</B><BR>
	Brain Activity: <b>[victim.isFBP() ? "<span class='danger'>N/A</span>" : victim.get_brain_status()]</b><br>
	Pulse: <b>[victim.get_pulse(GETPULSE_TOOL)]</b><br>
	BP: <b>[victim.get_blood_pressure()]</b><br>
	Blood Oxygenation: <b>[victim.get_blood_oxygenation()]%</b><br>
	Blood Volume: <b>[victim.get_blood_volume()]%</b><br>
	"}
		if(!input_scan)
			dat += "Patient Scan: <b>Scan not found. Please insert a Medical Scan.</b><br>"
		else
			dat += {"
		Patient Scan: <b>[input_scan]</b><br>
		<a href='?src=\ref[src];action=update'>Update scan</a>
		<a href='?src=\ref[src];action=eject'>Remove and update scan</a>
		<a href='?src=\ref[src];action=print_new'>Print new scan</a><br><hr>
		"}
			dat += "[input_scan.get_content()]"
	else
		src.victim = null
		dat += {"
<B>Patient Information:</B><BR>
<B>No Patient Detected</B>
"}
	var/datum/browser/op_win = new(user, "op", capitalize_first_letters(name), 450, 800)
	op_win.set_content(dat)
	op_win.open()

/obj/machinery/computer/operating/examine(mob/user)
	..()
	if(get_dist(src, user) <= 2)
		if(src.table && (src.table.check_victim()))
			src.victim = src.table.victim

			to_chat(user, SPAN_NOTICE("Patient Info:"))
			to_chat(user, SPAN_NOTICE("Brain Activity: [victim.isFBP() ? "N/A" : victim.get_brain_status()]"))
			to_chat(user, SPAN_NOTICE("Pulse: [victim.get_pulse(GETPULSE_TOOL)]"))
			to_chat(user, SPAN_NOTICE("BP: [victim.get_blood_pressure()]"))
			to_chat(user, SPAN_NOTICE("Blood Oxygenation: [victim.get_blood_oxygenation()]%"))
			to_chat(user, SPAN_NOTICE("Blood Volume: [victim.get_blood_volume()]%"))
			if(!input_scan)
				to_chat(user, SPAN_NOTICE("Patient Scan: Scan not found. Please insert the Medical Scan."))
			else
				to_chat(user, SPAN_NOTICE("Patient Scan: [input_scan]"))
		else
			src.victim = null
			to_chat(user, SPAN_NOTICE("No Patient Detected"))

/obj/machinery/computer/operating/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["action"])
		switch(href_list["action"])
			if("update")
				input_scan.set_content_unsafe("Scan ([victim])", operating_format(get_medical_data(victim)))
				usr.visible_message("\The [src] chimes, updating \the [input_scan].")
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
			if("eject")
				usr.visible_message("\The [src] beeps, ejecting \the [input_scan].")
				input_scan.color = "#eeffe8"
				input_scan.set_content_unsafe("Scan ([victim])", internal_bodyscanner.format_occupant_data(get_medical_data(victim))) // Re-formats it correctly
				input_scan.forceMove(usr.loc)
				usr.put_in_hands(input_scan)
				input_scan = null
				backup_clear()
				playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
			if("print_new")
				print_new()
				usr.visible_message("\The [src] beeps, printing a new [input_scan] after a moment.")
	return

/obj/machinery/computer/operating/process()
	if(operable())
		src.updateDialog()
	if(src.stat & BROKEN)
		QDEL_NULL(input_scan)
		QDEL_NULL(internal_bodyscanner)
		return PROCESS_KILL
	if(src.table && (src.table.check_victim())) // Specific warning alarms for specific conditions. Times to be tweaked according to feedback
		src.victim = src.table.victim
		scan_slot = TRUE
		if(src.victim.stat != DEAD && !src.victim.is_diona())
			if(victim.get_blood_oxygenation() < 30 && victim.get_brain_result() < 20)
				if(world.time > last_critical + 25 SECONDS)
					last_critical = world.time
					src.visible_message(SPAN_WARNING("Warning! <b>[victim]'s Blood Oxygenation AND Brain Activity</b> are in critical condition!"))
					playsound(src, 'sound/effects/3.wav', 75)
			else
				if(victim.get_blood_oxygenation() < 30 && victim.get_brain_result() > 20)
					blood_oxygenation_alarm()
				if(victim.get_brain_result() < 20 && victim.get_blood_oxygenation() > 30)
					brain_activity_alarm()
	else if(input_scan)
		src.visible_message(SPAN_WARNING("Patient not found! Automatically ejecting the scan."))
		playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		input_scan.color = "#eeffe8"
		input_scan.set_content_unsafe("Scan ([backup_victim])", internal_bodyscanner.format_occupant_data(backup_data)) // To do: Figure out how to re-format without doing more shitcode
		input_scan.forceMove(src.loc)
		input_scan = null
		backup_clear()
		scan_slot = FALSE

/obj/machinery/computer/operating/proc/blood_oxygenation_alarm()
	if(world.time > last_bo + 25 SECONDS)
		last_bo = world.time
		src.visible_message(SPAN_WARNING("Warning! <b>[victim]'s Blood Oxygenation</b> is in critical condition!"))
		playsound(src, 'sound/machines/ringer.ogg', 50)

/obj/machinery/computer/operating/proc/brain_activity_alarm()
	if(world.time > last_ba + 20 SECONDS)
		last_ba = world.time
		src.visible_message(SPAN_WARNING("Warning! <b>[victim]'s Brain Activity</b> is in critical condition!"))
		playsound(src, 'sound/effects/alert.ogg', 50)

/obj/machinery/computer/operating/proc/backup_clear()
	backup_victim = null
	backup_data = null

// PRINTING SHENANIGANRY
/obj/machinery/computer/operating/proc/print_new()
	var/obj/item/paper/medscan/S = new()
	usr.put_in_hands(S)
	S.color = "#eeffe8"
	S.set_content_unsafe("Scan ([victim])", internal_bodyscanner.format_occupant_data(get_medical_data(victim)))
	playsound(src, 'sound/bureaucracy/print.ogg', 50, 1)

/obj/machinery/computer/operating/proc/get_medical_data(var/mob/living/carbon/human/H)
	if (!ishuman(H))
		return

	var/list/medical_data = list(
		"stationtime" = worldtime2text(),
		"brain_activity" = H.get_brain_status(),
		"blood_volume" = H.get_blood_volume(),
		"blood_oxygenation" = H.get_blood_oxygenation(),
		"blood_pressure" = H.get_blood_pressure(),

		"bruteloss" = get_severity(H.getBruteLoss(), TRUE),
		"fireloss" = get_severity(H.getFireLoss(), TRUE),
		"oxyloss" = get_severity(H.getOxyLoss(), TRUE),
		"toxloss" = get_severity(H.getToxLoss(), TRUE),
		"cloneloss" = get_severity(H.getCloneLoss(), TRUE),

		"rads" = H.total_radiation,
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = REAGENT_VOLUME(H.reagents, /decl/reagent/inaprovaline),
		"dexalin_amount" = REAGENT_VOLUME(H.reagents, /decl/reagent/dexalin),
		"stoxin_amount" = REAGENT_VOLUME(H.reagents, /decl/reagent/soporific),
		"bicaridine_amount" = REAGENT_VOLUME(H.reagents, /decl/reagent/bicaridine),
		"dermaline_amount" = REAGENT_VOLUME(H.reagents, /decl/reagent/dermaline),
		"thetamycin_amount" = REAGENT_VOLUME(H.reagents, /decl/reagent/thetamycin),
		"blood_amount" = REAGENT_VOLUME(H.vessel, /decl/reagent/blood),
		"disabilities" = H.sdisabilities,
		"lung_ruptured" = H.is_lung_ruptured(),
		"lung_rescued" = H.is_lung_rescued(),
		"external_organs" = H.organs.Copy(),
		"internal_organs" = H.internal_organs.Copy(),
		"species_organs" = H.species.has_organ
		)
	backup_victim = H.name
	backup_data = medical_data
	return medical_data

/obj/machinery/computer/operating/proc/operating_format(var/list/occ) // Format to cut out redundant information
	var/dat = "<center><b>Scan last updated at [occ["stationtime"]]</b></center>"
	if(occ["borer_present"])
		dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

	dat += "<center><div style='background-color: #E8FAFF; color: black'><table border='1'>"
	dat += "<tr>"
	dat += "<th>Organ</th>"
	dat += "<th>Burn Severity</th>"
	dat += "<th>Physical Trauma</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/obj/item/organ/external/e in occ["external_organs"])
		var/AN = ""
		var/open = ""
		var/infected = ""
		var/imp = ""
		var/bled = ""
		var/robot = ""
		var/splint = ""
		var/internal_bleeding = ""
		var/severed_tendon = ""
		var/lung_ruptured = ""
		var/dislocated = ""

		dat += "<tr>"

		if(e.status & ORGAN_ARTERY_CUT)
			internal_bleeding = "Arterial bleeding."
		if(e.tendon_status() & TENDON_CUT)
			severed_tendon = "Severed tendon."
		if(istype(e, /obj/item/organ/external/chest) && occ["lung_ruptured"])
			lung_ruptured = "Lung ruptured."
		if(e.status & ORGAN_SPLINTED)
			splint = "Splinted."
		if(ORGAN_IS_DISLOCATED(e))
			dislocated = "Dislocated."
		if(e.status & ORGAN_BLEEDING)
			bled = "Bleeding."
		if(e.status & ORGAN_BROKEN)
			AN = "[e.broken_description]."
		if(e.status & ORGAN_ROBOT)
			robot = "Prosthetic."
		if(e.open)
			open = "Open."

		var/infection = internal_bodyscanner.get_infection_level(e.germ_level)
		if (infection != "")
			infected = "[infection] infection"
		if(e.rejecting)
			infected += " (being rejected)"

		if (e.implants.len)
			var/unknown_body = 0
			var/list/organic = list()
			for(var/I in e.implants)
				if(is_type_in_list(I,internal_bodyscanner.known_implants))
					imp += "[I] implanted:"
				else if(istype(I, /obj/effect/spider))
					organic += I
				else
					unknown_body++
			if(unknown_body)
				imp += "Unknown body present:"
			var/friends = length(organic)
			if(friends)
				imp += friends > 1 ? "Multiple abnormal organic bodies present:" : "Abnormal organic body present:"

		if(!AN && !open && !infected && !imp)
			AN = "None:"
		if(!e.is_stump())
			dat += "<td>[e.name]</td><td>[get_severity(e.burn_dam, TRUE)]</td><td>[get_severity(e.brute_dam, TRUE)]</td><td>[robot][bled][AN][splint][open][infected][imp][dislocated][internal_bleeding][severed_tendon][lung_ruptured]</td>"
		else
			dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not [e.is_stump() ? "Found" : "Attached Completely"]</td>"
		dat += "</tr>"

	for(var/obj/item/organ/internal/i in occ["internal_organs"])

		var/mech = ""
		if(i.robotic == ROBOTIC_ASSISTED)
			mech = "Assisted:"
		if(i.robotic == ROBOTIC_MECHANICAL)
			mech = "Mechanical:"

		var/infection = internal_bodyscanner.get_infection_level(i.germ_level)
		if(infection == "")
			infection = "No Infection."
		else
			infection = "[infection] infection."
		if(i.rejecting)
			infection += "(being rejected)."

		var/necrotic = ""
		if(i.get_scarring_level() > 0.01)
			necrotic += " [i.get_scarring_results()]."
		if(i.status & ORGAN_DEAD)
			necrotic = " <span class='warning'>Necrotic and decaying</span>."

		var/rescued = ""
		if(istype(i, /obj/item/organ/internal/lungs) && occ["lung_rescued"])
			rescued = " Has a small puncture wound."

		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[internal_bodyscanner.get_internal_damage(i)]</td><td>[infection][mech][necrotic][rescued]</td><td></td>"
		dat += "</tr>"
	dat += "</table></div></center>"

	var/list/species_organs = occ["species_organs"]
	for(var/organ_name in species_organs)
		if(!locate(species_organs[organ_name]) in occ["internal_organs"])
			dat += text("<span class='warning'>No [organ_name] detected.</span><BR>")

	if(occ["sdisabilities"] & BLIND)
		dat += text("<span class='warning'>Cataracts detected.</span><BR>")
	if(occ["sdisabilities"] & NEARSIGHTED)
		dat += text("<font color='red'>Retinal misalignment detected.</font><BR>")
	return dat
