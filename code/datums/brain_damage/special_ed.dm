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

/datum/brain_trauma/special/love
	name = "Hyper-dependency"
	desc = "Patient feels lovesick and is emotionally dependent to a specific person."
	scan_desc = "severe dependency"
	gain_text = ""
	lose_text = "<span class='notice'>You feel love leave your heart.</span>"
	var/stress = 0
	var/datum/weakref/beloved = null
	cure_type = CURE_HYPNOSIS

/datum/brain_trauma/special/love/on_gain()
	..()
	for(var/mob/living/L in view(7,owner))
		if(L != owner)
			beloved = L
			break
	if(beloved)
		to_chat(owner, "<span class='notice'>You can't help but love [beloved]. You can't bear to be apart from them, and would do anything they say.</span>")

	else
		to_chat(owner, "<span class='notice'>You feel a brief burst of passion, but it quickly fades.</span>")
		qdel()

/datum/brain_trauma/special/love/on_life()
	..()
	if(check_alone())
		stress = min(stress + 0.5, 100)
		if(stress > 10 && (prob(10)))
			stress_reaction()
	else
		stress = max(0, stress - 4)
		if(prob(5) && stress > 0)
			var/mushy = pick("You feel so good when [beloved] is with you.","You can't believe you ever lived without [beloved].","You'd do anything for [beloved].","[beloved] makes everything better.","You can never let [beloved] leave again.")
			to_chat(owner, "<span class='notice'>[mushy]</span>")

/datum/brain_trauma/special/love/proc/check_alone()
	if(owner.disabilities & BLIND)
		return TRUE

	for(var/mob/living/L in view(owner, 7))
		if(L == beloved)
			return FALSE

	return TRUE

/datum/brain_trauma/special/love/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1,6))
		if(1)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>You feel sick...</span>")
			else
				to_chat(owner, "<span class='warning'>You feel really sick at the thought of being seperated from [beloved]!</span>")
			addtimer(CALLBACK(owner, /mob/living/carbon.proc/vomit, high_stress), 50) //blood vomit if high stress
		if(2)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>You can't stop shaking...</span>")
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
			else
				to_chat(owner, "<span class='warning'>You feel weak and scared! If only [beloved] was here!</span>")
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
				owner.adjustHalLoss(50)

		if(3, 4)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>You feel really lonely without [beloved]...</span>")
			else
				to_chat(owner, "<span class='warning'>You're going mad with loneliness! You need [beloved]!</span>")
				owner.hallucination += 20

		if(5)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Your heart skips a beat. Oh, [beloved]!</span>")
				owner.adjustOxyLoss(8)
			else
				if(prob(15) && ishuman(owner))
					var/mob/living/carbon/human/H = owner
					var/obj/item/organ/heart/heart = H.internal_organs_by_name["heart"]
					heart.take_damage(heart.min_bruised_damage)
					to_chat(H, "<span class='danger'>You feel a stabbing pain in your heart!</span>")
				else
					to_chat(owner, "<span class='danger'>You feel your heart lurching in your chest... Oh, [beloved]!</span>")
					owner.adjustOxyLoss(8)