// Commonly used code
#define TRY_INSERT_SUIT_PIECE(slot, path)\
	if(istype(attacking_item, /obj/item/##path)){\
		if(active || locked) {\
			FEEDBACK_FAILURE(user, "\The [src] is locked.");\
			return\
		};\
		if(occupant) {\
			FEEDBACK_FAILURE(user, "There is no space in \the [src] for \the [attacking_item]!");\
			return\
		};\
		if(##slot){\
			FEEDBACK_FAILURE(user, "\The [src] already contains \a [slot]!");\
			return\
		};\
		if(attacking_item.icon_override == CUSTOM_ITEM_MOB){\
			FEEDBACK_FAILURE(user, "You cannot insert a customized voidsuit.");\
			return\
		};\
		to_chat(user, SPAN_NOTICE("You load \the [attacking_item] into the storage compartment."));\
		user.drop_from_inventory(attacking_item, src);\
		##slot = attacking_item;\
		update_icon();\
		updateUsrDialog();\
		return\
	}

/obj/machinery/suit_cycler
	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = TRUE
	density = TRUE

	icon = 'icons/obj/suit_cycler.dmi'
	icon_state = "base"

	req_access = list(ACCESS_CAPTAIN, ACCESS_HEADS)

	var/active = FALSE		// PLEASE HOLD.
	var/safeties = TRUE		// The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0		// If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2	// 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""		// Some flavour text for the topic box.
	var/locked = TRUE		// If locked, nothing can be taken from or added to the cycler.
	var/can_repair			// If set, the cycler can repair voidsuits.
	var/electrified = FALSE

	//Will it change the suit name to "refitted [x]" on refit
	var/rename_on_refit = TRUE
	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering", "Mining", "Medical", "Security", "Atmos")
	//Species that the suits can be configured to fit.
	var/list/species = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_TAJARA, BODYTYPE_IPC)

	var/target_department
	var/target_species

	var/mob/living/carbon/human/occupant
	var/obj/item/clothing/head/helmet/space/helmet
	var/obj/item/clothing/suit/space/void/suit
	var/obj/item/clothing/shoes/magboots/boots
	var/obj/item/clothing/mask/breath/mask

	var/datum/wires/suit_storage_unit/wires

/obj/machinery/suit_cycler/Initialize(mapload, d = 0, populate_parts = TRUE)
	. = ..()

	if(populate_parts)
		if(ispath(suit))
			suit = new suit(src)
		if(ispath(helmet))
			helmet = new helmet(src)
		if(ispath(boots))
			boots = new boots(src)
		if(ispath(mask))
			mask = new mask(src)

	wires = new(src)
	target_department = departments[1]
	target_species = species[1]
	update_icon()
	if(!target_department || !target_species)
		qdel(src)

/obj/machinery/suit_cycler/Destroy()
	if(occupant)
		occupant.dropInto(loc)
		occupant.reset_view()
		occupant = null
	DROP_NULL(suit)
	DROP_NULL(helmet)
	DROP_NULL(boots)
	DROP_NULL(mask)
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
	var/image/overbase = image(icon, "overbase", layer = ABOVE_HUMAN_LAYER)
	add_overlay(overbase)
	if(locked || active)
		var/image/closed = image(icon, "closed", layer = ABOVE_HUMAN_LAYER)
		add_overlay(closed)
	else
		var/image/open = image(icon, "open", layer = ABOVE_HUMAN_LAYER)
		add_overlay(open)
	if(panel_open)
		var/image/panel = image(icon, "panel", layer = ABOVE_HUMAN_LAYER)
		add_overlay(panel)

	if(irradiating)
		var/image/irradiating_lights = make_screen_overlay(icon, "light_radiation")
		add_overlay(irradiating_lights)
		set_light(3, 0.8, COLOR_RED_LIGHT)
	else if(active)
		var/image/active_lights = make_screen_overlay(icon, "light_active")
		add_overlay(active_lights)
		set_light(3, 0.8, COLOR_YELLOW)
	else
		set_light(0)

/obj/machinery/suit_cycler/relaymove(var/mob/user)
	eject_occupant(user)

