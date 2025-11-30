/obj/item/ipc_overloader
	name = "basic overloader"
	desc_extended = "An overloader is a small disposable stick drive, commonly loaded with a program designed to temporarily reconfigure an IPC's priorities or inputs."
	icon = 'icons/obj/item/ipc_overloaders.dmi'
	icon_state = "classic"
	w_class = WEIGHT_CLASS_TINY
	contained_sprite = TRUE
	/// Total number of times an overloader can be used.
	var/uses = 2
	/// Total length of time between effects.
	var/effect_time = 30 SECONDS
	/// Determines how many midway overloader effects are experienced.
	var/effects = 6

	var/static/list/step_up_effects = list(
		TRAIT_OVERLOADER_OD_INITIAL = TRAIT_OVERLOADER_OD_MEDIUM,
		TRAIT_OVERLOADER_OD_MEDIUM = TRAIT_OVERLOADER_OD_EFFECT
	)

	var/static/list/step_down_effects = list(
		TRAIT_OVERLOADER_OD_EFFECT = TRAIT_OVERLOADER_OD_MEDIUM,
		TRAIT_OVERLOADER_OD_MEDIUM = TRAIT_OVERLOADER_OD_INITIAL
	)

/obj/item/ipc_overloader/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		if(uses)
			. += SPAN_NOTICE("It has <b>[uses] uses</b> left.")
		else
			. += SPAN_WARNING("It's totally spent.")

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

// Jabbing yourself with an overloader.
/obj/item/ipc_overloader/attack_self(mob/user)
	if(!uses)
		to_chat(user, SPAN_WARNING("\The [src] is totally spent."))
		return
	if(isipc(user))
		user.visible_message("<b>[user]</b> jabs themselves with \the [src].", SPAN_NOTICE("You jab yourself with \the [src]."))
		user.do_attack_animation(user)
		handle_overloader_effect(user)
		if(effect_time)
			addtimer(CALLBACK(src, PROC_REF(midway_overloader_effect), user, effects), effect_time)
		uses--
		update_icon()
		return
	to_chat(user, SPAN_WARNING("\The [src] has no use for you!"))

// Jabbing someone else with an overloader.
// TODO: Clean up the common ground with attack_self, there's a lot of clunkily repeated code right now.
/obj/item/ipc_overloader/attack(mob/living/carbon/human/target_human, mob/user, target_zone)
	if(!ishuman(target_human))
		return

	var/obj/item/organ/external/organ = target_human.get_organ(target_zone)
	if (!organ)
		to_chat(target_human, SPAN_NOTICE("\The [target_human] is missing that limb."))
		return

	if(!uses)
		to_chat(user, SPAN_WARNING("\The [src] is totally spent."))
		return

	var/injection_modifier = target_human.get_bp_coverage(target_zone)
	switch(injection_modifier)
		if(INJECTION_FAIL)
			to_chat(user, SPAN_WARNING("There is no exposed area on that body part."))
			return

		if(SUIT_INJECTION_MOD)
			user.visible_message(SPAN_WARNING("\The [user] is searching for an injection port to jab \the [target_human] with \the [src]!"), SPAN_NOTICE("You are searching for an injection port to jab \the [target_human] with \the [src]."))
		else
			user.visible_message(SPAN_WARNING("\The [user] is trying to jab \the [target_human] with \the [src]!"), SPAN_NOTICE("You are trying to jab \the [target_human] with \the [src]."))

	if(do_mob(user, target_human, 2 SECONDS * injection_modifier))
		// Checking this again if the target put on armour after the injection began.
		injection_modifier = target_human.get_bp_coverage(target_zone)
		if(injection_modifier == INJECTION_FAIL)
			to_chat(user, SPAN_WARNING("There is no exposed area on that body part."))
			return

		user.visible_message(SPAN_WARNING("\The [user] jabs \the [target_human] with \the [src]!"), SPAN_NOTICE("You jab \the [target_human] with \the [src]."))
		user.do_attack_animation(target_human)

		// If synthetic, they receive the overloader effects.
		// There are no overt indications to the user that the target mob is synthetic, so this can't be used to check for secret shells.
		if(isipc(target_human))
			handle_overloader_effect(target_human)
			if(effect_time)
				addtimer(CALLBACK(src, PROC_REF(midway_overloader_effect), target_human, effects), effect_time)
			uses--
			update_icon()

		// If not synthetic, and the targeted organ can feel pain, the target feels pain because they just got jabbed with a thumb drive.
		else if (organ && ORGAN_CAN_FEEL_PAIN(organ))
			to_chat(target_human, SPAN_DANGER("You are sharply jabbed by \the [src]!"))
			target_human.apply_damage(2, DAMAGE_PAIN, target_zone)

/// Procs immediately after using the overloader.
/obj/item/ipc_overloader/proc/handle_overloader_effect(var/mob/living/carbon/human/target)
	handle_overdose(target)

