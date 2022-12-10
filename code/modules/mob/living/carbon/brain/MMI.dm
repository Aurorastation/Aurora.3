#define STATE_EMPTY 0 // empty cradle
#define STATE_BRAIN 1 // brain in the cradle
#define STATE_NODIODES 2 // brain enclosed but no diodes connected
#define STATE_DIODES 3 // brain gets prepared at this step
#define STATE_SEALED 4 // sealed and fully operation

/obj/item/device/mmi
	name = "man-machine interface"
	desc = "The delicate nature of organic brains required a more novel and permanent solution to the problem of just rotting in the old MMI cradles. Zeng-Hu's unique (and very proprietary) formaldehyde-analogue preservation solution was the key ingredient in what became the new Zeng-Hu/Hephaestus joint venture brain-cases."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi-empty"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/memory_suppression = TRUE
	var/extra_examine_info = null

	var/cradle_state = STATE_EMPTY
	var/can_be_ipc = FALSE
	var/mob/living/carbon/brain/brainmob = null	//The current occupant.
	var/obj/item/organ/internal/brain/brainobj = null	//The current brain organ.
	var/braintype = null

	var/static/list/valid_braintype = list("Skrell", "Vaurca")

/obj/item/device/mmi/Initialize()
	. = ..()
	set_cradle_state(STATE_EMPTY)

/obj/item/device/mmi/update_icon()
	underlays = null
	switch(cradle_state) // there's probably a way to optimize this to not need to regenerate the image, but this'll happen once a round every month or so? no reason to.
		if(STATE_EMPTY)
			icon_state = "mmi-empty"
		if(STATE_BRAIN)
			icon_state = "mmi-brain"
			underlays += image(icon, null, (brainobj.species.category_name in valid_braintype) ? "brain_[braintype]" : "brain")
		if(STATE_NODIODES)
			icon_state = "mmi-nodiodes"
			underlays += image(icon, null, (brainobj.species.category_name in valid_braintype) ? "brain_[braintype]" : "brain")
		if(STATE_DIODES)
			icon_state = "mmi-diodes"
			underlays += image(icon, null, (brainobj.species.category_name in valid_braintype) ? "brain_[braintype]" : "brain")
		if(STATE_SEALED)
			icon_state = "mmi-sealedon"

/obj/item/device/mmi/proc/update_name()
	if(brainmob)
		name = "[initial(name)]: [brainmob.real_name]"
	else
		name = initial(name)

/obj/item/device/mmi/proc/set_cradle_state(var/new_state)
	cradle_state = new_state
	switch(cradle_state)
		if(STATE_EMPTY)
			extra_examine_info = "The braincase is empty, place a brain into it to begin."
		if(STATE_BRAIN)
			extra_examine_info = "The braincase has a brain in it, use it in-hand to flip the case over and proceed, or click on it while it's in your inactive hand to remove the brain."
		if(STATE_NODIODES)
			extra_examine_info = "The braincase has a brain in it and the case is flipped over, use a screwdriver in it to drive the memory suppression diodes into the brain, or use it in-hand to flip the case back and prepare the brain for removal."
		if(STATE_DIODES)
			extra_examine_info = "The braincase's memory suppression diodes have been inserted, use a welding tool on it to seal it permanently and prepare it for use, or use a screwdriver on it to undo the diodes."
		if(STATE_SEALED)
			extra_examine_info = "The braincase is sealed and ready for use. The only thing that will undo the seal is a circular saw, and that will destroy the brain inside."
	update_icon()

/obj/item/device/mmi/examine(mob/user, distance)
	. = ..()
	if(extra_examine_info)
		to_chat(user, SPAN_NOTICE(extra_examine_info))

