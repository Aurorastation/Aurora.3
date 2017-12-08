
//please preference put stuff where it's easy to find - C

	name = "autopsy scanner"
	desc = "Extracts information on wounds."
	icon = 'icons/obj/autopsy_scanner.dmi'
	icon_state = ""
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	var/list/datum/autopsy_data_scanner/wdata = list()
	var/list/datum/autopsy_data_scanner/chemtraces = list()
	var/target_name = null
	var/timeofdeath = null

/datum/autopsy_data_scanner
	var/list/organs_scanned = list() // this maps a number of scanned organs to
	var/organ_names = ""

/datum/autopsy_data
	var/damage = 0
	var/hits = 0
	var/time_inflicted = 0

	proc/copy()
		var/datum/autopsy_data/W = new()
		W.damage = damage
		W.hits = hits
		W.time_inflicted = time_inflicted
		return W

	if(!O.autopsy_data.len && !O.trace_chemicals.len) return

	for(var/V in O.autopsy_data)
		var/datum/autopsy_data/W = O.autopsy_data[V]

			/*
			if(prob(50 + W.hits * 10 + W.damage))
			*/

			// Buffing this stuff up for now!
			if(1)
			else


		var/datum/autopsy_data_scanner/D = wdata[V]
		if(!D)
			D = new()
			wdata[V] = D

		if(!D.organs_scanned[O.name])
			if(D.organ_names == "")
				D.organ_names = O.name
			else
				D.organ_names += ", [O.name]"

		qdel(D.organs_scanned[O.name])
		D.organs_scanned[O.name] = W.copy()

	for(var/V in O.trace_chemicals)
		if(O.trace_chemicals[V] > 0 && !chemtraces.Find(V))
			chemtraces += V

	set category = "Object"
	set src in view(usr, 1)
	set name = "Print Data"

	if(use_check(usr))
		return

	var/scan_data = ""

	if(timeofdeath)
		scan_data += "<b>Time of death:</b> [worldtime2text(timeofdeath)]<br><br>"

	var/n = 1
	for(var/wdata_idx in wdata)
		var/datum/autopsy_data_scanner/D = wdata[wdata_idx]
		var/total_hits = 0
		var/total_score = 0
		var/age = 0

		for(var/wound_idx in D.organs_scanned)
			var/datum/autopsy_data/W = D.organs_scanned[wound_idx]
			total_hits += W.hits


			total_score+=W.damage


			var/wound_age = W.time_inflicted
			age = max(age, wound_age)

		var/damage_desc


		// total score happens to be the total damage
		switch(total_score)
			if(0)
				damage_desc = "Unknown"
			if(1 to 5)
				damage_desc = "<font color='green'>negligible</font>"
			if(5 to 15)
				damage_desc = "<font color='green'>light</font>"
			if(15 to 30)
				damage_desc = "<font color='orange'>moderate</font>"
			if(30 to 1000)
				damage_desc = "<font color='red'>severe</font>"

		if(!total_score) total_score = D.organs_scanned.len

		scan_data += "<b>Weapon #[n]</b><br>"
			scan_data += "Severity: [damage_desc]<br>"
		scan_data += "Approximate time of wound infliction: [worldtime2text(age)]<br>"
		scan_data += "Affected limbs: [D.organ_names]<br>"

		scan_data += "<br>"

		n++

	if(chemtraces.len)
		scan_data += "<b>Trace Chemicals: </b><br>"
		for(var/chemID in chemtraces)
			scan_data += chemID
			scan_data += "<br>"

	for(var/mob/O in viewers(usr))
		O.show_message("<span class='notice'>\The [src] rattles and prints out a sheet of paper.</span>", 1)

	sleep(10)

	P.name = "Autopsy Data ([target_name])"
	P.info = "<tt>[scan_data]</tt>"
	P.icon_state = "paper_words"

	usr.put_in_hands(P)

	if(!istype(M))
		return

	if(!can_operate(M))
		return

	if(target_name != M.name)
		target_name = M.name
		src.wdata = list()
		src.chemtraces = list()
		src.timeofdeath = null
		user << "<span class='notice'>A new patient has been registered.. Purging data for previous patient.</span>"

	src.timeofdeath = M.timeofdeath

	var/obj/item/organ/external/S = M.get_organ(user.zone_sel.selecting)
	if(!S)
		usr << "<span class='warning'>You can't scan this body part.</span>"
		return
	if(!S.open)
		usr << "<span class='warning'>You have to cut the limb open first!</span>"
		return
	for(var/mob/O in viewers(M))
		O.show_message("<span class='notice'>\The [user] scans the wounds on [M.name]'s [S.name] with \the [src]</span>", 1)

	src.add_data(S)

	return 1
