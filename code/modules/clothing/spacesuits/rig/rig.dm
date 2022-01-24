#define ONLY_DEPLOY 1
#define ONLY_RETRACT 2
#define SEAL_DELAY 30

/*
 * Defines the behavior of hardsuits/rigs/power armor.
 */

/obj/item/rig
	name = "hardsuit control module"
	desc = "A back-mounted hardsuit deployment and control mechanism."
	icon = 'icons/obj/rig_modules.dmi'
	contained_sprite = TRUE
	slot_flags = SLOT_BACK
	req_one_access = list()
	req_access = list()
	w_class = ITEMSIZE_LARGE

	// These values are passed on to all component pieces.
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = RIG_MAX_PRESSURE
	min_pressure_protection = 0

	siemens_coefficient = 0.35
	permeability_coefficient = 0.1
	unacidable = 1
	slowdown = 1 // All rigs by default should have slowdown.

	var/has_sealed_state = FALSE

	var/interface_path = "hardsuit.tmpl"
	var/ai_interface_path = "hardsuit.tmpl"
	var/interface_title = "Hardsuit Controller"
	var/wearer_move_delay //Used for AI moving.
	var/ai_controlled_move_delay = 10
	var/last_remote_message // when did a mounted pAI or AI use a module? used to prevent admin msg spam

	// Keeps track of what this rig should spawn with.
	var/suit_type = "hardsuit"
	var/list/initial_modules
	var/chest_type = /obj/item/clothing/suit/space/rig
	var/helm_type =  /obj/item/clothing/head/helmet/space/rig
	var/boot_type =  /obj/item/clothing/shoes/magboots/rig
	var/glove_type = /obj/item/clothing/gloves/rig
	var/cell_type =  /obj/item/cell/high
	var/air_type =   /obj/item/tank/oxygen

	//Component/device holders.
	var/obj/item/tank/air_supply                       // Air tank, if any.
	var/obj/item/clothing/shoes/boots = null                  // Deployable boots, if any.
	var/obj/item/clothing/suit/space/rig/chest                // Deployable chestpiece, if any.
	var/obj/item/clothing/head/helmet/space/rig/helmet = null // Deployable helmet, if any.
	var/obj/item/clothing/gloves/rig/gloves = null            // Deployable gauntlets, if any.
	var/obj/item/cell/cell                             // Power supply, if any.
	var/obj/item/rig_module/selected_module = null            // Primary system (used with middle-click)
	var/obj/item/rig_module/vision/visor                      // Kinda shitty to have a var for a module, but saves time.
	var/obj/item/rig_module/voice/speech                      // As above.
	var/mob/living/carbon/human/wearer                        // The person currently wearing the rig.
	var/image/mob_icon                                        // Holder for on-mob icon.
	var/list/installed_modules = list()                       // Power consumption/use bookkeeping.

	// Rig status vars.
	var/open = 0                                              // Access panel status.
	var/locked = 1                                            // Lock status.
	var/dnaLock                                               // To whom do we belong?
	var/crushing = FALSE                                      // Are we crushing the occupant to death?
	var/subverted = 0
	var/interface_locked = 0
	var/control_overridden = 0
	var/ai_override_enabled = 0
	var/security_check_enabled = 1
	var/malfunctioning = 0
	var/malfunction_delay = 0
	var/electrified = 0
	var/locked_down = 0

	var/seal_delay = SEAL_DELAY
	var/sealing                                               // Keeps track of seal status independantly of canremove.
	var/offline = 1                                           // Should we be applying suit maluses?
	var/offline_slowdown = 3                                  // If the suit is deployed and unpowered, it sets slowdown to this.
	var/vision_restriction = TINT_NONE
	var/offline_vision_restriction = TINT_HEAVY
	var/airtight = 1 //If set, will adjust the AIRTIGHT flag on components. Otherwise it should leave them untouched.

	var/emp_protection = 0

	// Wiring! How exciting.]
	var/datum/wires/rig/wires
	var/datum/effect_system/sparks/spark_system

	var/allowed_module_types = MODULE_GENERAL // All rigs by default should have access to general
	var/list/species_restricted = list(BODYTYPE_HUMAN,BODYTYPE_TAJARA,BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)

/obj/item/rig/examine()
	to_chat(usr, "This is [icon2html(src, usr)][src.name].")
	to_chat(usr, "[src.desc]")
	if(wearer)
		for(var/obj/item/piece in list(helmet,gloves,chest,boots))
			if(!piece || piece.loc != wearer)
				continue
			to_chat(usr, "[icon2html(piece, usr)] \The [piece] [piece.gender == PLURAL ? "are" : "is"] deployed.")

	if(src.loc == usr)
		to_chat(usr, "The maintenance panel is [open ? "open" : "closed"].")
		to_chat(usr, "Hardsuit systems are [offline ? "<span class='warning'>offline</span>" : "<span class='good'>online</span>"].")

