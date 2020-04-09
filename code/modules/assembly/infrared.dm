//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	origin_tech = list(TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500)

	wires = WIRE_PULSE
	secured = 0
	obj_flags = OBJ_FLAG_ROTATABLE

	var/on = 0
	var/visible = 0
	var/obj/effect/beam/i_beam/first = null

	proc
		trigger_beam()


	activate()
		if(!..())	return 0//Cooldown check
		on = !on
		update_icon()
		return 1


	toggle_secure()
		secured = !secured
		if(secured)
			START_PROCESSING(SSprocessing, src)
		else
			on = 0
			if(first)	qdel(first)
			STOP_PROCESSING(SSprocessing, src)
		update_icon()
		return secured


	update_icon()
		cut_overlays()
		attached_overlays = list()
		if(on)
			add_overlay("infrared_on")
			attached_overlays += "infrared_on"

		if(holder)
			holder.update_icon()
		return


	process()//Old code
		if(!on)
			if(first)
				qdel(first)
				return

		if((!(first) && (secured && (istype(loc, /turf) || (holder && istype(holder.loc, /turf))))))
			var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam((holder ? holder.loc : loc) )
			I.master = src
			I.density = 1
			I.set_dir(dir)
			step(I, I.dir)
			if(I)
				I.density = 0
				first = I
				I.vis_spread(visible)
				spawn(0)
					if(I)
						I.limit = 8
						I.process()
					return
		return


	attack_hand()
		qdel(first)
		..()
		return


	Move()
		var/t = dir
		..()
		set_dir(t)
		qdel(first)
		return


	holder_movement()
		if(!holder)	return 0
//		set_dir(holder.dir)
		qdel(first)
		return 1


	trigger_beam()
		if((!secured)||(!on)||(cooldown > 0))	return 0
		pulse(0)
		if(!holder)
			visible_message("\icon[src] *beep* *beep*")
		cooldown = 2
		addtimer(CALLBACK(src, .proc/process_cooldown), 10)
		return


	interact(mob/user as mob)//TODO: change this this to the wire control panel
		if(!secured)	return
		user.set_machine(src)
		var/dat = text("<TT><B>Infrared Laser</B>\n<B>Status</B>: []<BR>\n<B>Visibility</B>: []<BR>\n</TT>", (on ? text("<A href='?src=\ref[];state=0'>On</A>", src) : text("<A href='?src=\ref[];state=1'>Off</A>", src)), (src.visible ? text("<A href='?src=\ref[];visible=0'>Visible</A>", src) : text("<A href='?src=\ref[];visible=1'>Invisible</A>", src)))
		dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
		dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(dat, "window=infra")
		onclose(user, "infra")
		return


	Topic(href, href_list)
		..()
		if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
			usr << browse(null, "window=infra")
			onclose(usr, "infra")
			return

		if(href_list["state"])
			on = !(on)
			update_icon()

		if(href_list["visible"])
			visible = !(visible)
			spawn(0)
				if(first)
					first.vis_spread(visible)

		if(href_list["close"])
			usr << browse(null, "window=infra")
			return

		if(usr)
			attack_self(usr)

		return


/***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/effect/beam/i_beam/next = null
	var/obj/item/device/assembly/infra/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	anchored = 1.0


/obj/effect/beam/i_beam/proc/hit()
	if(master)
		master.trigger_beam()
	qdel(src)
	return

/obj/effect/beam/i_beam/proc/vis_spread(v)
	visible = v
	spawn(0)
		if(next)
			next.vis_spread(v)
		return
	return

/obj/effect/beam/i_beam/process()

	if((loc && loc.density) || !master)
		qdel(src)
		return

	if(left > 0)
		left--
	if(left < 1)
		if(!(visible))
			invisibility = 101
		else
			invisibility = 0
	else
		invisibility = 0


	var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(loc)
	I.master = master
	I.density = 1
	I.set_dir(dir)
	step(I, I.dir)

	if(I)
		if(!(next))
			I.density = 0
			I.vis_spread(visible)
			next = I
			spawn(0)
				if((I && limit > 0))
					I.limit = limit - 1
					I.process()
				return
		else
			qdel(I)
	else
		qdel(next)
	spawn(10)
		process()
		return
	return

/obj/effect/beam/i_beam/Collide()
	. = ..()
	qdel(src)

/obj/effect/beam/i_beam/CollidedWith()
	..()
	hit()

/obj/effect/beam/i_beam/Crossed(atom/movable/AM as mob|obj)
	if(istype(AM, /obj/effect/beam))
		return
	if( (AM.invisibility == INVISIBILITY_OBSERVER) || (AM.invisibility == 101) )
		return
	spawn(0)
		hit()
		return
	return

/obj/effect/beam/i_beam/Destroy()
	if(master.first == src)
		master.first = null
	if(next)
		qdel(next)
		next = null
	return ..()
