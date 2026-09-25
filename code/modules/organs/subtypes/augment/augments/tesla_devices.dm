/*
 * Civilian Elektroika devices powered by a Tesla spine.
 */

/proc/get_tesla_spine(var/mob/living/carbon/human/H)
	if(!istype(H))
		return null
	return H.internal_organs_by_name[BP_AUG_TESLA]

/obj/item/organ/internal/augment/tesla_device
	name = "tesla-powered augment"
	desc = "A civilian Elektroika augment which draws power from a Tesla spine."
	icon_state = "augment"
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/obj/item/organ/internal/augment/tesla_device/Initialize()
	. = ..()
	register_tesla_power_signal()

/obj/item/organ/internal/augment/tesla_device/replaced()
	. = ..()
	register_tesla_power_signal()

/obj/item/organ/internal/augment/tesla_device/removed()
	if(owner)
		UnregisterSignal(owner, COMSIG_TESLA_POWER_CHANGED)
	return ..()

/obj/item/organ/internal/augment/tesla_device/proc/register_tesla_power_signal()
	if(owner)
		RegisterSignal(owner, COMSIG_TESLA_POWER_CHANGED, PROC_REF(handle_tesla_power_signal))

/obj/item/organ/internal/augment/tesla_device/proc/handle_tesla_power_signal(mob/living/carbon/human/source, powered)
	SIGNAL_HANDLER
	tesla_power_changed(powered)

/obj/item/organ/internal/augment/tesla_device/proc/get_spine()
	return get_tesla_spine(owner)

/obj/item/organ/internal/augment/tesla_device/proc/has_tesla_power(var/show_warning = FALSE, var/check_damage = FALSE)
	var/obj/item/organ/internal/augment/tesla/spine = get_spine()
	if(!spine || spine.is_broken() || spine.surge_damage)
		if(show_warning && owner)
			to_chat(owner, SPAN_WARNING("Your [src] cannot draw power from a functioning Tesla spine!"))
		return FALSE
	if(check_damage && spine.is_bruised() && prob(50))
		if(show_warning)
			to_chat(owner, SPAN_WARNING("Your damaged Tesla spine fails to power your [src]!"))
		spark(get_turf(owner), 3)
		return FALSE
	return TRUE

/obj/item/organ/internal/augment/tesla_device/attack_self(var/mob/user)
	if(!has_tesla_power(TRUE, TRUE))
		return FALSE
	return ..()

/obj/item/organ/internal/augment/tesla_device/proc/tesla_power_changed(var/powered)
	return

// Integrated traction pads

/obj/item/organ/internal/augment/tesla_device/traction
	name = "transdermal magnetic pads"
	desc = "A Tesla augment developed for Kosmostrelki and other void-based workers who require safety while performing \
	extravehicular activities. A set of pads are grafted onto the foot or attached to the base of a prosthetic. \
	These pads, when energized, are capable of increasing traction or magnetizing. The pads are controlled from a \
	Tesla spine which provides the control logic necessary for walking and other maneuvers."
	icon_state = "suspension"
	action_button_name = "Cycle Magnetic Pads"
	action_button_icon = "magclaws"
	organ_tag = BP_AUG_TESLA_TRACTION
	parent_organ = BP_R_FOOT
	activable = TRUE
	cooldown = 10
	var/mode = 0 // 0 off, 1 assisted traction, 2 magnetic anchoring

/obj/item/organ/internal/augment/tesla_device/traction/Initialize()
	. = ..()
	register_owner_signals()

/obj/item/organ/internal/augment/tesla_device/traction/replaced()
	. = ..()
	register_owner_signals()

/obj/item/organ/internal/augment/tesla_device/traction/proc/register_owner_signals()
	if(!owner)
		return
	RegisterSignal(owner, COMSIG_GET_MOVEMENT_TALLY, PROC_REF(modify_movement_tally))
	RegisterSignal(owner, COMSIG_GET_SLIP_MODIFIERS, PROC_REF(prevent_slipping))
	RegisterSignal(owner, COMSIG_CHECK_SHOE_GRIP, PROC_REF(provide_shoe_grip))

/obj/item/organ/internal/augment/tesla_device/traction/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	set_mode((mode + 1) % 3)

/obj/item/organ/internal/augment/tesla_device/traction/proc/set_mode(var/new_mode)
	if(!owner)
		mode = 0
		return
	mode = has_tesla_power() ? new_mode : 0
	switch(mode)
		if(1)
			to_chat(owner, SPAN_NOTICE("You set your transdermal magnetic pads to assisted traction."))
			playsound(get_turf(owner), 'sound/effects/magnetclamp.ogg', 15)
		if(2)
			to_chat(owner, SPAN_NOTICE("You fully magnetize your transdermal magnetic pads."))
			playsound(get_turf(owner), 'sound/effects/magnetclamp.ogg', 20)
		else
			to_chat(owner, SPAN_NOTICE("You switch off your transdermal magnetic pads."))

/obj/item/organ/internal/augment/tesla_device/traction/proc/modify_movement_tally(mob/living/carbon/human/human, movement_tally_modifier)
	SIGNAL_HANDLER
	switch(mode)
		if(1)
			*movement_tally_modifier += 0.5
		if(2)
			*movement_tally_modifier += 1

/obj/item/organ/internal/augment/tesla_device/traction/proc/prevent_slipping(mob/living/carbon/human/human)
	SIGNAL_HANDLER
	if(mode)
		return COMPONENT_PREVENT_SLIP

/obj/item/organ/internal/augment/tesla_device/traction/proc/provide_shoe_grip(mob/living/carbon/human/human)
	SIGNAL_HANDLER
	if(mode == 2)
		return COMPONENT_HAS_SHOE_GRIP

/obj/item/organ/internal/augment/tesla_device/traction/tesla_power_changed(var/powered)
	if(!powered && mode)
		set_mode(0)