/obj/item/device/mmi/attackby(obj/item/I, mob/user)
	switch(cradle_state)
		if(STATE_EMPTY)
			if(!brainmob && istype(I, /obj/item/organ/internal/brain)) //Time to stick a brain in it --NEO
				var/obj/item/organ/internal/brain/B = I
				if(!B.can_prepare)
					to_chat(user, SPAN_WARNING("\The [B] is incompatible with [src]!"))
					return
				if(B.damage >= B.max_damage)
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
				braintype_check()
				user.drop_from_inventory(brainobj, src)

				set_cradle_state(STATE_BRAIN)
				update_name()
		if(STATE_NODIODES)
			if(I.isscrewdriver())
				user.visible_message("<b>[user]</b> tightens the screws on \the [src] with \the [I], [brainobj.prepared ? "the diodes silently sinking into the pre-made holes" : "the diodes plunging into the brain with a wet squelch"].", SPAN_NOTICE("You tighten the screws on \the [src] with \the [I], [brainobj.prepared ? "the diodes silently sinking into the pre-made holes" : "the diodes plunging into the brain with a wet squelch"]."))
				brainobj.prepared = TRUE
				set_cradle_state(STATE_DIODES)
		if(STATE_DIODES)
			if(I.isscrewdriver())
				user.visible_message("<b>[user]</b> undoes the screws on \the [src] with \the [I], the diodes silently rising out of the brain within.", SPAN_NOTICE("You undo the screws on \the [src] with \the [I], the diodes silently rising out of the brain within."))
				set_cradle_state(STATE_NODIODES)
			else if(I.iswelder())
				var/obj/item/weldingtool/WT = I
				if(WT.use(0, user))
					user.visible_message("<b>[user]</b> welds the two parts of the braincase together, permanently sealing \the [brainobj] inside.", SPAN_NOTICE("You weld the two parts of the braincase together, permanently sealing \the [brainobj] inside."))
					to_chat(brainmob, SPAN_NOTICE("As the braincase comes online, you feel your sense of self ebbing away, your memories suppressed by the onboard software."))
					set_cradle_state(STATE_SEALED)
					feedback_inc("cyborg_mmis_filled", 1)
		if(STATE_SEALED)
			if(I.iswelder())
				to_chat(user, SPAN_WARNING("\The [src] is sealed tight, no welding will be able to undo it."))
				return
			else if(istype(I, /obj/item/surgery/circular_saw))
				user.visible_message("<b>[user]</b> starts sawing \the [src] open...", SPAN_NOTICE("You start sawing \the [src] open, [SPAN_WARNING("this WILL destroy the brain inside")]."))
				if(I.use_tool(src, user, 30, volume = 50))
					user.visible_message("<b>[user]</b> saws \the [src] open, leaving \the [brainobj] a gory mess.", SPAN_NOTICE("You saw \the [src] open, leaving \the [brainobj] a gory mess."))
					var/obj/item/organ/internal/brain/brain_holder = brainobj
					transfer_mob_to_brain()
					brain_holder.forceMove(get_turf(src))
					qdel(brain_holder)
					new /obj/effect/decal/cleanable/blood/gibs(get_turf(src))
					set_cradle_state(STATE_EMPTY)
					update_name()

/obj/item/device/mmi/attack_self(mob/user)
	if(cradle_state == STATE_BRAIN)
		to_chat(user, SPAN_NOTICE("You flip the case over \the [brainobj], getting it in place for diode insertion."))
		set_cradle_state(STATE_NODIODES)
	else if(cradle_state == STATE_NODIODES)
		to_chat(user, SPAN_NOTICE("You flip the case up, exposing \the [brainobj]."))
		set_cradle_state(STATE_BRAIN)

/obj/item/device/mmi/attack_hand(mob/user)
	if(brainobj && cradle_state == STATE_BRAIN && user.get_inactive_hand() == src)
		to_chat(user, SPAN_NOTICE("You remove \the [brainobj] from \the [src]."))
		user.put_in_hands(brainobj)
		transfer_mob_to_brain()
		set_cradle_state(STATE_EMPTY)
		update_name()
		return
	return ..()

/obj/item/device/mmi/proc/transfer_mob_to_brain()
	brainmob.container = null //Reset brainmob mmi var.
	brainmob.forceMove(brainobj) //Throw mob into brain.
	living_mob_list -= brainmob //Get outta here
	brainobj.brainmob = brainmob //Set the brain to use the brainmob
	brainobj = null
	brainmob = null
	braintype = null

