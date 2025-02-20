/*
CONTAINS:

Deployable items
Barricades
Deployable Kits

*/

//Barricades!
/obj/structure/blocker
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"

	build_amt = 5
	anchored = TRUE
	density = TRUE

	var/force_material
	var/health = 100
	var/maxhealth = 100

/obj/structure/blocker/Initialize(mapload, var/material_name)
	. = ..()
	if(!material_name)
		material_name = MATERIAL_WOOD
	set_material(material_name)

/obj/structure/blocker/proc/set_material(var/material_name)
	if(force_material)
		material_name = force_material
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] [name]"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/blocker/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	var/damage_modifier = 0.4
	switch(hitting_projectile.damage_type)
		if(DAMAGE_BURN)
			damage_modifier = 1
		if(DAMAGE_BRUTE)
			damage_modifier = 0.75
	health -= hitting_projectile.damage * damage_modifier
	if(!check_dismantle())
		visible_message(SPAN_WARNING("\The [src] is hit by \the [hitting_projectile]!"))

/obj/structure/blocker/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ishammer() && user.a_intent != I_HURT)
		var/obj/item/I = usr.get_inactive_hand()
		if(I && istype(I, /obj/item/stack))
			var/obj/item/stack/D = I
			if(D.get_material_name() != material.name)
				to_chat(user, SPAN_WARNING("You need one sheet of [material.display_name] to repair \the [src]."))
				return ..()
			if(health < maxhealth)
				if(D.get_amount() < 1)
					to_chat(user, SPAN_WARNING("You need one sheet of [material.display_name] to repair \the [src]."))
					return TRUE
				user.visible_message("<b>[user]</b> begins to repair \the [src].", SPAN_NOTICE("You begin to repair \the [src]."))
				if(I.use_tool(src, user, 20, volume = 50) && health < maxhealth)
					if(D.use(1))
						health = maxhealth
						visible_message("<b>[user]</b> repairs \the [src].", SPAN_NOTICE("You repair \the [src]."))
			return TRUE
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(attacking_item.damtype)
			if(DAMAGE_BURN)
				src.health -= attacking_item.force * 1
			if(DAMAGE_BRUTE)
				src.health -= attacking_item.force * 0.75
		shake_animation()
		playsound(src.loc, material.hitsound, attacking_item.get_clamped_volume(), 1)
		if(check_dismantle())
			return TRUE
		return ..()

/obj/structure/blocker/proc/check_dismantle()
	if(src.health <= 0)
		visible_message(SPAN_DANGER("The barricade is smashed apart!"))
		dismantle()
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/blocker/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				dismantle()
			return

/obj/structure/blocker/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return TRUE
	if(mover.movement_type & PHASING)
		return TRUE
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		if(P.original == src)
			return FALSE
		if(P.firer && Adjacent(P.firer))
			return TRUE
		return prob(35)
	if(isliving(mover))
		return FALSE
	if(istype(mover) && mover.pass_flags & PASSTABLE)
		return TRUE
	return FALSE

/obj/structure/blocker/steel
	force_material = MATERIAL_STEEL

/obj/structure/blocker/steel/fence
	name = "fence"
	force_material = MATERIAL_STEEL
	icon_state = "chainfence"

//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(ACCESS_SECURITY)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = 0.0
	density = 1.0
	icon_state = "barrier"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
//	req_access = list(ACCESS_MAINT_TUNNELS)

/obj/machinery/deployable/barrier/New()
	..()

	src.icon_state = "[initial(icon_state)][src.locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/card/id/))
		if (src.allowed(user))
			if	(src.emagged < 2.0)
				src.locked = !src.locked
				src.anchored = !src.anchored
				src.icon_state = "[initial(icon_state)][src.locked]"
				if ((src.locked == 1.0) && (src.emagged < 2.0))
					to_chat(user, "Barrier lock toggled on.")
					return
				else if ((src.locked == 0.0) && (src.emagged < 2.0))
					to_chat(user, "Barrier lock toggled off.")
					return
			else
				spark(src, 2, src)
				visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
				return
		return
	else if (attacking_item.iswrench())
		if (src.health < src.maxhealth)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			src.health = src.maxhealth
			src.emagged = 0
			src.req_access = list(ACCESS_SECURITY)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		else if (src.emagged > 0)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			src.emagged = 0
			src.req_access = list(ACCESS_SECURITY)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(attacking_item.damtype)
			if("fire")
				src.health -= attacking_item.force * 0.75
			if("brute")
				src.health -= attacking_item.force * 0.5

		if (src.health <= 0)
			src.explode()
		..()

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				src.explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	. = ..()

	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "[initial(icon_state)][src.locked]"

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(mover?.movement_type & PHASING)
		return TRUE
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.pass_flags & PASSTABLE)
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/proc/explode()
	visible_message(SPAN_DANGER("[src] blows apart!"))

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(get_turf(src))

	spark(src, 3, GLOB.alldirs)

	explosion(src.loc,-1,-1,0)
	qdel(src)

