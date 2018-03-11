//Brain traumas that are rare and/or somewhat beneficial;
//they are the easiest to cure, which means that if you want
//to keep them, you can't cure your other traumas
/datum/brain_trauma/special

/datum/brain_trauma/special/bluespace_prophet
	name = "Bluespace Prophecy"
	desc = "Patient can sense the bob and weave of bluespace around them, showing them passageways no one else can see."
	scan_desc = "bluespace attunement"
	gain_text = "<span class='notice'>You feel the bluespace pulsing around you...</span>"
	lose_text = "<span class='warning'>The faint pulsing of bluespace fades into silence.</span>"
	var/next_portal = 0
	cure_type = CURE_SURGERY

/datum/brain_trauma/special/bluespace_prophet/on_life()
	if(world.time > next_portal)
		next_portal = world.time + 100
		var/list/turf/possible_turfs = list()
		for(var/turf/T in range(owner, 8))
			if(!T.density)
				var/clear = TRUE
				for(var/obj/O in T)
					if(O.density)
						clear = FALSE
						break
				if(clear)
					possible_turfs += T

		if(!LAZYLEN(possible_turfs))
			return

		var/turf/first_turf = pick(possible_turfs)
		if(!first_turf)
			return

		possible_turfs -= (possible_turfs & range(first_turf, 3))

		var/turf/second_turf = pick(possible_turfs)
		if(!second_turf)
			return

		var/obj/effect/bluespace_stream/first = new(first_turf, owner)
		var/obj/effect/bluespace_stream/second = new(second_turf, owner)

		first.linked_to = second
		second.linked_to = first
		first.seer = owner
		second.seer = owner

/obj/effect/bluespace_stream
	name = "bluespace stream"
	desc = "You see a hidden pathway through bluespace..."
	var/image_icon = 'icons/effects/effects.dmi'
	var/image_state = "bluestream"
	var/image_layer = 4.1
	invisibility = INVISIBILITY_OBSERVER
	var/obj/effect/bluespace_stream/linked_to
	var/mob/living/carbon/seer
	var/mob/living/carbon/target = null
	var/image/current_image = null

/obj/effect/bluespace_stream/Initialize(mapload, var/mob/living/carbon/T)
	. = ..()
	target = T
	current_image = GetImage()
	if(target.client)
		target.client.images |= current_image
	QDEL_IN(src, 300)

/obj/effect/bluespace_stream/proc/GetImage()
	var/image/I = image(image_icon,src,image_state,image_layer,dir=src.dir)
	return I

/obj/effect/overlay/temp/bluespace_fissure
	name = "bluespace fissure"
	icon_state = "bluestream_fade"
	duration = 9

/obj/effect/bluespace_stream/attack_hand(mob/user)
	if(user != seer || !linked_to)
		return
	var/slip_in_message = pick("slides sideways in an odd way, and disappears", "jumps into an unseen dimension",\
		"sticks one leg straight out, wiggles their foot, and is suddenly gone", "stops, then blinks out of reality", \
		"is pulled into an invisible vortex, vanishing from sight")
	var/slip_out_message = pick("silently fades in", "leaps out of thin air","appears", "walks out of an invisible doorway",\
		"slides out of a fold in spacetime")
	to_chat(user, "<span class='notice'>You try to align with the bluespace stream...</span>")
	if(do_after(user, 20))
		new /obj/effect/overlay/temp/bluespace_fissure(get_turf(src))
		new /obj/effect/overlay/temp/bluespace_fissure(get_turf(linked_to))
		user.forceMove(get_turf(linked_to))
		user.visible_message("<span class='warning'>[user] [slip_in_message].</span>", ignored_mob = user)
		user.visible_message("<span class='warning'>[user] [slip_out_message].</span>", "<span class='notice'>...and find your way to the other side.</span>")