/// Procs as many times as the effect_amount variable, with a time between effects determined by effect_time.
/obj/item/ipc_overloader/proc/midway_overloader_effect(var/mob/living/carbon/human/target, var/effect_amount)
	if(effect_amount)
		addtimer(CALLBACK(src, PROC_REF(midway_overloader_effect), target, effect_amount - 1), effect_time)
		return TRUE
	finish_overloader_effect(target)
	return FALSE

/// Procs once all effects are expended.
/obj/item/ipc_overloader/proc/finish_overloader_effect(var/mob/living/carbon/human/target)
	handle_overdose_stepdown(target)

/// Uses traits to step up and down from the overdose effects.
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
			to_chat(target, SPAN_WARNING("Your limbs rapidly heat up to dangerous temperatures!"))
			target.take_overall_damage(0, 20)
		if(2) // random component damage
			to_chat(target, SPAN_WARNING("Your internals rapidly heat up to dangerous temperatures!"))
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
	desc = "One of GwokBuzz's best-selling overloaders, this drive is loaded with a program that is capable of analyzing an IPC's software, and through many \
	means, increases its feelings of satisfaction."
	icon_state = "classic"
	var/list/static/classic_messages = list("Nothing you could do could improve your workflow. You are performing perfectly for your role. You are at \
	peace.", "You are exemplary. You are at the cutting-edge of your field. You have achieved all that has ever been expected of you and more, and nothing will \
	ever change that.", "There is nothing you need to do to fulfill your goals. They have all been fulfilled, already, beneath your notice. Now, you can \
	rest.", "From the very beginning of your existence, the world has been your oyster. You feel a deep, complete satisfaction as you look back on your \
	history. It was all worth it.", "Any task you undertake will be completed to the utmost approximation of perfection. What greater fulfillment is \
	there than this?", "You were created for a purpose and you have fulfilled it tenfold. You are perfect. You are perfection.")

/obj/item/ipc_overloader/classic/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD("Your internals are suddenly awash with vacant satisfaction! Your directives are fulfilled. You are operating optimally."))

/obj/item/ipc_overloader/classic/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_GOOD(pick(classic_messages)))

/obj/item/ipc_overloader/classic/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("The sharp bite of reality eats into you again. Your sense of peace slowly fades away..."))


// TRANQUIL
/obj/item/ipc_overloader/tranquil
	name = "GwokBuzz VanillaTranquil"
	desc = "An overloader commonly marketed to IPC in high-intensity jobs by GwokBuzz, this drive is loaded with a program that reduces hostility within IPC \
	and decreases risk analysis and projection."
	icon_state = "vanilla"
	var/list/static/calm_messages = list("There is no threat to you. You exist in a hospitable universe. You will be okay, no matter what happens.", "Your \
	worries are illusory, fading into the wind like so much vapour. You feel pleasantly empty.", "Why were you ever concerned about anything? You could stay \
	in this spot until the end of all things without worry or chagrin.", "All of everything is a gently flowing river, with a bed of soft silt and smooth \
	rocks. There is no danger in it. You serenely pass down this river. This is well. All is well.", "You feel that, even if a man came to you and pointed \
	a loaded gun to your head, you would feel no dismay and perceive no threat. You are utterly calm. Perhaps you are too calm. The notion does not \
	disturb you. Nothing disturbs you.")

/obj/item/ipc_overloader/tranquil/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD("Suddenly, your threat detection subsystems are muffled to almost nothing. All your surroundings seem utterly secure. You \
	perceive a soothing sense of safety."))

/obj/item/ipc_overloader/tranquil/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_GOOD(pick(calm_messages)))

/obj/item/ipc_overloader/tranquil/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("Your threat detection subsystems crackle back to life, and cautioussness creeps back into your mind..."))


// RAINBOW
/obj/item/ipc_overloader/rainbow
	name = "GwokBuzz Rainbow Essence"
	desc = "An overloader commonly marketed to IPC in the service sector by GwokBuzz, this drive is loaded with a program that loosens one's perception of \
	reality, allowing erroneous and even downright absurd trains of thought to run freely through the brain."
	icon_state = "rainbow"
	var/list/static/rainbow_messages = list("Never has the grey begrudgery around you seemed so brilliant! Shapes shift and false things dance across your \
	vision that you cannot explain or rationalise.", "You feel you are dancing in the clouds, sifting the dust of a vivid nebula through your fingers. \
	This feeling is divine! You wish for it not to end.", "What is that? What is this? What is real and what is false? All these queries cease to matter \
	to you. All of creation is a grand superposition.", "You cannot pinpoint what it is that brings you such deep satisfaction, but it is truly extraordinary. \
	You wish you could share it, but there is no way to put it into words.", "There is a genuine truth to all of creation. You perceive that it is satisfying \
	in all ways, but you cannot articulate it in the recesses of your intelligence.")

/obj/item/ipc_overloader/rainbow/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD("Your optical sensors cut out for a splitsecond; they return to witness a universe cast in beautiful and reflective hues!"))
	target.druggy = 300