/obj/item/organ/internal/augment/tesla_device/traction/removed()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_GET_MOVEMENT_TALLY, COMSIG_GET_SLIP_MODIFIERS, COMSIG_CHECK_SHOE_GRIP))
	mode = 0
	return ..()

/obj/item/organ/internal/augment/tesla_device/traction/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "Its magnetic traction system is [mode == 2 ? "fully magnetized" : (mode == 1 ? "providing assisted traction" : "inactive")]."

// Spine-powered internal computer

/obj/item/organ/internal/augment/tesla_device/pda
	name = "transdermal computer"
	desc = "A prototype Tesla augment developed for use in mobile jobs where reliable access to a computational device is needed. \
	A computer screen is grafted onto the arm, either on top of or within the skin, or onto a designated location on a prosthetic. \
	Most of the processing occurs in the Tesla spine. The screen is a configurable touchscreen. \
	The transdermal computer has mediocre thermal dissipation, causing the arm to remain warmer than the rest of the body."
	icon_state = "augment-pda"
	action_button_name = "Access Transdermal Computer"
	action_button_icon = "augment-pda"
	organ_tag = BP_AUG_TESLA_PDA
	parent_organ = BP_R_ARM
	activable = TRUE
	cooldown = 10
	var/obj/item/modular_computer/handheld/pda/tesla_internal/internal_pda

/obj/item/organ/internal/augment/tesla_device/pda/left
	parent_organ = BP_L_ARM

/obj/item/organ/internal/augment/tesla_device/pda/Initialize()
	. = ..()
	internal_pda = new(src)

/obj/item/organ/internal/augment/tesla_device/pda/process_initialize()
	START_PROCESSING(SSprocessing, src)

/obj/item/organ/internal/augment/tesla_device/pda/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(internal_pda)
	return ..()

/obj/item/organ/internal/augment/tesla_device/pda/attack_self(var/mob/user)
	. = ..()
	if(!. || !internal_pda)
		return FALSE
	internal_pda.attack_self(user)

/obj/item/organ/internal/augment/tesla_device/pda/process()
	if(!owner || !internal_pda || !has_tesla_power())
		return
	var/obj/item/cell/device/pda_cell = internal_pda.get_cell()
	if(istype(pda_cell) && pda_cell.charge < pda_cell.maxcharge)
		pda_cell.give(max(1, pda_cell.maxcharge * 0.02))

/obj/item/modular_computer/handheld/pda/tesla_internal
	name = "transdermal computer"
	desc = "A configurable implanted computer whose buffer cell is kept charged by its user's Tesla spine."
	enrolled = DEVICE_UNSET
	_app_preset_type = null

/obj/item/modular_computer/handheld/pda/tesla_internal/GetID()
	var/obj/item/organ/internal/augment/tesla_device/pda/access_point = loc
	return access_point?.owner?.GetIdCard()

/obj/item/modular_computer/handheld/pda/tesla_internal/ui_status(mob/user, datum/ui_state/state)
	var/obj/item/organ/internal/augment/tesla_device/pda/access_point = loc
	if(istype(access_point) && access_point.owner == user && !access_point.is_broken() && access_point.has_tesla_power())
		return UI_INTERACTIVE
	to_chat(user, SPAN_WARNING("Your transdermal computer is not receiving power from your Tesla spine."))
	return UI_CLOSE

// Tesla voice box

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla
	name = "tesla voice box"
	desc = "A Tesla augment initially developed for use in new Hadiist robotics. \
	The design uses arc discharges within a contained, sterile device implanted into the throat. \
	By modulating the incoming Tesla power, the device produces speech. \
	The voice produced by the box can be unsettling and is capable of great volume. \
	Following the loss of a notable party member's voice, the augment was adapted for medical applications."
	accent = ACCENT_ELEKTRO_SIIK
	action_button_name = "Use Voice Amplifier"
	action_button_icon = "augment"
	activable = TRUE
	cooldown = 20 SECONDS
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/Initialize()
	. = ..()
	register_tesla_power_signal()

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/replaced()
	. = ..()
	register_tesla_power_signal()

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/removed()
	if(owner)
		UnregisterSignal(owner, COMSIG_TESLA_POWER_CHANGED)
	return ..()

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/proc/register_tesla_power_signal()
	if(owner)
		RegisterSignal(owner, COMSIG_TESLA_POWER_CHANGED, PROC_REF(handle_tesla_power_signal))

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/proc/handle_tesla_power_signal(mob/living/carbon/human/source, powered)
	SIGNAL_HANDLER
	tesla_power_changed(powered)

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/attack_self(var/mob/user)
	if(user.client && (user.client.prefs.muted & MUTE_IC))
		to_chat(user, SPAN_WARNING("You cannot speak in IC while muted."))
		return FALSE
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(owner)
	if(!spine || spine.is_broken())
		to_chat(owner, SPAN_WARNING("Your voice box cannot draw power from a functioning Tesla spine!"))
		return FALSE
	if(spine.is_bruised() && prob(50))
		to_chat(owner, SPAN_WARNING("Your damaged Tesla spine produces only a burst of static!"))
		playsound(get_turf(owner), 'sound/effects/sparks1.ogg', 40, TRUE)
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	var/message = sanitize(input(user, "Broadcast a message?", "Tesla Voice Amplifier", null) as text)
	if(!message || owner.stat != CONSCIOUS)
		return FALSE
	message = capitalize(message)
	owner.say(message, owner.get_default_language(), "broadcasts")
	playsound(owner, 'sound/items/megaphone.ogg', 75, FALSE, 1)
	for(var/mob/living/carbon/human/H in range(owner, 2) - owner)
		H.earpain((H in range(owner, 1)) ? 3 : 2, TRUE, 2)
	return TRUE

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/proc/tesla_power_changed(var/powered)
	return

// Tesla tool augment base

/obj/item/organ/internal/augment/tool/tesla
	name = "tesla retractable tool"
	desc = "A retractable tool powered by a Tesla spine."
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/obj/item/organ/internal/augment/tool/tesla/Initialize()
	. = ..()
	register_tesla_power_signal()

