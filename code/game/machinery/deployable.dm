/*
CONTAINS:

Deployable items
Barricades
Deployable Kits

for reference:

	access_security = 1
	access_brig = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_medical = 5
	access_morgue = 6
	access_tox = 7
	access_tox_storage = 8
	access_genetics = 9
	access_engine = 10
	access_engine_equip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_atmospherics = 24
	access_bar = 25
	access_janitor = 26
	access_crematorium = 27
	access_kitchen = 28
	access_robotics = 29
	access_rd = 30
	access_cargo = 31
	access_construction = 32
	access_pharmacy = 33
	access_cargo_bot = 34
	access_hydroponics = 35
	access_manufacturing = 36
	access_library = 37
	access_lawyer = 38
	access_virology = 39
	access_cmo = 40
	access_qm = 41
	access_court = 42
	access_clown = 43
	access_mime = 44

*/

//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = 1.0
	density = 1.0
	var/health = 100
	var/maxhealth = 100

/obj/structure/barricade/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if (health < maxhealth)
			if (D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>")
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20) && health < maxhealth)
				if (D.use(1))
					health = maxhealth
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.75
			else
		animate_shake()
		playsound(src.loc, material.hitsound, 100, 1)
		if (src.health <= 0)
			visible_message("<span class='danger'>The barricade is smashed apart!</span>")
			dismantle()
			qdel(src)
			return
		..()

/obj/structure/barricade/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				visible_message("<span class='danger'>\The [src] is blown apart!</span>")
				dismantle()
			return

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/structure/barricade/steel/New(var/newloc)
	.=..(newloc, MATERIAL_STEEL)

//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

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
//	req_access = list(access_maint_tunnels)

	New()
		..()

		src.icon_state = "[initial(icon_state)][src.locked]"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/card/id/))
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
					visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
					return
			return
		else if (W.iswrench())
			if (src.health < src.maxhealth)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				src.health = src.maxhealth
				src.emagged = 0
				src.req_access = list(access_security)
				visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
				return
			else if (src.emagged > 0)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				src.emagged = 0
				src.req_access = list(access_security)
				visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
				return
			return
		else
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			switch(W.damtype)
				if("fire")
					src.health -= W.force * 0.75
				if("brute")
					src.health -= W.force * 0.5
				else
			if (src.health <= 0)
				src.explode()
			..()

	ex_act(severity)
		switch(severity)
			if(1.0)
				src.explode()
				return
			if(2.0)
				src.health -= 25
				if (src.health <= 0)
					src.explode()
				return
	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			return
		if(prob(50/severity))
			locked = !locked
			anchored = !anchored
			icon_state = "[initial(icon_state)][src.locked]"

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
		if(air_group || (height==0))
			return 1
		if(istype(mover) && mover.checkpass(PASSTABLE))
			return 1
		else
			return 0

	proc/explode()
		visible_message("<span class='danger'>[src] blows apart!</span>")

	/*	var/obj/item/stack/rods/ =*/
		new /obj/item/stack/rods(get_turf(src))

		spark(src, 3, alldirs)

		explosion(src.loc,-1,-1,0)
		qdel(src)

/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access.Cut()
		src.req_one_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the [src].")
		spark(src, 2, alldirs)
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
	else if (src.emagged == 1)
		src.emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		spark(src, 2, alldirs)
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1

/obj/machinery/deployable/barrier/legion
	name = "legion barrier"
	desc = "A deployable barrier, bearing the marks of the Tau Ceti Foreign Legion. Swipe your ID card to lock/unlock it."
	icon_state = "barrier_legion"
	req_access = list(access_legion)

/obj/item/deployable_kit
	name = "Emergency Floodlight Kit"
	desc = "A do-it-yourself kit for constructing the finest of emergency floodlights."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_box"
	item_state = "box"
	var/kit_product = /obj/machinery/floodlight
	var/assembly_time = 8 SECONDS

/obj/item/deployable_kit/attack_self(mob/user)
	to_chat(user, span("notice","You start assembling \the [src]..."))
	if(do_after(user, assembly_time))
		assemble_kit(user)
		qdel(src)

/obj/item/deployable_kit/proc/assemble_kit(mob/user)
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
	var/atom/A = new kit_product(user.loc)
	user.visible_message(span("notice","[user] assembles \a [A]."),span("notice","You assemble \a [A]."))
	A.add_fingerprint(user)

/obj/item/deployable_kit/legion_barrier
	name = "legion barrier kit"
	desc = "A quick assembly kit for deploying id-lockable barriers in the field. Most commonly seen used for crowd control by corporate security."
	icon_state = "barrier_kit"
	w_class = 2
	kit_product = /obj/machinery/deployable/barrier/legion

/obj/item/deployable_kit/surgery_table
	name = "surgery table assembly kit"
	desc = "A quick assembly kit to deploy a surgery table in the field. Cannot be put together again after being unfolded, choose your spot wisely."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table_deployable"
	item_state = "table_parts"
	w_class = 4
	kit_product = /obj/machinery/optable
	assembly_time = 20 SECONDS

/obj/item/deployable_kit/surgery_table/assemble_kit(mob/user)
	..()
	var/free_spot = null
	for(var/check_dir in cardinal)
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
	w_class = 4
	kit_product = /obj/machinery/porta_turret/legion
	assembly_time = 15 SECONDS

/obj/item/deployable_kit/iv_drip
	name = "IV drip assembly kit"
	desc = "A quick assembly kit to put together an IV drip."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_box"
	item_state = "syringe_kit"
	w_class = 3
	kit_product = /obj/machinery/iv_drip
	assembly_time = 4 SECONDS