/obj/item/rig/Initialize()
	. = ..()

	item_state = icon_state
	wires = new(src)

	if(!LAZYLEN(req_access) && !LAZYLEN(req_one_access))
		locked = 0

	spark_system = bind_spark(src, 5)

	START_PROCESSING(SSprocessing, src)

	last_remote_message = world.time

	if(initial_modules && initial_modules.len)
		for(var/path in initial_modules)
			var/obj/item/rig_module/module = new path(src)
			installed_modules += module
			module.installed(src)

	// Create and initialize our various segments.
	if(cell_type)
		cell = new cell_type(src)
	if(air_type)
		air_supply = new air_type(src)
	if(glove_type)
		gloves = new glove_type(src)
		verbs |= /obj/item/rig/proc/toggle_gauntlets
	if(helm_type)
		helmet = new helm_type(src)
		verbs |= /obj/item/rig/proc/toggle_helmet
	if(boot_type)
		boots = new boot_type(src)
		verbs |= /obj/item/rig/proc/toggle_boots
	if(chest_type)
		chest = new chest_type(src)
		if(allowed)
			chest.allowed = allowed
		verbs |= /obj/item/rig/proc/toggle_chest

	for(var/obj/item/clothing/piece in list(gloves,helmet,boots,chest))
		if(!istype(piece))
			continue
		piece.canremove = 0
		piece.name = "[suit_type] [initial(piece.name)]"
		piece.desc = "It seems to be part of a [src.name]."
		piece.icon = icon
		piece.icon_state = "[initial(icon_state)]_[piece.clothing_class()]"
		piece.item_state = "[initial(icon_state)]"
		piece.contained_sprite = TRUE
		if(length(icon_supported_species_tags))
			piece.icon_auto_adapt = TRUE
			piece.icon_supported_species_tags = icon_supported_species_tags
		piece.min_cold_protection_temperature = min_cold_protection_temperature
		piece.max_heat_protection_temperature = max_heat_protection_temperature
		if(piece.siemens_coefficient > siemens_coefficient) //So that insulated gloves keep their insulation.
			piece.siemens_coefficient = siemens_coefficient
		piece.permeability_coefficient = permeability_coefficient
		piece.unacidable = unacidable
		piece.species_restricted = species_restricted
		if(islist(armor))
			var/datum/component/armor/armor_component = piece.GetComponent(/datum/component/armor)
			if(istype(armor_component))
				armor_component.RemoveComponent()
			piece.AddComponent(/datum/component/armor, armor, ARMOR_TYPE_STANDARD|ARMOR_TYPE_RIG)

	set_vision(!offline)
	update_icon(1)

/obj/item/rig/Destroy()
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		qdel(piece)
	STOP_PROCESSING(SSprocessing, src)
	qdel(wires)
	wires = null
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/rig/proc/set_vision(var/active)
	if(helmet)
		helmet.tint = (active? vision_restriction : offline_vision_restriction)

/obj/item/rig/proc/suit_is_deployed()
	if(!istype(wearer) || src.loc != wearer || wearer.back != src)
		return 0
	if(helm_type && !(helmet && wearer.head == helmet))
		return 0
	if(glove_type && !(gloves && wearer.gloves == gloves))
		return 0
	if(boot_type && !(boots && wearer.shoes == boots))
		return 0
	if(chest_type && !(chest && wearer.wear_suit == chest))
		return 0
	return 1

/obj/item/rig/proc/reset()
	offline = 2
	canremove = 1
	crushing = FALSE
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(!piece) continue
		piece.icon_state = "[initial(icon_state)]"
		if(airtight)
			piece.max_pressure_protection = initial(piece.max_pressure_protection)
			piece.min_pressure_protection = initial(piece.min_pressure_protection)
			piece.item_flags &= ~AIRTIGHT
	update_icon(1)

