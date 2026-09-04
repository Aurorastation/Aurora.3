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

/obj/item/organ/internal/augment/tesla_device/proc/get_spine()
	return get_tesla_spine(owner)

/obj/item/organ/internal/augment/tesla_device/proc/has_tesla_power(var/show_warning = FALSE, var/check_damage = FALSE)
	var/obj/item/organ/internal/augment/tesla/spine = get_spine()
	if(!spine || spine.is_broken())
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
	name = "tesla traction pads"
	desc = "Electromagnetic pads fitted beneath the feet. When active, they provide the grip of magnetic boots at the cost of slower movement."
	icon_state = "suspension"
	action_button_name = "Toggle Traction Pads"
	action_button_icon = "magclaws"
	organ_tag = BP_AUG_TESLA_TRACTION
	parent_organ = BP_R_FOOT
	activable = TRUE
	cooldown = 10
	var/active = FALSE

/obj/item/organ/internal/augment/tesla_device/traction/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	set_active(!active)

/obj/item/organ/internal/augment/tesla_device/traction/proc/set_active(var/new_active)
	if(!owner)
		active = FALSE
		return
	active = new_active && has_tesla_power()
	if(active)
		ADD_TRAIT(owner, TRAIT_SHOE_GRIP, TRAIT_SOURCE_AUGMENT)
		to_chat(owner, SPAN_NOTICE("You activate your Tesla traction pads."))
		playsound(get_turf(owner), 'sound/effects/magnetclamp.ogg', 20)
	else
		REMOVE_TRAIT(owner, TRAIT_SHOE_GRIP, TRAIT_SOURCE_AUGMENT)
		to_chat(owner, SPAN_NOTICE("You deactivate your Tesla traction pads."))

/obj/item/organ/internal/augment/tesla_device/traction/tesla_power_changed(var/powered)
	if(!powered && active)
		set_active(FALSE)

/obj/item/organ/internal/augment/tesla_device/traction/removed()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_SHOE_GRIP, TRAIT_SOURCE_AUGMENT)
	return ..()

/obj/item/organ/internal/augment/tesla_device/traction/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "Its magnetic traction system is [active ? "active" : "inactive"]."

// Spine-powered internal computer

/obj/item/organ/internal/augment/tesla_device/pda
	name = "tesla internal computer"
	desc = "A basic modular computer integrated into the forearm and powered by a Tesla spine."
	icon_state = "augment-pda"
	action_button_name = "Access Internal Computer"
	action_button_icon = "augment-pda"
	organ_tag = BP_AUG_TESLA_PDA
	parent_organ = BP_R_ARM
	activable = TRUE
	cooldown = 10
	var/obj/item/modular_computer/handheld/pda/tesla_internal/internal_pda

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
	name = "tesla internal computer"
	desc = "A basic internal computer drawing its power from a Tesla spine."

/obj/item/modular_computer/handheld/pda/tesla_internal/GetID()
	var/obj/item/organ/internal/augment/tesla_device/pda/access_point = loc
	return access_point?.owner?.GetIdCard()

/obj/item/modular_computer/handheld/pda/tesla_internal/ui_status(mob/user, datum/ui_state/state)
	var/obj/item/organ/internal/augment/tesla_device/pda/access_point = loc
	if(istype(access_point) && access_point.owner == user && !access_point.is_broken() && access_point.has_tesla_power())
		return UI_INTERACTIVE
	to_chat(user, SPAN_WARNING("Your internal computer is not receiving power from your Tesla spine."))
	return UI_CLOSE

// Tesla voice box

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla
	name = "tesla voice box"
	desc = "An Elektroika voice box powered by a Tesla spine. It produces the flat Elektro'Siik accent and can briefly amplify its user's voice."
	accent = ACCENT_ELEKTRO_SIIK
	action_button_name = "Use Voice Amplifier"
	action_button_icon = "augment"
	activable = TRUE
	cooldown = 20 SECONDS
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/attack_self(var/mob/user)
	if(user.client && (user.client.prefs.muted & MUTE_IC))
		to_chat(user, SPAN_WARNING("You cannot speak in IC while muted."))
		return FALSE
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(owner)
	if(!spine || spine.is_broken())
		to_chat(owner, SPAN_WARNING("Your voice amplifier cannot draw power from a functioning Tesla spine!"))
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
		H.earpain(H in range(owner, 1) ? 3 : 2, TRUE, 2)
	return TRUE

