/obj/item/rig/attackby(obj/item/W, mob/user)
	if(!istype(user,/mob/living))
		return FALSE

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return

	// Pass repair items on to the chestpiece.
	if(chest && (istype(W, /obj/item/stack/material) || W.iswelder()))
		return chest.attackby(W,user)

	// Lock or unlock the access panel.
	if(W.GetID())
		if(subverted)
			locked = FALSE
			to_chat(user, SPAN_WARNING("It looks like the locking system has been shorted out."))
			return

		if((!req_access || !req_access.len) && (!req_one_access || !req_one_access.len))
			locked = FALSE
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to have a locking mechanism."))
			return

		if(lock_broken)
			to_chat(user, SPAN_WARNING("\The [src]'s lock is completely broken!"))
			return

		if(security_check_enabled && !src.allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return

		locked = !locked
		to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src] access panel."))
		return

	else if(W.iscrowbar())
		if(!open && locked)
			to_chat(user, SPAN_WARNING("The access panel is locked shut."))
			return
		if(lock_broken)
			to_chat(user, SPAN_WARNING("\The [src]'s access panel is broken and can't be closed anymore!"))
			return

		open = !open
		to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] the access panel."))
		return

	if(open)
		// Hacking.
		if(W.iswirecutter() || W.ismultitool())
			wires.Interact(user)

			return
		// Air tank.
		if(istype(W,/obj/item/tank)) //Todo, some kind of check for suits without integrated air supplies.
			if(air_supply)
				to_chat(user, SPAN_WARNING("\The [src] already has a tank installed."))
				return

			if(!user.unEquip(W))
				return
			air_supply = W
			W.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src] and tighten the connecting valve."))
			return

		// Check if this is a hardsuit upgrade or a modification.
		else if(istype(W, /obj/item/rig_module))
			var/obj/item/rig_module/module = W
			if(istype(src.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					to_chat(user, SPAN_WARNING("You can't install a hardsuit module while the suit is being worn."))
					return TRUE

			if(!installed_modules)
				installed_modules = list()

			if(!(module.category & allowed_module_types))
				var/mod_name = get_module_category(module.category)
				to_chat(user, SPAN_WARNING("\The [src] does not support [mod_name] modules!"))
				return FALSE

			if(length(installed_modules))
				for(var/obj/item/rig_module/installed_mod in installed_modules)
					if(!installed_mod.redundant && istype(installed_mod,W))
						to_chat(user, SPAN_WARNING("The hardsuit already has a module of that class installed."))
						return TRUE

			var/obj/item/rig_module/mod = W
			to_chat(user, SPAN_NOTICE("You begin installing \the [mod] into \the [src]."))
			if(!do_after(user, 40))
				return
			if(!user || !W)
				return
			if(!user.unEquip(mod))
				return
			to_chat(user, SPAN_NOTICE("You install \the [mod] into \the [src]."))
			installed_modules |= mod
			mod.forceMove(src)
			mod.installed(src)
			update_icon()
			return TRUE

		else if(!cell && istype(W, /obj/item/cell))
			if(!user.unEquip(W))
				return
			to_chat(user, SPAN_NOTICE("You jack \the [W] into \the [src]'s battery mount."))
			W.forceMove(src)
			src.cell = W
			return

		else if(W.iswrench())
			if(!air_supply)
				to_chat(user, SPAN_WARNING("\The [src] doesn't have an air tank attached."))
				return

			if(user.r_hand && user.l_hand)
				air_supply.forceMove(get_turf(user))
			else
				user.put_in_hands(air_supply)
			to_chat(user, SPAN_NOTICE("You detach and remove \the [air_supply]."))
			air_supply = null
			return

		else if(W.isscrewdriver())
			var/list/current_mounts = list()
			if(cell)
				current_mounts += "cell"
			if(length(installed_modules))
				current_mounts += "system module"

			var/to_remove = input("Which would you like to modify?") as null|anything in current_mounts
			if(!to_remove)
				return

			if(istype(src.loc,/mob/living/carbon/human) && to_remove != "cell")
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					to_chat(user, SPAN_WARNING("You can't remove an installed device while the hardsuit is being worn."))
					return

			switch(to_remove)
				if("cell")
					if(cell)
						to_chat(user, SPAN_NOTICE("You detach \the [cell] from \the [src]'s battery mount."))
						for(var/obj/item/rig_module/module in installed_modules)
							module.deactivate()
						if(user.r_hand && user.l_hand)
							cell.forceMove(get_turf(user))
						else
							cell.forceMove(user.put_in_hands(cell))
						cell = null
					else
						to_chat(user, SPAN_WARNING("There is nothing loaded in that mount."))

				if("system module")
					var/list/possible_removals = list()
					for(var/obj/item/rig_module/module in installed_modules)
						if(module.permanent)
							continue
						possible_removals[module.name] = module

					if(!possible_removals.len)
						to_chat(user, SPAN_WARNING("There are no installed modules to remove."))
						return

					var/removal_choice = input("Which module would you like to remove?") as null|anything in possible_removals
					if(!removal_choice)
						return

					var/obj/item/rig_module/removed = possible_removals[removal_choice]
					to_chat(user, SPAN_NOTICE("You detach \the [removed] from \the [src]."))
					removed.forceMove(get_turf(src))
					removed.removed()
					installed_modules -= removed
					update_icon()

		else if(istype(W, /obj/item/stack/nanopaste)) //EMP repair
			var/obj/item/stack/S = W
			if(malfunctioning || malfunction_delay)
				if(S.use(1))
					to_chat(user, SPAN_NOTICE("You pour some of \the [S] over \the [src]'s control circuitry."))
					malfunctioning = 0
					malfunction_delay = 0
				else
					to_chat(user, SPAN_WARNING("\The [S] is empty!"))
		return

	// If we've gotten this far, all we have left to do before we pass off to root procs
	// is check if any of the loaded modules want to use the item we've been given.
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.accepts_item(W, user)) //Item is handled in this proc
			return

	if(!open)
		user.do_attack_animation(src)
		var/others_msg = "\The [user] [pick(W.attack_verb)] \the [src] with \the [W][W.force ? "" : ", but it bounces off"]!"
		var/self_msg = "You [pick(W.attack_verb)] \the [src] with \the [W][W.force ? "" : ", but it bounces off"]!"
		user.visible_message(SPAN_WARNING(others_msg), SPAN_NOTICE(self_msg))
		playsound(loc, W.hitsound, 60, TRUE)
		playsound(loc, 'sound/weapons/smash.ogg', 50, TRUE)
		lock_health -= W.force
		if(lock_health <= 0)
			visible_message(SPAN_DANGER("\The [src]'s access hatch blows open!"))
			spark(get_turf(src), 3, alldirs)
			open = TRUE
			locked = FALSE
			lock_broken = TRUE

/obj/item/rig/attack_hand(var/mob/user)
	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return
	..()

/obj/item/rig/emag_act(var/remaining_charges, var/mob/user)
	if(!subverted)
		req_access.Cut()
		req_one_access.Cut()
		locked = FALSE
		subverted = TRUE
		to_chat(user, SPAN_NOTICE("You short out the access protocol for the suit."))
		return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] is already subverted!"))
		return FALSE

/obj/item/rig/proc/get_module_category(var/category)
	switch(category)
		if(MODULE_GENERAL)
			return "general"
		if(MODULE_LIGHT_COMBAT)
			return "light combat"
		if(MODULE_HEAVY_COMBAT)
			return "heavy combat"
		if(MODULE_UTILITY)
			return "utility"
		if(MODULE_MEDICAL)
			return "medical"
		if(MODULE_SPECIAL)
			return "special"
		if(MODULE_VAURCA)
			return "vaurca"