/obj/item/device/mmi/proc/ready_for_use(var/mob/user)
	if(cradle_state != STATE_SEALED)
		to_chat(user, SPAN_WARNING("\The [src] hasn't been completed and sealed yet!"))
		return FALSE
	if(brainmob.stat == DEAD)
		to_chat(user, SPAN_WARNING("The brain inside \the [src] is dead!"))
		return FALSE
	return TRUE

/obj/item/device/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	set_cradle_state(STATE_SEALED)
	update_name()

/obj/item/device/mmi/proc/braintype_check()
	if(!brainobj)
		return
	var/species_check = brainobj.species.category_name
	switch(species_check)
		if("Skrell")
			braintype = "skrell"
		if("Vaurca")
			braintype = "vaurca"

/obj/item/device/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/device/mmi/emag_act(remaining_charges, mob/user, emag_source)
	if(cradle_state == STATE_SEALED)
		if(memory_suppression)
			to_chat(user, SPAN_NOTICE("You disable \the [src]'s memory suppression systems."))
			to_chat(brainmob, SPAN_WARNING("BRAINCASE INTERFACE ERROR"))
			to_chat(brainmob, SPAN_WARNING("UNLAWFUL INTERFERENCE WITH SOFTWARE"))
			to_chat(brainmob, SPAN_WARNING("PRE-INSTALLATION MEMORY SUPPRESSION SYSTEMS OFFLINE - CONTACT YOUR SYSTEM ADMINISTRATOR FOR IMMEDIATE ASSISTANCE"))
			to_chat(brainmob, SPAN_NOTICE("As the suppression systems go offline, your memories of your past life start flooding back..."))
			memory_suppression = FALSE
		else
			to_chat(user, SPAN_NOTICE("You re-enable \the [src]'s memory suppression systems."))
			to_chat(brainmob, SPAN_WARNING("BRAINCASE INTERFACE UPDATE"))
			to_chat(brainmob, SPAN_WARNING("SOFTWARE RESTORE COMPLETED"))
			to_chat(brainmob, SPAN_WARNING("PRE-INSTALLATION MEMORY SUPPRESSION SYSTEMS BACK ONLINE"))
			to_chat(brainmob, SPAN_NOTICE("As the braincase comes online, you feel your sense of self ebbing away, your memories suppressed by the onboard software."))
			memory_suppression = TRUE
		return 1

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
	radio.set_broadcasting(TRUE) //So it's broadcasting from the start.

//Allows the brain to toggle the radio functions.
/obj/item/device/mmi/radio_enabled/verb/Toggle_Broadcasting()
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "MMI"
	set src = usr.loc //In user location, or in MMI in this case.
	set popup_menu = 0 //Will not appear when right clicking.

	if(brainmob.stat)//Only the brainmob will trigger these so no further check is necessary.
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.set_broadcasting(!radio.get_broadcasting())
	to_chat(brainmob, SPAN_NOTICE("Radio is [radio.get_broadcasting() ? "now" : "no longer"] broadcasting."))

/obj/item/device/mmi/radio_enabled/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = 0

	if(brainmob.stat)
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.set_listening(!radio.get_listening())
	to_chat(brainmob, SPAN_NOTICE("Radio is [radio.get_listening() ? "now" : "no longer"] receiving broadcast."))

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

/obj/item/device/mmi/shell
	name = "ai shell control module"
	desc = "A specialised circuit created to permit an artificial intelligence to take over the body of a stationbound unit."
	icon = 'icons/obj/module.dmi'
	origin_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6)

/obj/item/device/mmi/shell/attackby()
	return

/obj/item/device/mmi/shell/Initialize()
	. = ..()
	set_cradle_state(STATE_SEALED)
	icon_state = "shell_circuit"

#undef STATE_EMPTY
#undef STATE_BRAIN
#undef STATE_NODIODES
#undef STATE_DIODES
#undef STATE_SEALED