/obj/item/organ/internal/augment/tool/tesla/replaced()
	. = ..()
	register_tesla_power_signal()

/obj/item/organ/internal/augment/tool/tesla/removed()
	if(owner)
		UnregisterSignal(owner, COMSIG_TESLA_POWER_CHANGED)
	return ..()

/obj/item/organ/internal/augment/tool/tesla/proc/register_tesla_power_signal()
	if(owner)
		RegisterSignal(owner, COMSIG_TESLA_POWER_CHANGED, PROC_REF(handle_tesla_power_signal))

/obj/item/organ/internal/augment/tool/tesla/proc/handle_tesla_power_signal(mob/living/carbon/human/source, powered)
	SIGNAL_HANDLER
	tesla_power_changed(powered)

/obj/item/organ/internal/augment/tool/tesla/attack_self(var/mob/user)
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(owner)
	if(!spine || spine.is_broken())
		to_chat(owner, SPAN_WARNING("Your [src] cannot draw power from a functioning Tesla spine!"))
		return FALSE
	if(spine.is_bruised() && prob(50))
		to_chat(owner, SPAN_WARNING("Your damaged Tesla spine fails to power your [src]!"))
		spark(get_turf(owner), 3)
		return FALSE
	return ..()

/obj/item/organ/internal/augment/tool/tesla/proc/tesla_power_changed(var/powered)
	if(powered || !owner || !augment_type)
		return
	var/obj/item/deployed = locate(augment_type) in owner
	if(deployed)
		owner.drop_from_inventory(deployed)
		qdel(deployed)

// Passively recharging arc welder

/obj/item/organ/internal/augment/tool/tesla/arc_welder
	name = "tesla arc welder"
	desc = "Developed and provided primarily to engineers and technicians, \
	the Tesla Arc Welder leverages the capabilities of the Tesla Spine to generate the power needed for stick welding. \
	The welding tip is typically installed into the prosthetic finger, \
	or implanted into an organic finger alongside subdermal sheets for heat and spatter protection. \
	This tip requires frequent replacement as the material is used during welding."
	icon_state = "lighter-aug"
	action_button_name = "Deploy Arc Welder"
	action_button_icon = "lighter-aug"
	organ_tag = BP_AUG_TESLA_WELDER
	parent_organ = BP_R_HAND
	augment_type = /obj/item/weldingtool/experimental/tesla_augment
	var/charge = 40
	var/max_charge = 40
	var/last_charge_generation = 0
	var/charge_generation_delay = 15 SECONDS // Ten minutes from empty to full.

/obj/item/organ/internal/augment/tool/tesla/arc_welder/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/tesla/arc_welder/process_initialize()
	last_charge_generation = world.time
	START_PROCESSING(SSprocessing, src)

/obj/item/organ/internal/augment/tool/tesla/arc_welder/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/organ/internal/augment/tool/tesla/arc_welder/process(seconds_per_tick)
	. = ..()
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(owner)
	if(!spine || spine.is_broken() || spine.surge_damage || surge_damage || charge >= max_charge)
		last_charge_generation = world.time
		return
	var/generated_charge = (world.time - last_charge_generation) / charge_generation_delay
	charge = min(max_charge, charge + generated_charge)
	last_charge_generation = world.time

/obj/item/organ/internal/augment/tool/tesla/arc_welder/attack_self(var/mob/user)
	. = ..()
	var/obj/item/weldingtool/experimental/tesla_augment/deployed = locate(augment_type) in owner
	if(deployed)
		deployed.source_augment = src

/obj/item/organ/internal/augment/tool/tesla/arc_welder/emp_act(severity)
	. = ..()
	charge = 0
	last_charge_generation = world.time
	var/obj/item/weldingtool/experimental/tesla_augment/deployed
	if(owner)
		deployed = locate(augment_type) in owner
	if(deployed)
		deployed.setWelding(FALSE, owner)

/obj/item/weldingtool/experimental/tesla_augment
	name = "tesla arc welder"
	desc = "Developed and provided primarily to engineers and technicians, \
	the Tesla Arc Welder leverages the capabilities of the Tesla Spine to generate the power needed for stick welding. \
	The welding tip is typically installed into the prosthetic finger, \
	or implanted into an organic finger alongside subdermal sheets for heat and spatter protection. \
	This tip requires frequent replacement as the material is used during welding."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "lighter-aug"
	item_state = "lighter-aug"
	change_icons = FALSE
	var/obj/item/organ/internal/augment/tool/tesla/arc_welder/source_augment

/obj/item/weldingtool/experimental/tesla_augment/Initialize()
	. = ..()
	reagents.clear_reagents()

/obj/item/weldingtool/experimental/tesla_augment/Destroy()
	source_augment = null
	return ..()

/obj/item/weldingtool/experimental/tesla_augment/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(distance <= 1)
		. += "Its capacitor holds [round(get_fuel(), 0.1)]/[max_fuel] units of charge."

/obj/item/weldingtool/experimental/tesla_augment/proc/has_spine_power(var/mob/living/user)
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(user)
	return source_augment && !QDELETED(source_augment) && !source_augment.surge_damage && spine && !spine.is_broken() && !spine.surge_damage

/obj/item/weldingtool/experimental/tesla_augment/tool_use_check(mob/living/user, amount)
	return welding && get_fuel() >= amount && has_spine_power(user)

/obj/item/weldingtool/experimental/tesla_augment/get_fuel()
	if(!source_augment || QDELETED(source_augment))
		return 0
	return source_augment.charge

/obj/item/weldingtool/experimental/tesla_augment/use(var/amount = 1, var/mob/M = null, var/colourChange = TRUE)
	if(!welding)
		return FALSE
	var/mob/living/power_user = M
	if(!power_user && isliving(loc))
		power_user = loc
	if(welding > 0 && colourChange)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon), 5))
	if(get_fuel() < amount)
		if(M)
			to_chat(M, SPAN_NOTICE("You need more capacitor charge to complete this task."))
		return FALSE
	if(!has_spine_power(power_user))
		return FALSE
	source_augment.charge = max(0, source_augment.charge - amount)
	if(M && produces_flash)
		flash_welding_arc(M)
	return TRUE

