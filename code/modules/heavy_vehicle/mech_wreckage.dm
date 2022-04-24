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
			for(var/obj/item/thing in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
				if(thing && prob(40))
					thing.forceMove(src)
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

/obj/structure/mech_wreckage/attackby(var/obj/item/W, var/mob/user)
	var/cutting
	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())
			cutting = TRUE
		else
			to_chat(user, "<span class='warning'>Turn the torch on, first.</span>")
			return
	else if(istype(W, /obj/item/gun/energy/plasmacutter))
		cutting = TRUE

	if(cutting)
		if(!prepared)
			prepared = 1
			to_chat(user, "<span class='notice'>You partially dismantle \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has already been weakened.</span>")
		return 1

	else if(W.iswrench())
		if(prepared)
			to_chat(user, "<span class='notice'>You finish dismantling \the [src].</span>")
			new /obj/item/stack/material/steel(get_turf(src),rand(5,10))
			qdel(src)
		else
			to_chat(user, "<span class='warning'>It's too solid to dismantle. Try cutting through some of the bigger bits.</span>")
		return 1
	else if(istype(W) && W.force > 20)
		visible_message("<span class='danger'>\The [src] has been smashed with \the [W] by \the [user]!</span>")
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