/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access.Cut()
		src.req_one_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the [src].")
		spark(src, 2, GLOB.alldirs)
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return 1
	else if (src.emagged == 1)
		src.emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		spark(src, 2, GLOB.alldirs)
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return 1

/obj/machinery/deployable/barrier/legion
	name = "\improper TCAF barrier"
	desc = "A deployable barrier, bearing the marks of the Tau Ceti Armed Forces. Swipe your ID card to lock/unlock it."
	icon_state = "barrier_legion"
	req_access = null
	req_one_access = list(ACCESS_TCAF_SHIPS, ACCESS_LEGION)

/obj/item/deployable_kit
	name = "Emergency Floodlight Kit"
	desc = "A do-it-yourself kit for constructing the finest of emergency floodlights."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "inf_box"
	item_state = "inf_box"
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	var/kit_product = /obj/machinery/floodlight
	var/assembly_time = 8 SECONDS

/obj/item/deployable_kit/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("You start assembling \the [src]..."))
	if(do_after(user, assembly_time, src, DO_REPAIR_CONSTRUCT))
		assemble_kit(user)
		qdel(src)

/obj/item/deployable_kit/proc/assemble_kit(mob/user)
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
	var/atom/A = new kit_product(user.loc)
	user.visible_message(SPAN_NOTICE("[user] assembles \a [A]."), SPAN_NOTICE("You assemble \a [A]."))
	A.add_fingerprint(user)

/obj/item/deployable_kit/legion_barrier
	name = "\improper TCAF barrier kit"
	desc = "A quick assembly kit for deploying id-lockable barriers in the field. This one has the mark of the Tau Ceti Armed Forces."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "barrier_kit"
	item_state = "barrier_kit"
	w_class = WEIGHT_CLASS_SMALL
	kit_product = /obj/machinery/deployable/barrier/legion

/obj/item/deployable_kit/surgery_table
	name = "surgery table assembly kit"
	desc = "A quick assembly kit to deploy a surgery table in the field. Cannot be put together again after being unfolded, choose your spot wisely."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table_deployable"
	item_state = "table_parts"
	w_class = WEIGHT_CLASS_BULKY
	kit_product = /obj/machinery/optable
	assembly_time = 20 SECONDS

/obj/item/deployable_kit/surgery_table/assemble_kit(mob/user)
	..()
	var/free_spot = null
	for(var/check_dir in GLOB.cardinals)
		var/turf/T = get_step(src, check_dir)
		if(turf_clear(T))
			free_spot = T
			break
	if(!free_spot)
		free_spot = src.loc
	new /obj/structure/curtain/open/medical(free_spot, src)
	new /obj/structure/curtain/open/medical(free_spot, src)

/obj/item/deployable_kit/legion_turret
	name = "legion blaster turret assembly kit"
	desc = "A quick assembly kit to deploy a blaster turret in the field. Swipe with a TCFL id card to configure it once assembled."
	icon = 'icons/obj/turrets.dmi'
	icon_state = "blaster_turret_kit"
	item_state = "table_parts"
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	w_class = WEIGHT_CLASS_BULKY
	kit_product = /obj/machinery/porta_turret/legion
	assembly_time = 15 SECONDS

/obj/item/deployable_kit/iv_drip
	name = "IV drip assembly kit"
	desc = "A quick assembly kit to put together an IV drip."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "inf_box"
	item_state = "inf_box"
	w_class = WEIGHT_CLASS_NORMAL
	kit_product = /obj/machinery/iv_drip
	assembly_time = 4 SECONDS

/obj/item/deployable_kit/remote_mech
	name = "mech control centre assembly kit"
	desc = "A quick assembly kit to put together a mech control centre."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "barrier_kit"
	item_state = "barrier_kit"
	w_class = WEIGHT_CLASS_BULKY
	kit_product = /obj/structure/bed/stool/chair/remote/mech/portable
	assembly_time = 20 SECONDS

/obj/item/deployable_kit/remote_mech/attack_self(mob/user)
	var/area/A = get_area(user)
	if(!A.powered(AREA_USAGE_EQUIP))
		to_chat(user, SPAN_WARNING("\The [src] can not be deployed in an unpowered area."))
		return FALSE
	..()

/obj/item/deployable_kit/remote_mech/brig
	name = "brig mech control centre assembly kit"
	desc = "A quick assembly kit to put together a brig mech control centre."
	kit_product = /obj/structure/bed/stool/chair/remote/mech/prison/portable
