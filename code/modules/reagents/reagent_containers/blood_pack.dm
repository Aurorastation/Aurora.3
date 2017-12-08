	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"

	..()

	name = "blood pack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	volume = 200

	var/blood_type = null
	var/vampire_marks = null
	var/being_feed = FALSE

	. = ..()
	if(blood_type != null)
		name = "blood pack [blood_type]"
		reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))
		update_icon()

	update_icon()

	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 9)			icon_state = "empty"
		if(10 to 50) 		icon_state = "half"
		if(51 to INFINITY)	icon_state = "full"

	if (user == M && (user.mind.vampire))
		if (being_feed)
			user << "<span class='notice'>You are already feeding on \the [src].</span>"
			return
		if (reagents.get_reagent_amount("blood"))
			user.visible_message("<span class='warning'>[user] raises \the [src] up to their mouth and bites into it.</span>", "<span class='notice'>You raise \the [src] up to your mouth and bite into it, starting to drain its contents.<br>You need to stand still.</span>")
			being_feed = TRUE
			vampire_marks = TRUE
			if (!LAZYLEN(src.other_DNA))
				LAZYADD(src.other_DNA, M.dna.unique_enzymes)
				src.other_DNA_type = "saliva"

			while (do_after(user, 25, 5, 1))
				var/blood_taken = 0
				blood_taken = min(5, reagents.get_reagent_amount("blood")/4)

				reagents.remove_reagent("blood", blood_taken*4)
				user.mind.vampire.blood_usable += blood_taken

				if (blood_taken)
					user << "<span class='notice'>You have accumulated [user.mind.vampire.blood_usable] [user.mind.vampire.blood_usable > 1 ? "units" : "unit"] of usable blood. It tastes quite stale.</span>"

				if (reagents.get_reagent_amount("blood") < 1)
					break
			user.visible_message("<span class='warning'>[user] licks \his fangs dry, lowering \the [src].</span>", "<span class='notice'>You lick your fangs clean of the tasteless blood.</span>")
			being_feed = FALSE
	else
		..()

	if (..() && vampire_marks)
		user << "<span class='warning'>There are teeth marks on it.</span>"
	return

	..()
		if (reagents.get_reagent_amount("blood") && name != "empty blood pack") //Stops people mucking with bloodpacks that are filled
			usr << "<span class='notice'>You can't relabel [name] until it is empty!</span>"
			return
		var/blood_name = input(usr, "What blood type would you like to label it as?", "Blood Types") in list("A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-", "Cancel")
		if (blood_name == "Cancel") return
		var/obj/item/i = usr.get_active_hand()
		name = "blood pack [blood_name]"
		desc = "Contains blood used for transfusion."
		usr << "<span class='notice'>You label the blood pack as [blood_name].</span>"
		return

		var/mob/living/carbon/human/H = usr
		if(LAZYLEN(P.attack_verb))
			user.visible_message("<span class='danger'>[src] has been [pick(P.attack_verb)] with \the [P] by [user]!</span>")
		var/atkmsg_filled = null
		if (reagents.get_reagent_amount("blood"))
			atkmsg_filled = " and the contents spray everywhere"
			if (src.loc != usr)
				var/strength
				var/percent = round((reagents.get_reagent_amount("blood") / volume) * 100) //the amount of blood changes the strength of spray
				switch(percent)
					if(1 to 9)	strength = 2
					if(10 to 50)	strength = 3
					if(51 to INFINITY)	strength = 4
				for (var/j = 0, j < strength - 1, j++) //The number of separate splatters
					spray_loop:
						var/direction = pick(alldirs)
						for (var/i = 1, i < strength, i++) //The distance the splatters will travel from random direction
							switch (direction)
								if (NORTH)
									target = locate(src.x, src.y+i, src.z)
								if (SOUTH)
									target = locate(src.x, src.y-i, src.z)
								if (EAST)
									target = locate(src.x+i, src.y, src.z)
								if (WEST)
									target = locate(src.x-i, src.y, src.z)
								if (NORTHEAST)
									target = locate(src.x+i, src.y+i, src.z)
								if (NORTHWEST)
									target = locate(src.x-i, src.y+i, src.z)
								if (SOUTHEAST)
									target = locate(src.x+i, src.y-i, src.z)
								if (SOUTHWEST)
									target = locate(src.x-i, src.y-i, src.z)
							if (istype(get_turf(target), /turf/simulated/wall))
								blood_splatter(target, null, 1)
								break spray_loop
							var/turf/base = get_turf(target)
							for (var/atom/A in base) // Stops your blood spray if it meets a person, wall, door or window
								if (istype(A, /mob/living/carbon/human/))
									var/mob/living/carbon/human/K = A
									K.bloody_body()
									break spray_loop
								if ((!istype(A, /obj/) && A.density) || istype(A, /obj/structure/window/) || istype(A, /obj/machinery/door/airlock/))
									break spray_loop
							blood_splatter(target, null, 1)
			blood_splatter(src.loc, null, 1)
			playsound(src.loc, 'sound/effects/splat.ogg', 50, 1, -6)
			if(istype(H))
				H.bloody_hands()
				if (loc == usr)
					H.bloody_body()
		// Line below will do a check where the target bloodbag is located and create a new one accordingly
		if (reagents.get_reagent_amount("blood"))
			I.add_blood()
		var/atkmsg = "<span class='warning'>\The [src] rips apart[atkmsg_filled]!</span>"
		user.visible_message(atkmsg)
		qdel(src)
		return
	return

	blood_type = "A+"

	blood_type = "A-"

	blood_type = "B+"

	blood_type = "B-"

	blood_type = "O+"

	blood_type = "O-"

	name = "empty blood pack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"

	name = "ripped blood pack"
	desc = "It's torn up and useless."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "ripped"
	volume = 0

	user << "<span class='warning'>You can't do anything further with this.</span>"
	return
