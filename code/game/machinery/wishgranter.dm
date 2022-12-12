/obj/machinery/wish_granter
	name = "Wish Granter"
	desc = "You are not so sure about this anymore..."
	icon = 'icons/obj/machines/wishgranter.dmi' //thanks cakeisossim for the sprites
	icon_state = "wishgranter"

	light_color = "#458F94"
	light_power = 3
	light_range = 4

	anchored = 1
	density = 1
	layer = 9
	use_power = POWER_USE_OFF

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter/attack_hand(var/mob/living/carbon/human/user as mob)
	usr.set_machine(src)

	if(chargesa <= 0)
		to_chat(user, "The Wish Granter lies silent.")
		return

	else if(!istype(user, /mob/living/carbon/human))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away.")

	else if (!insistinga)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insistinga++

	else
		chargesa--
		insistinga = 0
		var/wish = input("You want...","Wish") as null|anything in list("I want to rule the station","I want to be rich","I want immortality","The station is corrupt, it must be destroyed","I want peace")
		switch(wish)
			if("I want to rule the station")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				if (NOT_FLAG(user.mutations, HULK))
					user.mutations |= HULK
					to_chat(user, SPAN_NOTICE("Your muscles hurt."))
				if (NOT_FLAG(user.mutations, LASER_EYES))
					user.mutations |= LASER_EYES
					to_chat(user, SPAN_NOTICE("You feel pressure building behind your eyes."))
				if (NOT_FLAG(user.mutations, COLD_RESISTANCE))
					user.mutations |= COLD_RESISTANCE
					to_chat(user, SPAN_NOTICE("Your body feels warm."))
				if (NOT_FLAG(user.mutations, XRAY))
					user.mutations |= XRAY
					user.set_sight(user.sight|SEE_MOBS|SEE_OBJS|SEE_TURFS)
					user.set_see_in_dark(8)
					user.set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
					to_chat(user, SPAN_NOTICE("The walls suddenly disappear."))
				user.set_species(SPECIES_REVENANT)
				user.mind.special_role = "Avatar of the Wish Granter"
			if("I want to be rich")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your greediness, claiming your soul and warping your body to match the darkness in your heart.")
				new /obj/structure/closet/syndicate/resources/everything(loc)
				user.set_species(SPECIES_REVENANT)
				user.mind.special_role = "Avatar of the Wish Granter"
			if("I want immortality")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				user.verbs += /mob/living/carbon/proc/immortality
				user.set_species(SPECIES_SKELETON)
				user.mind.special_role = "Avatar of the Wish Granter"
			if("The station is corrupt, it must be destroyed")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your wickedness, claiming your soul and slaving you to its own dark purposes.")
				user.mind.special_role = "Avatar of the Wish Granter"
				user.hallucination += 10
				user.adjustBrainLoss(30, 50) //shouldn't kill you
				user.emote("scream")
				playsound(user, 'sound/hallucinations/wail.ogg', 40, 1)
				sleep(30)
				to_chat(user, "<span class='warning'>Your mind is assaulted by endless horrors, your only desire is to end it, you must fulfill the Wish Granter's desires!</span>")
				var/datum/objective/nuclear/nuclear = new
				nuclear.owner = user.mind
				user.mind.objectives += nuclear
				var/obj_count = 1
				for(var/datum/objective/OBJ in user.mind.objectives)
					to_chat(user, "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]")
					obj_count++
				for(var/obj/machinery/nuclearbomb/station/N in SSmachinery.machinery)
					to_chat(user, "<span class='warning'>[N.r_code]...!</span>")
					user.mind.store_memory("<B>Nuclear Bomb Code</B>: [N.r_code]", 0, 0)
			if("I want peace")
				to_chat(user, "<B>Your wish is granted...</B>")
				to_chat(user, "Everything lies silently and then the station, its crew and troubles are gone in a blink of light. You found peace at last.")
				user.sdisabilities += BLIND
				user.sdisabilities += DEAF
				user.mind.special_role = "Avatar of the Wish Granter"
				chargesa = 1

/////For the Wishgranter///////////

/mob/living/carbon/proc/immortality()
	set category = "Abilities"
	set name = "Resurrection"
	set desc = "Rise from your grave."

	var/mob/living/carbon/C = usr
	if(!C.stat)
		to_chat(C, "<span class='notice'>You're not dead yet!</span>")
		return
	to_chat(C, "<span class='notice'>Death is not your end!</span>")
	C.verbs -= /mob/living/carbon/proc/immortality

	spawn(rand(400,800))
		if(C.stat == DEAD)
			dead_mob_list -= C
			living_mob_list += C
		C.stat = CONSCIOUS
		C.revive()
		C.reagents.clear_reagents()
		to_chat(C, "<span class='notice'>You have regenerated.</span>")
		C.visible_message("<span class='warning'>[usr] appears to wake from the dead, having healed all wounds.</span>")
		C.update_canmove()
		C.verbs += /mob/living/carbon/proc/immortality
	return 1