/obj/item/rig/proc/toggle_seals(var/mob/initiator,var/instant)

	if(sealing) return

	// Seal toggling can be initiated by the suit AI, too
	if(!wearer)
		to_chat(initiator, "<span class='danger'>Cannot toggle suit: The suit is currently not being worn by anyone.</span>")
		return 0

	if(!check_power_cost(wearer))
		return 0

	deploy(wearer,instant)

	var/seal_target = !canremove
	var/failed_to_seal

	canremove = 0 // No removing the suit while unsealing.
	sealing = 1

	if(!seal_target && !suit_is_deployed())
		wearer.visible_message("<span class='danger'>[wearer]'s suit flashes an error light.</span>","<span class='danger'>Your suit flashes an error light. It can't function properly without being fully deployed.</span>")
		playsound(src, 'sound/items/rfd_empty.ogg', 20, FALSE)
		failed_to_seal = 1

	var/is_in_cycler = istype(initiator.loc, /obj/machinery/suit_cycler)
	seal_delay = is_in_cycler ? 1 : initial(seal_delay)

	if(!failed_to_seal)
		if(!instant)
			wearer.visible_message("<span class='notice'>[wearer]'s suit emits a quiet hum as it begins to adjust its seals.</span>","<span class='notice'>With a quiet hum, the suit begins running checks and adjusting components.</span>")
			if(seal_delay && !do_after(wearer, seal_delay, act_target = src))
				if(wearer) to_chat(wearer, "<span class='warning'>You must remain still while the suit is adjusting the components.</span>")
				playsound(src, 'sound/items/rfd_empty.ogg', 20, FALSE)
				failed_to_seal = 1

		if(!wearer)
			failed_to_seal = 1
		else
			for(var/list/piece_data in list(list(wearer.shoes,boots,"boots",boot_type),list(wearer.gloves,gloves,"gloves",glove_type),list(wearer.head,helmet,"helmet",helm_type),list(wearer.wear_suit,chest,BP_CHEST,chest_type)))

				var/obj/item/clothing/piece = piece_data[1]
				var/obj/item/compare_piece = piece_data[2]
				var/msg_type = piece_data[3]
				var/piece_type = piece_data[4]

				if(!piece || !piece_type)
					continue

				if(!istype(wearer) || !istype(piece) || !istype(compare_piece) || !msg_type)
					if(wearer) to_chat(wearer, "<span class='warning'>You must remain still while the suit is adjusting the components.</span>")
					playsound(src, 'sound/items/rfd_empty.ogg', 20, FALSE)
					failed_to_seal = 1
					break

				if(!failed_to_seal && wearer.back == src && piece == compare_piece)

					if(seal_delay && !instant && !do_after(wearer,seal_delay,needhand=0, act_target = src))
						failed_to_seal = 1

					piece.icon_state = "[initial(icon_state)][!seal_target ? "_sealed" : ""]_[piece.clothing_class()]"
					piece.item_state = "[initial(icon_state)][!seal_target ? "_sealed" : ""]"
					switch(msg_type)
						if("boots")
							to_chat(wearer, "<span class='notice'>\The [piece] [!seal_target ? "seal around your feet" : "relax their grip on your legs"].</span>")
							wearer.update_inv_shoes()
						if("gloves")
							to_chat(wearer, "<span class='notice'>\The [piece] [!seal_target ? "tighten around your fingers and wrists" : "become loose around your fingers"].</span>")
							wearer.update_inv_gloves()
						if(BP_CHEST)
							to_chat(wearer, "<span class='notice'>\The [piece] [!seal_target ? "cinches tight again your chest" : "releases your chest"].</span>")
							wearer.update_inv_wear_suit()
						if("helmet")
							to_chat(wearer, "<span class='notice'>\The [piece] hisses [!seal_target ? "closed" : "open"].</span>")
							wearer.update_inv_head()
							if(helmet)
								helmet.update_light(wearer)

					//sealed pieces become airtight, protecting against diseases
					var/datum/component/armor/armor_component = piece.GetComponent(/datum/component/armor)
					if(istype(armor_component))
						armor_component.sealed = !seal_target
					playsound(src, "[!seal_target ? 'sound/machines/rig/rig_deploy.ogg' : 'sound/machines/rig/rig_retract.ogg']", 20, FALSE)

				else
					failed_to_seal = 1

		if((wearer && !(istype(wearer) && wearer.back == src)) || (!seal_target && !suit_is_deployed()))
			failed_to_seal = 1

	sealing = null

	if(failed_to_seal)
		for(var/obj/item/piece in list(helmet,boots,gloves,chest))
			if(!piece) continue
			piece.icon_state = "[initial(icon_state)][!seal_target ? "" : "_sealed"]"
		canremove = !seal_target
		if(airtight)
			update_component_sealed()
		update_icon(1)
		return 0

	// Success!
	canremove = seal_target
	to_chat(wearer, "<span class='notice'><b>Your entire suit [canremove ? "loosens as the components relax" : "tightens around you as the components lock into place"].</b></span>")
	playsound(src, 'sound/items/rped.ogg', 20, FALSE)
	if (has_sealed_state)
		icon_state = canremove ? initial(icon_state) : "[initial(icon_state)]_sealed"
	if(dnaLock && !offline)
		if(dnaLock != wearer.dna)
			visible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> announces, <span class='notice'>\"DNA mismatch. Unauthorized access detected.\"</span>")
			crushing = TRUE

	if(wearer != initiator)
		to_chat(initiator, "<span class='notice'>Suit adjustment complete. Suit is now [canremove ? "unsealed" : "sealed"].</span>")

	if(canremove)
		for(var/obj/item/rig_module/module in installed_modules)
			module.deactivate(initiator)
	if(airtight)
		update_component_sealed()
	update_icon(1)
	if(is_in_cycler)
		initiator.loc.update_icon()

/obj/item/rig/proc/update_component_sealed()
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(canremove)
			piece.max_pressure_protection = initial(piece.max_pressure_protection)
			piece.min_pressure_protection = initial(piece.min_pressure_protection)
			piece.item_flags &= ~AIRTIGHT
		else
			piece.max_pressure_protection = max_pressure_protection
			piece.min_pressure_protection = min_pressure_protection
			piece.item_flags |= AIRTIGHT
	update_icon(1)

