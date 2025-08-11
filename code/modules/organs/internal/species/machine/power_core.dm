/obj/item/organ/internal/machine/power_core
	name = "power core"
	desc = "An advanced power storage system for use in fully prosthetic bodies."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_battery"
	organ_tag = BP_CELL
	parent_organ = BP_CHEST
	max_damage = 80
	robotic_sprite = FALSE

	relative_size = 25

	/// If the power core's hatch is open. Battery can be removed if TRUE.
	var/open = FALSE
	/// The type (and later instance) of the cell inside this organ.
	var/obj/item/cell/cell = /obj/item/cell/super
	/// The cost of movement below (check process()) is multiplied by this factor.
	var/move_charge_factor = 1
	/// At 0.8 completely depleted after 60ish minutes of constant walking or 130 minutes of standing still.
	var/servo_cost = 0.8

/obj/item/organ/internal/machine/power_core/Initialize()
	robotize()
	replace_cell(new cell(src))
	. = ..()

/**
 * Returns current charge in %.
 */
/obj/item/organ/internal/machine/power_core/proc/percent()
	if(!cell)
		return FALSE

	return get_charge() / cell.maxcharge * 100

/**
 * Returns current charge level, modified by damage.
 */
/obj/item/organ/internal/machine/power_core/proc/get_charge()
	if(!cell)
		return FALSE

	return round(cell.charge*(1 - damage/max_damage))

/**
 * Wrapper for /obj/item/cell/proc/give.
 */
/obj/item/organ/internal/machine/power_core/proc/give(amount)
	if(!cell)
		return

	if(status & ORGAN_DEAD)
		return

	return cell.give(amount * get_damage_multiplier())

/obj/item/organ/internal/machine/power_core/use(var/amount)
	if(!is_usable() || !cell)
		return

	if(status & ORGAN_DEAD)
		amount *= 1.2 // uh oh

	return cell.use(amount)

/obj/item/organ/internal/machine/power_core/process()
	..()
	if(!owner)
		return

	if(owner.stat == DEAD)	//not a drain anymore
		return

	var/cost = get_power_drain()
	if(world.time - owner.l_move_time < 15)
		cost *= 2

	cost *= move_charge_factor
	use(cost)

/**
 * Gets the cost for walking. For some reason, handled in the fucking cell.
 */
/obj/item/organ/internal/machine/power_core/proc/get_power_drain()
	return servo_cost

/obj/item/organ/internal/machine/power_core/emp_act(severity)
	. = ..()
	if(electronics.get_status() > 0)
		to_chat(owner, SPAN_MACHINE_WARNING("Power core electronics damaged. Caution. Caution."))

/obj/item/organ/internal/machine/power_core/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(open)
			open = FALSE
			to_chat(user, SPAN_NOTICE("You screw the battery panel in place."))
		else
			open = TRUE
			to_chat(user, SPAN_NOTICE("You unscrew the battery panel."))

	if(attacking_item.iscrowbar())
		if(open)
			if(cell)
				user.put_in_hands(cell)
				to_chat(user, SPAN_NOTICE("You remove \the [cell] from \the [src]."))
				cell = null
			else
				to_chat(user, SPAN_WARNING("There is no cell to remove."))
		else
			to_chat(user, SPAN_WARNING("You need to unscrew the battery panel first."))

	if(istype(attacking_item, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
			else if(user.unEquip(attacking_item, src))
				replace_cell(attacking_item)
				to_chat(user, SPAN_NOTICE("You insert \the [cell]."))
		else
			to_chat(user, SPAN_WARNING("You need to unscrew the battery panel first."))

/obj/item/organ/internal/machine/power_core/low_integrity_damage(integrity)
	to_chat(owner, SPAN_WARNING("Your [src]'s wiring fizzles."))
	electronics.take_damage(10)
	. = ..()

/obj/item/organ/internal/machine/power_core/medium_integrity_damage(integrity)
	if(prob(get_integrity_damage_probability()))
		to_chat(owner, SPAN_DANGER("Your [src]'s power conduits burn!"))
		servo_cost *= 1.25
	. = ..()

/obj/item/organ/internal/machine/power_core/high_integrity_damage(integrity)
	if(prob(get_integrity_damage_probability()))
		to_chat(owner, SPAN_DANGER("Your [src]'s cell melts begins melting due to the overvoltage!"))
		var/old_charge = cell.maxcharge
		cell.maxcharge *= 0.85
		cell.use(old_charge - cell.maxcharge)
	. = ..()

/obj/item/organ/internal/machine/power_core/proc/replace_cell(var/obj/item/cell/C)
	if(istype(cell))
		qdel(cell)
	if(C.loc != src)
		C.forceMove(src)
	cell = C
	desc = initial(desc) + "This appears embedded with a [C.name]."

/obj/item/organ/internal/machine/power_core/listen()
	if(get_charge())
		return "faint hum of \the [src]"

/obj/item/organ/internal/machine/power_core/terminator
	name = "shielded power core"
	desc = "A small, powerful power core for use in fully prosthetic bodies. Equipped with anti-electromagnetic plating."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "shielded cell"
	parent_organ = BP_CHEST
	vital = TRUE
	emp_coeff = 0.1
