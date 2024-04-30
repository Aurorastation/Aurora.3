/obj/item/organ/internal/parasite/zombie
	name = BP_ZOMBIE_PARASITE
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "black_tumour"
	dead_icon = "black_tumour"

	organ_tag = BP_ZOMBIE_PARASITE
	parent_organ = BP_L_HAND
	stage_interval = 110
	drug_resistance = TRUE
	relative_size = 0
	status = ORGAN_ZOMBIFIED

	egg = /singleton/reagent/toxin/hylemnomil

	/// If the parasite is currently being cured by an antidote. Stops progression.
	var/curing = FALSE
	/// If the parasite has been cured. Stops the cure from happening twice.
	var/cured = FALSE
	/// Tracker for cure progress.
	var/cured_timer = 0
	/// The last world.time we were healed as a zombie.
	var/last_heal = 0
	/// The amount of seconds between each heal.
	var/heal_rate = 5 SECONDS

/obj/item/organ/internal/parasite/zombie/process()
	..()

	if(!owner)
		return

	if(owner.stat >= DEAD)
		return

	if(!iszombie(owner))
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(curing && !cured)
			cured_timer += 5
			switch(cured_timer)
				if(10 to 40)
					if(prob(10))
						to_chat(owner, SPAN_DANGER("The veins in your [E.name] feel like they're coming apart!"))
						E.add_pain(10)
				if(40 to 80)
					if(prob(10))
						to_chat(owner, SPAN_DANGER(FONT_HUGE("Your [E.name] is burning as the black veins start retreating!")))
						E.add_pain(25)
						if(E.status & ORGAN_ZOMBIFIED)
							E.add_pain(25)
							E.status &= ~ORGAN_ZOMBIFIED
							owner.update_body(TRUE, TRUE)
				if(90 to INFINITY)
					to_chat(owner, SPAN_DANGER(FONT_HUGE("Your head, your whole body starts burning up...!")))
					owner.Paralyse(20)
					owner.Stun(20)
					owner.adjustHalLoss(50)
					cured = TRUE
					addtimer(CALLBACK(src, PROC_REF(cure_infection)), 10 SECONDS)

			return

		if(stage < 2)
			if(prob(2))
				to_chat(owner, SPAN_WARNING("The skin on your [E.name] itches a bit."))

		if(stage >= 2)
			if(prob(2))
				to_chat(owner, SPAN_WARNING("Your stomach churns, and you feel sick. Something tries to come up your throat, but nothing comes out..."))
				owner.adjustHalLoss(5)

		if(stage >= 3)
			if(prob(10))
				to_chat(owner, SPAN_CULT("Every beat of your heart hurts - an aching, dull pain. Cold sweat continues falling down your brows. You feel like you have a fever..."))
				owner.nutrition = max(0, owner.nutrition - 10)
				owner.hydration = max(0, owner.hydration - 10)
				E.add_pain(20)

		if(stage >= 4)
			if(prob(10))
				if(!isundead(owner))
					if(owner.species.zombie_type)
						for(var/datum/language/L in owner.languages)
							owner.remove_language(L.name)
						owner.visible_message(SPAN_DANGER("<font size=4>[owner] falls to the ground and begins convulsing, their flesh turning green and rotting!</font>"))
						owner.seizure(FALSE, 5, 10, FALSE)
						addtimer(CALLBACK(src, PROC_REF(turn_into_zombie)), 5 SECONDS, TIMER_UNIQUE)
					else
						owner.adjustToxLoss(50)
	else
		if(length(owner.bad_external_organs) && last_heal + heal_rate < world.time)
			var/list/organs_to_heal = owner.bad_external_organs
			shuffle(organs_to_heal)
			for(var/thing in organs_to_heal)
				var/obj/item/organ/external/O = thing
				if(istype(O, /obj/item/organ/external/head)) // the head is the weak point
					continue
				var/healed = FALSE
				if(O.status & ORGAN_ARTERY_CUT)
					O.status &= ~ORGAN_ARTERY_CUT
					owner.visible_message(SPAN_WARNING("The severed artery in \the [owner]'s [O] stitches itself back together..."), SPAN_NOTICE("The severed artery in your [O] stitches itself back together..."))
					healed = TRUE
				else if((O.tendon_status() & TENDON_CUT) && O.tendon.can_recover())
					O.tendon.rejuvenate()
					owner.visible_message(SPAN_WARNING("The severed tendon in \the [owner]'s [O] stitches itself back together..."), SPAN_NOTICE("The severed tendon in your [O] stitches itself back together..."))
					healed = TRUE
				else if(O.status & ORGAN_BROKEN)
					var/list/brute_wounds = list()
					for(var/wound in O.wounds)
						var/datum/wound/W = wound
						if(W.damage_type in list(CUT, BRUISE, PIERCE))
							brute_wounds += W
					for(var/wound in brute_wounds)
						var/datum/wound/W = wound
						W.damage = max(min(W.damage, (O.min_broken_damage / length(brute_wounds))), 0)
					O.status &= ~ORGAN_BROKEN
					owner.visible_message(SPAN_WARNING("The shattered bone in \the [owner]'s [O] melds back together..."), SPAN_NOTICE("The shattered bone in your [O] melds back together..."))
					healed = TRUE
				if(healed)
					last_heal = world.time
					heal_rate += 2 SECONDS
					O.update_damages()
					break

		if(prob(10) && (owner.can_feel_pain()))
			to_chat(owner, "<span class='warning'>You feel a burning sensation on your skin!</span>")
			owner.make_jittery(10)

