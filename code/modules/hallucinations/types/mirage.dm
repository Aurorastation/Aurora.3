/datum/hallucination/mirage
	max_power = HAL_POWER_LOW
	duration = 120
	var/number = 3
	var/list/mirages = list()

/datum/hallucination/mirage/start()
	duration = rand(100, 150)
	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(holder, world.view+1))
		possible_points += F
	if(possible_points.len)
		for(var/i = 1; i <= number; i++)
			var/image/thing = generate_mirage()
			mirages += thing
			thing.loc = pick(possible_points)
		holder.client.images += mirages

/datum/hallucination/mirage/Destroy()
	if(holder.client)
		holder.client.images -= mirages
	. = ..()

/datum/hallucination/mirage/proc/generate_mirage()
	var/icon/T = new('icons/obj/trash.dmi')
	return image(T, pick(T.IconStates()), layer = OBJ_LAYER)

/datum/hallucination/mirage/end()
	if(holder.client)
		holder.client.images -= mirages
	..()


/datum/hallucination/mirage/bleeding
	min_power = HAL_POWER_LOW
	max_power = INFINITY
	duration = 350
	allow_duplicates = FALSE
	number = 4
	var/obj/item/organ/external/part = "chest"

/datum/hallucination/mirage/bleeding/start()
	number = min(round(holder.hallucination/10), 7)	//cap at 7 times for duration's sake
	for(var/i = 1; i <= number; i++)
		addtimer(CALLBACK(src, .proc/show_mirage), rand(30,50)*i)	//every 3 to 5 seconds
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		part = pick(H.organs)
	to_chat(holder, SPAN_DANGER("The flesh on your [part.name] splits open. It doesn't hurt, but the blood won't stop coming..."))


/datum/hallucination/mirage/bleeding/generate_mirage()
	var/image/I
	if(prob(min(holder.hallucination, 80)))
		I = image('icons/effects/blood.dmi', pick("mgibbl1", "mgibbl2", "mgibbl3", "mgibbl4", "mgibbl5", "mfloor6", "mfloor7"), layer = TURF_LAYER)
	else
		var/icon/T = new('icons/effects/drip.dmi')
		I = image(T, pick(T.IconStates()), layer = TURF_LAYER)
	I.color = holder.species?.blood_color
	return I


/datum/hallucination/mirage/bleeding/proc/show_mirage()
	var/image/thing = generate_mirage()
	mirages += thing
	thing.loc = get_turf(holder)
	holder.client.images += thing	//one at a time
	if(prob(20))
		var/list/message_picks = list("It won't stop, it won't stop...!", "You're feeling lightheaded...", "Your [part.name] won't stop gushing blood!", "The blood is everywhere!", "Everything around you is soaked with your blood...!")
		to_chat(holder, SPAN_DANGER(pick(message_picks)))


/datum/hallucination/mirage/bleeding/end()
	to_chat(holder, SPAN_WARNING("The flesh on your [part.name] suddenly appears whole again. You can't see the blood anymore, but the scent of it lingers heavily in the air."))
	..()



/datum/hallucination/mirage/horror
	min_power = HAL_POWER_HIGH
	max_power = INFINITY
	number = 1

/datum/hallucination/mirage/horror/start()
	..()
	to_chat(holder, SPAN_WARNING("The horror [pick("gnashes", "lunges", "shrieks")] at [holder]!"))

/datum/hallucination/mirage/horror/end()
	to_chat(holder, SPAN_WARNING("With a final shriek that seems to originate from within your mind, the entity fades away."))
	sound_to(holder, pick('sound/hallucinations/wail.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/effects/creepyshriek.ogg'))
	..()

/datum/hallucination/mirage/horror/generate_mirage()
	var/icon/T = new('icons/mob/npc/animal.dmi')
	return image(T, pick("abomination", "lesser_ling", "faithless", "otherthing"), layer = MOB_LAYER)



/datum/hallucination/mirage/carnage
	min_power = HAL_POWER_LOW
	max_power = INFINITY
	number = 10

/datum/hallucination/mirage/carnage/start()
	if(holder.hallucination >= HAL_POWER_HIGH)	//Heavily hallucinating will increase the amount of horrific carnage we witness
		number = 20
	..()

/datum/hallucination/mirage/carnage/generate_mirage()
	if(prob(50))
		var/image/I = image('icons/effects/blood.dmi', pick("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7"), layer = TURF_LAYER)
		var/list/blood_picks = list("#1D2CBF" = 0.1, "#E6E600" = 0.1, "#A10808" = 0.8)	//skrell, vaurca, human. most likely to pick regular red
		I.color = pickweight(blood_picks)
		return I
	else
		var/image/I = image('icons/obj/ammo.dmi', "s-casing-spent", layer = OBJ_LAYER)
		I.layer = TURF_LAYER
		I.dir = pick(alldirs)
		I.pixel_x = rand(-10,10)
		I.pixel_y = rand(-10,10)
		return I


/datum/hallucination/mirage/anomaly
	min_power = 40
	max_power = INFINITY
	number = 1

/datum/hallucination/mirage/anomaly/start()
	..()
	to_chat(holder, SPAN_WARNING("With a small crackle, the [pick("entity", "idol", "device")] manifests!"))
	sound_to(holder, 'sound/effects/stealthoff.ogg')

/datum/hallucination/mirage/anomaly/generate_mirage()
	var/istate = pick("ano01", "ano11", "ano21", "ano31", "ano41", "ano81", "ano121")
	var/image/I = image('icons/obj/xenoarchaeology.dmi', istate, layer = OBJ_LAYER)
	return I

/datum/hallucination/mirage/anomaly/end()
	to_chat(holder, SPAN_WARNING("With a loud zap, the [pick("entity", "idol", "device")] is sucked through a rift in bluespace!"))
	sound_to(holder, 'sound/effects/phasein.ogg')
	..()



/datum/hallucination/mirage/viscerator
	min_power = 40
	max_power = INFINITY
	number = 3

/datum/hallucination/mirage/viscerator/start()
	addtimer(CALLBACK(src, .proc/buzz), rand(30, 60))
	..()

/datum/hallucination/mirage/viscerator/generate_mirage()
	var/image/I = image('icons/mob/npc/aibots.dmi', "viscerator_attack", layer = OBJ_LAYER)
	return I

/datum/hallucination/mirage/viscerator/proc/buzz()
	to_chat(holder, "The viscerator buzzes at [holder].")



/datum/hallucination/mirage/eyes
	min_power = HAL_POWER_MED
	max_power = INFINITY
	number = 6

/datum/hallucination/mirage/eyes/start()
	if(holder.hallucination >= 100)
		number = 15
	..()

/datum/hallucination/mirage/eyes/generate_mirage()
	var/icon/T = new('icons/obj/eyes.dmi')
	return image(T, pick(T.IconStates()), layer = OBJ_LAYER)



/datum/hallucination/mirage/narsie
	min_power = 5000	//this level of hallucination is only possible on the 2 last stages of your mind breaking during cult conversions. Or admin fuckery
	max_power = INFINITY
	number = 1
	duration = 30

/datum/hallucination/mirage/narsie/generate_mirage()
	var/image/T = image('icons/obj/narsie.dmi', "narsie-small-chains", layer = MOB_LAYER+0.01)
	return T
