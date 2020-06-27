/obj/machinery/suit_cycler
	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = TRUE
	density = TRUE

	icon = 'icons/obj/suit_cycler.dmi'
	icon_state = "base"

	req_access = list(access_captain, access_heads)

	var/active = FALSE		// PLEASE HOLD.
	var/safeties = TRUE		// The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0		// If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2	// 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""		// Some flavour text for the topic box.
	var/locked = TRUE		// If locked, nothing can be taken from or added to the cycler.
	var/can_repair			// If set, the cycler can repair voidsuits.
	var/electrified = FALSE

	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering", "Mining", "Medical", "Security", "Atmos")
	//Species that the suits can be configured to fit.
	var/list/species = list("Human", "Skrell", "Unathi", "Tajara", "Vaurca", "Machine")

	var/target_department
	var/target_species

	var/mob/living/carbon/human/occupant
	var/obj/item/clothing/head/helmet/space/helmet
	var/obj/item/clothing/suit/space/void/suit

	var/datum/wires/suit_storage_unit/wires

/obj/machinery/suit_cycler/Initialize()
	. = ..()

	wires = new(src)
	target_department = departments[1]
	target_species = species[1]
	update_icon()
	if(!target_department || !target_species)
		qdel(src)

/obj/machinery/suit_cycler/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/suit_cycler/update_icon()
	cut_overlays()

	if(helmet)
		//copied straight from the human update_icons thing
		var/image/helmet_image = helmet.return_own_image()
		if(helmet_image)
			add_overlay(helmet_image)
	if(suit)
		var/image/suit_image = suit.return_own_image()
		if(suit_image)
			add_overlay(suit_image)
	if(occupant)
		var/image/occupant_image = image(occupant.icon, occupant.icon_state)
		occupant_image.overlays = occupant.overlays
		add_overlay(occupant_image)
	add_overlay("closed")
	add_overlay("overbase")
	if(panel_open)
		add_overlay("panel")

	if(irradiating)
		var/image/irradiating_lights = make_screen_overlay(icon, "light_radiation")
		add_overlay(irradiating_lights)
	else if(active)
		var/image/active_lights = make_screen_overlay(icon, "light_active")
		add_overlay(active_lights)

/obj/machinery/suit_cycler/engineering
	name = "engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	departments = list("Engineering", "Atmos")

/obj/machinery/suit_cycler/mining
	name = "mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	departments = list("Mining")

/obj/machinery/suit_cycler/security
	name = "security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	departments = list("Security")

/obj/machinery/suit_cycler/medical
	name = "medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	departments = list("Medical")

/obj/machinery/suit_cycler/syndicate
	name = "non-standard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	departments = list("Mercenary")
	can_repair = TRUE

/obj/machinery/suit_cycler/wizard
	name = "magic suit cycler"
	model_text = "Wizardry"
	req_access = null
	departments = list("Wizardry")
	species = list("Human", "Tajara", "Skrell", "Unathi", "Machine")
	can_repair = TRUE

/obj/machinery/suit_cycler/hos
	name = "head of security suit cycler"
	model_text = "head of Security"
	req_access = list(access_hos)
	departments = list("Head of Security") // ONE MAN DEPARTMENT HOO HA GIMME CRAYONS - Geeves
	species = list("Human", "Tajara", "Skrell", "Unathi", "Machine")
	can_repair = TRUE

/obj/machinery/suit_cycler/captain
	name = "captain suit cycler"
	model_text = "Captain"
	req_access = list(access_captain)
	departments = list("Captain")
	species = list("Human", "Tajara", "Skrell", "Unathi", "Machine")
	can_repair = TRUE

/obj/machinery/suit_cycler/science
	name = "research suit cycler"
	model_text = "Research"
	req_access = list(access_research)
	departments = list("Research")
	species = list("Human", "Tajara", "Skrell", "Unathi", "Machine")
	can_repair = TRUE

