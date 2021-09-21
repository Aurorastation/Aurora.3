/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(flooring && (!ismob(user) || user.a_intent != I_HURT))
		if(C.iscrowbar())
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
		else if(C.isscrewdriver() && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/screwdriver.ogg', 80, 1)
			return
		else if(C.iswrench() && (flooring.flags & TURF_REMOVE_WRENCH))
			to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, C.usesound, 80, 1)
			return
		else if(istype(C, /obj/item/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return
		else if(C.iswelder() && (flooring.flags & TURF_REMOVE_WELDER))
			var/obj/item/weldingtool/WT = C
			if(!WT.isOn())
				to_chat(user, SPAN_WARNING("\The [WT] isn't turned on."))
				return
			if(WT.remove_fuel(0, user))
				to_chat(user, SPAN_NOTICE("You use \the [WT] to remove \the [src]."))
				make_plating(1)
				playsound(src, C.usesound, 80, 1)
				return
		else if(C.iscoil())
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return
	else

		if(C.iscoil())
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
			return
		else if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			var/list/decls = decls_repository.get_decls_of_subtype(/decl/flooring)
			for(var/flooring_type in decls)
				var/decl/flooring/F = decls[flooring_type]
				if(!F.build_type)
					continue
				if(ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				update_icon(TRUE)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs and deconstruction
		else if(C.iscrowbar())
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
		else if(C.iswelder())
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(do_after(user, 5 SECONDS))
						if(welder.remove_fuel(0, user))
							to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
							icon_state = "plating"
							burnt = null
							broken = null
						else
							to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
						return
				else
					if(welder.remove_fuel(0, user))
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						visible_message("<span class='notice'>[user] has started melting the plating's reinforcements!</span>")
						if(do_after(user, 10 SECONDS) && welder.isOn() && welder_melt())
							visible_message("<span class='warning'>[user] has melted the plating's reinforcements! It should be possible to pry it off.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
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