/obj/item/weldingtool/experimental/tesla_augment/use_resource(mob/user, var/use_amount)
	if(source_augment && has_spine_power(user) && get_fuel() >= use_amount)
		source_augment.charge = max(0, source_augment.charge - use_amount)

/obj/item/weldingtool/experimental/tesla_augment/setWelding(var/set_welding, var/mob/M)
	if(!status)
		return FALSE
	var/turf/T = get_turf(src)
	if(set_welding && !welding)
		if(!has_spine_power(M))
			to_chat(M, SPAN_WARNING("The arc welder cannot draw power from a functioning Tesla spine."))
			return FALSE
		if(get_fuel() <= 0)
			to_chat(M, SPAN_NOTICE("The arc welder's capacitor needs time to recharge."))
			return FALSE
		if(M)
			to_chat(M, SPAN_NOTICE("You switch the [src] on."))
		else if(T)
			T.visible_message(SPAN_DANGER("\The [src] turns on."))
		playsound(loc, 'sound/items/welder_activate.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
		force = 22
		damtype = DAMAGE_BURN
		w_class = WEIGHT_CLASS_BULKY
		welding = TRUE
		hitsound = pick(SOUNDS_LASER_MEAT)
		attack_verb = list("scorched", "burned", "blasted", "blazed")
		update_icon()
		set_processing(TRUE)
	else if(!set_welding && welding)
		if(M)
			to_chat(M, SPAN_NOTICE("You switch \the [src] off."))
		else if(T)
			T.visible_message(SPAN_WARNING("\The [src] turns off."))
		playsound(loc, 'sound/items/welder_deactivate.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
		force = 3
		damtype = DAMAGE_BRUTE
		w_class = initial(w_class)
		welding = FALSE
		hitsound = SFX_SWING_HIT
		attack_verb = list("hit", "bludgeoned", "whacked")
		set_processing(FALSE)
		update_icon()
	return TRUE

/obj/item/weldingtool/experimental/tesla_augment/fuel_gen()
	if(get_fuel() >= max_fuel)
		set_processing(FALSE)

/obj/item/weldingtool/experimental/tesla_augment/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/eyeshield) || istype(attacking_item, /obj/item/overcapacitor) || attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, SPAN_WARNING("The integrated arc welder's sealed controller cannot accept modifications."))
		return TRUE
	return ..()

/obj/item/weldingtool/experimental/tesla_augment/afterattack(obj/O, mob/user, proximity)
	if(istype(O, /obj/structure/reagent_dispensers/fueltank))
		to_chat(user, SPAN_NOTICE("The arc welder has no fuel tank; its capacitor recharges passively from the Tesla spine."))
		return
	return ..()

/obj/item/weldingtool/experimental/tesla_augment/dropped()
	. = ..()
	loc = null
	qdel(src)

// Low-energy electrical lighter

/obj/item/organ/internal/augment/tool/tesla/lighter
	name = "tesla arc lighter"
	desc = "Originally a Party-exclusive augment, the Tesla arc lighter is a relatively simple augment implanted into the finger. \
	When activated, it produces an arc across the tip of the finger."
	icon_state = "lighter-aug"
	action_button_name = "Deploy Arc Lighter"
	action_button_icon = "lighter-aug"
	organ_tag = BP_AUG_LIGHTER
	parent_organ = BP_R_HAND
	augment_type = /obj/item/tesla_arc_lighter

/obj/item/organ/internal/augment/tool/tesla/lighter/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/tesla_arc_lighter
	name = "tesla arc lighter"
	desc = "Originally a Party-exclusive augment, the Tesla arc lighter is a relatively simple augment implanted into the finger. \
	When activated, it produces an arc across the tip of the finger."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "lighter-aug"
	item_state = "lighter-aug"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	damtype = DAMAGE_PAIN

/obj/item/tesla_arc_lighter/isFlameSource()
	return TRUE

/obj/item/tesla_arc_lighter/attack(mob/living/target_mob, mob/living/user, target_zone)
	user.visible_message(SPAN_NOTICE("[user] gives [target_mob] a harmless snap from [src]."), SPAN_NOTICE("You give [target_mob] a harmless but sharp electrical snap."))
	to_chat(target_mob, SPAN_WARNING("A sharp electrical sting runs through your [parse_zone(target_zone)]!"))
	playsound(get_turf(user), 'sound/weapons/Egloves.ogg', 20, TRUE)
	return TRUE

/obj/item/tesla_arc_lighter/dropped()
	. = ..()
	loc = null
	qdel(src)

// Mutually-exclusive oxygenation systems

