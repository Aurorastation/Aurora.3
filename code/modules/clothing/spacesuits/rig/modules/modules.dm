/*
 * Rigsuit upgrades/abilities.
 */

/datum/rig_charge
	var/short_name = "undef"
	var/display_name = "undefined"
	var/product_type = "undefined"
	var/charges = 0

/obj/item/rig_module
	name = "hardsuit upgrade"
	desc = "It looks pretty sciency."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"
	matter = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_PLASTIC = 30000, MATERIAL_GLASS = 5000)

	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL=7000, MATERIAL_GLASS =7000)
	var/construction_time = 100

	var/damage = 0
	var/obj/item/rig/holder

	var/module_cooldown = 10
	var/next_use = 0

	var/engage_on_activate = TRUE       // Whether the rig should call engage() in its activate() proc
	var/toggleable                      // Set to 1 for the device to show up as an active effect.
	var/usable                          // Set to 1 for the device to have an on-use effect.
	var/selectable                      // Set to 1 to be able to assign the device as primary system.
	var/redundant                       // Set to 1 to ignore duplicate module checking when installing.
	var/permanent                       // If set, the module can't be removed.
	var/disruptive = 1                  // Can disrupt by other effects.
	var/activates_on_touch              // If set, unarmed attacks will call engage() on the target.
	var/confined_use = FALSE				// If set, can be used inside mechs and other vehicles.

	var/active                          // Basic module status
	var/disruptable                     // Will deactivate if some other powers are used.
	var/attackdisrupts = 0             // Will deactivate if user attacks

	var/use_power_cost = 0              // Power used when single-use ability called.
	var/active_power_cost = 0           // Power used when turned on.
	var/passive_power_cost = 0          // Power used when turned off.

	var/list/charges                    // Associative list of charge types and remaining numbers.
	var/charge_selected                 // Currently selected option used for charge dispensing.

	// Icons.
	var/suit_overlay
	var/suit_overlay_active             // If set, drawn over icon and mob when effect is active.
	var/suit_overlay_inactive           // As above, inactive.
	var/suit_overlay_used               // As above, when engaged.

	//Display fluff
	var/interface_name = "hardsuit upgrade"
	var/interface_desc = "A generic hardsuit upgrade."
	var/engage_string = "Engage"
	var/activate_string = "Activate"
	var/deactivate_string = "Deactivate"

	var/list/stat_rig_module/stat_modules = new()
	var/category	// Use for restricting modules for specific suits, to specialize

/obj/item/rig_module/examine(mob/user)
	..()
	switch(damage)
		if(0)
			to_chat(user, SPAN_NOTICE("It is undamaged."))
		if(1)
			to_chat(user, SPAN_WARNING("It is badly damaged."))
		if(2)
			to_chat(user, SPAN_DANGER("It is almost completely destroyed."))

/obj/item/rig_module/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/nanopaste))
		if(damage == 0)
			to_chat(user, SPAN_WARNING("There is no damage to mend."))
			return

		to_chat(user, SPAN_NOTICE("You start mending the damaged portions of \the [src]..."))
		if(!do_after(user,30) || !W || !src)
			return

		var/obj/item/stack/nanopaste/paste = W
		damage = 0
		to_chat(user, SPAN_NOTICE("You mend the damage to \the [src] with \the [W]."))
		paste.use(1)
		return

	else if(W.iscoil())
		switch(damage)
			if(0)
				to_chat(user, SPAN_WARNING("There is no damage to mend."))
				return
			if(2)
				to_chat(user, SPAN_WARNING("\The [src] is too damaged to repair with cable coil, it needs nanopaste."))
				return

		var/obj/item/stack/cable_coil/cable = W
		if(!cable.amount >= 5)
			to_chat(user, SPAN_WARNING("You need five units of cable to repair \the [src]."))
			return

		to_chat(user, SPAN_NOTICE("You start mending the damaged portions of \the [src]..."))
		if(!do_after(user, 30) || !W || !src)
			return

		damage = 1
		to_chat(user, SPAN_NOTICE("You mend some of damage to \the [src] with \the [W], but you will need more advanced tools to fix it completely."))
		cable.use(5)
		return
	..()

