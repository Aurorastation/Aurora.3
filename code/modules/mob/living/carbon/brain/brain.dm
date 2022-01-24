//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain"
	accent = ACCENT_TTS

/mob/living/carbon/brain/Initialize()
	. = ..()
	add_language(LANGUAGE_TCB)
	set_default_language(all_languages[LANGUAGE_TCB])

/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	container = null
	return ..()

/mob/living/carbon/brain/IsAdvancedToolUser() // to be able to use weapons when piloting a hardsuit
	return TRUE

/mob/living/carbon/brain/update_canmove()
	if(istype(loc, /obj/item/device/mmi))
		canmove = 1
		use_me = 1
	else
		canmove = 0

	return canmove