/obj/item/organ/internal/parasite/zombie/process_stage()
	if(stage >= 4)
		return
	var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
	if(iszombie(owner))
		if(parent_organ != BP_HEAD)
			var/obj/item/organ/external/head = owner.organs_by_name[BP_HEAD]
			move_to(owner, head, E)
			stage = 4
			return
	if(E.parent)
		to_chat(owner, SPAN_WARNING("The veins in your [E.name] turn black..."))
		E.status |= ORGAN_ZOMBIFIED
		move_to(owner, E.parent, E)
		owner.update_body(TRUE, TRUE)
	else
		if(parent_organ == BP_CHEST)
			to_chat(owner, SPAN_DANGER("<font size=4>Every vein in your chest turns black. Your heart becomes heavy. Each breath becomes fatigued. \
									You feel your own breathing. Cold sweat goes down your brows...</span>"))
			E.status |= ORGAN_ZOMBIFIED
			var/obj/item/organ/external/head = owner.organs_by_name[BP_HEAD]
			move_to(owner, head, E)
			owner.update_body(TRUE, TRUE)
	. = ..()
	E = owner.organs_by_name[parent_organ]
	if(E.limb_name == BP_GROIN)
		stage = 2
		stage_interval = 110

/obj/item/organ/internal/parasite/zombie/proc/move_to(mob/living/carbon/human/H, obj/item/organ/external/new_organ, obj/item/organ/external/old_organ)
	to_chat(H, SPAN_WARNING("The veins in your [new_organ.name] start turning black, bit by bit..."))
	parent_organ = new_organ.limb_name
	old_organ.internal_organs -= src
	replaced(H, new_organ)

/obj/item/organ/internal/parasite/zombie/proc/turn_into_zombie()
	var/r = owner.r_skin
	var/g = owner.g_skin
	var/b = owner.b_skin
	to_chat(owner, "<font size=4><span class='warning'>You feel your flesh burning as it rots, and your head exploding as the virus reaches it...</font></span>")
	to_chat(owner, "<font size=4><span class='cult'>All that is left is a cruel hunger for the flesh of the living, and the desire to spread this infection. You must consume all the living!</font></span>")
	owner.set_species(owner.species.zombie_type, 0, 0, 0)
	var/list/wakeup_sounds = list(
						'sound/effects/zombies/zombie_1.ogg',
						'sound/effects/zombies/zombie_2.ogg',
						'sound/effects/zombies/zombie_3.ogg',
						'sound/effects/zombies/zombie_4.ogg'
						)
	playsound(owner, pick(wakeup_sounds), 70)
	owner.change_skin_color(r, g, b)
	owner.update_dna()

/obj/item/organ/internal/parasite/zombie/proc/cure_infection()
	to_chat(owner, SPAN_GOOD(FONT_HUGE("...finally, relief. Your body starts cooling down. All your blackened veins go back to normal. It's over...")))
	for(var/obj/item/organ/external/E in owner.organs_by_name)
		if(E.status & ORGAN_ZOMBIFIED)
			E.status &= ~ORGAN_ZOMBIFIED
	owner.update_body(TRUE, TRUE)
	removed(owner)
	owner.adjustHalLoss(-50)
	qdel(src)