/obj/item/organ/internal/augment/tesla_device/oxygenation
	name = "tesla subdermal rebreather"
	desc = "Embodying the cutting edge of Tesla research, the subdermal rebreather is an augment implanted within the upper chest. \
	During an exhale, it filters the breath and redirects oxygen back into the lungs. \
	It features an internal mechanism to speed this process up utilizing Tesla power. \
	Additionally, it stores a small amount of concentrated oxygen for emergency release during extended periods of physical exertion or life-critical moments. \
	Those implanted with the rebreather report feeling and hearing a humming while breathing."
	icon_state = "boosted_heart"
	organ_tag = BP_AUG_TESLA_OXYGEN
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/tesla_device/oxygenation/proc/is_emp_disabled()
	return surge_damage > 0

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler
	name = "tesla subdermal rebreather"
	desc = "Embodying the cutting edge of Tesla research, the subdermal rebreather is an augment implanted within the upper chest. \
	During an exhale, it filters the breath and redirects oxygen back into the lungs. \
	It features an internal mechanism to speed this process up utilizing Tesla power. \
	Additionally, it stores a small amount of concentrated oxygen for emergency release during extended periods of physical exertion or life-critical moments. \
	Those implanted with the rebreather report feeling and hearing a humming while breathing."
	var/reserve_seconds = 30
	var/max_reserve_seconds = 30
	var/reserve_active = FALSE
	var/reserve_refill_rate = 0.25

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/Initialize()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_BLOOD_OXYGENATION_EVENT, PROC_REF(assist_oxygenation), override = TRUE)

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/replaced()
	. = ..()
	RegisterSignal(owner, COMSIG_BLOOD_OXYGENATION_EVENT, PROC_REF(assist_oxygenation), override = TRUE)

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/removed()
	if(owner)
		UnregisterSignal(owner, COMSIG_BLOOD_OXYGENATION_EVENT)
	return ..()

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/process_initialize()
	START_PROCESSING(SSprocessing, src)

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/process(seconds_per_tick)
	. = ..()
	if(!owner || is_emp_disabled() || !has_tesla_power())
		reserve_active = FALSE
		return
	var/seconds_elapsed = seconds_per_tick / 10
	var/needs_reserve = owner.failed_last_breath || owner.getOxyLoss() >= 20
	if(needs_reserve && reserve_seconds > 0)
		if(!reserve_active)
			reserve_active = TRUE
			to_chat(owner, SPAN_NOTICE("Your subdermal rebreather releases its emergency oxygen reserve."))
		reserve_seconds = max(0, reserve_seconds - seconds_elapsed)
		if(!reserve_seconds)
			reserve_active = FALSE
			to_chat(owner, SPAN_WARNING("Your subdermal rebreather's emergency oxygen reserve is exhausted."))
	else
		reserve_active = FALSE
		if(!owner.failed_last_breath && owner.losebreath <= 0 && owner.getOxyLoss() < 20)
			reserve_seconds = min(max_reserve_seconds, reserve_seconds + (reserve_refill_rate * seconds_elapsed))

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/proc/assist_oxygenation(implantee, blood_volume, blood_volume_mod, oxygenated_add)
	SIGNAL_HANDLER
	if(is_emp_disabled() || !has_tesla_power() || *blood_volume < BLOOD_VOLUME_BAD)
		return
	*oxygenated_add += reserve_active ? 0.5 : 0.25

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/emp_act(severity)
	. = ..()
	reserve_active = FALSE

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/tesla_power_changed(var/powered)
	if(!powered)
		reserve_active = FALSE

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "Its emergency oxygen reserve is at [round((reserve_seconds / max_reserve_seconds) * 100)]%."

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver
	name = "tesla circulatory enhancement pump"
	desc = "Created in lieu with the subdermal rebreather, the circulatory enhancement pump is an augment implanted within the chest. \
	During long periods of physical exertion, it boosts blood circulation. \
	Those new to having the augment often report feelings of nausea after the pump shuts off, \
	however this typically stops occurring after a few months."
	action_button_name = "Activate Circulatory Pump"
	action_button_icon = "augment"
	activable = TRUE
	cooldown = 10
	var/active = FALSE
	var/next_activation = 0

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/attack_self(var/mob/user)
	if(is_emp_disabled())
		to_chat(owner, SPAN_WARNING("Your circulatory pump is unresponsive due to electromagnetic interference."))
		return FALSE
	if(world.time < next_activation)
		to_chat(owner, SPAN_WARNING("Your circulatory pump's safety cycle has [round((next_activation - world.time) / 10)] seconds remaining."))
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	active = TRUE
	next_activation = world.time + 5 MINUTES
	RegisterSignal(owner, COMSIG_STAMINA_DRAIN_MODIFIERS, PROC_REF(modify_stamina_drain))
	to_chat(owner, SPAN_NOTICE("Your circulatory pump begins boosting your blood flow."))
	addtimer(CALLBACK(src, PROC_REF(deactivate)), 30 SECONDS)

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/proc/deactivate()
	if(owner)
		UnregisterSignal(owner, COMSIG_STAMINA_DRAIN_MODIFIERS)
		if(active)
			to_chat(owner, SPAN_NOTICE("Your circulatory pump winds down, leaving you briefly nauseated and light-headed."))
	active = FALSE

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/proc/modify_stamina_drain(mob/living/carbon/human/human, stamina_cost)
	SIGNAL_HANDLER
	*stamina_cost *= 0.85

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/tesla_power_changed(var/powered)
	if(!powered)
		deactivate()

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/emp_act(severity)
	. = ..()
	deactivate()

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/removed()
	deactivate()
	return ..()

// Ocular worklight

/obj/item/organ/internal/augment/tesla_device/worklight
	name = "ocular arc-light worklight"
	desc = "Developed to assist electrical workers, paramedics, \
	and other trades where visibility in low-light environments is required \
	alongside the complete color vision lost when using natural Tajaran dark vision. \
	By utilizing a controlled electric arc within devices implanted next to the eye, \
	light can be cast in whichever direction the user is looking. \
	The implant is known to cause the sensation of heat behind the eyes, \
	and may be painful for other individuals to look at directly."
	icon_state = "sightlights"
	light_system = DIRECTIONAL_LIGHT
	action_button_name = "Toggle Ocular Arc-Light"
	action_button_icon = "sightlights"
	organ_tag = BP_AUG_TESLA_LIGHT
	parent_organ = BP_HEAD
	activable = TRUE
	cooldown = 10
	var/lights_on = FALSE
	var/lights_color = LIGHT_COLOR_TUNGSTEN
	var/lights_range = 3
	var/lights_intensity = 0.6

/obj/item/organ/internal/augment/tesla_device/worklight/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	set_worklight(!lights_on)

/obj/item/organ/internal/augment/tesla_device/worklight/proc/set_worklight(var/new_state)
	lights_on = new_state && has_tesla_power()
	if(lights_on)
		set_light_range_power_color(lights_range, lights_intensity, lights_color)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)
	if(owner)
		to_chat(owner, SPAN_NOTICE("You switch your ocular arc-light [lights_on ? "on" : "off"]."))
	return lights_on

