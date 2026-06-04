/obj/item/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 50)
	var/listening = FALSE
	var/recorded //the activation message

/obj/item/assembly/voice/Initialize(mapload, ...)
	. = ..()
	become_hearing_sensitive()

/obj/item/assembly/voice/Destroy()
	return ..()

/obj/item/assembly/voice/hear_talk(mob/living/M, msg)
	if(listening)
		recorded = msg
		listening = FALSE
		var/turf/T = get_turf(src) //otherwise it won't work in hand
		T.audible_message("[icon2html(src, viewers(get_turf(T)))] beeps, \"Activation message is '[recorded]'.\"")
	else
		if(findtext(msg, recorded))
			pulse(FALSE)

/obj/item/assembly/voice/activate()
	if(secured && !holder)
		listening = !listening
		var/turf/T = get_turf(src)
		T.audible_message("[icon2html(src, viewers(get_turf(T)))] beeps, \"[listening ? "Now" : "No longer"] recording input.\"")

/obj/item/assembly/voice/attack_self(mob/user)
	if(!user)
		return FALSE
	activate()
	return TRUE

/obj/item/assembly/voice/toggle_secure()
	. = ..()
	listening = FALSE
