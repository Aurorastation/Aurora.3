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
				user.mind.vampire.bloodtotal += blood_taken
				user.check_vampire_upgrade(user.mind)

				if (blood_taken)
					user << "\blue <b>You have accumulated [user.mind.vampire.bloodtotal] [user.mind.vampire.bloodtotal > 1 ? "units" : "unit"] of blood and have [user.mind.vampire.bloodusable] left to use."

				if (need_to_break)
					break

			user.visible_message("\red [user] licks \his fangs dry, lowering \the [src].", "\blue You lick your fangs clean of the tasteless blood.")

	else
		..()

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