/obj/item/rig_module/New()
	..()
	if(suit_overlay_inactive)
		suit_overlay = suit_overlay_inactive

	if(charges && charges.len)
		var/list/processed_charges = list()
		for(var/list/charge in charges)
			var/datum/rig_charge/charge_dat = new

			charge_dat.short_name   = charge[1]
			charge_dat.display_name = charge[2]
			charge_dat.product_type = charge[3]
			charge_dat.charges      = charge[4]

			if(!charge_selected) charge_selected = charge_dat.short_name
			processed_charges[charge_dat.short_name] = charge_dat

		charges = processed_charges

	stat_modules += new /stat_rig_module/activate(src)
	stat_modules += new /stat_rig_module/deactivate(src)
	stat_modules += new /stat_rig_module/engage(src)
	stat_modules += new /stat_rig_module/select(src)
	stat_modules += new /stat_rig_module/charge(src)


/obj/item/rig_module/Destroy()
	for(var/sm in stat_modules)
		qdel(sm)
	stat_modules.Cut()
	holder = null
	return ..()

// Called when the module is installed into a suit.
/obj/item/rig_module/proc/installed(var/obj/item/rig/new_holder)
	holder = new_holder
	return

/obj/item/rig_module/proc/do_engage(atom/target, mob/living/carbon/human/user)
	. = engage(target, user)
	if(.)
		var/old_next_use = next_use
		next_use = world.time + module_cooldown
		if(next_use > old_next_use && holder.wearer)
			var/obj/screen/inventory/back/B = locate(/obj/screen/inventory/back) in holder.wearer.hud_used.adding
			if(B)
				B.set_color_for(COLOR_RED, module_cooldown)

//Proc for one-use abilities like teleport.
/obj/item/rig_module/proc/engage(atom/target, mob/user)
	if(damage >= 2)
		to_chat(user, SPAN_WARNING("\The [interface_name] is damaged beyond use!"))
		return FALSE

	if(world.time < next_use)
		to_chat(user, SPAN_WARNING("You cannot use \the [interface_name] again so soon."))
		return FALSE

	if(!holder || holder.canremove)
		to_chat(user, SPAN_WARNING("The suit is not initialized."))
		return FALSE

	if(user.lying || user.stat || user.stunned || user.paralysis || user.weakened)
		to_chat(user, SPAN_WARNING("You cannot use the suit in this state."))
		return FALSE

	if(holder.wearer && holder.wearer.lying)
		to_chat(user, SPAN_WARNING("The suit cannot function while the wearer is prone."))
		return FALSE

	if(holder.security_check_enabled && !holder.check_suit_access(user))
		to_chat(user, SPAN_DANGER("Access denied."))
		return FALSE

	if(!holder.check_power_cost(user, use_power_cost, 0, src, (istype(user,/mob/living/silicon ? 1 : 0) ) ) )
		return FALSE

	if(!confined_use && istype(user.loc, /mob/living/heavy_vehicle))
		to_chat(user, SPAN_DANGER("You cannot use the suit in the confined space."))
		return FALSE

	return TRUE

// Proc for toggling on active abilities.
/obj/item/rig_module/proc/activate(mob/user)
	if(active)
		return FALSE
	if(engage_on_activate && !do_engage(null, user))
		return FALSE

	if(use_check_and_message(user, USE_ALLOW_NON_ADJACENT))
		return FALSE

	active = TRUE

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	return TRUE

// Proc for toggling off active abilities.
/obj/item/rig_module/proc/deactivate(mob/user)
	if(!active)
		return FALSE

	if(use_check_and_message(user, USE_ALLOW_NON_ADJACENT))
		return FALSE

	active = FALSE

	spawn(1)
		if(suit_overlay_inactive)
			suit_overlay = suit_overlay_inactive
		else
			suit_overlay = null
		if(holder)
			holder.update_icon()

	return TRUE

// Called when the module is uninstalled from a suit.
/obj/item/rig_module/proc/removed()
	deactivate()
	holder = null
	return

// Called by the hardsuit each rig process tick.
/obj/item/rig_module/process()
	if(active)
		return active_power_cost
	else
		return passive_power_cost

// Called by holder rigsuit attackby()
// Checks if an item is usable with this module and handles it if it is
/obj/item/rig_module/proc/accepts_item(var/obj/item/input_device)
	return FALSE

