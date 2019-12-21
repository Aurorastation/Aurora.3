/obj/machinery/computer/centrifuge
	name = "isolation centrifuge"
	desc = "Used to separate things with different weight. Spin 'em round, round, right round."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	var/curing
	var/isolating

	var/obj/item/reagent_containers/glass/beaker/vial/sample = null
	var/datum/disease2/disease/virus2 = null

/obj/machinery/computer/centrifuge/attackby(var/obj/O as obj, var/mob/user as mob)
	if(O.isscrewdriver())
		return ..(O,user)

	if(istype(O,/obj/item/reagent_containers/glass/beaker/vial))
		if(sample)
			to_chat(user, "\The [src] is already loaded.")
			return

		sample = O
		user.drop_from_inventory(O,src)

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SSnanoui.update_uis(src)

	src.attack_hand(user)

/obj/machinery/computer/centrifuge/update_icon()
	..()
	if(! (stat & (BROKEN|NOPOWER)))
		icon_state = (isolating||curing ? "centrifuge_moving" : "centrifuge")

/obj/machinery/computer/centrifuge/attack_hand(var/mob/user as mob)
	if(..()) return
	ui_interact(user)

/obj/machinery/computer/centrifuge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["antibodies"] = null
	data["pathogens"] = null
	data["is_antibody_sample"] = null

	if (curing)
		data["busy"] = "Isolating antibodies..."
	else if (isolating)
		data["busy"] = "Isolating pathogens..."
	else
		data["sample_inserted"] = !!sample

		if (sample)
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if (B)
				data["antibodies"] = antigens2string(B.data["antibodies"], none=null)

				var/list/pathogens[0]
				var/list/virus = B.data["virus2"]
				for (var/ID in virus)
					var/datum/disease2/disease/V = virus[ID]
					pathogens.Add(list(list("name" = V.name(), "spread_type" = V.spreadtype, "reference" = "\ref[V]")))

				if (pathogens.len > 0)
					data["pathogens"] = pathogens

			else
				var/datum/reagent/antibodies/A = locate(/datum/reagent/antibodies) in sample.reagents.reagent_list
				if(A)
					data["antibodies"] = antigens2string(A.data["antibodies"], none=null)
				data["is_antibody_sample"] = 1

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "isolation_centrifuge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/centrifuge/machinery_process()
	if (inoperable()) return

	if (curing)
		curing -= 1
		if (curing == 0)
			cure()

	if (isolating)
		isolating -= 1
		if(isolating == 0)
			isolate()

/obj/machinery/computer/centrifuge/Topic(href, href_list)
	if (..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if (href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if (href_list["print"])
		do_print(user)
		return 1

	if(href_list["isolate"])
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
		if (B)
			var/datum/disease2/disease/virus = locate(href_list["isolate"])
			virus2 = virus.getcopy()
			isolating = 40
			update_icon()
		return 1

	switch(href_list["action"])
		if ("antibody")
			var/delay = 20
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if (!B)
				state("\The [src] buzzes, \"No antibody carrier detected.\"", "blue")
				return 1

			var/has_toxins = locate(/datum/reagent/toxin) in sample.reagents.reagent_list
			var/has_radium = sample.reagents.has_reagent("radium")
			if (has_toxins || has_radium)
				state("\The [src] beeps, \"Pathogen purging speed above nominal.\"", "blue")
				if (has_toxins)
					delay = delay/2
				if (has_radium)
					delay = delay/2

			curing = round(delay)
			playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
			update_icon()
			return 1

		if("sample")
			if(sample)
				sample.forceMove(src.loc)
				sample = null
			return 1

	return 0

/obj/machinery/computer/centrifuge/proc/cure()
	if (!sample) return
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (!B) return

	var/list/data = list("antibodies" = B.data["antibodies"])
	var/amt= sample.reagents.get_reagent_amount("blood")
	sample.reagents.remove_reagent("blood", amt)
	sample.reagents.add_reagent("antibodies", amt, data)

	SSnanoui.update_uis(src)
	update_icon()
	ping("\The [src] pings, \"Antibody isolated.\"")

/obj/machinery/computer/centrifuge/proc/isolate()
	if (!sample) return
	var/obj/item/virusdish/dish = new/obj/item/virusdish(loc)
	dish.virus2 = virus2
	virus2 = null

	SSnanoui.update_uis(src)
	update_icon()
	ping("\The [src] pings, \"Pathogen isolated.\"")

/obj/machinery/computer/centrifuge/proc/do_print(var/mob/user)
	var/obj/item/paper/P = new /obj/item/paper(loc)
	var/pname = "paper - Pathology Report"
	var/info = {"
		[virology_letterhead("Pathology Report")]
		<large><u>Sample:</u></large> [sample.name]<br>
"}

	if (user)
		info += "<u>Generated By:</u> [user.name]<br>"

	info += "<hr>"

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (B)
		info += "<u>Antibodies:</u> "
		info += antigens2string(B.data["antibodies"])
		info += "<br>"

		var/list/virus = B.data["virus2"]
		info += "<u>Pathogens:</u> <br>"
		if (virus.len > 0)
			for (var/ID in virus)
				var/datum/disease2/disease/V = virus[ID]
				info += "[V.name()]<br>"
		else
			info += "None<br>"

	else
		var/datum/reagent/antibodies/A = locate(/datum/reagent/antibodies) in sample.reagents.reagent_list
		if (A)
			info += "The following antibodies have been isolated from the blood sample: "
			info += antigens2string(A.data["antibodies"])
			info += "<br>"

	info += {"
	<hr>
	<u>Additional Notes:</u> <field>
"}

	P.set_content_unsafe(pname, info)
	print(P)
