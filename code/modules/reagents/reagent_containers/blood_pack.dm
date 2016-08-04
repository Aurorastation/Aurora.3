/obj/item/weapon/storage/box/bloodpacks
	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	New()
		..()
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)

/obj/item/weapon/reagent_containers/blood
	name = "BloodPack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	volume = 200

	var/blood_type = null

	New()
		..()
		if(blood_type != null)
			name = "BloodPack [blood_type]"
			reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))
			update_icon()

	on_reagent_change()
		update_icon()

	update_icon()
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)			icon_state = "empty"
			if(10 to 50) 		icon_state = "half"
			if(51 to INFINITY)	icon_state = "full"

/obj/item/weapon/reagent_containers/blood/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob)
	if (user == M && (user.mind.vampire))
		if (reagents.get_reagent_amount("blood"))
			user.visible_message("\red [user] raises \the [src] up to \his mouth and bites into it.", "\blue You raise \the [src] up to your mouth and bite into it, starting to drain its contents.")

			while (do_after(user, 25, 5, 1))
				var/blood_taken = 0
				var/need_to_break = 0
				if (reagents.get_reagent_amount("blood") > 10)
					blood_taken = 10
				else
					blood_taken = reagents.get_reagent_amount("blood")
					need_to_break = 1

				reagents.remove_reagent("blood", blood_taken)
				user.mind.vampire.blood_total += blood_taken
				user.check_vampire_upgrade(user.mind)

				if (blood_taken)
					user << "\blue <b>You have accumulated [user.mind.vampire.blood_total] [user.mind.vampire.blood_total > 1 ? "units" : "unit"] of blood and have [user.mind.vampire.blood_usable] left to use."

				if (need_to_break)
					break

			user.visible_message("\red [user] licks \his fangs dry, lowering \the [src].", "\blue You lick your fangs clean of the tasteless blood.")

	else
		..()

/obj/item/weapon/reagent_containers/blood/attackby(obj/item/weapon/P as obj, mob/user as mob)
	..()
	if (istype(P, /obj/item/weapon/pen))
		if (reagents.get_reagent_amount("blood") && name != "Empty BloodPack") //Stops people mucking with bloodpacks that are filled
			usr << "<span class='notice'>You can't relabel [name] until it is empty!</span>"
			return
		var/blood_name = input(usr, "What blood type would you like to label it as?", "Blood Types") in list("A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-", "Cancel")
		if (blood_name == "Cancel") return
		var/obj/item/i = usr.get_active_hand()
		if (!istype(i, /obj/item/weapon/pen) || !in_range(user, src)) return //Checks to see if pen is still held or bloodback is in range
		name = "BloodPack [blood_name]"
		desc = "Contains blood used for transfusion."
		usr << "<span class='notice'>You label the blood pack as [blood_name].</span>"
		return

	if (istype(P, /obj/item/weapon/) && P.sharp == 1)
		if(P.attack_verb.len)
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
						usr << "<span class='notice'>DEBUG: Direction is [direction].</span>"
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
							var/turf/base = get_turf(target)
							for (var/atom/A in base)
								if ((!istype(A, /obj/) && A.density) || istype(A, /obj/structure/window/) || istype(A, /obj/machinery/door/airlock/))
									add_blood(A)
									break spray_loop
							blood_splatter(target, null, 1)
			add_blood(src); add_blood(usr);
			blood_splatter(src.loc, null, 1)
			playsound(src.loc, 'sound/effects/splat.ogg', 50, 1, -6)
		reagents.remove_reagent("blood", reagents.total_volume)
		icon_state = "ripped"; update_icon();
		var/atkmsg = "<span class='warning'>\The [src] rips apart[atkmsg_filled]!</span>"
		user.visible_message(atkmsg)
		return
	return

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
	name = "Empty BloodPack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"
