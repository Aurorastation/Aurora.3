/obj/machinery/wish_granter
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	use_power = 0
	anchored = 1
	density = 1

	var/charges = 1
	var/insisting = 0

/obj/machinery/wish_granter/attack_hand(var/mob/user as mob)
	usr.set_machine(src)

	if(charges <= 0)
		user << "The Wish Granter lies silent."
		return

	else if(!istype(user, /mob/living/carbon/human))
		user << "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's."
		return

	else if(is_special_character(user))
		user << "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away."

	else if (!insisting)
		user << "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?"
		insisting++

	else
		user << "You speak.  [pick("I want the station to disappear","Humanity is corrupt, mankind must be destroyed","I want to be rich", "I want to rule the world","I want immortality.")].  The Wish Granter answers."
		user << "Your head pounds for a moment, before your vision clears.  You are the avatar of the Wish Granter, and your power is LIMITLESS!  And it's all yours.  You need to make sure no one can take it from you.  No one can know, first."

		charges--
		insisting = 0

		if (!(HULK in user.mutations))
			user.mutations.Add(HULK)

		if (!(LASER in user.mutations))
			user.mutations.Add(LASER)

		if (!(XRAY in user.mutations))
			user.mutations.Add(XRAY)
			user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			user.see_in_dark = 8
			user.see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if (!(COLD_RESISTANCE in user.mutations))
			user.mutations.Add(COLD_RESISTANCE)

		if (!(TK in user.mutations))
			user.mutations.Add(TK)

		if(!(HEAL in user.mutations))
			user.mutations.Add(HEAL)

		user.update_mutations()
		user.mind.special_role = "Avatar of the Wish Granter"

		var/datum/objective/silence/silence = new
		silence.owner = user.mind
		user.mind.objectives += silence

		show_objectives(user.mind)
		user << "You have a very bad feeling about this."

	return
	
	
/obj/machinery/wish_granter_dark
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = 1
	density = 1
	use_power = 0

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter_dark/attack_hand(var/mob/living/carbon/human/user as mob)
	usr.set_machine(src)

	if(chargesa <= 0)
		user << "The Wish Granter lies silent."
		return

	else if(!istype(user, /mob/living/carbon/human))
		user << "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's."
		return

	else if(is_special_character(user))
		user << "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away."

	else if (!insistinga)
		user << "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?"
		insistinga++

	else
		chargesa--
		insistinga = 0
		var/wish = input("You want...","Wish") as null|anything in list("I want to rule the station","I want to be rich","I want immortality","The station is corrupt, it must be destroyed","I want peace")
		switch(wish)
			if("I want to rule the station")
				user << "<B>Your wish is granted, but at a terrible cost...</B>"
				user << "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart."
				if (!(HULK in user.mutations))
					user.mutations.Add(HULK)
					user << "\blue Your muscles hurt."
				if (!(LASER in user.mutations))
					user.mutations.Add(LASER)
					user << "\blue You feel pressure building behind your eyes."
				if (!(COLD_RESISTANCE in user.mutations))
					user.mutations.Add(COLD_RESISTANCE)
					user << "\blue Your body feels warm."
				if (!(XRAY in user.mutations))
					user.mutations.Add(XRAY)
					user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
					user.see_in_dark = 8
					user.see_invisible = SEE_INVISIBLE_LEVEL_TWO
					user << "\blue The walls suddenly disappear."
					user.set_species("Shadow")
					user.mind.special_role = "Avatar of the Wish Granter"
			if("I want to be rich")
				user << "<B>Your wish is granted, but at a terrible cost...</B>"
				user << "The Wish Granter punishes you for your greediness, claiming your soul and warping your body to match the darkness in your heart."
				new /obj/structure/closet/syndicate/resources/everything(loc)
				user.set_species("Shadow")
				user.mind.special_role = "Avatar of the Wish Granter"
			if("I want immortality")
				user << "<B>Your wish is granted, but at a terrible cost...</B>"
				user << "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart."
				user.verbs += /mob/living/carbon/proc/immortality
				user.set_species("Skeleton")
				user.mind.special_role = "Avatar of the Wish Granter"
			if("The station is corrupt, it must be destroyed")
				user << "<B>Your wish is granted, but at a terrible cost...</B>"
				user << "The Wish Granter punishes you for your wickedness, claiming your soul and warping your body to match the darkness in your heart."
				user.mind.special_role = "Avatar of the Wish Granter"
				var/datum/objective/hijack/hijack = new
				hijack.owner = user.mind
				user.mind.objectives += hijack
				user << "<B>Your inhibitions are swept away, the bonds of loyalty broken, you are free to murder as you please!</B>"
				var/obj_count = 1
				for(var/datum/objective/OBJ in user.mind.objectives)
					user << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
					obj_count++
				user.set_species("Shadow")
			if("I want peace")
				user << "<B>Your wish is granted...</B>"
				user << "Everything lies silently and then the station, its crew and troubles are gone in a blink of light. You found peace at last."
				user.sdisabilities += BLIND
				user.sdisabilities += DEAF

/////For the Wishgranter///////////

/mob/living/carbon/proc/immortality()
	set category = "Immortality"
	set name = "Resurrection"

	var/mob/living/carbon/C = usr
	if(!C.stat)
		C << "<span class='notice'>You're not dead yet!</span>"
		return
	C << "<span class='notice'>Death is not your end!</span>"

	spawn(rand(800,1200))
		if(C.stat == DEAD)
			dead_mob_list -= C
			living_mob_list += C
		C.stat = CONSCIOUS
		C.revive()
		C.reagents.clear_reagents()
		C << "<span class='notice'>You have regenerated.</span>"
		C.visible_message("<span class='warning'>[usr] appears to wake from the dead, having healed all wounds.</span>")
		C.update_canmove()
	return 1
