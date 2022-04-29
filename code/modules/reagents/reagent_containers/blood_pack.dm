/obj/item/storage/box/bloodpacks
	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"

/obj/item/storage/box/bloodpacks/fill()
	..()
	new /obj/item/reagent_containers/blood/empty(src)
	new /obj/item/reagent_containers/blood/empty(src)
	new /obj/item/reagent_containers/blood/empty(src)
	new /obj/item/reagent_containers/blood/empty(src)
	new /obj/item/reagent_containers/blood/empty(src)
	new /obj/item/reagent_containers/blood/empty(src)
	new /obj/item/reagent_containers/blood/empty(src)

/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains fluids used for transfusions."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "bloodpack"
	filling_states = "-10;10;25;50;75;80;100"
	w_class = ITEMSIZE_SMALL
	volume = 200

	amount_per_transfer_from_this = 0.2
	possible_transfer_amounts = list(0.2, 1, 2, 3, 4)
	flags = OPENCONTAINER

	var/datum/weakref/attached_mob

	var/blood_type = null
	var/vampire_marks = null
	var/being_feed = FALSE
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/reagent_containers/blood/Initialize()
	. = ..()
	if(blood_type != null)
		name = "blood pack [blood_type]"
		reagents.add_reagent(/decl/reagent/blood, volume, list("donor"=null,"blood_DNA"=null,"blood_type"=blood_type,"trace_chem"=null,"dose_chem"=null))
		w_class = ITEMSIZE_NORMAL
		update_icon()

/obj/item/reagent_containers/blood/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	attached_mob = null
	return ..()

/obj/item/reagent_containers/blood/on_reagent_change()
	update_icon()
	if(reagents.total_volume > volume / 2)
		w_class = ITEMSIZE_NORMAL
	else
		w_class = ITEMSIZE_SMALL

/obj/item/reagent_containers/blood/update_icon()
	cut_overlays()

	if(blood_type)
		add_overlay(image('icons/obj/bloodpack.dmi', "[blood_type]"))

	if(attached_mob)
		add_overlay(image('icons/obj/bloodpack.dmi', "dongle"))

	if(reagents && reagents.total_volume)
		add_overlay(overlay_image('icons/obj/bloodpack.dmi', "[icon_state][get_filling_state()]", color = reagents.get_color()))

/obj/item/reagent_containers/blood/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob, var/target_zone)
	if(user == M && (MODE_VAMPIRE in user.mind?.antag_datums))
		var/datum/vampire/vampire = user.mind.antag_datums[MODE_VAMPIRE]
		if (being_feed)
			to_chat(user, SPAN_NOTICE("You are already feeding on \the [src]."))
			return
		if (REAGENT_VOLUME(reagents, /decl/reagent/blood))
			user.visible_message(SPAN_WARNING("[user] raises \the [src] up to their mouth and bites into it."), SPAN_NOTICE("You raise \the [src] up to your mouth and bite into it, starting to drain its contents.<br>You need to stand still."))
			being_feed = TRUE
			vampire_marks = TRUE
			if (!LAZYLEN(src.other_DNA))
				LAZYADD(src.other_DNA, M.dna.unique_enzymes)
				src.other_DNA_type = "saliva"

			while (do_after(user, 25, 5, 1))
				var/blood_taken = 0
				blood_taken = min(5, REAGENT_VOLUME(reagents, /decl/reagent/blood)/4)

				reagents.remove_reagent(/decl/reagent/blood, blood_taken*4)
				vampire.blood_usable += blood_taken

				if (blood_taken)
					to_chat(user, SPAN_NOTICE("You have accumulated [vampire.blood_usable] unit\s of usable blood. It tastes quite stale."))

				if (REAGENT_VOLUME(reagents, /decl/reagent/blood) < 1)
					break
			user.visible_message(SPAN_WARNING("[user] licks [user.get_pronoun("his")] fangs dry, lowering \the [src]."), SPAN_NOTICE("You lick your fangs clean of the tasteless blood."))
			being_feed = FALSE
	else
		..()

/obj/item/reagent_containers/blood/MouseDrop(over_object, src_location, over_location)
	if(!ismob(loc))
		return
	var/turf/our_turf = get_turf(src)
	var/turf/target_turf = get_turf(over_object)
	if(!our_turf.Adjacent(target_turf))
		return
	if(attached_mob)
		remove_iv_mob()
	else if(ishuman(over_object))
		visible_message(SPAN_WARNING("\The [usr] starts hooking \the [over_object] up to \the [src]."))
		if(do_after(usr, 30))
			to_chat(usr, SPAN_NOTICE("You hook \the [over_object] up to \the [src]."))
			attached_mob = WEAKREF(over_object)
			START_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/reagent_containers/blood/process()
	var/mob/living/carbon/human/attached
	if(attached_mob)
		attached = attached_mob.resolve()
		if(!attached)
			attached_mob = null
			return PROCESS_KILL
		var/is_adjacent = loc.Adjacent(attached)
		if(!is_adjacent || !ismob(loc))
			remove_iv_mob(is_adjacent)
			update_icon()
			return PROCESS_KILL
	else
		remove_iv_mob()
		return

	var/mob/M = loc
	if(M.l_hand != src && M.r_hand != src)
		remove_iv_mob()
		return

	if(!reagents.total_volume)
		remove_iv_mob()
		return

	reagents.trans_to_mob(attached, amount_per_transfer_from_this, CHEM_BLOOD)
	update_icon()

