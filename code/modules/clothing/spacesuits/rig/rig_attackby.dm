/obj/item/rig/attackby(obj/item/attacking_item, mob/user)

	if(!isliving(user))
		return FALSE

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return

	// Pass repair items on to the chestpiece.
	if(chest && (istype(attacking_item, /obj/item/stack/material) || attacking_item.iswelder()))
		return chest.attackby(attacking_item, user)

	// Lock or unlock the access panel.
	if(attacking_item.GetID())
		if(subverted)
			locked = FALSE
			to_chat(user, SPAN_DANGER("It looks like the locking system has been shorted out."))
			return

		if((!req_access || !req_access.len) && (!req_one_access || !req_one_access.len))
			locked = FALSE
			to_chat(user, SPAN_DANGER("\The [src] doesn't seem to have a locking mechanism."))
			return

		if(security_check_enabled && locked && !src.allowed(user))
			to_chat(user, SPAN_DANGER("Access denied."))
			return

		locked = !locked
		to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src] access panel."))
		return

	else if(attacking_item.iscrowbar())

		if(!open && locked)
			//Ask to confirm the attempt, otherwise leave
			if(tgui_alert(user, "Do you want to try to force the hardsuit maintenance panel open?", "Force Open", list("Yes", "No")) != "Yes")
				return

			//Take a while to pry it open
			to_chat(user, SPAN_NOTICE("You start to pry open the maintenance panel of \the [src]."))
			if(do_after(user, 30 SECONDS, src))
				//You might be lucky not to touch any wire; emphasis on might
				if(prob(80))
					//If you get shocked, you lose all the progress, start over
					if(electrocute_mob(user, src.cell, src))
						to_chat(user, SPAN_ALERT("\The [src] wires electrocute you, before closing shut again!"))
						return

					//You did it, the Aut'akh are smiling upon you
					to_chat(user, SPAN_NOTICE("You manage to pry open \the [src] maintenance panel!"))

		open = !open
		to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] the access panel."))
		return

	if(open)

		// Hacking.
		wires.interact(user)

		// Air tank.
		if(istype(attacking_item,/obj/item/tank)) //Todo, some kind of check for suits without integrated air supplies.

			if(air_supply)
				to_chat(user, SPAN_NOTICE("\The [src] already has a tank installed."))
				return

			if(!user.unEquip(attacking_item))
				return

			air_supply = attacking_item
			attacking_item.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slot [attacking_item] into [src] and tighten the connecting valve."))
			return

		// Check if this is a hardsuit upgrade or a modification.
		else if(istype(attacking_item,/obj/item/rig_module))

			var/obj/item/rig_module/module = attacking_item
			if(istype(src.loc,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					to_chat(user, SPAN_DANGER("You can't install a hardsuit module while the suit is being worn."))
					return 1

			if(!installed_modules) installed_modules = list()

			if(!(module.category & allowed_module_types))
				var/mod_name = get_module_category(module.category)
				to_chat(user, SPAN_WARNING("\The [src] does not support [mod_name] modules!"))
				return 0

			if(installed_modules.len)
				for(var/obj/item/rig_module/installed_mod in installed_modules)
					if(!installed_mod.redundant && istype(installed_mod, attacking_item))
						to_chat(user, SPAN_NOTICE("The hardsuit already has a module of that class installed."))
						return 1

			var/obj/item/rig_module/mod = attacking_item
			to_chat(user, SPAN_NOTICE("You begin installing \the [mod] into \the [src]."))

			if(!do_after(user,40))
				return
			if(!user || !attacking_item)
				return
			if(!user.unEquip(mod))
				return

			to_chat(user, SPAN_NOTICE("You install \the [mod] into \the [src]."))
			installed_modules |= mod
			mod.forceMove(src)
			mod.installed(src)
			update_icon()
			return 1

		else if(!cell && istype(attacking_item,/obj/item/cell))

			if(!user.unEquip(attacking_item)) return
			to_chat(user, SPAN_NOTICE("You jack \the [attacking_item] into \the [src]'s battery mount."))
			attacking_item.forceMove(src)
			src.cell = attacking_item
			return

		else if(attacking_item.iswrench())

			if(!air_supply)
				to_chat(user, SPAN_WARNING("There is no tank to remove."))
				return

			if(user.r_hand && user.l_hand)
				air_supply.forceMove(get_turf(user))
			else
				user.put_in_hands(air_supply)
			to_chat(user, SPAN_NOTICE("You detach and remove \the [air_supply]."))
			air_supply = null
			return

		else if(attacking_item.isscrewdriver())

			var/list/current_mounts = list()
			if(cell) current_mounts   += "cell"
			if(installed_modules && installed_modules.len) current_mounts += "system module"

			var/to_remove = tgui_input_list(usr, "Which would you like to modify?", "Hardsuit Modification", current_mounts)
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

						user.put_in_hands(cell)

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

					var/removal_choice = tgui_input_list(usr, "Which module would you like to remove?", "Hardsuit Modification", possible_removals)
					if(!removal_choice)
						return

					var/obj/item/rig_module/removed = possible_removals[removal_choice]
					to_chat(user, SPAN_NOTICE("You detach \the [removed] from \the [src]."))
					removed.forceMove(get_turf(src))
					removed.removed()
					installed_modules -= removed
					update_icon()

		else if(istype(attacking_item,/obj/item/stack/nanopaste)) //EMP repair
			var/obj/item/stack/S = attacking_item
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
		if(module.accepts_item(attacking_item, user)) //Item is handled in this proc
			return
	..()


/obj/item/rig/attack_hand(var/mob/user)

	var/obj/item/rig_module/storage/storage = locate() in installed_modules
	if(storage && !storage.pockets.handle_attack_hand(user))
		return

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return
	..()

/obj/item/rig/emag_act(var/remaining_charges, var/mob/user)
	if(!subverted)
		req_access.Cut()
		req_one_access.Cut()
		locked = FALSE
		subverted = 1
		to_chat(user, SPAN_DANGER("You short out the access protocol for the suit."))
		return 1

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