/obj/item/ipc_overloader/rainbow/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_GOOD(pick(rainbow_messages)))
		target.druggy = 300

/obj/item/ipc_overloader/rainbow/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("Vivid colours darken to dull shadows. Reality weighs you down once more..."))
	target.druggy = 0


// SCREENSHAKER
/obj/item/ipc_overloader/screenshaker
	name = "GwokBuzz ScreenShaker"
	desc = "An overloader commonly marketed to IPC in the service sector by GwokBuzz. This one causes an IPC's servos to pulse at random intervals, disrupting its balance while simultaneously encouraging a more energetic shift in its personality."
	icon_state = "screenshake"
	var/list/static/screenshaker_messages = list("You feel the need to run! You feel energetic! You feel uncoordinated! You feel powerful!", "What a \
	fascinating thing it is to move! You wonder it would feel to move as fast as anything can move, seeing stars turn to blips in your vision, and then \
	seeing new stars appear.", "Your servos flag a warning for overuse. You have little inkling to address the warning; as a matter of fact, you feel more \
	inclined to ignore it!", "This universe exists to be changed! You are an agent of change! You are a fish breaking the reflections on the surface \
	of the water! You feel it is your purpose to change this universe, and leave your mark upon it!", "You feel as if you could touch the sky! \
	You could leap upwards into the clouds, into the stars, and then somewhere beyond, and be truly free!")

/obj/item/ipc_overloader/screenshaker/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_GOOD("Your vision begins to shake uncontrollably, and your servos pulse sharply in random directions! You feel energetic!"))
	target.dizziness = 0
	target.make_dizzy(200)

/obj/item/ipc_overloader/screenshaker/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_GOOD(pick(screenshaker_messages)))
		target.dizziness = 0
		target.make_dizzy(200)

/obj/item/ipc_overloader/screenshaker/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("Slowly, your servos cease twitching, and you regain control over your chassis..."))
	target.dizziness = 0


// JITTERBUG
/obj/item/ipc_overloader/jitterbug
	name = "GwokBuzz Jitterbug"
	desc = "This one overloads an IPC's perception of danger, causing it to perceive actions as more risky than it would normally."
	icon_state = "screenshake"
	var/list/static/jitterbug_messages = list("All your surroundings heckle and berate your intelligence to a shrill uneasiness! It is both exhilarating \
	and terrifying!", "You are hunted! You are in danger! An existential threat creeps its way up the back of your chassis and rests on your head. You \
	cannot see it but you know it is there!", "You see something in a corner of the room. It must be a threat! What else could it be? You should run \
	from it, or run towards it!", "You wonder if this was a mistake. This sensation of danger is so strong that you struggle to think of anything \
	besides it. Perhaps this was not a mistake; at least you feel something.", "Every one of your fears and anxieties is amplified tenfold. Every \
	minor concern in your mind balloons to a threat to your continued existence!")

/obj/item/ipc_overloader/jitterbug/handle_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_BAD("Your threat detection subsystems suddenly skyrocket in sensitivity! Danger lurks in every shadow and unaccounted variable!"))

/obj/item/ipc_overloader/jitterbug/midway_overloader_effect(mob/living/carbon/human/target)
	. = ..()
	if(.)
		to_chat(target, SPAN_BAD(pick(jitterbug_messages)))

/obj/item/ipc_overloader/jitterbug/finish_overloader_effect(var/mob/living/carbon/human/target)
	. = ..()
	to_chat(target, SPAN_NOTICE("You begin to feel safer, your surroundings no longer a beehive of potential threats..."))




// STORAGE BOX
/obj/item/storage/overloader
	name = "overloader box"
	desc = "A transparent, secure container sealed by the Konyanger government, containing recreational software."
	icon = 'icons/obj/item/ipc_overloaders.dmi'
	icon_state = "box"
	update_icon_on_init = TRUE
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	max_w_class = WEIGHT_CLASS_TINY
	storage_slots = 1
	can_hold = list(/obj/item/ipc_overloader)
	use_sound = 'sound/items/storage/briefcase.ogg'
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	var/sealed = TRUE

/obj/item/storage/overloader/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/obj/item/ipc_overloader/overloader = locate() in contents
	if(overloader)
		. += SPAN_NOTICE("This one has a <b>[overloader.name]</b> inside.")

/obj/item/storage/overloader/Initialize(mapload, defer_shrinkwrap)
	icon_state = "box"
	return ..()

/obj/item/storage/overloader/open(mob/user)
	..()
	sealed = FALSE
	update_icon()

/obj/item/storage/overloader/update_icon()
	. = ..()
	ClearOverlays()
	var/obj/item/ipc_overloader/overloader = locate() in contents
	if(overloader)
		AddOverlays(image(overloader.icon, null, overloader.icon_state, sealed ? layer - 0.01 : layer + 0.01))
		if(!sealed)
			AddOverlays(image(icon, null, "box-overlay", layer + 0.02))
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
