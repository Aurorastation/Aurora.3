/*
 * Contains
 * /obj/item/rig_module/ai_container
 * /obj/item/rig_module/datajack
 * /obj/item/rig_module/power_sink
 * /obj/item/rig_module/electrowarfare_suite
 */

/obj/item/ai_verbs
	name = "AI verb holder"

/obj/item/ai_verbs/verb/hardsuit_interface()
	set category = "Hardsuit"
	set name = "Open Hardsuit Interface"
	set src in usr

	if(!usr.loc || !usr.loc.loc || !istype(usr.loc.loc, /obj/item/rig_module))
		to_chat(usr, SPAN_WARNING("You are not loaded into a hardsuit."))
		return

	var/obj/item/rig_module/module = usr.loc.loc
	if(!module.holder)
		to_chat(usr, SPAN_WARNING("Your module is not installed in a hardsuit."))
		return

	module.holder.ui_interact(usr, nano_state = contained_state)

/mob
	var/get_rig_stats = 0

/obj/item/rig_module/ai_container
	name = "IIS module"
	desc = "An integrated intelligence system module suitable for most hardsuits."
	icon_state = "IIS"
	toggleable = TRUE
	usable = TRUE
	disruptive = FALSE
	activates_on_touch = TRUE
	confined_use = TRUE

	construction_cost = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 7500)
	construction_time = 300

	engage_string = "Eject AI"
	activate_string = "Enable Dataspike"
	deactivate_string = "Disable Dataspike"

	interface_name = "integrated intelligence system"
	interface_desc = "A socket that supports a range of artificial intelligence systems."

	var/mob/integrated_ai // Direct reference to the actual mob held in the suit.
	var/obj/item/ai_card  // Reference to the MMI, posibrain, intellicard or pAI card previously holding the AI.
	var/obj/item/ai_verbs/verb_holder

	category = MODULE_GENERAL

/obj/item/rig_module/ai_container/Destroy()
	qdel(ai_card)
	qdel(verb_holder)
	return ..()

/obj/item/rig_module/ai_container/process()
	if(integrated_ai)
		var/obj/item/rig/rig = get_rig()
		if(rig && rig.ai_override_enabled)
			integrated_ai.get_rig_stats = 1
		else
			integrated_ai.get_rig_stats = 0

/mob/living/Stat()
	. = ..()
	if(. && get_rig_stats)
		var/obj/item/rig/rig = get_rig()
		if(rig)
			SetupStat(rig)

/obj/item/rig_module/ai_container/proc/update_verb_holder()
	if(!verb_holder)
		verb_holder = new(src)
	if(integrated_ai)
		verb_holder.forceMove(integrated_ai)
	else
		verb_holder.forceMove(src)

/obj/item/rig_module/ai_container/accepts_item(var/obj/item/input_device, var/mob/living/user)
	// Check if there's actually an AI to deal with.
	var/mob/living/silicon/ai/target_ai
	if(istype(input_device, /mob/living/silicon/ai))
		target_ai = input_device
	else
		target_ai = locate(/mob/living/silicon/ai) in input_device.contents

	var/obj/item/aicard/card = ai_card

	// Downloading from/loading to a terminal.
	if(istype(input_device,/mob/living/silicon/ai) || istype(input_device,/obj/structure/AIcore/deactivated))

		// If we're stealing an AI, make sure we have a card for it.
		if(!card)
			card = new /obj/item/aicard(src)

		// Terminal interaction only works with an intellicarded AI.
		if(!istype(card))
			return FALSE

		// Since we've explicitly checked for three types, this should be safe.
		input_device.attackby(card,user)

		// If the transfer failed we can delete the card.
		if(locate(/mob/living/silicon/ai) in card)
			ai_card = card
			integrated_ai = locate(/mob/living/silicon/ai) in card
		else
			eject_ai()
		update_verb_holder()
		return TRUE

	if(istype(input_device,/obj/item/aicard))
		// We are carding the AI in our suit.
		if(integrated_ai)
			integrated_ai.attackby(input_device,user)
			// If the transfer was successful, we can clear out our vars.
			if(integrated_ai.loc != src)
				integrated_ai = null
				eject_ai()
		else
			// You're using an empty card on an empty suit, idiot.
			if(!target_ai)
				return FALSE
			integrate_ai(input_device,user)
		return TRUE

	// Okay, it wasn't a terminal being touched, check for all the simple insertions.
	if(input_device.type in list(/obj/item/device/paicard, /obj/item/device/mmi, /obj/item/device/mmi/digital/posibrain))
		if(integrated_ai)
			integrated_ai.attackby(input_device,user)
			// If the transfer was successful, we can clear out our vars.
			if(integrated_ai.loc != src)
				integrated_ai = null
				eject_ai()
		else
			integrate_ai(input_device,user)
		return TRUE

	return FALSE

