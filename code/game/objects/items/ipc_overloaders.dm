/obj/item/ipc_overloader
	name = "basic overloader"
	desc_extended = "An overloader is a small disposable stick drive, commonly loaded with a program designed to temporarily reconfigure an IPC's priorities or inputs."
	icon = 'icons/obj/item/ipc_overloaders.dmi'
	icon_state = "classic"
	w_class = ITEMSIZE_TINY
	contained_sprite = TRUE
	var/uses = 2
	var/effect_time = 30 SECONDS
	var/effects = 4

	var/static/list/step_up_effects = list(
		TRAIT_OVERLOADER_OD_INITIAL = TRAIT_OVERLOADER_OD_MEDIUM,
		TRAIT_OVERLOADER_OD_MEDIUM = TRAIT_OVERLOADER_OD_EFFECT
	)

	var/static/list/step_down_effects = list(
		TRAIT_OVERLOADER_OD_EFFECT = TRAIT_OVERLOADER_OD_MEDIUM,
		TRAIT_OVERLOADER_OD_MEDIUM = TRAIT_OVERLOADER_OD_INITIAL
	)

/obj/item/ipc_overloader/Initialize()
	. = ..()
	item_state = icon_state

/obj/item/ipc_overloader/update_icon()
	if(uses == initial(uses))
		icon_state = initial(icon_state)
	else if(!uses)
		icon_state = "[initial(icon_state)]-spent"
	else
		icon_state = "[initial(icon_state)]-[initial(uses)-uses]"

/obj/item/ipc_overloader/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(uses)
			to_chat(user, SPAN_NOTICE("It has <b>[uses]</b> uses left."))
		else
			to_chat(user, SPAN_WARNING("It's totally spent."))

/obj/item/ipc_overloader/attack_self(mob/user)
	if(!uses)
		to_chat(user, SPAN_WARNING("\The [src] is totally spent."))
		return
	if(isipc(user))
		user.visible_message("<b>[user]</b> jabs themselves with \the [src].", SPAN_NOTICE("You jab yourself with \the [src]."))
		handle_overloader_effect(user)
		if(effect_time)
			addtimer(CALLBACK(src, PROC_REF(midway_overloader_effect), user, effects), effect_time)
		uses--
		update_icon()
		return
	to_chat(user, SPAN_WARNING("\The [src] has no use for you!"))

/obj/item/ipc_overloader/proc/handle_overloader_effect(var/mob/living/carbon/human/target)
	handle_overdose(target)

/obj/item/ipc_overloader/proc/midway_overloader_effect(var/mob/living/carbon/human/target, var/effect_amount)
	if(effect_amount)
		addtimer(CALLBACK(src, PROC_REF(midway_overloader_effect), target, effect_amount - 1), effect_time)
		return TRUE
	addtimer(CALLBACK(src, PROC_REF(finish_overloader_effect), target), effect_time)
	finish_overloader_effect(target)
	return FALSE

/obj/item/ipc_overloader/proc/finish_overloader_effect(var/mob/living/carbon/human/target)
	handle_overdose_stepdown(target)

// use traits to step up and down from the overdose effects
/obj/item/ipc_overloader/proc/handle_overdose(var/mob/living/carbon/human/target)
	var/added_trait = FALSE
	for(var/trait in step_up_effects)
		if(HAS_TRAIT(target, trait))
			REMOVE_TRAIT(target, trait, TRAIT_SOURCE_OVERLOADER)
			ADD_TRAIT(target, step_up_effects[trait], TRAIT_SOURCE_OVERLOADER)
			added_trait = TRUE
			break
	if(HAS_TRAIT(target, TRAIT_OVERLOADER_OD_EFFECT))
		handle_overdose_effect(target)
	else if(!added_trait)
		ADD_TRAIT(target, TRAIT_OVERLOADER_OD_INITIAL, TRAIT_SOURCE_OVERLOADER)

