/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(flooring && user.a_intent != I_HURT)
		if(C.iscrowbar())
			if(broken || burnt)
				to_chat(user, SPAN_NOTICE("You remove the broken [flooring.descriptor]."))
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				to_chat(user, SPAN_DANGER("You forcefully pry off the [flooring.descriptor], destroying them in the process."))
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				to_chat(user, SPAN_NOTICE("You lever off the [flooring.descriptor]."))
				make_plating(1)
			else
				return
			playsound(src, C.usesound, 80, 1)
			return
		else if(C.isscrewdriver() && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			to_chat(user, SPAN_NOTICE("You unscrew and remove the [flooring.descriptor]."))
			make_plating(1)
			playsound(src, 'sound/items/screwdriver.ogg', 80, 1)
			return
		else if(C.iswrench() && (flooring.flags & TURF_REMOVE_WRENCH))
			to_chat(user, SPAN_NOTICE("You unwrench and remove the [flooring.descriptor]."))
			make_plating(1)
			playsound(src, C.usesound, 80, 1)
			return
		else if(istype(C, /obj/item/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, SPAN_NOTICE("You shovel off the [flooring.descriptor]."))
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return
		else if(C.iscoil())
			to_chat(user, SPAN_WARNING("You must remove the [flooring.descriptor] first."))
			return
	else

		if(C.iscoil())
			if(broken || burnt)
				to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
				return
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
			return
		else if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
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
				to_chat(user, SPAN_WARNING("You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor]."))
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs.
		else if(C.iswelder())
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0,user))
						to_chat(user, SPAN_NOTICE("You fix some dents on the broken plating."))
						playsound(src, 'sound/items/welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))

/turf/simulated/floor/can_lay_cable()
	return !flooring

/turf/simulated/can_have_cabling()
	return TRUE