/obj/item/rig_module/ai_container/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if(!target)
		if(ai_card)
			if(istype(ai_card, /obj/item/aicard))
				ai_card.ui_interact(H, state = deep_inventory_state)
			else
				eject_ai(H)
		update_verb_holder()
		return TRUE

	if(accepts_item(target,H))
		return TRUE

	return FALSE

/obj/item/rig_module/ai_container/removed()
	eject_ai()
	..()

/obj/item/rig_module/ai_container/proc/eject_ai(var/mob/user)
	if(ai_card)
		if(istype(ai_card, /obj/item/aicard))
			if(integrated_ai && !integrated_ai.stat)
				if(user)
					to_chat(user, SPAN_WARNING("You cannot eject your currently stored AI. Purge it manually."))
				return FALSE
			message_user(user, SPAN_NOTICE("You purge the remaining scraps of data from your previous AI, freeing it for use."), SPAN_NOTICE("\The [user] purges \the [integrated_ai]."))
			if(integrated_ai)
				integrated_ai.ghostize()
				QDEL_NULL(integrated_ai)
			if(ai_card)
				QDEL_NULL(ai_card)
		else if(user)
			user.put_in_hands(ai_card)
		else
			ai_card.forceMove(get_turf(src))
	ai_card = null
	integrated_ai = null
	update_verb_holder()

/obj/item/rig_module/ai_container/proc/integrate_ai(var/obj/item/ai,var/mob/user)
	if(!ai)
		return

	// The ONLY THING all the different AI systems have in common is that they all store the mob inside an item.
	var/mob/living/ai_mob = locate(/mob/living) in ai.contents
	if(ai_mob)
		ai_mob.resting = FALSE
		ai_mob.canmove = TRUE
		if(ai_mob.key && ai_mob.client)
			if(istype(ai, /obj/item/aicard))
				if(!ai_card)
					ai_card = new /obj/item/aicard(src)

				var/obj/item/aicard/source_card = ai
				var/obj/item/aicard/target_card = ai_card
				if(istype(source_card) && istype(target_card))
					if(target_card.grab_ai(ai_mob, user))
						source_card.clear()
					else
						return FALSE
				else
					return FALSE
			else
				user.drop_from_inventory(ai,src)
				ai_card = ai
				to_chat(ai_mob, "<span class='notice'>You have been transferred to \the [holder]'s [src].</span>")
				to_chat(user, "<span class='notice'>You load [ai_mob] into \the [holder]'s [src].</span>")

			integrated_ai = ai_mob

			if(!(locate(integrated_ai) in ai_card))
				integrated_ai = null
				eject_ai()
		else
			to_chat(user, SPAN_WARNING("There is no active AI within \the [ai]."))
	else
		to_chat(user, SPAN_WARNING("There is no active AI within \the [ai]."))
	update_verb_holder()
	return

/obj/item/rig_module/datajack
	name = "datajack module"
	desc = "A simple induction datalink module."
	icon_state = "datajack"
	toggleable = TRUE
	activates_on_touch = TRUE
	usable = FALSE

	activate_string = "Enable Datajack"
	deactivate_string = "Disable Datajack"

	interface_name = "contact datajack"
	interface_desc = "An induction-powered high-throughput datalink suitable for hacking encrypted networks."
	var/list/stored_research

	category = MODULE_SPECIAL

