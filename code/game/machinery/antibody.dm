#define MAX_STAGES 3

/obj/machinery/antibody_extractor
	name = "antibody extractor"
	desc = "A machine made to extract antibodies. There's a holographic info-label on it..."
	desc_extended = "This machine is made to extract antibodies from a subject. It will only work with the <b>unmutated, original</b> version of the virus."
	icon = 'icons/obj/machinery/extractor.dmi'
	icon_state = "extractor"
	anchored = TRUE
	can_buckle = list(/mob/living/carbon/human)
	/// If the machine is currently under use.
	var/working = FALSE
	/// Current stage.
	var/stage = 0
	/// Current progress to the next stage.
	var/cure_progress = 0
	/// Threshold to the next stage.
	var/stage_threshold = 100
	/// The person from which the cure is being extracted.
	var/mob/living/carbon/human/occupant

/obj/machinery/antibody_extractor/Destroy()
	occupant = null
	return ..()

/obj/machinery/antibody_extractor/attack_hand(mob/user)
	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is totally unresponsive while processing the cure!"))
		return

	if(user == occupant)
		to_chat(user, SPAN_WARNING("The buckles stop you from doing much at all."))
		..()
		return FALSE

	if(!user.use_check_and_message())
		return FALSE

	if(occupant)
		var/is_infected = FALSE
		if(occupant.organs_by_name[BP_ZOMBIE_PARASITE])
			is_infected = TRUE
		if(!is_infected)
			to_chat(user, SPAN_WARNING("\The [src] beeps in disapproval. The error message says something along the lines of needing a patient infected with \
										Hylemnomil-Zeta."))
			return ..()
		var/time_to_die = tgui_alert(user, "Are you sure?", "Begin Antibody Creation", list("Yes", "No"))
		if(time_to_die == "Yes")
			user.visible_message(SPAN_WARNING("[user] starts fiddling with \the [src]'s controls..."))
			if(do_after(user, 5 SECONDS, src))
				user.visible_message(SPAN_WARNING(FONT_HUGE("[user] activates \the [src] as it begins rumbling!")))
				working = TRUE
				stage = 1
				log_and_message_admins("has begun antibody extraction", usr, get_turf(src))
				to_chat(occupant, SPAN_CULT(FONT_HUGE("You are locked by bindings into \the [src] and your arm is stabbed by a needle!")))
				playsound(src, 'sound/effects/lingextends.ogg', 30)

/obj/machinery/antibody_extractor/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!working)
		. += "It's inactive, and beeping ominously every now and then."
	switch(stage)
		if(1)
			. += SPAN_WARNING("It's sucking dark, almost black blood, from the arm of [occupant] into a container.")
		if(2)
			. += SPAN_DANGER("More and more dark, black blood is being collected and centrifuged.")
		if(3)
			. += SPAN_CULT("The dark, black blood is slowly being treated and filtered into a shiny, white substance...")

/obj/machinery/antibody_extractor/process()
	if(working)
		icon_state = "extractor-active"
		if(stage < MAX_STAGES+1)
			if(cure_progress > stage*stage_threshold)
				playsound(src, 'sound/effects/lingextends.ogg', 30)
				stage++
			cure_progress += 5

			switch(stage)
				if(1)
					if(prob(25))
						to_chat(occupant, SPAN_DANGER(FONT_HUGE("Your blood is being sucked out of you - the pain is unbearable!")))
						occupant.adjustHalLoss(10)
						if(prob(10))
							occupant.emote("whimper")
				if(2)
					if(prob(25))
						to_chat(occupant, SPAN_DANGER(FONT_HUGE("Your arm feels like it's being torn apart as the needle digs further and further inside!")))
						occupant.adjustHalLoss(15)
						if(prob(5))
							occupant.emote("scream")
				if(3)
					if(prob(25))
						to_chat(occupant, SPAN_DANGER(FONT_HUGE("You feel like you're going to die any second now!")))
						occupant.adjustHalLoss(20)
						if(prob(10))
							occupant.emote("scream")
		else
			if(occupant)
				visible_message(SPAN_CULT(FONT_HUGE("\The [src] finishes working and, with a click, releases [occupant] from their bindings. It helpfully dispenses \
								a vial of shining white liquid...")))
				unbuckle()
				new /obj/item/reagent_containers/glass/beaker/vial/antidote(get_turf(src))
				playsound(src, 'sound/machines/weapons_analyzer_finish.ogg', 30)
			working = FALSE
			stage = 0
			cure_progress = 0
			icon_state = "extractor"

/obj/machinery/antibody_extractor/ex_act(severity)
	return

/obj/machinery/antibody_extractor/post_buckle(mob/living/carbon/human/H)
	if(H.buckled_to == src)
		occupant = H
	playsound(src, 'sound/effects/buckle.ogg', 30)

/obj/machinery/antibody_extractor/user_unbuckle(mob/user)
	if(working)
		to_chat(user, SPAN_WARNING("The buckles are too tight! There's no way out for [occupant]!"))
		return
	. = ..()
	occupant = null

/obj/machinery/antibody_extractor/relaymove(mob/user as mob)
	if (user.stat)
		return
	if(working)
		to_chat(user, SPAN_DANGER("The bindings are keeping you locked in place!"))
		return
	. = ..()

#undef MAX_STAGES