/obj/item/reagent_containers/blood/proc/remove_iv_mob(var/safe = TRUE)
	if(attached_mob)
		var/mob/living/carbon/human/attached = attached_mob.resolve()
		if(attached)
			if(safe)
				visible_message(SPAN_NOTICE("\The [attached] is taken off \the [src]."))
			else
				var/obj/item/organ/external/affecting = attached.get_organ(pick(BP_R_ARM, BP_L_ARM))
				attached.visible_message(SPAN_WARNING("The needle is ripped out of [attached]'s [affecting.limb_name == BP_R_ARM ? "right arm" : "left arm"]."), SPAN_DANGER("The needle <b>painfully</b> rips out of your [affecting.limb_name == BP_R_ARM ? "right arm" : "left arm"]."))
				affecting.take_damage(brute = 5, damage_flags = DAM_SHARP)
		attached_mob = null
	STOP_PROCESSING(SSprocessing, src)

/obj/item/reagent_containers/blood/examine(mob/user, distance = 2)
	if (..() && vampire_marks)
		to_chat(user, SPAN_WARNING("There are teeth marks on it."))
	return

/obj/item/reagent_containers/blood/attackby(obj/item/P as obj, mob/user as mob)
	..()
	if (P.ispen())
		if (REAGENT_VOLUME(reagents, /decl/reagent/blood) && name != "empty blood pack") //Stops people mucking with bloodpacks that are filled
			to_chat(user, SPAN_NOTICE("You can't relabel [name] until it is empty!"))
			return
		var/blood_name = input(user, "What blood type would you like to label it as?", "Blood Types") in list("A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-", "Saline Plus", "Clear", "Cancel")
		if(blood_name == "Cancel")
			return
		var/obj/item/i = user.get_active_hand()
		if(!i.ispen() || !in_range(user, src)) //Checks to see if pen is still held or bloodpack is in range
			return
		if(blood_name == "Clear")
			blood_type = null
			name = initial(name)
			desc = initial(desc)
			to_chat(user, SPAN_NOTICE("You clear the blood pack label."))
			update_icon()
			return
		blood_type = blood_name
		name = "blood pack [blood_type]"
		desc = "Contains fluids used for transfusions."
		to_chat(user, SPAN_NOTICE("You label the blood pack as [blood_type]."))
		update_icon()
		return

	if (istype(P, /obj/item/) && P.sharp == 1)
		var/mob/living/carbon/human/H = usr
		if(LAZYLEN(P.attack_verb))
			user.visible_message(SPAN_DANGER("[src] has been [pick(P.attack_verb)] with \the [P] by [user]!"))
		var/atkmsg_filled = null
		if (REAGENT_VOLUME(reagents, /decl/reagent/blood))
			atkmsg_filled = " and the contents spray everywhere"
			if (src.loc != usr)
				var/strength
				var/percent = round((REAGENT_VOLUME(reagents, /decl/reagent/blood) / volume) * 100) //the amount of blood changes the strength of spray
				switch(percent)
					if(1 to 9)	strength = 2
					if(10 to 50)	strength = 3
					if(51 to INFINITY)	strength = 4
				for (var/j = 0, j < strength - 1, j++) //The number of separate splatters
					spray_loop:
						var/direction = pick(alldirs)
						var/target
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
		var/obj/item/reagent_containers/I = src.loc != usr ? new/obj/item/reagent_containers/blood/ripped(src.loc) : new/obj/item/reagent_containers/blood/ripped(usr.loc)
		if (REAGENT_VOLUME(reagents, /decl/reagent/blood))
			I.add_blood()
		var/atkmsg = SPAN_WARNING("\The [src] rips apart[atkmsg_filled]!")
		user.visible_message(atkmsg)
		qdel(src)
		return
	return

/obj/item/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/reagent_containers/blood/empty
	name = "empty blood pack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "bloodpack"

/obj/item/reagent_containers/blood/ripped
	name = "ripped blood pack"
	desc = "It's torn up and useless."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "ripped"
	volume = 0

/obj/item/reagent_containers/blood/ripped/attackby(obj/item/P as obj, mob/user as mob)
	to_chat(user, SPAN_WARNING("You can't do anything further with this."))
	return
