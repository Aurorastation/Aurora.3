#define MODE_SCANNING 0
#define MODE_COLLECTION 1

/obj/item/nanomachine_scanner
	name = "nanomachine scanner"
	desc = "A Zeng-Hu produced scanner originating with Jeonshi Biotech, this device is used to determine whether or not there are nanomachines within a subject and extract research data if available."
	desc_info = "Alt-click to eject the research slip into your hands."

	icon = 'icons/obj/contained_items/tools/nanomachine.dmi'
	icon_state = "scanner"
	contained_sprite = TRUE

	var/mode = MODE_SCANNING

	var/obj/item/research_slip/nanomachine/loaded_slip

/obj/item/nanomachine_scanner/update_icon()
	cut_overlays()
	if(mode == MODE_COLLECTION)
		add_overlay("scanner-overlay")
	if(loaded_slip)
		add_overlay("scanner-slip")

/obj/item/nanomachine_scanner/attack_self(mob/user)
	playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
	mode = !mode
	to_chat(user, SPAN_NOTICE("You set \the [src] into [mode == MODE_SCANNING ? "scanning" : "collection"] mode."))
	update_icon()

/obj/item/nanomachine_scanner/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/research_slip/nanomachine))
		if(loaded_slip)
			to_chat(user, SPAN_WARNING("\The [src] already as a slip loaded."))
			return
		to_chat(user, SPAN_NOTICE("You slide \the [W] into \the [src]."))
		user.drop_from_inventory(W, src)
		loaded_slip = W
		update_icon()
		return
	return ..()

/obj/item/nanomachine_scanner/AltClick(mob/living/carbon/user)
	if(!loaded_slip)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a research slip loaded."))
		return
	if(!istype(user))
		to_chat(user, SPAN_WARNING("You're too simple to work \the [src]."))
		return
	if(user.l_hand == src || user.r_hand == src)
		to_chat(user, SPAN_NOTICE("You eject \the [loaded_slip]."))
		user.put_in_hands(loaded_slip)
		loaded_slip = null
		update_icon()
	else
		to_chat(user, SPAN_WARNING("You must be holding \the [src] in one of your hands before you can eject a loaded slip."))

/obj/item/nanomachine_scanner/attack(mob/living/carbon/human/H, mob/living/user, target_zone)
	if(!ishuman(H))
		to_chat(user, SPAN_WARNING("\The [src] can only be used on humanoids."))
		return
	if(mode == MODE_COLLECTION)
		if(!loaded_slip)
			to_chat(user, SPAN_WARNING("You are in collection mode, but you do not have a research slip inserted."))
			return
		if(loaded_slip.origin_tech)
			to_chat(user, SPAN_WARNING("The loaded research slip already has tech points loaded."))
			return
	user.visible_message("<b>[user]</b> holds \the [src] up to \the [H]...", SPAN_NOTICE("You start [mode == MODE_SCANNING ? "scanning" : "collecting data from"] \the [H]..."))
	if(!do_mob(user, H, 3 SECONDS))
		return
	switch(mode)
		if(MODE_SCANNING)
			if(H.nanomachines)
				to_chat(user, SPAN_NOTICE("\The [H] has nanomachines. Currently, they are at <b>[round(H.nanomachines.machine_volume, 0.1)]</b>/[H.nanomachines.max_machines] growth."))
				if(H.nanomachines.tech_points_researched)
					to_chat(user, SPAN_NOTICE("Their nanomachines have bio-computing enabled, there [H.nanomachines.tech_points_researched == 1 ? "is" : "are"] <b>[H.nanomachines.tech_points_researched]</b> research point\s available."))
			else
				to_chat(user, SPAN_NOTICE("\The [H] does not have any active nanomachines."))
		if(MODE_COLLECTION)
			if(!H.nanomachines)
				to_chat(user, SPAN_WARNING("\The [H] does not have any active nanomachines."))
				return
			if(!H.nanomachines.tech_points_researched)
				to_chat(user, SPAN_WARNING("\The [H]'s nanomachines do not have bio-computing enabled."))
				return
			to_chat(user, SPAN_NOTICE("You successfully collect [H.nanomachines.tech_points_researched] research point\s from \the [H]."))
			H.nanomachines.speak_to_owner("Successfully delivered [H.nanomachines.tech_points_researched] research point\s.")
			playsound(loc, 'sound/machines/weapons_analyzer.ogg', 50, TRUE)
			var/list/techs = list(TECH_MATERIAL, TECH_ENGINEERING, TECH_PHORON, TECH_POWER, TECH_BLUESPACE, TECH_BIO, TECH_COMBAT, TECH_MAGNET, TECH_DATA)
			loaded_slip.origin_tech = list()
			for(var/tech in techs)
				loaded_slip.origin_tech[tech] = H.nanomachines.tech_points_researched
			H.nanomachines.tech_points_researched = 1