/obj/item/organ/internal/augment/tesla_device/worklight/tesla_power_changed(var/powered)
	if(!powered && lights_on)
		set_worklight(FALSE)

/obj/item/organ/internal/augment/tesla_device/worklight/removed()
	lights_on = FALSE
	set_light_on(FALSE)
	return ..()

/obj/item/organ/internal/augment/tesla_device/worklight/emp_act(severity)
	. = ..()
	if(lights_on)
		set_worklight(FALSE)

/obj/item/organ/internal/augment/tesla_device/worklight/take_damage(var/amount, var/silent = 0)
	. = ..()
	if(lights_on)
		set_worklight(FALSE)

/obj/item/organ/internal/augment/tesla_device/worklight/take_internal_damage(var/amount, var/silent = 0)
	. = ..()
	if(lights_on)
		set_worklight(FALSE)

// Automatic cardiac restart system with a passive recharge cycle

/obj/item/organ/internal/augment/tesla_device/cardiac
	name = "tesla emergency resuscitation apparatus"
	desc = "An integral automatic defibrillator attached to the heart. \
	Sensors within the Tesla spine and augment monitor vital signs for life-threatening events. \
	When the heart is about to stop, or has stopped, the augment applies a shock. \
	Due to the constant power provided by the spine regardless of individual health, \
	the augment can continue working briefly after clinical death. Once discharged, it takes ten minutes to rearm."
	icon_state = "boosted_heart"
	organ_tag = BP_AUG_TESLA_CARDIAC
	parent_organ = BP_CHEST
	var/primed = TRUE
	var/restart_pending = FALSE
	var/restart_delay = 5 SECONDS
	var/restart_generation = 0
	var/rearm_at = 0

/obj/item/organ/internal/augment/tesla_device/cardiac/Initialize()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_HEART_PUMP_EVENT, PROC_REF(handle_cardiac_event), override = TRUE)

/obj/item/organ/internal/augment/tesla_device/cardiac/process_initialize()
	START_PROCESSING(SSprocessing, src)

/obj/item/organ/internal/augment/tesla_device/cardiac/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/organ/internal/augment/tesla_device/cardiac/replaced()
	. = ..()
	RegisterSignal(owner, COMSIG_HEART_PUMP_EVENT, PROC_REF(handle_cardiac_event), override = TRUE)

/obj/item/organ/internal/augment/tesla_device/cardiac/removed()
	if(owner)
		UnregisterSignal(owner, COMSIG_HEART_PUMP_EVENT)
	restart_pending = FALSE
	restart_generation++
	return ..()

/obj/item/organ/internal/augment/tesla_device/cardiac/process(seconds_per_tick)
	. = ..()
	if(!owner || !has_tesla_power())
		return
	if(!primed && rearm_at && world.time >= rearm_at)
		primed = TRUE
		rearm_at = 0
		to_chat(owner, SPAN_NOTICE("Your emergency resuscitation apparatus finishes rearming."))
	if(!primed || restart_pending)
		return
	var/obj/item/organ/internal/heart/heart = owner.internal_organs_by_name[BP_HEART]
	if(owner.stat != DEAD && istype(heart) && heart.pulse == PULSE_NONE)
		begin_restart(heart)

/obj/item/organ/internal/augment/tesla_device/cardiac/proc/handle_cardiac_event(implantee, obj/item/organ/internal/heart/heart, blood_volume, recent_pump, pulse_mod, min_efficiency)
	SIGNAL_HANDLER
	if(!primed || restart_pending || is_broken() || !has_tesla_power() || !heart || heart.pulse != PULSE_NONE)
		return
	begin_restart(heart)

/obj/item/organ/internal/augment/tesla_device/cardiac/proc/begin_restart(var/obj/item/organ/internal/heart/heart)
	if(!primed || restart_pending || !owner || !heart || heart.pulse != PULSE_NONE)
		return FALSE
	restart_pending = TRUE
	restart_generation++
	to_chat(owner, SPAN_DANGER("Your emergency resuscitation apparatus detects asystole and begins charging!"))
	playsound(get_turf(owner), 'sound/machines/defib_charge.ogg', 35, FALSE)
	addtimer(CALLBACK(src, PROC_REF(attempt_restart), restart_generation), restart_delay)
	return TRUE

