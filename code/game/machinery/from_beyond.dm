/obj/machinery/from_beyond
	name = "resonance wave emissor"
	desc = "We see things only as we are constructed to see them."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano60"	//TODO: get unique sprites for this

	anchored = 0
	density = 1

	idle_power_usage = 1 KILOWATTS
	active_power_usage = 10 KILOWATTS

	var/active = FALSE
	var/static/list/whispers = list(
			"You hear something behind you.",
			"Endless eyes gaze upon you from above.",
			"All is gone.",
			"The light is slowly dying.",
			"This world is not yours, who are you?!",
			"Blasphemous whispers invade your thoughts.",
			"You hear a nasty ripping noise, as if flesh is being torn apart.",
			"All hope is lost.",
			"The abyss stares back at you.",
			"The rats, the rats in the walls!",
			"The air is filled with poisonous whispers and cruel truths.",
			"The stars are gone, all is void now.",
			"He comes...",
			"The end is near.",
			"You are all alone.",
			"You feel like a stranger in a strange land.",
			"The world crumbles under your feet.",
			"You see worlds that no other living men have seen.",
			"There is no escape..."
			)

/obj/machinery/from_beyond/attack_hand(var/mob/living/carbon/human/user as mob)

	if(!active)
		src.visible_message(SPAN_WARNING("[user] switches \the [src] on."))
		to_chat(user, SPAN_WARNING("The world beyond opens to your eyes."))
		active = TRUE

	else
		src.visible_message(SPAN_WARNING("[user] switches \the [src] off."))
		to_chat(user, SPAN_WARNING("The world beyond vanishes before your eyes."))
		active = FALSE

	update_icon()

/obj/machinery/from_beyond/update_icon()
	if(!(stat & NOPOWER))
		icon_state = "ano60"

	if(active)
		icon_state = "ano61"

	else
		icon_state = "ano60"

/obj/machinery/from_beyond/process()
	..()
	if(active)

		if(prob(25))
			for(var/obj/machinery/light/P in view(7, src))
				P.flicker(1)

		for(var/mob/living/carbon/human/L in view(7, src))
			L.see_invisible = SEE_INVISIBLE_CULT
			if(prob(15))
				var/message = pick(whispers)
				to_chat(L, SPAN_CULT("<b>[message]</b>"))
				L.hallucination += 50
				L.adjustBrainLoss(5, 55)

			if(prob(15))
				src.visible_message(SPAN_WARNING("\The [src] hums ominously."))

			if(prob(5))
				src.visible_message(SPAN_WARNING("\The [src] crackles with energy!"))
				playsound(src, 'sound/magic/lightningbolt.ogg', 40, 1)

			if(prob(1))
				to_chat(L, SPAN_CULT("<b>Reality feels less stable...</b>"))
				src.visible_message(SPAN_WARNING("\The [src] screeches loudly!"))
				playsound(src, 'sound/magic/dimensional_rend.ogg', 100, 1)
				new /obj/effect/gateway/active/rift(src.loc)


/obj/effect/gateway/active/rift
	name = "interdimensional rift"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "rift"
	light_range= 5
	light_color="#E260F4"
