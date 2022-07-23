/mob
	var/bloody_hands = null
	var/datum/weakref/bloody_hands_mob
	var/track_footprint = 0
	var/list/feet_blood_DNA
	var/track_footprint_type
	var/footprint_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/datum/weakref/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_footprint = 0

/obj/item/reagent_containers/glass/rag
	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/janitor.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 10
	can_be_placed_into = null
	flags = OPENCONTAINER | NOBLUDGEON
	unacidable = FALSE
	fragile = FALSE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes
	var/cleantime = 30
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
		user.visible_message(SPAN_WARNING("\The [user] stamps out \the [src]."), SPAN_WARNING("You stamp out \the [src]."))
		user.unEquip(src)
		extinguish()
	else
		remove_contents(user)

/obj/item/reagent_containers/glass/rag/attackby(obj/item/W, mob/user)
	if(!on_fire && W.isFlameSource())
		ignite()
		if(on_fire)
			visible_message(SPAN_WARNING("\The [user] lights \the [src] with \the [W]."))
		else
			to_chat(user, SPAN_WARNING("You manage to singe \the [src], but fail to light it."))
		return TRUE
	. = ..()
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/proc/update_name(var/base_name = initial(name))
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	if(on_fire)
		name = "burning [base_name]"
	else if(reagents.total_volume)
		name = "damp [base_name]"
	else
		name = "dry [base_name]"

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
		user.visible_message(SPAN_DANGER("\The [user] begins to wring out \the [src] over \the [target_text]."), SPAN_NOTICE("You begin to wring out \the [src] over \the [target_text]."))

		if(do_after(user, reagents.total_volume*5)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message(SPAN_DANGER("\The [user] wrings out \the [src] over \the [target_text]."), SPAN_NOTICE("You finish wringing out \the [src]."))
			update_name()
			update_icon()

/obj/item/reagent_containers/glass/rag/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [name] is dry!"))
	else
		if (!(last_clean && world.time < last_clean + 120) )
			user.visible_message("<b>[user]</b> starts to wipe [A] with [src].")
			clean_msg = TRUE
			last_clean = world.time
		else
			clean_msg = FALSE
		playsound(loc, 'sound/effects/mop.ogg', 25, 1)
		update_name()
		update_icon()
		if(do_after(user,cleantime))
			if(clean_msg)
				user.visible_message("<b>[user]</b> finishes wiping [A].")
		A.on_rag_wipe(src)

/obj/item/reagent_containers/glass/rag/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(isliving(target))
		var/mob/living/M = target
		if(on_fire)
			user.visible_message(SPAN_DANGER("\The [user] hits \the [target] with \the [src]!"))
			user.do_attack_animation(src)
			M.IgniteMob()
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
			if(LAZYLEN(affecting.wounds))
				for (var/datum/wound/W in affecting.wounds)
					if(W.bandaged || W.clamped)
						continue
					to_chat(user, SPAN_NOTICE("You begin to bandage \a [W.desc] on [M]'s [affecting.name] with a rag."))
					if(!do_mob(user, M, W.damage/10)) // takes twice as long as a normal bandage
						to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
						return
					for(var/_R in reagents.reagent_volumes)
						var/decl/reagent/R = decls_repository.get_decl(_R)
						var/strength = R.germ_adjust * reagents.reagent_volumes[_R]/4
						if(ispath(_R, /decl/reagent/alcohol))
							var/decl/reagent/alcohol/A = R
							strength = strength * (A.strength/100)
						W.germ_level -= min(strength, W.germ_level)//Clean the wound a bit.
						if (W.germ_level <= 0)
							W.disinfected = TRUE//The wound becomes disinfected if fully cleaned
							break
					reagents.trans_to_mob(H, reagents.total_volume*0.75, CHEM_TOUCH) // most of it gets on the skin
					reagents.trans_to_mob(H, reagents.total_volume*0.25, CHEM_BLOOD) // some gets in the wound
					user.visible_message(SPAN_NOTICE("\The [user] bandages \a [W.desc] on [M]'s [affecting.name] with [src], tying it in place."), \
					                     SPAN_NOTICE("You bandage \a [W.desc] on [M]'s [affecting.name] with [src], tying it in place."))
					W.bandage()
					qdel(src) // the rag is used up, it'll be all bloody and useless after
					return // we can only do one at a time
			else if(reagents.total_volume)
				if(user.zone_sel.selecting == BP_MOUTH && !(M.wear_mask && M.wear_mask.item_flags & AIRTIGHT))
					user.do_attack_animation(src)
					user.visible_message(
						SPAN_DANGER("\The [user] smothers [target] with [src]!"),
						SPAN_WARNING("You smother [target] with [src]!"),
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

	if(istype(A, /obj/structure/sink))
		return

	else if(istype(A, /obj/structure/reagent_dispensers) || istype(A, /obj/structure/mopbucket) || istype(A, /obj/item/reagent_containers/glass))
		if(!REAGENTS_FREE_SPACE(reagents))
			to_chat(user, SPAN_WARNING("\The [src] is already soaked."))
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("\The [user] soaks \the [src] using \the [A]."), SPAN_NOTICE("You soak \the [src] using \the [A]."))
			update_name()
			update_icon()
		return

	else if(!on_fire && istype(A) && (src in user))
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

//rag must have a minimum of 2 units fuel and at least 80% of the reagents must be fuel.
//maybe generalize flammable reagents someday
/obj/item/reagent_containers/glass/rag/proc/can_ignite()
	var/fuel = 0
	for(var/fuel_type in reagents.reagent_volumes)
		if(ispath(fuel_type, /decl/reagent/fuel) || ispath(fuel_type, /decl/reagent/alcohol))
			fuel += reagents.reagent_volumes[fuel_type]
	return (fuel >= 2 && fuel >= reagents.total_volume*0.8)

/obj/item/reagent_containers/glass/rag/proc/ignite()
	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from matches
	if(REAGENT_VOLUME(reagents, /decl/reagent/toxin/phoron)) // the phoron explodes when exposed to fire
		visible_message(SPAN_DANGER("\The [src] conflagrates violently!"))
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round(REAGENT_VOLUME(reagents, /decl/reagent/toxin/phoron) / 2.5, 1), get_turf(src), 0, 0)
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
		visible_message(SPAN_WARNING("\The [src] falls apart!"))
		if(istype(loc, /obj/item/reagent_containers/food/drinks/bottle))
			var/obj/item/reagent_containers/food/drinks/bottle/B = loc
			B.delete_rag()
		else
			new /obj/effect/decal/cleanable/ash(get_turf(src))
			qdel(src)
		return
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/process()
	if(!can_ignite())
		visible_message(SPAN_WARNING("\The [src] burns out."))
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
		if(istype(loc, /obj/item/reagent_containers/food/drinks/bottle))
			var/obj/item/reagent_containers/food/drinks/bottle/B = loc
			B.delete_rag()
		else
			new /obj/effect/decal/cleanable/ash(location)
			qdel(src)
		return

	for(var/fuel_type in reagents.reagent_volumes)
		if(ispath(fuel_type, /decl/reagent/fuel) || ispath(fuel_type, /decl/reagent/alcohol))
			reagents.remove_reagent(reagents.reagent_volumes[fuel_type], reagents.maximum_volume/25)
			break
	update_name()
	update_icon()
	burn_time--

/obj/item/reagent_containers/glass/rag/advanced
	name = "microfiber cloth"
	desc = "A synthetic fiber cloth; the split fibers and the size of the individual filaments make it more effective for cleaning purposes."
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/janitor.dmi'
	icon_state = "advrag"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5)
	volume = 10
	cleantime = 15

/obj/item/reagent_containers/glass/rag/advanced/idris
	name = "Idris advanced service cloth"
	desc = "An advanced rag developed and sold by Idris Incorporated at a steep price. It's dry-clean design and advanced insulating synthetic weave make this the pinnacle of service cloths for any self respecting chef or bartender!"
	icon_state = "idrisrag"
	volume = 15

/obj/item/reagent_containers/glass/rag/handkerchief
	name = "handkerchief"
	desc = "For cleaning a lady's hand, your bruised ego or a crime scene."
	volume = 5
	icon_state = "handkerchief"