/obj/item/organ/internal/augment/synthetic_cords/voice/tesla/proc/tesla_power_changed(var/powered)
	return

// Tesla tool augment base

/obj/item/organ/internal/augment/tool/tesla
	name = "tesla retractable tool"
	desc = "A retractable tool powered by a Tesla spine."
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

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
	desc = "A retractable electrical arc welder with a Tesla-powered capacitor patterned after an experimental self-replenishing welder."
	icon_state = "robotanalyzer"
	action_button_name = "Deploy Arc Welder"
	action_button_icon = "augment-tool"
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

/obj/item/organ/internal/augment/tool/tesla/arc_welder/process()
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(owner)
	if(!spine || spine.is_broken() || charge >= max_charge)
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

/obj/item/weldingtool/experimental/tesla_augment
	name = "tesla arc welder"
	desc = "An electrical arc welder powered by a slowly regenerating internal capacitor. Its charge cannot be replenished from an external fuel source."
	icon_state = "expwelder"
	item_state = "expwelder"
	change_icons = FALSE
	var/obj/item/organ/internal/augment/tool/tesla/arc_welder/source_augment

/obj/item/weldingtool/experimental/tesla_augment/Initialize()
	. = ..()
	reagents.clear_reagents()

/obj/item/weldingtool/experimental/tesla_augment/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(distance <= 0)
		. -= "It contains [get_fuel()]/[max_fuel] units of fuel."
	if(distance <= 1)
		. += "Its capacitor holds [round(get_fuel(), 0.1)]/[max_fuel] units of charge."

/obj/item/weldingtool/experimental/tesla_augment/proc/has_spine_power(var/mob/living/user)
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(user)
	return spine && !spine.is_broken()

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
	desc = "A retractable electrode which produces a small ignition arc without maintaining an open flame."
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
	desc = "A pair of retractable electrodes producing a momentary ignition arc. It has no persistent flame and does not radiate enough heat to ignite the surrounding atmosphere."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "zippo"
	item_state = "zippo"
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
	name = "tesla oxygenation system"
	desc = "An Elektroika system which assists the wearer's respiratory or circulatory system."
	icon_state = "boosted_heart"
	organ_tag = BP_AUG_TESLA_OXYGEN
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler
	name = "tesla oxygen recycler"
	desc = "A low-power blood oxygenation system which partially counters mild oxygen deprivation. It cannot compensate for severe blood loss."

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

/obj/item/organ/internal/augment/tesla_device/oxygenation/recycler/proc/assist_oxygenation(implantee, blood_volume, blood_volume_mod, oxygenated_add)
	SIGNAL_HANDLER
	if(has_tesla_power() && *blood_volume >= BLOOD_VOLUME_BAD)
		*oxygenated_add += 0.25

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver
	name = "tesla circulatory driver"
	desc = "An activated circulatory stimulator which briefly reduces stamina expenditure before entering a long safety cooldown."
	action_button_name = "Activate Circulatory Driver"
	action_button_icon = "augment"
	activable = TRUE
	cooldown = 10
	var/active = FALSE
	var/next_activation = 0

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/attack_self(var/mob/user)
	if(world.time < next_activation)
		to_chat(owner, SPAN_WARNING("Your circulatory driver's safety cycle has [round((next_activation - world.time) / 10)] seconds remaining."))
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	active = TRUE
	next_activation = world.time + 5 MINUTES
	ADD_TRAIT(owner, TRAIT_TESLA_CIRCULATORY_DRIVER, TRAIT_SOURCE_AUGMENT)
	to_chat(owner, SPAN_NOTICE("Your circulatory driver begins assisting your heart and lungs."))
	addtimer(CALLBACK(src, PROC_REF(deactivate)), 30 SECONDS)

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/proc/deactivate()
	if(owner && active)
		REMOVE_TRAIT(owner, TRAIT_TESLA_CIRCULATORY_DRIVER, TRAIT_SOURCE_AUGMENT)
		to_chat(owner, SPAN_NOTICE("Your circulatory driver winds down."))
	active = FALSE

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/tesla_power_changed(var/powered)
	if(!powered)
		deactivate()

/obj/item/organ/internal/augment/tesla_device/oxygenation/driver/removed()
	deactivate()
	return ..()

// Arm- and palm-mounted worklights