/obj/item/ipc_overloader/proc/handle_overdose_effect(var/mob/living/carbon/human/target)
	switch(rand(1, 8))
		if(1) // random limb fire damage
			to_chat(target, SPAN_WARNING("Your limbs rapidly heat up!"))
			target.take_overall_damage(0, 20)
		if(2) // random component damage
			to_chat(target, SPAN_WARNING("Your internals rapidly heat up!"))
			var/probability = 100
			for(var/obj/item/organ/internal/internal_component as anything in shuffle(target.internal_organs))
				if(prob(probability))
					internal_component.take_internal_damage(10, FALSE)
					probability -= 25
		if(3) // stumbling and falling down
			to_chat(target, SPAN_WARNING("Your locomotive sensors starts rebooting repeatedly!"))
			target.confused = 20
			target.Weaken(5)
		if(4) // text coming out as a garbled mess like when you get a lot of damage
			to_chat(target, SPAN_WARNING("Your speech synthesis software starts rebooting repeatedly!"))
			ADD_TRAIT(target, TRAIT_SPEAKING_GIBBERISH, TRAIT_SOURCE_OVERLOADER)
			addtimer(CALLBACK(src, PROC_REF(end_overdose_effect), target, 4), 2 MINUTES)
		if(5) // blindness
			to_chat(target, SPAN_WARNING("Your vision sensors starts rebooting repeatedly!"))
			target.eye_blind = 20
		if(6) // deafness
			to_chat(target, SPAN_WARNING("Your audio sensors starts rebooting repeatedly!"))
			target.ear_deaf = 20
		if(7) // aggressive screen shaking
			to_chat(target, SPAN_WARNING("Your balancing sensors starts rebooting repeatedly!"))
			target.make_dizzy(1000)
			addtimer(CALLBACK(src, PROC_REF(end_overdose_effect), target, 7), 1 MINUTE)
		if(8) // hallucinations
			to_chat(target, SPAN_WARNING("Your logic centre starts rebooting repeatedly!"))
			ADD_TRAIT(target, TRAIT_BYPASS_HALLUCINATION_RESTRICTION, TRAIT_SOURCE_OVERLOADER)
			target.hallucination = 200
			addtimer(CALLBACK(src, PROC_REF(end_overdose_effect), target, 8), 2 MINUTES)

/obj/item/ipc_overloader/proc/end_overdose_effect(var/mob/living/carbon/human/target, var/overdose_effect)
	switch(overdose_effect)
		if(4) // text coming out as a garbled mess like when you get a lot of damage
			REMOVE_TRAIT(target, TRAIT_SPEAKING_GIBBERISH, TRAIT_SOURCE_OVERLOADER)
		if(7) // aggressive screen shaking
			target.dizziness = 0
		if(8) // hallucinations
			REMOVE_TRAIT(target, TRAIT_BYPASS_HALLUCINATION_RESTRICTION, TRAIT_SOURCE_OVERLOADER)
			target.hallucination = 0

/obj/item/ipc_overloader/proc/handle_overdose_stepdown(var/mob/living/carbon/human/target)
	var/added_trait = FALSE
	for(var/trait in step_down_effects)
		if(HAS_TRAIT(target, trait))
			REMOVE_TRAIT(target, trait, TRAIT_SOURCE_OVERLOADER)
			ADD_TRAIT(target, step_down_effects[trait], TRAIT_SOURCE_OVERLOADER)
			added_trait = TRUE
			break
	if(!added_trait)
		REMOVE_TRAIT(target, TRAIT_OVERLOADER_OD_INITIAL, TRAIT_SOURCE_OVERLOADER)


// CLASSIC
/obj/item/ipc_overloader/classic
	name = "GwokBuzz Classic"
	desc = "One of GwokBuzz's best-selling overloaders, this drive is loaded with a program that is capable of analyzing an IPC's software, and through many means, increases its feelings of satisfaction."
	icon_state = "classic"

/obj/item/ipc_overloader/classic/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD("You feel good."))

/obj/item/ipc_overloader/classic/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_NOTICE("You feel buzzed."))

/obj/item/ipc_overloader/classic/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("You sense the buzz is wearing off..."))


// TRANQUIL
/obj/item/ipc_overloader/tranquil
	name = "GwokBuzz VanillaTranquil"
	desc = "An overloader commonly marketed to IPC in high-intensity jobs by GwokBuzz, this drive is loaded with a program that reduces hostility within IPC and decreases risk analysis and projection."
	icon_state = "vanilla"
	var/list/static/calm_messages = list("You feel calm.", "You forget about your concerns.")

/obj/item/ipc_overloader/tranquil/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD(pick(calm_messages)))

/obj/item/ipc_overloader/tranquil/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_GOOD(pick(calm_messages)))

/obj/item/ipc_overloader/tranquil/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("You feel the weight of the world return to your shoulders..."))