/obj/item/organ/internal/augment/tesla_device/cardiac/proc/attempt_restart(var/expected_generation)
	if(expected_generation != restart_generation)
		return FALSE
	restart_pending = FALSE
	if(!primed || !owner || is_broken() || !has_tesla_power() || !owner.should_have_organ(BP_HEART))
		return FALSE
	var/obj/item/organ/internal/heart/heart = owner.internal_organs_by_name[BP_HEART]
	if(!istype(heart) || (heart.status & ORGAN_DEAD) || !owner.is_asystole())
		return FALSE
	if(owner.should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain = owner.internal_organs_by_name[BP_BRAIN]
		if(!brain || (brain.status & ORGAN_DEAD) || owner.nervous_system_failure())
			return FALSE
	primed = FALSE
	rearm_at = world.time + 10 MINUTES
	owner.visible_message(SPAN_DANGER("[owner]'s Tesla spine discharges with a sharp crack!"), SPAN_DANGER("Your emergency resuscitation apparatus shocks your stopped heart!"))
	playsound(get_turf(owner), 'sound/machines/defib_zap.ogg', 60, TRUE)
	var/was_dead = owner.stat == DEAD
	if(was_dead)
		owner.basic_revival(FALSE)
	if(!owner.resuscitate())
		return FALSE
	if(was_dead)
		owner.reload_fullscreen()
	to_chat(owner, SPAN_DANGER("Agonizing pain tears through your chest as the apparatus discharges."))
	return TRUE

/obj/item/organ/internal/augment/tesla_device/cardiac/emp_act(severity)
	var/was_primed = primed
	. = ..()
	if(!was_primed || !owner)
		return
	primed = FALSE
	restart_pending = FALSE
	restart_generation++
	rearm_at = world.time + 10 MINUTES
	owner.visible_message(SPAN_DANGER("[owner]'s Tesla spine discharges with a sharp crack!"), SPAN_DANGER("Your emergency resuscitation sends an agonizing shock through your chest!"))
	playsound(get_turf(owner), 'sound/machines/defib_zap.ogg', 60, TRUE)
	owner.apply_damage(5, DAMAGE_BURN, BP_CHEST, src)
	owner.custom_pain("Agonizing electrical pain tears through your chest!", 30, TRUE, owner.organs_by_name[BP_CHEST])

/obj/item/organ/internal/augment/tesla_device/cardiac/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "Its restart capacitor is [restart_pending ? "charging for a restart" : (primed ? "primed" : "spent and rearming; [max(0, round((rearm_at - world.time) / 10))] seconds remain")]."

// Personal prosthetic diagnostic panel and maintenance annunciator

/obj/item/organ/internal/augment/tesla_device/diagnostic
	name = "transdermal tesla diagnostic panel"
	desc = "A Tesla augment similar to the transdermal computer. \
	A small screen is grafted into the skin or replacing a prosthetic panel alongside a probe and connector. \
	This probe may be used to scan prosthetics and augments to ascertain their current state. \
	Despite originally being developed for Tesla prosthetics, collaboration with \
	Hephaestus Industries has allowed the augment to scan most prosthetics used across the Spur."
	icon_state = "robotanalyzer"
	action_button_name = "Deploy Diagnostic Probe"
	action_button_icon = "augment-tool"
	organ_tag = BP_AUG_TESLA_DIAGNOSTIC
	parent_organ = BP_CHEST
	activable = TRUE
	cooldown = 30
	var/last_announced_severity = 0

/obj/item/organ/internal/augment/tesla_device/diagnostic/process_initialize()
	START_PROCESSING(SSprocessing, src)

/obj/item/organ/internal/augment/tesla_device/diagnostic/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	retract_probe()
	return ..()

/obj/item/organ/internal/augment/tesla_device/diagnostic/removed()
	retract_probe()
	return ..()

/obj/item/organ/internal/augment/tesla_device/diagnostic/proc/retract_probe()
	if(!owner)
		return
	var/obj/item/robotanalyzer/augment/tesla/probe = locate() in owner
	if(probe?.source_augment == src)
		owner.drop_from_inventory(probe)

/obj/item/organ/internal/augment/tesla_device/diagnostic/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/robotanalyzer/augment/tesla/deployed = locate() in owner
	if(deployed?.source_augment == src)
		owner.drop_from_inventory(deployed)
		owner.visible_message(
			SPAN_NOTICE("The diagnostic probe retracts into [owner]'s [src]."),
			SPAN_NOTICE("You retract your diagnostic probe.")
		)
		return TRUE

	var/obj/item/robotanalyzer/augment/tesla/probe = new(owner)
	probe.source_augment = src
	probe.canremove = FALSE
	if(!owner.put_in_hands(probe))
		to_chat(owner, SPAN_WARNING("You need an empty hand to deploy your diagnostic probe."))
		return FALSE
	probe.item_flags |= ITEM_FLAG_NO_MOVE
	owner.visible_message(
		SPAN_NOTICE("A diagnostic probe extends from [owner]'s [src]."),
		SPAN_NOTICE("You deploy your diagnostic probe.")
	)
	return TRUE

/obj/item/organ/internal/augment/tesla_device/diagnostic/tesla_power_changed(var/powered)
	if(powered || !owner)
		return
	retract_probe()

/obj/item/robotanalyzer/augment/tesla
	name = "Tesla diagnostic probe"
	desc = "A retractable probe connected to a transdermal Tesla diagnostic panel. It can diagnose robots, prosthetics, and Tesla systems."
	analyzer_component_type = /datum/component/robotics_analyzer/tesla
	var/obj/item/organ/internal/augment/tesla_device/diagnostic/source_augment

/obj/item/robotanalyzer/augment/tesla/proc/has_tesla_power(mob/living/user)
	if(!source_augment || QDELETED(source_augment) || source_augment.owner != user || !source_augment.has_tesla_power())
		to_chat(user, SPAN_WARNING("Your diagnostic probe cannot draw power from a functioning Tesla spine!"))
		return FALSE
	return TRUE

/obj/item/robotanalyzer/augment/tesla/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!has_tesla_power(user))
		return
	return ..()

/obj/item/robotanalyzer/augment/tesla/attack_self(mob/user)
	if(!has_tesla_power(user))
		return
	return ..()

/obj/item/organ/internal/augment/tesla_device/diagnostic/process()
	if(!owner || !has_tesla_power())
		return
	var/severity = 0
	for(var/obj/item/organ/O in owner.internal_organs)
		if(O == src)
			continue
		if(O.organ_tag == BP_AUG_TESLA || hascall(O, "tesla_power_changed"))
			severity = max(severity, O.is_broken() ? 2 : (O.is_bruised() ? 1 : 0))
	for(var/obj/item/organ/external/E in owner.organs)
		var/datum/robolimb/R = GLOB.all_robolimbs[E.model]
		if(R?.is_tesla)
			severity = max(severity, E.is_broken() ? 2 : (E.is_bruised() ? 1 : 0))
	if(severity > last_announced_severity)
		to_chat(owner, severity >= 2 ? SPAN_DANGER("Your maintenance annunciator reports a Tesla component failure!") : SPAN_WARNING("Your maintenance annunciator reports damage to connected Tesla hardware."))
		playsound(get_turf(owner), 'sound/machines/twobeep.ogg', 30, TRUE)
	last_announced_severity = severity

// Low-power in-hand device-cell charger