/obj/item/organ/internal/augment/tesla_device/worklight
	name = "tesla worklight"
	desc = "A compact worklight mounted in a Tesla prosthesis and powered by its spine."
	icon_state = "sightlights"
	light_system = DIRECTIONAL_LIGHT
	action_button_name = "Toggle Tesla Worklight"
	action_button_icon = "sightlights"
	organ_tag = BP_AUG_TESLA_LIGHT
	parent_organ = BP_R_ARM
	activable = TRUE
	cooldown = 10
	var/lights_on = FALSE
	var/lights_color = LIGHT_COLOR_TUNGSTEN
	var/lights_range = 3
	var/lights_intensity = 0.6

/obj/item/organ/internal/augment/tesla_device/worklight/shoulder_left
	name = "left shoulder tesla worklight"
	parent_organ = BP_L_ARM

/obj/item/organ/internal/augment/tesla_device/worklight/palm_right
	name = "right palm tesla worklight"
	parent_organ = BP_R_HAND

/obj/item/organ/internal/augment/tesla_device/worklight/palm_left
	name = "left palm tesla worklight"
	parent_organ = BP_L_HAND

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
		to_chat(owner, SPAN_NOTICE("You switch your Tesla worklight [lights_on ? "on" : "off"]."))
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

// One-shot cardiac restart system, re-primed by an absorbed spine charge

/obj/item/organ/internal/augment/tesla_device/cardiac
	name = "tesla emergency cardiac driver"
	desc = "An automatic cardiac driver which makes one attempt to restart a stopped heart. Once fired, it must consume an electrical charge absorbed by the Tesla spine before it can work again."
	icon_state = "boosted_heart"
	organ_tag = BP_AUG_TESLA_CARDIAC
	parent_organ = BP_CHEST
	var/primed = TRUE
	var/restart_pending = FALSE
	var/restart_delay = 5 SECONDS
	var/restart_generation = 0

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

/obj/item/organ/internal/augment/tesla_device/cardiac/process()
	if(primed || !owner || !has_tesla_power())
		return
	var/obj/item/organ/internal/augment/tesla/spine = get_spine()
	if(spine.actual_charges > 0)
		spine.actual_charges--
		primed = TRUE
		to_chat(owner, SPAN_NOTICE("Your cardiac driver's capacitor draws an absorbed charge from your Tesla spine and re-primes."))

/obj/item/organ/internal/augment/tesla_device/cardiac/proc/handle_cardiac_event(implantee, obj/item/organ/internal/heart/heart, blood_volume, recent_pump, pulse_mod, min_efficiency)
	SIGNAL_HANDLER
	if(!primed || restart_pending || is_broken() || !has_tesla_power() || !heart || heart.pulse != PULSE_NONE || owner.stat == DEAD)
		return
	restart_pending = TRUE
	restart_generation++
	to_chat(owner, SPAN_DANGER("Your emergency cardiac driver detects asystole and begins charging!"))
	playsound(get_turf(owner), 'sound/machines/defib_charge.ogg', 35, FALSE)
	addtimer(CALLBACK(src, PROC_REF(attempt_restart), restart_generation), restart_delay)

/obj/item/organ/internal/augment/tesla_device/cardiac/proc/attempt_restart(var/expected_generation)
	if(expected_generation != restart_generation)
		return FALSE
	restart_pending = FALSE
	if(!primed || !owner || owner.stat == DEAD || is_broken() || !has_tesla_power() || !owner.should_have_organ(BP_HEART))
		return FALSE
	var/obj/item/organ/internal/heart/heart = owner.internal_organs_by_name[BP_HEART]
	if(!istype(heart) || (heart.status & ORGAN_DEAD) || !owner.is_asystole())
		return FALSE
	primed = FALSE
	owner.visible_message(SPAN_DANGER("[owner]'s Tesla spine discharges with a sharp crack!"), SPAN_DANGER("Your emergency cardiac driver shocks your stopped heart!"))
	playsound(get_turf(owner), 'sound/machines/defib_zap.ogg', 60, TRUE)
	if(!owner.resuscitate())
		primed = TRUE
		return FALSE
	return TRUE

/obj/item/organ/internal/augment/tesla_device/cardiac/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "Its restart capacitor is [restart_pending ? "charging for a restart" : (primed ? "primed" : "spent and awaiting an absorbed spine charge")]."

// Personal prosthetic diagnostic panel and maintenance annunciator