// RAINBOW
/obj/item/ipc_overloader/rainbow
	name = "GwokBuzz Rainbow Essence"
	desc = "An overloader commonly marketed to IPC in the service sector by GwokBuzz, this drive is loaded with a program that increases an IPC's perception that it has completed its current objectives or is more likely to complete its objectives."
	icon_state = "rainbow"

/obj/item/ipc_overloader/rainbow/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD("You feel happy."))
	target.druggy = 300

/obj/item/ipc_overloader/rainbow/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_GOOD("You feel happy."))
		target.druggy = 300

/obj/item/ipc_overloader/rainbow/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("The world seems a bit duller than it was before..."))
	target.druggy = 0


// SCREENSHAKER
/obj/item/ipc_overloader/screenshaker
	name = "GwokBuzz ScreenShaker"
	desc = "An overloader commonly marketed to IPC in the service sector by GwokBuzz. This one causes an IPC's servos to pulse at random intervals, disrupting its balance."
	icon_state = "screenshake"

/obj/item/ipc_overloader/screenshaker/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("You feel alert."))
	target.dizziness = 0
	target.make_dizzy(200)

/obj/item/ipc_overloader/screenshaker/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_NOTICE("You feel alert."))
		target.dizziness = 0
		target.make_dizzy(200)

/obj/item/ipc_overloader/screenshaker/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("You start feeling uncoordinated..."))
	target.dizziness = 0


// JITTERBUG
/obj/item/ipc_overloader/jitterbug
	name = "GwokBuzz Jitterbug"
	desc = "This one overloads an IPC's perception of danger, causing it to perceive actions as more risky than it would normally."
	icon_state = "screenshake"

/obj/item/ipc_overloader/jitterbug/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_BAD("You feel uneasy."))

/obj/item/ipc_overloader/jitterbug/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_BAD("You feel uneasy."))

/obj/item/ipc_overloader/jitterbug/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("You start feeling a bit safer..."))




// STORAGE BOX
/obj/item/storage/overloader
	name = "overloader box"
	desc = "A transparent, secure container sealed by the Konyanger government, containing recreational software."
	icon = 'icons/obj/item/ipc_overloaders.dmi'
	icon_state = "box"
	update_icon_on_init = TRUE
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_TINY
	storage_slots = 1
	can_hold = list(/obj/item/ipc_overloader)
	use_sound = 'sound/items/storage/briefcase.ogg'
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	var/sealed = TRUE

/obj/item/storage/overloader/Initialize(mapload, defer_shrinkwrap)
	icon_state = "box"
	return ..()

/obj/item/storage/overloader/examine(mob/user)
	. = ..()
	var/obj/item/ipc_overloader/overloader = locate() in contents
	if(overloader)
		to_chat(user, SPAN_NOTICE("This one has a <b>[overloader.name]</b> inside."))

/obj/item/storage/overloader/open(mob/user)
	..()
	sealed = FALSE
	update_icon()

/obj/item/storage/overloader/update_icon()
	. = ..()
	cut_overlays()
	var/obj/item/ipc_overloader/overloader = locate() in contents
	if(overloader)
		add_overlay(image(overloader.icon, null, overloader.icon_state, sealed ? layer - 0.01 : layer + 0.01))
		if(!sealed)
			add_overlay(image(icon, null, "box-overlay", layer + 0.02))
	if(!sealed)
		icon_state = "box-open"

/obj/item/storage/overloader/classic
	name = "overloader box (classic)"
	icon_state = "box-classic"
	starts_with = list(/obj/item/ipc_overloader/classic = 1)

/obj/item/storage/overloader/tranquil
	name = "overloader box (tranquil)"
	icon_state = "box-vanilla"
	starts_with = list(/obj/item/ipc_overloader/tranquil = 1)

/obj/item/storage/overloader/rainbow
	name = "overloader box (rainbow)"
	icon_state = "box-rainbow"
	starts_with = list(/obj/item/ipc_overloader/rainbow = 1)

/obj/item/storage/overloader/screenshaker
	name = "overloader box (screenshaker)"
	icon_state = "box-screenshaker"
	starts_with = list(/obj/item/ipc_overloader/screenshaker = 1)

/obj/item/storage/overloader/jitterbug
	name = "overloader box (jitterbug)"
	icon_state = "box-jitterbug"
	starts_with = list(/obj/item/ipc_overloader/jitterbug = 1)