/obj/machinery/suit_cycler/MouseDrop_T(atom/dropping, mob/user)
	var/mob/living/M = dropping
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
	if(do_after(user, 2 SECONDS, src, DO_UNIQUE))
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
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/attacking_item, mob/user)
	if(electrified != 0)
		if(src.shock(user, 100))
			return

	if(attacking_item.GetID())
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "" : "un"]lock \the [src]."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return

	//Hacking init.
	if(attacking_item.ismultitool() || attacking_item.iswirecutter())
		if(panel_open)
			wires.interact(user)
		return

	//Other interface stuff.
	if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/G = attacking_item
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
		if(do_after(user, 2 SECONDS, src, DO_UNIQUE))
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
	else if(attacking_item.isscrewdriver())
		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance panel."))
		updateUsrDialog()
		update_icon()
		return

	TRY_INSERT_SUIT_PIECE(suit, clothing/suit/space)
	TRY_INSERT_SUIT_PIECE(helmet, clothing/head/helmet/space)
	TRY_INSERT_SUIT_PIECE(boots, clothing/shoes/magboots)
	TRY_INSERT_SUIT_PIECE(mask, clothing/mask)

	..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, mob/user)
	if(emagged)
		to_chat(user, SPAN_WARNING("The cycler has already been subverted."))
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, SPAN_WARNING("You run the sequencer across the interface, corrupting the operating protocols."))
	departments = list("Engineering", "Mining", "Medical", "Security", "Atmos", "^%###^%$", "Unchanged")
	emagged = TRUE
	safeties = FALSE
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user)
	add_fingerprint(user)

	if(panel_open)
		wires.interact(user)
		return

	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(electrified != 0)
		if(src.shock(user, 100))
			return

	ui_interact(user)

/obj/machinery/suit_cycler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuitCycler", name, ui_x=450, ui_y=500)
		ui.open()

/obj/machinery/suit_cycler/ui_data(mob/user)
	return list(
		"in_use" = active,
		"locked" = locked,
		"emagged" = emagged,
		"has_access" = allowed(user),
		"can_repair" = can_repair,
		"model_text" = model_text,
		"radiation_level" = radiation_level,
		"target_department" = target_department,
		"department_change" = can_change_departments(),
		"target_species" = target_species,
		"species_change" = can_change_species(),
		"helmet" = helmet ? list("name" = helmet.name, "damage" = 0) : null,
		"suit" = suit ? list("name" = suit.name, "damage" = suit.damage) : null,
		"boots" = boots ? list("name" = boots.name, "damage" = 0) : null,
		"mask" = mask ? list("name" = mask.name, "damage" = 0) : null
	)

