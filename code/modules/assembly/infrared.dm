/obj/item/device/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500)

	secured = FALSE
	obj_flags = OBJ_FLAG_ROTATABLE

	var/on = FALSE
	var/visible = FALSE
	var/obj/effect/beam/i_beam/first = null
	var/turf/beam_origin //If we're not on this turf anymore, we've moved. Catches holder.master movements when we're attached to bombs and stuff.

/obj/item/device/assembly/infra/activate()
	if(!..())
		return FALSE //Cooldown check
	toggle_on()
	return TRUE

/obj/item/device/assembly/infra/proc/toggle_on()
	on = !on
	if(secured && on)
		START_PROCESSING(SSprocessing, src)
	else
		on = FALSE
		QDEL_NULL(first)
		STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/device/assembly/infra/toggle_secure()
	secured = !secured
	if(secured && on)
		START_PROCESSING(SSprocessing, src)
	else
		on = FALSE
		QDEL_NULL(first)
		STOP_PROCESSING(SSprocessing, src)
	update_icon()
	return secured

/obj/item/device/assembly/infra/update_icon()
	cut_overlays()
	attached_overlays = list()
	if(on)
		add_overlay("infrared_on")
		attached_overlays += "infrared_on"

	if(holder)
		holder.update_icon()

/obj/item/device/assembly/infra/rotate(var/mob/user, var/anchored_ignore = FALSE)
	if(..())
		var/direction_text = dir2text(dir)
		to_chat(user, SPAN_NOTICE("You rotate \the [src] to face [direction_text]."))
		QDEL_NULL(first)

/obj/item/device/assembly/infra/examine(mob/user)
	. = ..()
	var/direction_text = dir2text(dir)
	to_chat(user, SPAN_NOTICE("It is facing [direction_text]."))


/obj/item/device/assembly/infra/process()

	if(!on || !secured)
		QDEL_NULL(first)
		return ..()

	if(first && !isturf(first.loc))
		QDEL_NULL(first)

	//We have no infrared beam, so create one.
	if(!first)
		//We cannot create beams while being held or in a bag. So we have to compare locs to turfs.
		//We need to check if whatever we're attached to, if anything, is on a turf. Since we can be attached to an assembly and that assembly can be attached, we have to check a couple locs.
		//First check if we're part of an assembly(holder) and if that assembly is attached (holder.master). If we are, THOSE are the locs we care about.
		var/true_location = holder ? holder.master ? holder.master.loc : holder.loc : loc 
		if(!isturf(true_location)) //Wherever we are, we're not on a turf, nor is our assembly, nor is our bomb/whatever the assembly is attached to. We cannot make a beam.
			return
		beam_origin = true_location
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(true_location, src)
		I.density = TRUE
		step(I, I.dir)
		if(I)
			I.density = FALSE
			spawn(0)
				if(I)
					I.limit = 8
					I.process()
		return

	if(first)
		if(beam_origin != get_turf(src)) //If the assembly we're attached to has moved, delete the beam.
			QDEL_NULL(first)
			beam_origin = null
			return
		first.process()


/obj/item/device/assembly/infra/attack_hand()
	QDEL_NULL(first)
	return ..()

/obj/item/device/assembly/infra/Move()
	var/t = dir
	..()
	set_dir(t)
	QDEL_NULL(first)
	return

/obj/item/device/assembly/infra/holder_movement()
	if(!holder)
		return FALSE
	QDEL_NULL(first)
	return TRUE

/obj/item/device/assembly/infra/proc/trigger_beam()
	if(!secured || !on || cooldown)
		return FALSE
	pulse(FALSE)
	if(!holder)
		audible_message("[icon2html(src, viewers(get_turf(src)))] *beep* *beep*")
	cooldown = 2
	addtimer(CALLBACK(src, PROC_REF(process_cooldown)), 10)

/obj/item/device/assembly/infra/interact(mob/user)
	if(!secured)
		to_chat(user, SPAN_WARNING("\The [src] is unsecured!"))
		return

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "devices-assembly-infrared", 320, 220, capitalize_first_letters(name), state = deep_inventory_state)
	ui.open()

/obj/item/device/assembly/infra/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	VUEUI_SET_CHECK(data["active"], on, ., data)
	VUEUI_SET_CHECK(data["visible"], visible, ., data)

/obj/item/device/assembly/infra/Topic(href, href_list)
	..()

	if(href_list["state"])
		toggle_on()

	if(href_list["visible"])
		visible = !visible

	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	ui.check_for_change()


/***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/effect/beam/i_beam/next = null
	var/obj/item/device/assembly/infra/master = null
	var/limit = null

/obj/effect/beam/i_beam/New(loc, var/set_master)
	..()
	master = set_master
	if(!master.first)
		master.first = src
	set_dir(master.dir)
	check_visiblity()

/obj/effect/beam/i_beam/proc/hit()
	if(master)
		master.trigger_beam()
	qdel(src)

/obj/effect/beam/i_beam/proc/check_visiblity()
	if(master.visible)
		invisibility = 0
	else
		invisibility = 101

/obj/effect/beam/i_beam/process()
	if(loc?.density || !master)
		qdel(src)
		return

	check_visiblity()

	if(!limit)
		return

	if(!QDELETED(next))
		next.process()
		return

	var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(loc, master)
	I.density = TRUE
	step(I, I.dir)
	if(I)
		I.density = FALSE
		next = I
		spawn(0)
			if(I && limit > 0)
				I.limit = limit - 1
				I.process()

/obj/effect/beam/i_beam/Collide()
	. = ..()
	qdel(src)

/obj/effect/beam/i_beam/CollidedWith()
	..()
	hit()

/obj/effect/beam/i_beam/Crossed(atom/movable/AM as mob|obj)
	if(istype(AM, /obj/effect/beam))
		return
	if(AM.invisibility == INVISIBILITY_OBSERVER || AM.invisibility == 101)
		return
	spawn(0)
		hit()

/obj/effect/beam/i_beam/Destroy()
	if(master.first == src)
		master.first = null
	if(next)
		QDEL_NULL(next)
	return ..()

/obj/effect/beam/i_beam/set_dir(ndir)
	. = ..()
	if(ndir & EAST || ndir & WEST)
		var/matrix/M = matrix()
		M.Turn(90)
		transform = M