/obj/item/rig_module/datajack/New()
	..()
	stored_research = list()

/obj/item/rig_module/datajack/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	if(target)
		var/mob/living/carbon/human/H = holder.wearer
		if(!accepts_item(target,H))
			return FALSE
	return TRUE

/obj/item/rig_module/datajack/accepts_item(var/obj/item/input_device, var/mob/living/user)
	if(istype(input_device, /obj/item/disk/tech_disk))
		to_chat(user, SPAN_NOTICE("You slot the disk into [src]."))
		var/obj/item/disk/tech_disk/disk = input_device
		if(disk.stored)
			if(load_data(disk.stored))
				to_chat(user, SPAN_NOTICE("Download successful; disk erased."))
				disk.stored = null
			else
				to_chat(user, SPAN_WARNING("The disk is corrupt. It is useless to you."))
		else
			to_chat(user, SPAN_WARNING("The disk is blank. It is useless to you."))
		return TRUE

	// I fucking hate R&D code. This typecheck spam would be totally unnecessary in a sane setup.
	else if(istype(input_device,/obj/machinery))
		var/datum/research/incoming_files
		if(istype(input_device,/obj/machinery/computer/rdconsole))
			var/obj/machinery/computer/rdconsole/input_machine = input_device
			incoming_files = input_machine.files
		else if(istype(input_device,/obj/machinery/r_n_d/server))
			var/obj/machinery/r_n_d/server/input_machine = input_device
			incoming_files = input_machine.files
		else if(istype(input_device,/obj/machinery/mecha_part_fabricator))
			var/obj/machinery/mecha_part_fabricator/input_machine = input_device
			incoming_files = input_machine.files

		if(!incoming_files || !incoming_files.known_tech || !incoming_files.known_tech.len)
			to_chat(user, SPAN_WARNING("Memory failure. There is nothing accessible stored on this terminal."))
		else
			// Maybe consider a way to drop all your data into a target repo in the future.
			if(load_data(incoming_files.known_tech))
				to_chat(user, SPAN_NOTICE("Download successful; local and remote repositories synchronized."))
			else
				to_chat(user, SPAN_WARNING("Scan complete. There is nothing useful stored on this terminal."))
		return TRUE
	return FALSE

/obj/item/rig_module/datajack/proc/load_data(var/incoming_data)

	if(islist(incoming_data))
		for(var/entry in incoming_data)
			load_data(entry)
		return TRUE

	if(istype(incoming_data, /datum/tech))
		var/data_found
		var/datum/tech/new_data = incoming_data
		for(var/datum/tech/current_data in stored_research)
			if(current_data.id == new_data.id)
				data_found = 1
				if(current_data.level < new_data.level)
					current_data.level = new_data.level
				break
		if(!data_found)
			stored_research += incoming_data
		return TRUE
	return FALSE

/obj/item/rig_module/electrowarfare_suite

	name = "electrowarfare module"
	desc = "A bewilderingly complex bundle of fiber optics and chips."
	icon_state = "ewar"
	toggleable = TRUE
	usable = FALSE
	confined_use = TRUE

	activate_string = "Enable Countermeasures"
	deactivate_string = "Disable Countermeasures"

	interface_name = "electrowarfare system"
	interface_desc = "An active counter-electronic warfare suite that disrupts AI tracking."

	category = MODULE_SPECIAL

/obj/item/rig_module/electrowarfare_suite/activate()

	if(!..())
		return

	// This is not the best way to handle this, but I don't want it to mess with ling camo
	var/mob/living/M = holder.wearer
	M.digitalcamo++

/obj/item/rig_module/electrowarfare_suite/deactivate()

	if(!..())
		return

	var/mob/living/M = holder.wearer
	M.digitalcamo = max(0,(M.digitalcamo-1))