/obj/machinery/suit_cycler/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "eject_suit")
		if(!suit)
			return
		suit.forceMove(get_turf(src))
		if(Adjacent(usr))
			usr.put_in_hands(suit)
		suit = null
		update_icon()

	else if(action == "eject_helmet")
		if(!helmet)
			return
		helmet.forceMove(get_turf(src))
		if(Adjacent(usr))
			usr.put_in_hands(helmet)
		helmet = null
		update_icon()

	else if(action == "eject_boots")
		if(!boots)
			return
		boots.forceMove(get_turf(src))
		if(Adjacent(usr))
			usr.put_in_hands(boots)
		boots = null
		update_icon()

	else if(action == "eject_mask")
		if(!mask)
			return
		mask.forceMove(get_turf(src))
		if(Adjacent(usr))
			usr.put_in_hands(mask)
		mask = null
		update_icon()

	else if(action == "select_department")
		if(!can_change_departments())
			return
		var/choice = tgui_input_list(usr, "Please select the target department paintjob.", "Cycler Target Department Selection", departments, target_department)
		if(choice)
			target_department = choice

	else if(action == "select_species")
		if(!can_change_species())
			return
		var/choice = tgui_input_list(usr, "Please select the target species configuration.", "Cycler Target Species Selection", species, target_species)
		if(choice)
			target_species = choice

	else if(action == "select_rad_level")
		var/choices = list(1, 2, 3)
		if(emagged)
			choices = list(1, 2, 3, 4, 5)
		var/choice = tgui_input_list(usr, "Please select the desired radiation level.", "Cycler Radiation Level Selection", choices, radiation_level)
		if(choice)
			radiation_level = choice

	else if(action == "repair_suit")
		if(!suit || !can_repair)
			return
		playsound(loc, 'sound/machines/suitstorage_lockdoor.ogg', 50, FALSE)
		active = TRUE
		update_icon()
		spawn(100)
			repair_suit()
			finished_job()

	else if(action == "apply_paintjob")
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

		playsound(loc, 'sound/machines/suitstorage_lockdoor.ogg', 50, FALSE)
		active = TRUE
		update_icon()
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(action == "toggle_lock")
		if(src.allowed(usr))
			locked = !locked
			playsound(loc, 'sound/machines/suitstorage_cycledoor.ogg', 50, FALSE)
			to_chat(usr, SPAN_WARNING("You [locked ? "" : "un"]lock \the [src]."))
			update_icon()
		else
			to_chat(usr, SPAN_WARNING("Access denied."))

	else if(action == "begin_decontamination")
		if(safeties && occupant)
			to_chat(usr, SPAN_WARNING("The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
			return

		playsound(loc, 'sound/machines/suitstorage_lockdoor.ogg', 50, FALSE)
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

		if(boots)
			if(radiation_level > 2)
				boots.decontaminate()
			if(radiation_level > 1)
				boots.clean_blood()

		if(mask)
			if(radiation_level > 2)
				mask.decontaminate()
			if(radiation_level > 1)
				mask.clean_blood()

	src.updateUsrDialog()
	return

/obj/machinery/suit_cycler/process()
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
		occupant.apply_damage(radiation_level * 10, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/machinery/suit_cycler/proc/finished_job()
	visible_message("[icon2html(src, viewers(get_turf(src)))] <span class='notice'>\The [src] pings loudly.</span>")
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE)
	playsound(loc, 'sound/machines/suitstorage_lockdoor.ogg', 50, FALSE)
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
	if(user && (locked || active))
		to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	occupant = null

	if(user)
		add_fingerprint(user)
	updateUsrDialog()
	update_icon()

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet && !helmet.contained_sprite)
			helmet.refit_for_species(target_species)
		if(suit && !suit.contained_sprite)
			suit.refit_for_species(target_species)

	switch(target_department)
		if("Engineering")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
				helmet.name = "engineering voidsuit helmet"
				helmet.icon_state = "engineering_helm"
				helmet.item_state = "engineering_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
				suit.name = "engineering voidsuit"
				suit.icon_state = "engineering"
				suit.item_state = "engineering"
		if("Mining")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/mining.dmi'
				helmet.name = "mining voidsuit helmet"
				helmet.icon_state = "mining_helm"
				helmet.item_state = "mining_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/mining.dmi'
				suit.name = "mining voidsuit"
				suit.icon_state = "mining"
				suit.item_state = "mining"
		if("Medical")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/medical.dmi'
				helmet.name = "medical voidsuit helmet"
				helmet.icon_state = "medical_helm"
				helmet.item_state = "medical_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/medical.dmi'
				suit.name = "medical voidsuit"
				suit.icon_state = "medical"
				suit.item_state = "medical"
		if("Security")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/security.dmi'
				helmet.name = "security voidsuit helmet"
				helmet.icon_state = "security_helm"
				helmet.item_state = "security_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/security.dmi'
				suit.name = "security voidsuit"
				suit.icon_state = "security"
				suit.item_state = "security"
		if("Atmos")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
				helmet.name = "atmospherics voidsuit helmet"
				helmet.icon_state = "atmos_helm"
				helmet.item_state = "atmos_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/engineering.dmi'
				suit.name = "atmospherics voidsuit"
				suit.icon_state = "atmos"
				suit.item_state = "atmos"
		if("Captain")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/captain.dmi'
				helmet.name = "captain voidsuit helmet"
				helmet.icon_state = "captain_helm"
				helmet.item_state = "captain_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/captain.dmi'
				suit.name = "captain voidsuit"
				suit.icon_state = "captain"
				suit.item_state = "captain"
		if("^%###^%$", "Mercenary")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
				helmet.name = "blood-red voidsuit helmet"
				helmet.icon_state = "syndie_helm"
				helmet.item_state = "syndie_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
				suit.name = "blood-red voidsuit"
				suit.item_state = "syndie"
				suit.icon_state = "syndie"
		if("Research")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/station/captain.dmi'
				helmet.name = "research voidsuit helmet"
				helmet.icon_state = "research_helm"
				helmet.item_state = "research_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/station/captain.dmi'
				suit.name = "research voidsuit"
				suit.item_state = "research"
				suit.icon_state = "research"

		if("Freelancers")
			if(helmet)
				helmet.icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
				helmet.name = "freelancer voidsuit helmet"
				helmet.icon_state = "freelancer_helm"
				helmet.item_state = "freelancer_helm"
			if(suit)
				suit.icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
				suit.name = "freelancer voidsuit"
				suit.item_state = "freelancer"
				suit.icon_state = "freelancer"

	if(helmet)
		if(helmet.contained_sprite)
			helmet.refit_contained(target_species)
		if(rename_on_refit)
			helmet.name = "refitted [helmet.name]"
	if(suit)
		if(suit.contained_sprite)
			suit.refit_contained(target_species)
		if(rename_on_refit)
			suit.name = "refitted [suit.name]"
	update_icon()

/obj/machinery/suit_cycler/proc/can_change_departments()
	if(departments.len <= 1)
		return FALSE
	else return TRUE

/obj/machinery/suit_cycler/proc/can_change_species()
	if(species.len <= 1)
		return FALSE
	else return TRUE

#undef TRY_INSERT_SUIT_PIECE