/obj/machinery/suit_cycler/freelancer
	name = "freelancers suit cycler"
	model_text = "Freelancers"
	req_access = list(access_distress)
	departments = list("Freelancers")
	species = list("Human", "Tajara", "Skrell", "Unathi", "Machine")
	can_repair = TRUE

/obj/machinery/suit_cycler/MouseDrop_T(mob/living/M, mob/living/user)
	if(use_check_and_message(user))
		return
	if(!istype(M))
		return

	if(user != M)
		to_chat(user, SPAN_WARNING("You need a grab to do this!"))
		return

	if(active || locked)
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied!"))
		return

	if(length(contents))
		to_chat(user, SPAN_WARNING("There's no space in \the [src] for you!"))
		return

	user.visible_message("<b>\The [M]</b> starts climbing into \the [src]...", SPAN_NOTICE("You start climbing into \the [src]..."), range = 3)
	if(do_after(user, 20, TRUE, src))
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		user.visible_message("<b>\The [user]</b> climbs into \the [src].", SPAN_NOTICE("You climb into \the [src]."), range = 3)
		M.forceMove(src)
		occupant = M

		add_fingerprint(user)
		updateUsrDialog()
		update_icon()

/obj/machinery/suit_cycler/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I, mob/user)
	if(electrified != 0)
		if(src.shock(user, 100))
			return

	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/device/pda) || istype(I, /obj/item/modular_computer))
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "" : "un"]lock \the [src]."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return

	//Hacking init.
	if(I.ismultitool() || I.iswirecutter())
		if(panel_open)
			wires.Interact(user)
		return

	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(G.state < GRAB_NECK)
			to_chat(user, SPAN_WARNING("You need a stronger grip to do this!"))
			return

		if(!ismob(G.affecting))
			to_chat(user, SPAN_WARNING("\The [G.affecting] doesn't fit into \the [src]!"))
			return

		if(active || locked)
			to_chat(user, SPAN_DANGER("The suit cycler is locked."))
			return

		if(contents.len > 0)
			to_chat(user, SPAN_WARNING("There is no room inside \the [src] for \the [G.affecting]."))
			return

		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
			return

		user.visible_message("<b>\The [user]</b> starts putting \the [G.affecting] into \the [src]...", SPAN_NOTICE("You start putting \the [G.affecting] into \the [src]..."), range = 3)
		if(do_after(user, 20, TRUE, src))
			if(!G || !G.affecting)
				return
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			user.visible_message("<b>\The [user]</b> puts \the [G.affecting] into \the [src].", SPAN_NOTICE("You put \the [G.affecting] into \the [src]."), range = 3)
			M.forceMove(src)
			occupant = M

			add_fingerprint(user)
			qdel(G)

			updateUsrDialog()
			update_icon()
		return
	else if(I.isscrewdriver())
		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance panel."))
		updateUsrDialog()
		update_icon()
		return

	else if(istype(I, /obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))
		if(active || locked)
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return

		if(occupant)
			to_chat(user, SPAN_WARNING("There is no space in \the [src] for \the [I]!"))
			return

		if(helmet)
			to_chat(user, SPAN_WARNING("\The [src] already contains a helmet."))
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, SPAN_WARNING("You cannot refit a customised voidsuit."))
			return

		to_chat(user, SPAN_NOTICE("You fit \the [I] into \the [src]."))
		user.drop_from_inventory(I, src)
		helmet = I
		update_icon()
		updateUsrDialog()
		return

	else if(istype(I, /obj/item/clothing/suit/space/void))
		if(active || locked)
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return

		if(occupant)
			to_chat(user, SPAN_WARNING("There is no space in \the [src] for \the [I]!"))
			return

		if(suit)
			to_chat(user, SPAN_WARNING("\The [src] already contains a voidsuit."))
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, SPAN_WARNING("You cannot refit a customised voidsuit."))
			return

		to_chat(user, SPAN_NOTICE("You fit \the [I] into \the [src]."))
		user.drop_from_inventory(I, src)
		suit = I

		update_icon()
		updateUsrDialog()
		return

	..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, mob/user)
	if(emagged)
		to_chat(user, SPAN_WARNING("The cycler has already been subverted."))
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, SPAN_WARNING("You run the sequencer across the interface, corrupting the operating protocols."))
	departments = list("Engineering", "Mining", "Medical", "Security", "Atmos", "^%###^%$")
	emagged = TRUE
	safeties = FALSE
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user)

	add_fingerprint(user)

	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(!user.IsAdvancedToolUser())
		return FALSE

	if(electrified != 0)
		if(src.shock(user, 100))
			return

	usr.set_machine(src)

	var/dat = ""

	if(src.active)
		dat += "<font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(src.allowed(usr))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>\[eject\]</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_department]</a>, <A href='?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<br><A href='?src=\ref[src];apply_paintjob=1'>\[apply customisation routine\]</a><br><hr>"

	if(panel_open)
		wires.Interact(user)

	send_theme_resources(user)
	user << browse(enable_ui_theme(user, dat), "window=suit_cycler")
	onclose(user, "suit_cycler")
	return

