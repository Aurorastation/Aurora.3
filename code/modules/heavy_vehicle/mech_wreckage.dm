/obj/structure/mech_wreckage
	name = "wreckage"
	desc = "It might have some salvagable parts."
	density = 1
	opacity = 1
	anchored = 1
	icon_state = "wreck"
	icon = 'icons/mecha/mech_part_items.dmi'
	var/prepared = FALSE

/obj/structure/mech_wreckage/Initialize(mapload, var/mob/living/heavy_vehicle/exosuit, var/gibbed)
	. = ..(mapload)
	if(exosuit)
		name = "wreckage of \the [exosuit.name]"
		if(!gibbed)
			INVOKE_ASYNC(src, PROC_REF(wreck_break_hardpoint), exosuit)
			for(var/obj/item/mech_component/comp in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
				if(comp && prob(40))
					exosuit.remove_body_part(comp, src)

/obj/structure/mech_wreckage/proc/wreck_break_hardpoint(var/mob/living/heavy_vehicle/exosuit)
	for(var/hardpoint in exosuit.hardpoints)
		if(exosuit.hardpoints[hardpoint] && prob(40))
			var/obj/item/thing = exosuit.hardpoints[hardpoint]
			if(exosuit.remove_system(hardpoint))
				thing.forceMove(src)


/obj/structure/mech_wreckage/powerloader/Initialize(mapload)
	var/mob/living/heavy_vehicle/premade/ripley/new_mech = new(loc)
	. = ..(mapload, new_mech, FALSE)
	if(!QDELETED(new_mech))
		qdel(new_mech)

/obj/structure/mech_wreckage/attack_hand(var/mob/user)
	if(contents.len)
		var/obj/item/thing = pick(contents)
		if(istype(thing))
			thing.forceMove(get_turf(user))
			user.put_in_hands(thing)
			to_chat(user, "You retrieve \the [thing] from \the [src].")
			return
	return ..()

/obj/structure/mech_wreckage/attackby(obj/item/attacking_item, mob/user)
	var/cutting
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.isOn())
			cutting = TRUE
		else
			to_chat(user, SPAN_WARNING("Turn the torch on, first."))
			return
	else if(istype(attacking_item, /obj/item/gun/energy/plasmacutter))
		cutting = TRUE

	if(cutting)
		if(!prepared)
			prepared = 1
			to_chat(user, SPAN_NOTICE("You partially dismantle \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] has already been weakened."))
		return 1

	else if(attacking_item.iswrench())
		if(prepared)
			to_chat(user, SPAN_NOTICE("You finish dismantling \the [src]."))
			new /obj/item/stack/material/steel(get_turf(src),rand(5,10))
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("It's too solid to dismantle. Try cutting through some of the bigger bits."))
		return 1
	else if(istype(attacking_item) && attacking_item.force > 20)
		visible_message(SPAN_DANGER("\The [src] has been smashed with \the [attacking_item] by \the [user]!"))
		if(prob(20))
			new /obj/item/stack/material/steel(get_turf(src),rand(1,3))
			qdel(src)
		return 1
	return ..()

/obj/structure/mech_wreckage/Destroy()
	for(var/obj/thing in contents)
		if(prob(65))
			thing.forceMove(get_turf(src))
		else
			qdel(thing)
	return ..()