/obj/item/rig_module/power_sink

	name = "hardsuit power sink"
	desc = "An heavy-duty power sink."
	icon_state = "powersink"
	toggleable = TRUE
	activates_on_touch = TRUE
	disruptive = FALSE

	construction_cost = list(DEFAULT_WALL_MATERIAL=10000, MATERIAL_GOLD =2000, MATERIAL_SILVER =3000, MATERIAL_GLASS =2000)
	construction_time = 500

	activate_string = "Enable Power Sink"
	deactivate_string = "Disable Power Sink"

	interface_name = "niling d-sink"
	interface_desc = "Colloquially known as a power siphon, this module drains power through the suit hands into the suit battery."

	var/atom/interfaced_with // Currently draining power from this device.
	var/total_power_drained = 0
	var/drain_loc

	category = MODULE_SPECIAL

/obj/item/rig_module/power_sink/deactivate()

	if(interfaced_with)
		if(holder?.wearer)
			to_chat(holder.wearer, SPAN_WARNING("Your power sink retracts as the module deactivates."))
		drain_complete()
	interfaced_with = null
	total_power_drained = 0
	return ..()

/obj/item/rig_module/power_sink/activate()
	interfaced_with = null
	total_power_drained = 0
	return ..()

/obj/item/rig_module/power_sink/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	//Target wasn't supplied or we're already draining.
	if(interfaced_with)
		return FALSE

	if(!target)
		return TRUE

	// Are we close enough?
	var/mob/living/carbon/human/H = holder.wearer
	if(!target.Adjacent(H))
		return FALSE

	// Is it a valid power source?
	if(target.drain_power(1) <= 0)
		return FALSE

	message_user(user, SPAN_NOTICE("You begin draining power from \the [target]!"), SPAN_NOTICE("[user] begins draining power from \the [target]!"))
	interfaced_with = target
	drain_loc = interfaced_with.loc

	holder.spark_system.queue()
	playsound(H.loc, 'sound/effects/sparks2.ogg', 50, 1)

	return TRUE

/obj/item/rig_module/power_sink/accepts_item(var/obj/item/input_device, var/mob/living/user)
	var/can_drain = input_device.drain_power(1)
	if(can_drain > 0)
		do_engage(input_device, user)
		return TRUE
	return FALSE

/obj/item/rig_module/power_sink/process()
	if(!interfaced_with)
		return ..()

	var/mob/living/carbon/human/H
	if(holder && holder.wearer)
		H = holder.wearer

	if(!H || !istype(H))
		return FALSE

	holder.spark_system.queue()
	playsound(H.loc, 'sound/effects/sparks2.ogg', 50, 1)

	if(!holder.cell)
		to_chat(H, SPAN_WARNING("Your power sink flashes an error; there is no cell in your hardsuit."))
		drain_complete(H)
		return

	if(!interfaced_with || !interfaced_with.Adjacent(H) || !(interfaced_with.loc == drain_loc))
		to_chat(H, SPAN_WARNING("Your power sink retracts into its casing."))
		drain_complete(H)
		return

	if(holder.cell.fully_charged())
		to_chat(H, SPAN_WARNING("Your power sink flashes an amber light; your hardsuit cell is full."))
		drain_complete(H)
		return

	// Attempts to drain up to 80kW, determines this value from remaining cell capacity to ensure we don't drain too much..
	var/to_drain = min(80000, ((holder.cell.maxcharge - holder.cell.charge) / CELLRATE))
	var/target_drained = interfaced_with.drain_power(0,0,to_drain)
	if(target_drained <= 0)
		to_chat(H, SPAN_WARNING("Your power sink flashes a red light; there is no power left in \the [interfaced_with]."))
		drain_complete(H)
		return

	holder.cell.give(target_drained * CELLRATE * 2)
	total_power_drained += target_drained

	return TRUE

/obj/item/rig_module/power_sink/proc/drain_complete(var/mob/living/M)
	if(!interfaced_with)
		if(M) to_chat(M, SPAN_NOTICE("<b>Total power drained:</b> [round(total_power_drained/500)]kJ."))
	else
		if(M) to_chat(M, SPAN_NOTICE("<b>Total power drained from [interfaced_with]:</b> [round(total_power_drained/500)]kJ."))
		interfaced_with.drain_power(0, 1, 0) // Damage the victim.

	drain_loc = null
	interfaced_with = null
	total_power_drained = 0