/obj/item/rig/process()

	// If we've lost any parts, grab them back.
	var/mob/living/M
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		if(piece.loc != src && !(wearer && piece.loc == wearer))
			if(istype(piece.loc, /mob/living))
				M = piece.loc
				M.drop_from_inventory(piece,src)
			else
				piece.forceMove(src)

	if(!istype(wearer) || loc != wearer || wearer.back != src || canremove || !cell || cell.charge <= 0)
		if(!cell || cell.charge <= 0)
			if(electrified > 0)
				electrified = 0
			if(!offline)
				if(istype(wearer))
					playsound(src, 'sound/machines/rig/rig_shutdown.ogg', 20, FALSE)
					if(!canremove)
						if (offline_slowdown < 3)
							to_chat(wearer, "<span class='danger'>Your suit beeps stridently, and suddenly goes dead.</span>")
						else
							to_chat(wearer, "<span class='danger'>Your suit beeps stridently, and suddenly you're wearing a leaden mass of metal and plastic composites instead of a powered suit.</span>")
					if(offline_vision_restriction == 1)
						to_chat(wearer, "<span class='danger'>The suit optics flicker and die, leaving you with restricted vision.</span>")
					else if(offline_vision_restriction == 2)
						to_chat(wearer, "<span class='danger'>The suit optics drop out completely, drowning you in darkness.</span>")
		if(!offline)
			offline = 1
	else
		if(offline)
			offline = 0
			if(istype(wearer) && !wearer.wearing_rig)
				wearer.wearing_rig = src
			slowdown = initial(slowdown)

	set_vision(!offline)
	if(offline)
		crushing = FALSE
		if(offline == 1)
			for(var/obj/item/rig_module/module in installed_modules)
				module.deactivate()
			offline = 2
			slowdown = offline_slowdown
		return

	if(crushing)
		wearer.apply_damage(10) // Applies 10 brute damage to a random extremity each process
		if(wearer.stat == DEAD)
			crushing = FALSE
			visible_message(SPAN_DANGER("A squelching sound comes from within the sealed hardsuit..")) // this denotes that the user inside has died.

	if(cell && cell.charge > 0 && electrified > 0)
		electrified--

	if(malfunction_delay > 0)
		malfunction_delay--
	else if(malfunctioning)
		malfunctioning--
		malfunction()

	for(var/obj/item/rig_module/module in installed_modules)
		cell.use(module.process()*10)

/obj/item/rig/proc/check_power_cost(var/mob/living/user, var/cost, var/use_unconcious, var/obj/item/rig_module/mod, var/user_is_ai)

	if(!istype(user))
		return 0

	var/fail_msg

	if(!user_is_ai)
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.back != src)
			fail_msg = "<span class='warning'>You must be wearing \the [src] to do this.</span>"
		else if(user.incorporeal_move)
			fail_msg = "<span class='warning'>You must be solid to do this.</span>"
	if(sealing)
		fail_msg = "<span class='warning'>The hardsuit is in the process of adjusting seals and cannot be activated.</span>"
	else if(!fail_msg && ((use_unconcious && user.stat > 1) || (!use_unconcious && user.stat)))
		fail_msg = "<span class='warning'>You are in no fit state to do that.</span>"
	else if(!cell)
		fail_msg = "<span class='warning'>There is no cell installed in the suit.</span>"
	else if(cost && cell.charge < cost * 10) //TODO: Cellrate?
		fail_msg = "<span class='warning'>Not enough stored power.</span>"

	if(fail_msg)
		to_chat(user, "[fail_msg]")
		playsound(src, 'sound/items/rfd_empty.ogg', 20, FALSE)
		return 0

	// This is largely for cancelling stealth and whatever.
	if(mod && mod.disruptive)
		for(var/obj/item/rig_module/module in (installed_modules - mod))
			if(module.active && module.disruptable)
				module.deactivate()

	cell.use(cost*10)
	return 1

