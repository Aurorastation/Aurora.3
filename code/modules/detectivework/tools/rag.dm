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

/obj/item/reagent_containers/glass/rag
	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/janitor.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 10
	can_be_placed_into = null
	flags = OPENCONTAINER | NOBLUDGEON
	unacidable = 0
	no_shatter = TRUE

	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes
	var/cleantime = 30
	drop_sound = 'sound/items/drop/clothing.ogg'
	var/last_clean
	var/clean_msg = FALSE

/obj/item/reagent_containers/glass/rag/Initialize()
	. = ..()
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/Destroy()
	STOP_PROCESSING(SSprocessing, src) //so we don't continue turning to ash while gc'd
	return ..()

/obj/item/reagent_containers/glass/rag/attack_self(mob/user)
	if(on_fire)
		user.visible_message(span("warning", "\The [user] stamps out \the [src]."), span("warning", "You stamp out \the [src]."))
		user.unEquip(src)
		extinguish()
	else
		remove_contents(user)

/obj/item/reagent_containers/glass/rag/attackby(obj/item/W, mob/user)
	if(!on_fire && istype(W, /obj/item/flame))
		var/obj/item/flame/F = W
		if(F.lit)
			ignite()
			if(on_fire)
				visible_message(span("warning", "\The [user] lights \the [src] with \the [W]."))
			else
				to_chat(user, span("warning", "You manage to singe \the [src], but fail to light it."))

	. = ..()
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/proc/update_name()
	if(on_fire)
		name = "burning [initial(name)]"
	else if(reagents.total_volume)
		name = "damp [initial(name)]"
	else
		name = "dry [initial(name)]"

/obj/item/reagent_containers/glass/rag/update_icon()
	if(on_fire)
		icon_state = "[initial(icon_state)]_lit"
	else if(reagents.total_volume)
		icon_state = "[initial(icon_state)]_wet"
	else
		icon_state = "[initial(icon_state)]"

	var/obj/item/reagent_containers/food/drinks/bottle/B = loc
	if(istype(B))
		B.update_icon()

/obj/item/reagent_containers/glass/rag/on_reagent_change()
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the [trans_dest]" : "\the [user.loc]"
		user.visible_message(span("danger", "\The [user] begins to wring out \the [src] over \the [target_text]."), span("notice", "You begin to wring out \the [src] over \the [target_text]."))

		if(do_after(user, reagents.total_volume*5)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message(span("danger", "\The [user] wrings out \the [src] over \the [target_text]."), span("notice", "You finish wringing out \the [src]."))
			update_name()
			update_icon()

/obj/item/reagent_containers/glass/rag/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		to_chat(user, span("warning", "\The [initial(name)] is dry!"))
	else
		if ( !(last_clean && world.time < last_clean + 120) )
			user.visible_message("\The [user] starts to wipe down \the [A] with \the [src]!")
			clean_msg = TRUE
			last_clean = world.time
		else
			clean_msg = FALSE
		playsound(loc, 'sound/effects/mop.ogg', 25, 1)
		reagents.splash(A, 1) //get a small amount of liquid on the thing we're wiping.
		update_name()
		update_icon()
		if(do_after(user,cleantime))
			if(clean_msg)
				user.visible_message("\The [user] finishes wiping off \the [A]!")
			A.clean_blood()

/obj/item/reagent_containers/glass/rag/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(isliving(target))
		var/mob/living/M = target
		if(on_fire)
			user.visible_message(span("danger", "\The [user] hits \the [target] with \the [src]!"))
			user.do_attack_animation(src)
			M.IgniteMob()
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
			if(LAZYLEN(affecting.wounds))
				for (var/datum/wound/W in affecting.wounds)
					if(W.bandaged || W.clamped)
						continue
					to_chat(user, span("notice", "You begin to bandage \a [W.desc] on [M]'s [affecting.name] with a rag."))
					if(!do_mob(user, M, W.damage/10)) // takes twice as long as a normal bandage
						to_chat(user, span("notice","You must stand still to bandage wounds."))
						break
					for(var/datum/reagent/R in reagents.reagent_list)
						var/strength = R.germ_adjust * R.volume/4
						if(istype(R, /datum/reagent/alcohol))
							var/datum/reagent/alcohol/A = R
							strength = strength * (A.strength/100)
						W.germ_level -= min(strength, W.germ_level)//Clean the wound a bit.
						if (W.germ_level <= 0)
							W.disinfected = 1//The wound becomes disinfected if fully cleaned
							break
					reagents.trans_to_mob(H, reagents.total_volume*0.75, CHEM_TOUCH) // most of it gets on the skin
					reagents.trans_to_mob(H, reagents.total_volume*0.25, CHEM_BLOOD) // some gets in the wound
					user.visible_message(span("notice", "\The [user] bandages \a [W.desc] on [M]'s [affecting.name] with a rag, tying it in place."), \
					                     span("notice", "You bandage \a [W.desc] on [M]'s [affecting.name] with a rag, tying it in place."))
					W.bandage()
					qdel(src) // the rag is used up, it'll be all bloody and useless after
					break // we can only do one at a time
			else if(reagents.total_volume)
				if(user.zone_sel.selecting == BP_MOUTH && !(M.wear_mask && M.wear_mask.item_flags & AIRTIGHT))
					user.do_attack_animation(src)
					user.visible_message(
						span("danger","\The [user] smothers [target] with [src]!"),
						span("warning","You smother [target] with [src]!"),
						"You hear some struggling and muffled cries of surprise."
						)

					//it's inhaled, so... maybe CHEM_BLOOD doesn't make a whole lot of sense but it's the best we can do for now
					//^HA HA HA
					reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BREATHE)
					update_name()
					update_icon()
				else
					wipe_down(target, user)
			return

	return ..()