/obj/item/organ/internal/augment/tesla_device/charging_lead
	name = "tesla mobile power system"
	desc = "The Tesla Mobile Power System (TeMPS) was originally developed for field technicians \
	as a theoretical method to power hand tools without the need for batteries. \
	Despite not being powerful enough for all but small tools, the augment is popular among technicians. \
	It operates via an induction charger implanted into the palm of the hand \
	using power from the Tesla Spine. It is known to cause a tingling sensation in the hand during use."
	icon_state = "robotanalyzer"
	action_button_name = "Toggle Mobile Power System"
	action_button_icon = "augment-tool"
	organ_tag = BP_AUG_TESLA_CHARGER
	parent_organ = BP_R_HAND
	activable = TRUE
	cooldown = 10
	var/hand_slot = slot_r_hand
	var/charging_load = 2700
	var/obj/item/charging_target
	var/obj/item/cell/device/charging_cell

/obj/item/organ/internal/augment/tesla_device/charging_lead/left
	parent_organ = BP_L_HAND
	hand_slot = slot_l_hand

/obj/item/organ/internal/augment/tesla_device/charging_lead/Destroy()
	stop_charging()
	return ..()

/obj/item/organ/internal/augment/tesla_device/charging_lead/removed()
	stop_charging()
	return ..()

/obj/item/organ/internal/augment/tesla_device/charging_lead/attack_self(var/mob/user)
	if(charging_target)
		stop_charging("You stop charging [charging_target] with your mobile power system.")
		return TRUE
	if(!owner)
		return FALSE
	var/obj/item/target = owner.get_equipped_item(hand_slot)
	if(!target)
		to_chat(owner, SPAN_WARNING("You need to hold a compatible device in the charger's hand."))
		return FALSE
	var/obj/item/cell/device/cell = target.get_cell()
	if(!istype(cell))
		to_chat(owner, SPAN_WARNING("Your mobile power system rejects [target]; it only supports modular-computer and device cells."))
		return FALSE
	if(cell.fully_charged())
		to_chat(owner, SPAN_NOTICE("[target]'s device cell is already fully charged."))
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	charging_target = target
	charging_cell = cell
	START_PROCESSING(SSprocessing, src)
	to_chat(owner, SPAN_NOTICE("Your mobile power system begins charging [charging_target]."))
	playsound(get_turf(owner), 'sound/machines/click.ogg', 20, TRUE)
	return TRUE

/obj/item/organ/internal/augment/tesla_device/charging_lead/process()
	if(!owner || QDELETED(charging_target) || QDELETED(charging_cell) || owner.get_equipped_item(hand_slot) != charging_target || charging_target.get_cell() != charging_cell || !has_tesla_power() || is_broken())
		stop_charging(owner ? "Your mobile power system stops charging." : null)
		return PROCESS_KILL
	if(charging_cell.fully_charged())
		stop_charging("[charging_target] finishes charging and your mobile power system shuts off.")
		return PROCESS_KILL
	charging_cell.give(charging_load * CELLRATE)
	if(charging_cell.fully_charged())
		playsound(get_turf(owner), 'sound/machines/twobeep.ogg', 20, TRUE)
		stop_charging("[charging_target] finishes charging and your mobile power system shuts off.")
		return PROCESS_KILL

/obj/item/organ/internal/augment/tesla_device/charging_lead/proc/stop_charging(var/message)
	STOP_PROCESSING(SSprocessing, src)
	if(message && owner)
		to_chat(owner, SPAN_NOTICE(message))
	charging_target = null
	charging_cell = null

/obj/item/organ/internal/augment/tesla_device/charging_lead/tesla_power_changed(var/powered)
	if(!powered && charging_target)
		stop_charging("Your mobile power system loses power and shuts off.")

/obj/item/organ/internal/augment/tesla_device/charging_lead/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(charging_target && charging_cell)
			. += "It is charging [charging_target] at [charging_load] mW. The device cell is at [round(charging_cell.percent())]%."
		else
			. += "It charges compatible device cells at [charging_load] mW while their device is held in this hand."

// Switchable thermal coils

/obj/item/organ/internal/augment/tesla_device/thermal
	name = "tesla thermal coils"
	desc = "A Tesla augment consisting of a series of coils implanted across the body and linked to the Tesla spine. \
	This attachment is capable of enhancing body temperature regulation, \
	or actively cooling or heating the body internally. \
	Originally developed for Hadiist troopers, the augment became popular with offworld Hadiist citizens for its cooling function."
	icon_state = "augment"
	action_button_name = "Switch Thermal Coils"
	action_button_icon = "augment"
	organ_tag = BP_AUG_TESLA_THERMAL
	parent_organ = BP_CHEST
	activable = TRUE
	cooldown = 10
	var/mode = 0 // -1 cooling, 0 off, 1 warming

/obj/item/organ/internal/augment/tesla_device/thermal/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/organ/internal/augment/tesla_device/thermal/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	mode++
	if(mode > 1)
		mode = -1
	to_chat(owner, SPAN_NOTICE("You switch your thermal coils to [mode == 1 ? "warming" : (mode == -1 ? "cooling" : "off")]."))
	if(mode)
		START_PROCESSING(SSprocessing, src)

/obj/item/organ/internal/augment/tesla_device/thermal/process(seconds_per_tick)
	. = ..()
	if(!mode)
		if(surge_damage)
			return
		return PROCESS_KILL
	if(!owner)
		mode = 0
		return PROCESS_KILL
	if(!has_tesla_power())
		return
	var/target_temperature = owner.species.body_temperature + (20 * mode)
	if(mode > 0 && owner.bodytemperature < target_temperature)
		owner.bodytemperature = min(target_temperature, owner.bodytemperature + 1)
	else if(mode < 0 && owner.bodytemperature > target_temperature)
		owner.bodytemperature = max(target_temperature, owner.bodytemperature - 1)

/obj/item/organ/internal/augment/tesla_device/thermal/tesla_power_changed(var/powered)
	if(!powered && mode)
		mode = 0
		if(owner)
			to_chat(owner, SPAN_WARNING("Your thermal coils switch off as spine power fails."))

/obj/item/organ/internal/augment/tesla_device/thermal/removed()
	mode = 0
	STOP_PROCESSING(SSprocessing, src)
	return ..()