/obj/item/rig/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/nano_state = inventory_state)
	if(!user)
		return

	var/list/data = list()

	if(selected_module)
		data["primarysystem"] = "[selected_module.interface_name]"

	if(src.loc != user)
		data["ai"] = 1

	data["seals"] =     "[src.canremove]"
	data["sealing"] =   "[src.sealing]"
	data["helmet"] =    (helmet ? "[helmet.name]" : "None.")
	data["gauntlets"] = (gloves ? "[gloves.name]" : "None.")
	data["boots"] =     (boots ?  "[boots.name]" :  "None.")
	data[BP_CHEST] =     (chest ?  "[chest.name]" :  "None.")

	data["charge"] =       cell ? round(cell.charge,1) : 0
	data["maxcharge"] =    cell ? cell.maxcharge : 0
	data["chargestatus"] = cell ? Floor((cell.charge/cell.maxcharge)*50) : 0

	data["emagged"] =       subverted
	data["coverlock"] =     locked
	data["interfacelock"] = interface_locked
	data["aicontrol"] =     control_overridden
	data["aioverride"] =    ai_override_enabled
	data["securitycheck"] = security_check_enabled
	data["malf"] =          malfunction_delay


	var/list/module_list = list()
	var/i = 1
	for(var/obj/item/rig_module/module in installed_modules)
		var/list/module_data = list(
			"index" =             i,
			"name" =              "[module.interface_name]",
			"desc" =              "[module.interface_desc]",
			"can_use" =           "[module.usable]",
			"can_select" =        "[module.selectable]",
			"can_toggle" =        "[module.toggleable]",
			"is_active" =         "[module.active]",
			"engagecost" =        module.use_power_cost*10,
			"activecost" =        module.active_power_cost*10,
			"passivecost" =       module.passive_power_cost*10,
			"engagestring" =      module.engage_string,
			"activatestring" =    module.activate_string,
			"deactivatestring" =  module.deactivate_string,
			"damage" =            module.damage
			)

		if(module.charges && module.charges.len)

			module_data["charges"] = list()
			var/datum/rig_charge/selected = module.charges[module.charge_selected]
			module_data["chargetype"] = selected ? "[selected.display_name]" : "none"

			for(var/chargetype in module.charges)
				var/datum/rig_charge/charge = module.charges[chargetype]
				module_data["charges"] += list(list("caption" = "[chargetype] ([charge.charges])", "index" = "[chargetype]"))

		module_list += list(module_data)
		i++

	if(module_list.len)
		data["modules"] = module_list

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, ((src.loc != user) ? ai_interface_path : interface_path), interface_title, 480, 550, state = nano_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/rig/update_icon(var/update_mob_icon)

	//TODO: Maybe consider a cache for this (use mob_icon as blank canvas, use suit icon overlay).
	cut_overlays()
	if(!mob_icon || update_mob_icon)
		var/species_icon = 'icons/mob/rig_back.dmi'
		// Since setting mob_icon will override the species checks in
		// update_inv_wear_suit(), handle species checks here.
		if(wearer && sprite_sheets && sprite_sheets[wearer.species.get_bodytype()])
			species_icon =  sprite_sheets[wearer.species.get_bodytype()]
		mob_icon = image("icon" = species_icon, "icon_state" = "[icon_state]")

	if(installed_modules.len)
		for(var/obj/item/rig_module/module in installed_modules)
			if(module.suit_overlay)
				chest.add_overlay(image("icon" = 'icons/mob/rig_modules.dmi', "icon_state" = "[module.suit_overlay]", "dir" = SOUTH))

	if(wearer)
		wearer.update_inv_shoes()
		wearer.update_inv_gloves()
		wearer.update_inv_head()
		wearer.update_inv_wear_suit()
		wearer.update_inv_back()
	return

/obj/item/rig/get_cell()
	if(cell)
		return cell
	return ..()

/obj/item/rig/proc/check_suit_access(var/mob/living/carbon/human/user)

	if(!security_check_enabled)
		return 1

	if(istype(user))
		if(malfunction_check(user))
			return 0
		if(user.back != src)
			return 0
		else if(!src.allowed(user))
			to_chat(user, "<span class='danger'>Unauthorized user. Access denied.</span>")
			return 0

	else if(!ai_override_enabled)
		to_chat(user, "<span class='danger'>Synthetic access disabled. Please consult hardware provider.</span>")
		return 0

	return 1

//TODO: Fix Topic vulnerabilities for malfunction and AI override.
/obj/item/rig/Topic(href,href_list)
	if(ismob(href))
		do_rig_thing(href, href_list)
		return
	do_rig_thing(usr, href_list)

/obj/item/rig/proc/do_rig_thing(mob/user, var/list/href_list)
	if(!check_suit_access(user))
		return 0

	if(href_list["toggle_piece"])
		if(ishuman(user) && (user.stat || user.stunned || user.lying))
			return FALSE
		toggle_piece(href_list["toggle_piece"], user)
	else if(href_list["toggle_seals"])
		toggle_seals(user)
	else if(href_list["interact_module"])

		var/module_index = text2num(href_list["interact_module"])

		if(module_index > 0 && module_index <= installed_modules.len)
			var/obj/item/rig_module/module = installed_modules[module_index]
			switch(href_list["module_mode"])
				if("activate")
					module.activate(user)
				if("deactivate")
					module.deactivate(user)
				if("engage")
					module.do_engage(null, user)
				if("select")
					selected_module = module
				if("select_charge_type")
					module.charge_selected = href_list["charge_type"]
	else if(href_list["toggle_ai_control"])
		ai_override_enabled = !ai_override_enabled
		notify_ai("Synthetic suit control has been [ai_override_enabled ? "enabled" : "disabled"].")
	else if(href_list["toggle_suit_lock"])
		locked = !locked

	user.set_machine(src)
	src.add_fingerprint(user)
	return FALSE

