/obj/item/computer_hardware/
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'
	var/obj/item/modular_computer/parent_computer
	/// If the hardware uses extra power, change this.
	var/power_usage = 0
	/// If the hardware is turned off set this to 0.
	var/enabled = TRUE
	/// Prevent disabling for important component, like the HDD.
	var/critical = TRUE
	/// Limits which devices can contain this component. 1: Tablets/Laptops/Consoles, 2: Laptops/Consoles, 3: Consoles only
	var/hardware_size = 1
	/// Current damage level
	var/damage = 0
	/// Maximal damage level.
	var/max_damage = 100
	/// "Malfunction" threshold. When damage exceeds this value the hardware piece will semi-randomly fail and do !!FUN!! things
	var/damage_malfunction = 20
	/// "Failure" threshold. When damage exceeds this value the hardware piece will not work at all.
	var/damage_failure = 50
	/// Chance of malfunction when the component is damaged
	var/malfunction_probability = 10

/**
 * Default handling of hardware enable/disable. Override for specific functionality.
 */
/obj/item/computer_hardware/proc/enable()
	. = enabled = TRUE

/**
 * Default handling of hardware enable/disable. Override for specific functionality.
 */
/obj/item/computer_hardware/proc/disable()
	. = enabled = FALSE

/**
 * Default handling of hardware enable/disable. Override for specific functionality.
 */
/obj/item/computer_hardware/proc/toggle()
	if(enabled)
		return disable()
	return enable()

/obj/item/computer_hardware/attackby(obj/item/attacking_item, mob/user)
	/// Multitool. Runs diagnostics
	if(attacking_item.ismultitool())
		to_chat(user, SPAN_NOTICE("***** DIAGNOSTICS REPORT *****"))
		diagnostics(user)
		to_chat(user, SPAN_NOTICE("******************************"))
		return 1
	/// Nanopaste. Repair all damage if present for a single unit.
	var/obj/item/stack/S = attacking_item
	if(istype(S, /obj/item/stack/nanopaste))
		if(!damage)
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to require repairs."))
			return TRUE
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You apply a bit of \the [attacking_item] to \the [src], repairing it fully."))
			damage = 0
		return TRUE
	/// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(S.iscoil())
		if(!damage)
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to require repairs."))
			return TRUE
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You patch up \the [src] with a bit of \the [attacking_item]."))
			take_damage(-10)
		return TRUE
	return ..()

/**
 * Called on multitool click, prints diagnostic information to the user.
 */
/obj/item/computer_hardware/proc/diagnostics(var/mob/user)
	to_chat(user, SPAN_NOTICE("Hardware Integrity Test... (Physical Damage: [damage]/[max_damage]) [damage > damage_failure ? "FAIL" : damage > damage_malfunction ? "WARN" : "PASS"]"))

/obj/item/computer_hardware/Initialize()
	. = ..()
	w_class = hardware_size
	if(istype(loc, /obj/item/modular_computer))
		parent_computer = loc
		return .

/obj/item/computer_hardware/Destroy()
	parent_computer = null
	return ..()

/**
 * Handles damage checks
 */
/obj/item/computer_hardware/proc/check_functionality()
	/// Turned off
	if(!enabled)
		return FALSE
	/// Too damaged to work at all.
	if(damage > damage_failure)
		return FALSE
	/// Still working. Well, sometimes...
	if(damage > damage_malfunction)
		if(prob(malfunction_probability))
			return FALSE
	/// Good to go.
	return TRUE

/obj/item/computer_hardware/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(damage > damage_failure)
		. += SPAN_DANGER("It seems to be severely damaged!")
	else if(damage > damage_malfunction)
		. += SPAN_WARNING("It seems to be damaged!")
	else if(damage)
		. += SPAN_WARNING("It seems to be slightly damaged.")

/**
 * Damages the component. Contains necessary checks. Negative damage "heals" the component.
 */
/obj/item/computer_hardware/proc/take_damage(var/amount)
	damage += round(amount)						/// We want nice rounded numbers here.
	damage = between(0, damage, max_damage)		/// Clamp the value.
