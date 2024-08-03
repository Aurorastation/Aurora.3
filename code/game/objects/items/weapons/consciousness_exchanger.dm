/obj/item/clothing/head/consciousness_exchanger
	name = "consciousness exchange device"
	desc = "An experimental device that swaps one consciousness with another, with optional jolting capabilities. Cannot swap the same set of bodies twice."
	desc_antag = "The transfer process begins once both headsets are being worn. The jolts last ten seconds. If you are swapping with a detainee, set theirs to jolt before, and your own to jolt after, to give yourself time to switch the restraints around. Don't forget to swap PDAs!"
	icon = 'icons/obj/assemblies/wearable_electronic_setups.dmi'
	contained_sprite = TRUE
	icon_state = "head"
	item_state = "head"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 3, TECH_BLUESPACE = 4)
	matter = list(DEFAULT_WALL_MATERIAL = 400)
	var/datum/weakref/loaded_consciousness
	var/obj/item/clothing/head/consciousness_exchanger/linked_exchanger
	var/last_use = 0
	var/jolt_before_transfer = FALSE
	var/jolt_after_transfer = FALSE
	var/datum/progressbar/transfer_bar
	var/transfer_start_time
	var/transfer_start_message = "You feel the device start humming with vibration as it begins the transfer process."
	var/transfer_failed_message = "The device returns to stillness. The transfer process was interrupted."

// /obj/item/clothing/head/consciousness_exchanger/Initialize()
// 	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/small)
// 	return ..()

/obj/item/clothing/head/consciousness_exchanger/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/clothing/head/consciousness_exchanger/interact(mob/user)
	if(!user)
		return 0

	return ui_interact(user)