/obj/item/rig/proc/notify_ai(var/message)
	for(var/obj/item/rig_module/ai_container/module in installed_modules)
		if(module.integrated_ai && module.integrated_ai.client && !module.integrated_ai.stat)
			to_chat(module.integrated_ai, "[message]")
			. = 1

/obj/item/rig/check_equipped(mob/living/carbon/human/M, slot, assisted_equip = FALSE)
	if(istype(M) && slot == slot_back)
		if(!assisted_equip && seal_delay > 0)
			M.visible_message(SPAN_NOTICE("[M] starts putting on \the [src]..."), SPAN_NOTICE("You start putting on \the [src]..."))
			if(!do_after(M, seal_delay))
				return FALSE

		M.visible_message(SPAN_NOTICE("<b>[M] struggles into \the [src].</b>"), SPAN_NOTICE("<b>You struggle into \the [src].</b>"))
		wearer = M
		wearer.wearing_rig = src
		update_icon()
		return TRUE
	return TRUE

/obj/item/rig/proc/toggle_piece(var/piece, var/mob/initiator, var/deploy_mode)

	if(!usr || sealing || !cell || !cell.charge)
		return

	if(!istype(wearer) || !wearer.back == src)
		return

	if(initiator == wearer && (usr.stat||usr.paralysis||usr.stunned)) // If the initiator isn't wearing the suit it's probably an AI.
		return

	var/obj/item/check_slot
	var/equip_to
	var/obj/item/use_obj

	if(!wearer)
		return

	switch(piece)
		if("helmet")
			equip_to = slot_head
			use_obj = helmet
			check_slot = wearer.head
		if("gauntlets")
			equip_to = slot_gloves
			use_obj = gloves
			check_slot = wearer.gloves
		if("boots")
			equip_to = slot_shoes
			use_obj = boots
			check_slot = wearer.shoes
		if("chest")
			equip_to = slot_wear_suit
			use_obj = chest
			check_slot = wearer.wear_suit

	if(use_obj)
		if(check_slot == use_obj && deploy_mode != ONLY_DEPLOY)

			var/mob/living/carbon/human/holder

			if(use_obj)
				holder = use_obj.loc
				if(istype(holder))
					if(use_obj && check_slot == use_obj)
						to_chat(wearer, "<font color='blue'><b>Your [use_obj.name] [use_obj.gender == PLURAL ? "retract" : "retracts"] swiftly.</b></font>")
						playsound(src, 'sound/machines/rig/rig_retract.ogg', 20, FALSE)
						use_obj.canremove = 1
						holder.drop_from_inventory(use_obj,get_turf(src)) //TODO: TEST THIS CODE!
						use_obj.dropped(wearer)
						use_obj.canremove = 0
						use_obj.forceMove(src)

		else if (deploy_mode != ONLY_RETRACT)
			if(check_slot && check_slot == use_obj)
				return
			use_obj.forceMove(wearer)
			if(!wearer.equip_to_slot_if_possible(use_obj, equip_to, 0, 1))
				use_obj.forceMove(src)
				if(check_slot)
					to_chat(initiator, "<span class='danger'>You are unable to deploy \the [piece] as \the [check_slot] [check_slot.gender == PLURAL ? "are" : "is"] in the way.</span>")
					playsound(src, 'sound/items/rfd_empty.ogg', 20, FALSE)
					return
			else
				to_chat(wearer, "<span class='notice'>Your [use_obj.name] [use_obj.gender == PLURAL ? "deploy" : "deploys"] swiftly.</span>")
				playsound(src, 'sound/machines/rig/rig_deploy.ogg', 20, FALSE)

	if(piece == "helmet" && helmet)
		helmet.update_light(wearer)

/obj/item/rig/proc/deploy(mob/M,var/sealed)

	var/mob/living/carbon/human/H = M

	if(!H || !istype(H)) return

	if(H.back != src)
		return

	if(sealed)
		if(H.head)
			var/obj/item/garbage = H.head
			H.head = null
			qdel(garbage)

		if(H.gloves)
			var/obj/item/garbage = H.gloves
			H.gloves = null
			qdel(garbage)

		if(H.shoes)
			var/obj/item/garbage = H.shoes
			H.shoes = null
			qdel(garbage)

		if(H.wear_suit)
			var/obj/item/garbage = H.wear_suit
			H.wear_suit = null
			qdel(garbage)

	for(var/piece in list("helmet","gauntlets",BP_CHEST,"boots"))
		toggle_piece(piece, H, ONLY_DEPLOY)

/obj/item/rig/proc/null_wearer(var/mob/user)
	for(var/piece in list("helmet","gauntlets",BP_CHEST,"boots"))
		toggle_piece(piece, user, ONLY_RETRACT)
	if(wearer)
		wearer.wearing_rig = null
		wearer = null