/obj/item/organ/internal/augment/tesla_device/diagnostic
	name = "tesla personal diagnostic panel"
	desc = "A self-diagnostic panel based on a robotic analyzer. It reports prosthetic condition, Tesla spine status, and warns its user when connected Tesla hardware deteriorates."
	icon_state = "robotanalyzer"
	action_button_name = "Run Tesla Diagnostics"
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
	return ..()

/obj/item/organ/internal/augment/tesla_device/diagnostic/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE
	prosthetics_scan(owner, owner)
	var/obj/item/organ/internal/augment/tesla/spine = get_spine()
	to_chat(owner, SPAN_NOTICE("Tesla spine: [spine.is_broken() ? "NONFUNCTIONAL" : (spine.is_bruised() ? "DAMAGED" : "operational")]."))
	to_chat(owner, SPAN_NOTICE("Absorbed electrical charge: [spine.actual_charges]/[spine.max_charges]."))
	to_chat(owner, SPAN_NOTICE("Connected Tesla augments:"))
	for(var/obj/item/organ/internal/augment/A in owner.internal_organs)
		if(A == spine || hascall(A, "tesla_power_changed"))
			to_chat(owner, "[A.name]: [A.is_broken() ? SPAN_DANGER("nonfunctional") : (A.is_bruised() ? SPAN_WARNING("damaged") : SPAN_GOOD("operational"))]")
	return TRUE

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

// Low-power device-cell charging lead

/obj/item/organ/internal/augment/tool/tesla/charging_lead
	name = "tesla low-power charging lead"
	desc = "A retractable charging lead compatible only with modular-computer and handheld device cells."
	icon_state = "robotanalyzer"
	action_button_name = "Deploy Charging Lead"
	action_button_icon = "augment-tool"
	organ_tag = BP_AUG_TESLA_CHARGER
	parent_organ = BP_R_HAND
	augment_type = /obj/item/tesla_charging_lead

/obj/item/organ/internal/augment/tool/tesla/charging_lead/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/tesla_charging_lead
	name = "tesla low-power charging lead"
	desc = "A retractable low-current lead. Its controller refuses to charge anything larger than a handheld device cell."
	icon = 'icons/obj/item/multitool.dmi'
	icon_state = "multitool"
	item_state = "multitool"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	var/charge_per_use = 50

/obj/item/tesla_charging_lead/afterattack(atom/target, mob/living/user, proximity)
	if(!proximity || !isobj(target))
		return
	var/obj/O = target
	var/obj/item/cell/device/cell = O.get_cell()
	if(!istype(cell))
		to_chat(user, SPAN_WARNING("The charging lead rejects [target]; it only supports modular-computer and device cells."))
		return
	if(cell.charge >= cell.maxcharge)
		to_chat(user, SPAN_NOTICE("[target]'s device cell is already fully charged."))
		return
	var/obj/item/organ/internal/augment/tesla/spine = get_tesla_spine(user)
	if(!spine || spine.is_broken())
		to_chat(user, SPAN_WARNING("The charging lead cannot draw power from a functioning Tesla spine."))
		return
	cell.give(min(charge_per_use, cell.maxcharge - cell.charge))
	to_chat(user, SPAN_NOTICE("You trickle-charge [target] to [round(cell.percent())]%."))
	playsound(get_turf(user), 'sound/machines/click.ogg', 20, TRUE)
	user.setClickCooldown(1 SECOND)

/obj/item/tesla_charging_lead/dropped()
	. = ..()
	loc = null
	qdel(src)

// Switchable thermal coils

/obj/item/organ/internal/augment/tesla_device/thermal
	name = "tesla thermal coils"
	desc = "Switchable heating and cooling coils comparable to a wearable heat or cold pack. They provide comfort rather than environmental protection."
	icon_state = "augment"
	action_button_name = "Switch Thermal Coils"
	action_button_icon = "augment"
	organ_tag = BP_AUG_TESLA_THERMAL
	parent_organ = BP_CHEST
	activable = TRUE
	cooldown = 10
	var/mode = 0 // -1 cooling, 0 off, 1 warming

/obj/item/organ/internal/augment/tesla_device/thermal/process_initialize()
	START_PROCESSING(SSprocessing, src)

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

/obj/item/organ/internal/augment/tesla_device/thermal/process()
	if(!owner || !mode || !has_tesla_power())
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
