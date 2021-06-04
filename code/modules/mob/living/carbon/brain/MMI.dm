#define STATE_EMPTY 0 // empty cradle
#define STATE_BRAIN 1 // brain in the cradle
#define STATE_NODIODES 2 // brain enclosed but no diodes connected
#define STATE_DIODES 3 // brain gets lobotomized at this step
#define STATE_SEALEDOFF 4 // sealed, but not yet activated
#define STATE_SEALEDON 5 // sealed and fully operation

/obj/item/device/mmi
	name = "man-machine interface"
	desc = "The delicate nature of organic brains required a more novel and permanent solution to the problem of just rotting in the old MMI cradles. Zeng-Hu's unique (and very proprietary) formaldehyde-analogue preservation solution was the key ingredient in what became the new Zeng-Hu/Hephaestus joint venture brain-cases."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi-empty"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/cradle_state = STATE_EMPTY
	var/can_be_ipc = FALSE
	var/mob/living/carbon/brain/brainmob = null	//The current occupant.
	var/obj/item/organ/internal/brain/brainobj = null	//The current brain organ.

	var/static/list/valid_brain_icon_states = list("brain", "brain_skrell", "brain_vaurca")

/obj/item/device/mmi/update_icon()
	underlays = null
	switch(cradle_state) // there's probably a way to optimize this to not need to regenerate the image, but this'll happen once a round every month or so? no reason to.
		if(STATE_EMPTY)
			icon_state = "mmi-empty"
		if(STATE_BRAIN)
			icon_state = "mmi-brain"
			underlays += image(icon, null, (brainobj.icon_state in valid_brain_icon_states) ? brainobj.icon_state : "brain")
		if(STATE_NODIODES)
			icon_state = "mmi-nodiodes"
			underlays += image(icon, null, (brainobj.icon_state in valid_brain_icon_states) ? brainobj.icon_state : "brain")
		if(STATE_DIODES)
			icon_state = "mmi-diodes"
			underlays += image(icon, null, (brainobj.icon_state in valid_brain_icon_states) ? brainobj.icon_state : "brain")
		if(STATE_SEALEDOFF)
			icon_state = "mmi-sealedoff"
		if(STATE_SEALEDON)
			icon_state = "mmi-sealedon"

/obj/item/device/mmi/proc/update_name()
	if(brainmob)
		name = "[initial(name)]: [brainmob.real_name]"
	else
		name = initial(name)

// todo maybe: if state is above or equal to state_sealedoff, allow using circular saw to bring it to empty state, but gib brain
/obj/item/device/mmi/attackby(obj/item/I, mob/user)
	switch(state)
		if(STATE_EMPTY)
			if(!brainmob && istype(I, /obj/item/organ/internal/brain)) //Time to stick a brain in it --NEO
				var/obj/item/organ/internal/brain/B = O
				if(!B.can_lobotomize)
					to_chat(user, SPAN_WARNING("\The [B] is incompatible with [src]!"))
					return
				if(B.health <= 0)
					to_chat(user, SPAN_WARNING("That brain is well and truly dead."))
					return
				else if(!B.brainmob)
					to_chat(user, SPAN_WARNING("You aren't sure where this brain came from, but you're pretty sure it's a useless brain."))
					return

				user.visible_message("<b>[user]</b> places \the [B] into \the [src].", SPAN_NOTICE("You place \the [B] into \the [src]."))

				brainmob = B.brainmob
				B.brainmob = null
				brainmob.forceMove(src)
				brainmob.container = src
				brainmob.stat = CONSCIOUS
				dead_mob_list -= brainmob //Update dem lists
				living_mob_list += brainmob

				brainobj = B
				user.drop_from_inventory(brainobj, src)

				state = STATE_BRAIN
				update_icon()
				update_name()
		if(STATE_NODIODES)
			if(I.isscrewdriver())
				// todo: add visible message of the user using screwdriver to plunge diodes into brain. if brain is lobotomized, unique message is shown
		if(STATE_DIODES)
			feedback_inc("cyborg_mmis_filled", 1)

/obj/item/device/mmi/attack_self(mob/user)
	if(state == STATE_BRAIN)
		to_chat(user, SPAN_NOTICE("You flip the case over \the [brainobj], getting it in place for diode insertion."))
		state = STATE_NODIODES
		update_icon()
	else if(state == STATE_NODIODES)
		to_chat(user, SPAN_NOTICE("You flip the case up, exposing \the [brainobj]."))
		state = STATE_BRAIN
		update_icon()

/obj/item/device/mmi/attack_hand(mob/user)
	if(brainobj && state == STATE_BRAIN && user.get_inactive_hand() == src)
		to_chat(user, SPAN_NOTICE("You remove \the [brainobj] from \the [src]."))
		user.put_in_hands(brainobj)
		brainmob.container = null //Reset brainmob mmi var.
		brainmob.forceMove(brainbj) //Throw mob into brain.
		living_mob_list -= brainmob //Get outta here
		brainobj.brainmob = brainmob //Set the brain to use the brainmob
		brainobj = null
		brainmob = null
		state = STATE_EMPTY
		update_icon()
		update_name()
		return
	return ..()

/obj/item/device/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	update_icon()
	update_name()
	locked = TRUE

/obj/item/device/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/device/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(brainmob)
		QDEL_NULL(brainmob)
	return ..()

/obj/item/device/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The delicate nature of organic brains required a more novel and permanent solution to the problem of just rotting in the old MMI cradles. Zeng-Hu's unique (and very proprietary) formaldehyde-analogue preservation solution was the key ingredient in what became the new Zeng-Hu/Hephaestus joint venture brain-cases. This one comes with a built-in radio."
	origin_tech = list(TECH_BIO = 4)

	var/obj/item/device/radio/radio = null//Let's give it a radio.

/obj/item/device/mmi/radio_enabled/Initialize()
	. = ..()
	radio = new(src)//Spawns a radio inside the MMI.
	radio.broadcasting = TRUE//So it's broadcasting from the start.

//Allows the brain to toggle the radio functions.
/obj/item/device/mmi/radio_enabled/verb/Toggle_Broadcasting()
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "MMI"
	set src = usr.loc //In user location, or in MMI in this case.
	set popup_menu = 0 //Will not appear when right clicking.

	if(brainmob.stat)//Only the brainmob will trigger these so no further check is necessary.
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.broadcasting = radio.broadcasting==1 ? 0 : 1
	to_chat(brainmob, "<span class='notice'>Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting.</span>")

/obj/item/device/mmi/radio_enabled/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = 0

	if(brainmob.stat)
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.listening = radio.listening==1 ? 0 : 1
	to_chat(brainmob, "<span class='notice'>Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast.</span>")

/obj/item/device/mmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(0,10)
	..()

/obj/item/device/mmi/digital/Initialize(mapload, ...)
	. = ..()
	brainmob = new(src)
	brainmob.add_language(LANGUAGE_EAL)
	brainmob.stat = CONSCIOUS
	brainmob.container = src
	brainmob.silent = 0

/obj/item/device/mmi/digital/transfer_identity(var/mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.stat = CONSCIOUS
	if(H.mind)
		H.mind.transfer_to(brainmob)

#undef STATE_EMPTY
#undef STATE_BRAIN
#undef STATE_NODIODES
#undef STATE_DIODES
#undef STATE_SEALEDOFF
#undef STATE_SEALEDON