/obj/item/rig_module/proc/message_user(mob/user, var/user_text, var/wearer_text)
	to_chat(user, user_text)

	if(holder.wearer && user != holder.wearer)
		to_chat(holder.wearer, wearer_text)
		return

/mob/living/carbon/human/Stat()
	. = ..()

	if(. && istype(back,/obj/item/rig))
		var/obj/item/rig/R = back
		SetupStat(R)

/mob/proc/SetupStat(var/obj/item/rig/R)
	if(R && !R.canremove && R.installed_modules.len && statpanel("Hardsuit Modules"))
		var/cell_status = R.cell ? "[R.cell.charge]/[R.cell.maxcharge]" : "ERROR"
		stat("Suit charge", cell_status)
		for(var/obj/item/rig_module/module in R.installed_modules)
			for(var/stat_rig_module/SRM in module.stat_modules)
				if(SRM.CanUse())
					stat(SRM.module.interface_name,SRM)

/stat_rig_module
	parent_type = /atom/movable
	var/module_mode = ""
	var/obj/item/rig_module/module

/stat_rig_module/New(var/obj/item/rig_module/module)
	..()
	src.module = module

/stat_rig_module/Destroy()
	module = null
	return ..()

/stat_rig_module/proc/AddHref(var/list/href_list)
	return

/stat_rig_module/proc/CanUse()
	return FALSE

/stat_rig_module/Click()
	if(CanUse())
		var/list/href_list = list(
							"interact_module" = module.holder.installed_modules.Find(module),
							"module_mode" = module_mode
							)
		AddHref(href_list)
		module.holder.Topic(usr, href_list)

/stat_rig_module/DblClick()
	return Click()

/stat_rig_module/activate/New(var/obj/item/rig_module/module)
	..()
	name = module.activate_string
	if(module.active_power_cost)
		name += " ([module.active_power_cost*10]A)"
	module_mode = "activate"

/stat_rig_module/activate/CanUse()
	return module.toggleable && !module.active

/stat_rig_module/deactivate/New(var/obj/item/rig_module/module)
	..()
	name = module.deactivate_string
	// Show cost despite being 0, if it means changing from an active cost.
	if(module.active_power_cost || module.passive_power_cost)
		name += " ([module.passive_power_cost*10]P)"

	module_mode = "deactivate"

/stat_rig_module/deactivate/CanUse()
	return module.toggleable && module.active

/stat_rig_module/engage/New(var/obj/item/rig_module/module)
	..()
	name = module.engage_string
	if(module.use_power_cost)
		name += " ([module.use_power_cost*10]E)"
	module_mode = "engage"

/stat_rig_module/engage/CanUse()
	return module.usable

/stat_rig_module/select/New()
	..()
	name = "Select"
	module_mode = "select"

/stat_rig_module/select/CanUse()
	if(module.selectable)
		name = module.holder.selected_module == module ? "Selected" : "Select"
		return TRUE
	return FALSE

/stat_rig_module/charge/New()
	..()
	name = "Change Charge"
	module_mode = "select_charge_type"

/stat_rig_module/charge/AddHref(var/list/href_list)
	var/charge_index = module.charges.Find(module.charge_selected)
	if(!charge_index)
		charge_index = 0
	else
		charge_index = charge_index == module.charges.len ? 1 : charge_index+1

	href_list["charge_type"] = module.charges[charge_index]

/stat_rig_module/charge/CanUse()
	if(module.charges && module.charges.len)
		var/datum/rig_charge/charge = module.charges[module.charge_selected]
		name = "[charge.display_name] ([charge.charges]C) - Change"
		return TRUE
	return FALSE

/mob/living/carbon/human/ClickOn(atom/A, params)
	. = ..()
	if (ismob(A) && istype(back, /obj/item/rig))
		var/obj/item/rig/R = back
		R.attack_disrupt_check(src)

/mob/living/carbon/human/throw_item(atom/target)
	. = ..()
	if (ismob(src) && istype(back, /obj/item/rig))
		var/obj/item/rig/R = back
		R.attack_disrupt_check(src)

/obj/item/rig/proc/attack_disrupt_check()
	for (var/obj/item/rig_module/module in installed_modules)
		if (module.active && module.attackdisrupts)
			module.deactivate()