/obj/item/clothing/head/consciousness_exchanger/ui_interact(mob/user, ui_key = "main", datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ConsciousnessExchanger")
		ui.open()
		return

/obj/item/clothing/head/consciousness_exchanger/ui_data(mob/user)
	var/list/data = list()

	var/mob/living/linked_target
	if(linked_exchanger && linked_exchanger.loaded_consciousness)
		linked_target = linked_exchanger.loaded_consciousness.resolve()

	data["linked_target"] = linked_target ? linked_target.real_name : null
	data["jolt_before_transfer"] = jolt_before_transfer
	data["jolt_after_transfer"] = jolt_after_transfer

	return data

/obj/item/clothing/head/consciousness_exchanger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	. = TRUE

	switch(action)
		if("toggleJoltBefore")
			jolt_before_transfer = !jolt_before_transfer
		if("toggleJoltAfter")
			jolt_after_transfer = !jolt_after_transfer

/obj/item/clothing/head/consciousness_exchanger/equipped(var/mob/user, var/slot)
	..()
	if(slot == 12)
		loaded_consciousness = WEAKREF(user)
	else
		loaded_consciousness = null
	if(loaded_consciousness && linked_exchanger.loaded_consciousness)
		INVOKE_ASYNC(src, PROC_REF(pre_transfer), user)




// /obj/item/clothing/head/consciousness_exchanger/on_slotmove(var/mob/user, var/slot)
// 	..()
// 	if(slot == 12)
// 		loaded_consciousness = WEAKREF(user)
// 	else
// 		loaded_consciousness = null
// 	if(loaded_consciousness && linked_exchanger.loaded_consciousness)
// 		do_exchange(user)

/obj/item/clothing/head/consciousness_exchanger/dropped(var/mob/user)
	..()
	loaded_consciousness = null

/obj/item/clothing/head/consciousness_exchanger/proc/is_valid_loaded_consciousness(var/mob/target)
	if(!target)
		return FALSE
	// if(!target.mind)
	// 	return FALSE
	return TRUE

// /obj/item/clothing/head/consciousness_exchanger/proc/transfer_progress_check(var/end_time)
// 	//var/recheck = 0
// 	//world.time < end_time
// 	if (transfer_bar)
// 		transfer_bar.update(world.time - transfer_start_time)
// 	if (linked_exchanger.transfer_bar)
// 		linked_exchanger.transfer_bar.update(world.time - linked_exchanger.transfer_start_time)

/obj/item/clothing/head/consciousness_exchanger/proc/can_transfer(var/mob/user)
	if(!loaded_consciousness)
		to_chat(user, SPAN_WARNING("\The [src] isn't being worn!"))
		return FALSE
	if(!linked_exchanger)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a paired exchanger!"))
		return FALSE
	if(!linked_exchanger.loaded_consciousness)
		to_chat(user, SPAN_WARNING("The paired exchanger isn't being worn!"))
		return FALSE
	if(last_use + 180 > world.time)
		to_chat(user, SPAN_WARNING("The exchanger is recharging!"))
		return FALSE
	if(!is_valid_loaded_consciousness(linked_exchanger.loaded_consciousness))
		to_chat(user, SPAN_WARNING("The target is not suitable!"))
		return FALSE
	return TRUE
// /obj/item/clothing/head/consciousness_exchanger/verb/activate(var/mob/user)
// 	src.do_exchange(user)

/obj/item/clothing/head/consciousness_exchanger/proc/pre_transfer(var/mob/user)

	if(!can_transfer(user))
		return FALSE

	var/mob/consciousness = loaded_consciousness.resolve()
	var/mob/target = linked_exchanger.loaded_consciousness.resolve()

	if(jolt_before_transfer)
		jolt(consciousness)
	if(linked_exchanger.jolt_before_transfer)
		jolt(target)

	to_chat(user, SPAN_WARNING(transfer_start_message))
	to_chat(target, SPAN_WARNING(transfer_start_message))

	var/transfer_delay = 100
	addtimer(CALLBACK(src, PROC_REF(do_transfer), consciousness, target), transfer_delay)

	transfer_bar = new /datum/progressbar/autocomplete(user, transfer_delay, user)
	transfer_start_time = world.time
	transfer_bar.update(0)

	linked_exchanger.transfer_bar = new /datum/progressbar/autocomplete(target, transfer_delay, target)
	linked_exchanger.transfer_start_time = world.time
	linked_exchanger.transfer_bar.update(0)

	var/end_time = world.time + transfer_delay
	//addtimer(CALLBACK(src, PROC_REF(transfer_progress_check), end_time))
	while (world.time < end_time)
		stoplag(1)
		if (transfer_bar)
			transfer_bar.update(world.time - transfer_start_time)
		if (linked_exchanger.transfer_bar)
			linked_exchanger.transfer_bar.update(world.time - linked_exchanger.transfer_start_time)

		if(QDELETED(user) || QDELETED(target) || !can_transfer(user))
			. = FALSE
			to_chat(user, SPAN_WARNING(transfer_failed_message)) //bug: the message still sends even if transfer was successful
			to_chat(target, SPAN_WARNING(transfer_failed_message))

			qdel(transfer_bar)
			qdel(linked_exchanger.transfer_bar)
			break

		// if (user.loc != user_loc || target.loc != target_loc || (needhand && user.get_active_hand() != holding) || user.stat || user.weakened || user.stunned || (extra_checks && !extra_checks.Invoke()))
		// 	. = FALSE
		// 	break




/obj/item/clothing/head/consciousness_exchanger/proc/do_transfer(var/mob/consciousness, var/mob/target)
	//todo: add pair to list, to prevent further swapping with the same two bodies
	//bug: if the transfer process is interupted and restarted before the original timer is up, it will trigger
	if(!can_transfer())
		return FALSE

	var/mob/intermediary = new /mob/living(src)

	consciousness.mind.transfer_to(intermediary)
	target.mind.transfer_to(consciousness)
	intermediary.mind.transfer_to(target)

	last_use = world.time
	linked_exchanger.last_use = world.time

	if(target.client)
		target.client.init_verbs()
		target.update_action_buttons()

	if(consciousness.client)
		consciousness.client.init_verbs()
		consciousness.update_action_buttons()

	if(jolt_after_transfer)
		jolt(consciousness)
	if(linked_exchanger.jolt_after_transfer)
		jolt(target)

	//probably need special handling in here for antag stuff. should vampirism transfer with the mind? I think cultism should
	//what if one user is psionic/skrell but the other isn't?
	// languages? accents?

	qdel(intermediary)

/obj/item/clothing/head/consciousness_exchanger/proc/jolt(var/mob/living/target, var/stun_time = 10)
	if(iscarbon(target))
		target.Weaken(stun_time)
		target.Stun(stun_time)
	else if(issilicon(target))
		target.Weaken(stun_time)
	target.flash_act()
	to_chat(target, SPAN_WARNING("You feel a painful jolt at the base of your skull, temporarily paralyzing you!"))