/obj/item/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/structure/reagent_dispensers) || istype(A, /obj/structure/mopbucket) || istype(A, /obj/item/reagent_containers/glass))
		if(!reagents.get_free_space())
			to_chat(user, span("warning", "\The [src] is already soaked."))
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			user.visible_message(span("notice", "\The [user] soaks \the [src] using \the [A]."), span("notice", "You soak \the [src] using \the [A]."))
			update_name()
			update_icon()
		return

	if(!on_fire && istype(A) && (src in user))
		if(A.is_open_container() && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

/obj/item/reagent_containers/glass/rag/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 50 + T0C)
		ignite()
	if(exposed_temperature >= 900 + T0C)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)

//rag must have a minimum of 2 units welder fuel and at least 80% of the reagents must be welder fuel.
//maybe generalize flammable reagents someday
/obj/item/reagent_containers/glass/rag/proc/can_ignite()
	var/fuel = reagents.get_reagent_amount("fuel")
	return (fuel >= 2 && fuel >= reagents.total_volume*0.8)

/obj/item/reagent_containers/glass/rag/proc/ignite()
	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from matches
	if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
		visible_message(span("danger", "\The [src] conflagrates violently!"))
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

/obj/item/reagent_containers/glass/rag/proc/extinguish()
	STOP_PROCESSING(SSprocessing, src)
	set_light(0)
	on_fire = 0

	//rags sitting around with 1 second of burn time left is dumb.
	//ensures players always have a few seconds of burn time left when they light their rag
	if(burn_time <= 5)
		visible_message(span("warning", "\The [src] falls apart!"))
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/process()
	if(!can_ignite())
		visible_message(span("warning", "\The [src] burns out."))
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
	update_icon()
	burn_time--

/obj/item/reagent_containers/glass/rag/advanced
	name = "microfiber cloth"
	desc = "A synthetic fiber cloth; the split fibers and the size of the individual filaments make it more effective for cleaning purposes."
	w_class = 1
	icon = 'icons/obj/janitor.dmi'
	icon_state = "advrag"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5)
	volume = 10
	cleantime = 15
