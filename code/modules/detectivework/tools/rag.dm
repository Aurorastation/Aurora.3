/mob
	var/bloody_hands = null
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/feet_blood_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 10
	can_be_placed_into = null
	flags = OPENCONTAINER | NOBLUDGEON
	unacidable = 0

	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes

	. = ..()
	update_name()

	STOP_PROCESSING(SSprocessing, src) //so we don't continue turning to ash while gc'd
	return ..()

	if(on_fire)
		user.visible_message("<span class='warning'>\The [user] stamps out [src].</span>", "<span class='warning'>You stamp out [src].</span>")
		user.unEquip(src)
		extinguish()
	else
		remove_contents(user)

		if(F.lit)
			ignite()
			if(on_fire)
				visible_message("<span class='warning'>\The [user] lights [src] with [W].</span>")
			else
				user << "<span class='warning'>You manage to singe [src], but fail to light it.</span>"

	. = ..()
	update_name()

	if(on_fire)
		name = "burning [initial(name)]"
	else if(reagents.total_volume)
		name = "damp [initial(name)]"
	else
		name = "dry [initial(name)]"

	if(on_fire)
		icon_state = "raglit"
	else
		icon_state = "rag"

	if(istype(B))
		B.update_icon()

	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the [trans_dest]" : "\the [user.loc]"
		user.visible_message("<span class='danger'>\The [user] begins to wring out [src] over [target_text].</span>", "<span class='notice'>You begin to wring out [src] over [target_text].</span>")

		if(do_after(user, reagents.total_volume*5)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message("<span class='danger'>\The [user] wrings out [src] over [target_text].</span>", "<span class='notice'>You finish to wringing out [src].</span>")
			update_name()

	if(!reagents.total_volume)
		user << "<span class='warning'>The [initial(name)] is dry!</span>"
	else
		user.visible_message("\The [user] starts to wipe down [A] with [src]!")
		reagents.splash(A, 1) //get a small amount of liquid on the thing we're wiping.
		update_name()
		if(do_after(user,30))
			user.visible_message("\The [user] finishes wiping off \the [A]!")
			A.clean_blood()

	if(isliving(target))
		var/mob/living/M = target
		if(on_fire)
			user.visible_message("<span class='danger'>\The [user] hits [target] with [src]!</span>",)
			user.do_attack_animation(src)
			M.IgniteMob()
		else if(reagents.total_volume)
			if(user.zone_sel.selecting == "mouth" && !(M.wear_mask && M.wear_mask.item_flags & AIRTIGHT))
				user.do_attack_animation(src)
				user.visible_message(
					"<span class='danger'>\The [user] smothers [target] with [src]!</span>",
					"<span class='warning'>You smother [target] with [src]!</span>",
					"You hear some struggling and muffled cries of surprise"
					)

				//it's inhaled, so... maybe CHEM_BLOOD doesn't make a whole lot of sense but it's the best we can do for now
				reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
				update_name()
			else
				wipe_down(target, user)
		return

	return ..()

	if(!proximity)
		return

		if(!reagents.get_free_space())
			user << "<span class='warning'>\The [src] is already soaked.</span>"
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			user.visible_message("<span class='notice'>\The [user] soaks [src] using [A].</span>", "<span class='notice'>You soak [src] using [A].</span>")
			update_name()
		return

	if(!on_fire && istype(A) && (src in user))
		if(A.is_open_container() && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

	if(exposed_temperature >= 50 + T0C)
		ignite()
	if(exposed_temperature >= 900 + T0C)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)

//rag must have a minimum of 2 units welder fuel and at least 80% of the reagents must be welder fuel.
//maybe generalize flammable reagents someday
	var/fuel = reagents.get_reagent_amount("fuel")
	return (fuel >= 2 && fuel >= reagents.total_volume*0.8)

	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from matches
	if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
		visible_message("<span class='danger'>\The [src] conflagrates violently!</span>")
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return

	START_PROCESSING(SSprocessing, src)
	set_light(2, null, "#E38F46")
	on_fire = 1
	update_name()
	update_icon()

	STOP_PROCESSING(SSprocessing, src)
	set_light(0)
	on_fire = 0

	//rags sitting around with 1 second of burn time left is dumb.
	//ensures players always have a few seconds of burn time left when they light their rag
	if(burn_time <= 5)
		visible_message("<span class='warning'>\The [src] falls apart!</span>")
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)
	update_name()
	update_icon()

	if(!can_ignite())
		visible_message("<span class='warning'>\The [src] burns out.</span>")
		extinguish()

	//copied from matches
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(burn_time <= 0)
		STOP_PROCESSING(SSprocessing, src)
		new /obj/effect/decal/cleanable/ash(location)
		qdel(src)
		return

	reagents.remove_reagent("fuel", reagents.maximum_volume/25)
	update_name()
	burn_time--