/obj/item/rig/on_slotmove(var/mob/user)
	..()
	null_wearer(user)

/obj/item/rig/dropped(var/mob/user)
	..()
	null_wearer(user)


//Todo
/obj/item/rig/proc/malfunction()
	return 0

/obj/item/rig/emp_act(severity_class)
	//set malfunctioning
	if(emp_protection < 30) //for ninjas, really.
		malfunctioning += 10
		if(malfunction_delay <= 0)
			malfunction_delay = max(malfunction_delay, round(30/severity_class))

	//drain some charge
	if(cell) cell.emp_act((severity_class + 15)*1+(0.1*emp_protection))

	//possibly damage some modules
	take_hit((100/severity_class), "electrical pulse", 1)

/obj/item/rig/proc/shock(mob/user)
	var/touchy = pick(BP_CHEST,BP_HEAD,BP_GROIN)
	if(!wearer)
		touchy = "hand"

	if (electrocute_mob(user, cell, src, contact_zone = touchy)) //electrocute_mob() handles removing charge from the cell, no need to do that here.
		spark_system.queue()
		if(user.stunned)
			return 1
	return 0

/obj/item/rig/proc/take_hit(damage, source, is_emp=0)

	if(!installed_modules.len)
		return

	var/chance
	if(!is_emp)
		var/damage_resistance = 0
		if(istype(chest, /obj/item/clothing/suit/space))
			damage_resistance = chest.breach_threshold
		chance = 2*max(0, damage - damage_resistance)
	else
		//Want this to be roughly independant of the number of modules, meaning that X emp hits will disable Y% of the suit's modules on average.
		//that way people designing hardsuits don't have to worry (as much) about how adding that extra module will affect emp resiliance by 'soaking' hits for other modules
		chance = 2*max(0, damage - emp_protection)*min(installed_modules.len/15, 1)

	if(!prob(chance))
		return

	//deal addition damage to already damaged module first.
	//This way the chances of a module being disabled aren't so remote.
	var/list/valid_modules = list()
	var/list/damaged_modules = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.damage < 2)
			valid_modules |= module
			if(module.damage > 0)
				damaged_modules |= module

	var/obj/item/rig_module/dam_module = null
	if(damaged_modules.len)
		dam_module = pick(damaged_modules)
	else if(valid_modules.len)
		dam_module = pick(valid_modules)

	if(!dam_module) return

	dam_module.damage++

	if(!source)
		source = "hit"

	if(wearer)
		if(dam_module.damage >= 2)
			to_chat(wearer, "<span class='danger'>The [source] has disabled your [dam_module.interface_name]!</span>")
		else
			to_chat(wearer, "<span class='warning'>The [source] has damaged your [dam_module.interface_name]!</span>")
	dam_module.deactivate()

/obj/item/rig/proc/malfunction_check(var/mob/living/carbon/human/user)
	if(malfunction_delay)
		if(offline)
			to_chat(user, "<span class='danger'>The suit is completely unresponsive.</span>")
		else
			to_chat(user, "<span class='danger'>ERROR: Hardware fault. Rebooting interface...</span>")
		return 1
	return 0

/obj/item/rig/proc/ai_can_move_suit(var/mob/user, var/check_user_module = 0, var/check_for_ai = 0)

	if(check_for_ai)
		if(!(locate(/obj/item/rig_module/ai_container) in contents))
			return 0
		var/found_ai
		for(var/obj/item/rig_module/ai_container/module in contents)
			if(module.damage >= 2)
				continue
			if(module.integrated_ai && module.integrated_ai.client && !module.integrated_ai.stat)
				found_ai = 1
				break
		if(!found_ai)
			return 0

	if(check_user_module)
		if(!user || !user.loc || !user.loc.loc)
			return 0
		var/obj/item/rig_module/ai_container/module = user.loc.loc
		if(!istype(module) || module.damage >= 2)
			to_chat(user, "<span class='warning'>Your host module is unable to interface with the suit.</span>")
			return 0

	if(offline || !cell || !cell.charge || locked_down)
		if(user) to_chat(user, "<span class='warning'>Your host rig is unpowered and unresponsive.</span>")
		return 0
	if(!wearer || wearer.back != src)
		if(user) to_chat(user, "<span class='warning'>Your host rig is not being worn.</span>")
		return 0
	if(!wearer.stat && !control_overridden && !ai_override_enabled)
		if(user) to_chat(user, "<span class='warning'>You are locked out of the suit servo controller.</span>")
		return 0
	return 1

/obj/item/rig/proc/force_rest(var/mob/user)
	if(!ai_can_move_suit(user, check_user_module = 1))
		return
	wearer.lay_down()
	to_chat(user, "<span class='notice'>\The [wearer] is now [wearer.resting ? "resting" : "getting up"].</span>")

