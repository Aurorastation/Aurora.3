/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEMSIZE_IMMENSE
	layer = OBJ_LAYER - 0.01

	var/breakable
	var/parts

	var/list/footstep_sound	//footstep sounds when stepped on

	var/material/material
	var/build_amt = 2 // used by some structures to determine into how many pieces they should disassemble into or be made with

	var/slowdown = 0 //amount that pulling mobs have their movement delayed by

/obj/structure/Destroy()
	if(parts)
		new parts(get_turf(src))
	if(smooth)
		queue_smooth_neighbors(src)
	return ..()

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	return ..()

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/proc/dismantle()
	var/material/dismantle_material
	if(!get_material())
		dismantle_material = SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL) //if there is no defined material, it will use steel
	else
		dismantle_material = get_material()
	for(var/i = 1 to build_amt)
		dismantle_material.place_sheet(loc)
	qdel(src)

/obj/structure/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	bullet_ping(P)

/obj/structure/Initialize(mapload)
	. = ..()
	if(!mapload)
		updateVisibility(src)	// No point checking this before visualnet initializes.
	if(smooth)
		queue_smooth(src)
		queue_smooth_neighbors(src)

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(!breakable || !damage || !wallbreaker)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src] apart!</span>")
	user.do_attack_animation(src)
	spawn(1)
		qdel(src)
	return 1

/obj/structure/get_material()
	return material