/obj/machinery/suit_cycler/Topic(href, href_list)
	if(href_list["eject_suit"])
		if(!suit)
			return
		suit.forceMove(get_turf(src))
		usr.put_in_hands(suit)
		suit = null
		update_icon()

	else if(href_list["eject_helmet"])
		if(!helmet)
			return
		helmet.forceMove(get_turf(src))
		usr.put_in_hands(helmet)
		helmet = null
		update_icon()

	else if(href_list["select_department"])
		var/choice = input("Please select the target department paintjob.", "Suit cycler", null) as null|anything in departments
		if(choice)
			target_department = choice

	else if(href_list["select_species"])
		var/choice = input("Please select the target species configuration.", "Suit cycler", null) as null|anything in species
		if(choice)
			target_species = choice

	else if(href_list["select_rad_level"])
		var/choices = list(1, 2, 3)
		if(emagged)
			choices = list(1, 2, 3, 4, 5)
		var/choice = input("Please select the desired radiation level.", "Suit cycler", null) as null|anything in choices
		if(choice)
			radiation_level = choice

	else if(href_list["repair_suit"])
		if(!suit || !can_repair)
			return
		active = TRUE
		update_icon()
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])
		if(!suit && !helmet)
			return
		if(suit && suit.helmet)
			to_chat(usr, SPAN_WARNING("\The [src] cannot function while a helmet is attached to the suit!"))
			return
		var/list/no_refit
		if(helmet && !helmet.refittable)
			LAZYADD(no_refit, helmet)
		if(suit && !suit.refittable)
			LAZYADD(no_refit, suit)
		if(LAZYLEN(no_refit))
			to_chat(usr, SPAN_WARNING("\The [english_list(no_refit)] in [src] [no_refit.len == 1 ? "is" : "are"] not refittable!"))
			return

		active = TRUE
		update_icon()
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])
		if(src.allowed(usr))
			locked = !locked
			to_chat(usr, SPAN_WARNING("You [locked ? "" : "un"]lock \the [src]."))
		else
			to_chat(usr, SPAN_WARNING("Access denied."))

	else if(href_list["begin_decontamination"])
		if(safeties && occupant)
			to_chat(usr, SPAN_WARNING("The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
			return

		active = TRUE
		irradiating = 10
		update_icon()
		src.updateUsrDialog()

		sleep(10)
		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

	src.updateUsrDialog()
	return

/obj/machinery/suit_cycler/machinery_process()
	if(electrified > 0)
		electrified = max(electrified - 1, 0)

	if(!active)
		return

	if(active && stat & (BROKEN|NOPOWER))
		active = FALSE
		irradiating = 0
		electrified = 0
		update_icon()
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		update_icon()
		return

	irradiating = max(irradiating - 1, 0)

	if(occupant)
		if(prob(radiation_level * 2))
			occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0, radiation_level * 2 + rand(1, 3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0, radiation_level + rand(1, 3))
		occupant.apply_effect(radiation_level * 10, IRRADIATE)

/obj/machinery/suit_cycler/proc/finished_job()
	visible_message("\icon[src] <span class='notice'>\The [src] pings loudly.</span>")
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE)
	active = FALSE
	update_icon()
	updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

	return

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)

	if(use_check_and_message(usr))
		return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user)
	if(locked || active)
		to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	occupant = null

	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()
	return

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet)
			helmet.refit_for_species(target_species)
		if(suit)
			suit.refit_for_species(target_species)

	switch(target_department)
		if("Engineering")
			if(helmet)
				helmet.name = "engineering voidsuit helmet"
				helmet.icon_state = "rig0-engineering"
				helmet.item_state = "eng_helm"
			if(suit)
				suit.name = "engineering voidsuit"
				suit.icon_state = "rig-engineering"
				suit.item_state = "eng_voidsuit"
		if("Mining")
			if(helmet)
				helmet.name = "mining voidsuit helmet"
				helmet.icon_state = "rig0-mining"
				helmet.item_state = "mining_helm"
			if(suit)
				suit.name = "mining voidsuit"
				suit.icon_state = "rig-mining"
				suit.item_state = "mining_voidsuit"
		if("Medical")
			if(helmet)
				helmet.name = "medical voidsuit helmet"
				helmet.icon_state = "rig0-medical"
				helmet.item_state = "medical_helm"
			if(suit)
				suit.name = "medical voidsuit"
				suit.icon_state = "rig-medical"
				suit.item_state = "medical_voidsuit"
		if("Security")
			if(helmet)
				helmet.name = "security voidsuit helmet"
				helmet.icon_state = "rig0-sec"
				helmet.item_state = "sec_helm"
			if(suit)
				suit.name = "security voidsuit"
				suit.icon_state = "rig-sec"
				suit.item_state = "sec_voidsuit"
		if("Atmos")
			if(helmet)
				helmet.name = "atmospherics voidsuit helmet"
				helmet.icon_state = "rig0-atmos"
				helmet.item_state = "atmos_helm"
			if(suit)
				suit.name = "atmospherics voidsuit"
				suit.icon_state = "rig-atmos"
				suit.item_state = "atmos_voidsuit"
		if("Captain")
			if(helmet)
				helmet.name = "captain voidsuit helmet"
				helmet.icon_state = "capspace"
				helmet.item_state = "capspace"
			if(suit)
				suit.name = "captain voidsuit"
				suit.icon_state = "capspace"
				suit.item_state = "capspace"
		if("^%###^%$" || "Mercenary")
			if(helmet)
				helmet.name = "blood-red voidsuit helmet"
				helmet.icon_state = "rig0-syndie"
				helmet.item_state = "syndie_helm"
			if(suit)
				suit.name = "blood-red voidsuit"
				suit.item_state = "syndie_voidsuit"
				suit.icon_state = "rig-syndie"
		if("Research")
			if(helmet)
				helmet.name = "research voidsuit helmet"
				helmet.icon_state = "rig0-sci"
				helmet.item_state = "research_voidsuit_helmet"
			if(suit)
				suit.name = "research voidsuit"
				suit.item_state = "research_voidsuit"
				suit.icon_state = "rig-sci"

		if("Freelancers")
			if(helmet)
				helmet.name = "freelancer voidsuit helmet"
				helmet.icon_state = "rig0-freelancer"
				helmet.item_state = "rig0-freelancer"
			if(suit)
				suit.name = "freelancer voidsuit"
				suit.item_state = "freelancer"
				suit.icon_state = "freelancer"

	if(helmet)
		helmet.name = "refitted [helmet.name]"
	if(suit)
		suit.name = "refitted [suit.name]"
	update_icon()