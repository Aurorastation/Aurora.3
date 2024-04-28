/turf/simulated/floor/attackby(obj/item/attacking_item, mob/user)

	if(!attacking_item || !user)
		return 0

	if(flooring && (!ismob(user) || user.a_intent != I_HURT))
		if(attacking_item.iscrowbar())
			if(broken || burnt)
				to_chat(user, "<span class='notice'>You remove the broken [flooring.descriptor].</span>")
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				to_chat(user, "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>")
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				to_chat(user, "<span class='notice'>You lever off the [flooring.descriptor].</span>")
				make_plating(1)
			else
				return
			playsound(src, 'sound/items/crowbar_tile.ogg', 80, 1)
			return
		else if(attacking_item.isscrewdriver() && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
			make_plating(1)
			attacking_item.play_tool_sound(get_turf(src), 80)
			return
		else if(attacking_item.iswrench() && (flooring.flags & TURF_REMOVE_WRENCH))
			to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
			make_plating(1)
			attacking_item.play_tool_sound(get_turf(src), 80)
			return
		else if(istype(attacking_item, /obj/item/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
			make_plating(1)
			attacking_item.play_tool_sound(get_turf(src), 80)
			return
		else if(attacking_item.iswelder() && (flooring.flags & TURF_REMOVE_WELDER))
			var/obj/item/weldingtool/WT = attacking_item
			if(!WT.isOn())
				to_chat(user, SPAN_WARNING("\The [WT] isn't turned on."))
				return
			if(WT.use(0, user))
				to_chat(user, SPAN_NOTICE("You use \the [WT] to remove \the [src]."))
				make_plating(1)
				attacking_item.play_tool_sound(get_turf(src), 80)
				return
		else if(attacking_item.iscoil())
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return
	else

		if(attacking_item.iscoil())
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/cable_coil/coil = attacking_item
			coil.turf_place(src, user)
			return
		else if(istype(attacking_item, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/S = attacking_item
			var/singleton/flooring/use_flooring
			var/list/decls = GET_SINGLETON_SUBTYPE_MAP(/singleton/flooring)
			for(var/flooring_type in decls)
				var/singleton/flooring/F = decls[flooring_type]
				if(!F.build_type)
					continue
				if((ispath(S.type, F.build_type) && (S.type == F.build_type)) || (ispath(S.build_type, F.build_type) && (S.build_type == F.build_type)))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, flooring, DO_REPAIR_CONSTRUCT))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				update_icon(TRUE)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs and deconstruction
		else if(attacking_item.iscrowbar())
			var/area/A = get_area(src)
			if(A && (A.area_flags & AREA_FLAG_INDESTRUCTIBLE_TURFS))
				return
			if(broken || burnt)
				playsound(src, 'sound/items/crowbar_tile.ogg', 80, 1)
				visible_message("<span class='notice'>[user] has begun prying off the damaged plating.</span>")
				var/turf/T = GetBelow(src)
				if(T)
					T.visible_message("<span class='warning'>The ceiling above looks as if it's being pried off.</span>")
				if(do_after(user, 10 SECONDS))
					if(!istype(src, /turf/simulated/floor))
						return
					if(broken || burnt && !(is_plating()))
						return
					visible_message("<span class='warning'>[user] has pried off the damaged plating.</span>")
					new /obj/item/stack/tile/floor(src)
					src.ReplaceWithLattice()
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
					if(T)
						T.visible_message("<span class='danger'>The ceiling above has been pried off!</span>")
				return
			return
		else if(attacking_item.iswelder())
			var/obj/item/weldingtool/welder = attacking_item
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(do_after(user, 5 SECONDS))
						if(welder.use(0, user))
							to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
							icon_state = "plating"
							burnt = null
							broken = null
						else
							to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
						return
				else
					if(welder.use(0, user))
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						visible_message("<span class='notice'>[user] has started melting the plating's reinforcements!</span>")
						if(welder.use_tool(src, user, 100, volume = 80) && welder.isOn() && welder_melt())
							visible_message("<span class='warning'>[user] has melted the plating's reinforcements! It should be possible to pry it off.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
					return

	if(istype(attacking_item,/obj/item/floor_frame))
		var/obj/item/floor_frame/F = attacking_item
		F.try_build(src, user)
		return

	return ..()

/turf/simulated/floor/proc/welder_melt()
	if(!(is_plating()) || broken || burnt)
		return 0
	burnt = 1
	update_icon()
	return 1

/turf/simulated/floor/can_lay_cable()
	return !flooring

/turf/simulated/can_have_cabling()
	return TRUE