/obj/item/rig/proc/forced_move(var/direction, var/mob/user)
	// Why is all this shit in client/Move()? Who knows?
	if(world.time < wearer_move_delay)
		return

	if(!wearer || !wearer.loc || !ai_can_move_suit(user, check_user_module = 1))
		return

	if(!wearer.stat && !wearer.paralysis) // don't force move if our wearer is awake and capable of moving
		return

	//This is sota the goto stop mobs from moving var
	if(wearer.transforming || !wearer.canmove)
		return

	if(!wearer.lastarea)
		wearer.lastarea = get_area(wearer.loc)

	if(!wearer.check_solid_ground())
		var/allowmove = wearer.Allow_Spacemove(0)
		if(!allowmove)
			return 0
		else if(allowmove == -1 && wearer.handle_spaceslipping()) //Check to see if we slipped
			return 0
		else
			wearer.inertia_dir = 0 //If not then we can reset inertia and move

	if(malfunctioning)
		direction = pick(cardinal)

	// Inside an object, tell it we moved.
	if(isobj(wearer.loc) || ismob(wearer.loc))
		var/atom/O = wearer.loc
		return O.relaymove(wearer, direction)

	if(isturf(wearer.loc))
		if(wearer.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(wearer, 1))
				if(M.pulling == wearer)
					if(!M.restrained() && M.stat == 0 && M.canmove && wearer.Adjacent(M))
						to_chat(user, "<span class='notice'>Your host is restrained! They can't move!</span>")
						return 0
					else
						M.stop_pulling()

	if(wearer.pinned.len)
		to_chat(src, "<span class='notice'>Your host is pinned to a wall by [wearer.pinned[1]]</span>!")
		return 0

	// AIs are a bit slower than regular and ignore move intent.
	wearer_move_delay = world.time + ai_controlled_move_delay

	var/tickcomp = 0
	if(config.Tickcomp)
		tickcomp = ((1/(world.tick_lag))*1.3) - 1.3
		wearer_move_delay += tickcomp

	if(istype(wearer.buckled_to, /obj/vehicle))
		//manually set move_delay for vehicles so we don't inherit any mob movement penalties
		//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
		wearer_move_delay = world.time + tickcomp
		return wearer.buckled_to.relaymove(wearer, direction)

	if(istype(wearer.machine, /obj/machinery))
		if(wearer.machine.relaymove(wearer, direction))
			return

	if(wearer.pulledby || wearer.buckled_to) // Wheelchair driving!
		if(istype(wearer.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(wearer.pulledby, /obj/structure/bed/stool/chair/office/wheelchair))
			return wearer.pulledby.relaymove(wearer, direction)
		else if(istype(wearer.buckled_to, /obj/structure/bed/stool/chair/office/wheelchair))
			if(ishuman(wearer.buckled_to))
				var/obj/item/organ/external/l_hand = wearer.get_organ(BP_L_HAND)
				var/obj/item/organ/external/r_hand = wearer.get_organ(BP_R_HAND)
				if((!l_hand || (l_hand.status & ORGAN_DESTROYED)) && (!r_hand || (r_hand.status & ORGAN_DESTROYED)))
					return // No hands to drive your chair? Tough luck!
			wearer_move_delay += 2
			return wearer.buckled_to.relaymove(wearer,direction)

	cell.use(10)
	wearer.Move(get_step(get_turf(wearer),direction),direction)

// This returns the rig if you are contained inside one, but not if you are wearing it
/atom/proc/get_rig()
	if(loc)
		return loc.get_rig()
	return null

/obj/item/rig/get_rig()
	return src

/mob/living/carbon/human/get_rig()
	return back

//Used in random rig spawning for cargo
//Randomly deletes modules
/obj/item/rig/proc/lose_modules(var/probability)
	for(var/obj/item/rig_module/module in installed_modules)
		if (probability)
			qdel(module)


//Fiddles with some wires to possibly make the suit malfunction a little
//Had to use numeric literals here, the wire defines in rig_wiring.dm weren't working
//Possibly due to being defined in a later file, or undef'd somewhere
/obj/item/rig/proc/misconfigure(var/probability)
	if (prob(probability))
		wires.UpdatePulsed(1)//Fiddle with access
	if (prob(probability))
		wires.UpdatePulsed(2)//frustrate the AI
	if (prob(probability))
		wires.UpdateCut(4)//break the suit
	if (prob(probability))
		wires.UpdatePulsed(8)
	if (prob(probability))
		wires.UpdateCut(16)
	if (prob(probability))
		subverted = 1

//Drains, rigs or removes the cell
/obj/item/rig/proc/sabotage_cell()
	if (!cell)
		return

	if (prob(50))
		cell.charge = rand(0, cell.charge*0.5)
	else if (prob(15))
		cell.rigged = 1
	else
		cell = null

//Depletes or removes the airtank
/obj/item/rig/proc/sabotage_tank()
	if (!air_supply)
		return

	if (prob(70))
		air_supply.remove_air(air_supply.air_contents.total_moles)
	else
		air_supply = null

#undef ONLY_DEPLOY
#undef ONLY_RETRACT
#undef SEAL_DELAY
