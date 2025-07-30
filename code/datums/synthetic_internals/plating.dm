// The synthetic organ's plating. Represents its natural armour, which will degrade as it's damaged.

/datum/synthetic_internal/plating
	name = "internal steel plating"
	desc = "The steel plating that keeps internal components safe and sound from the exterior."
	/// The maximum health of the organ's plating. Represents... you know, the plating.
	var/max_health = 50
	/// The health of the organ's plating. Represents... you know, the plating.
	var/health = 50

/datum/synthetic_internal/plating/take_damage(amount)
	var/difference = max(amount - health, 0)
	health = max(health - amount, 0)
	return difference

/datum/synthetic_internal/plating/heal_damage(amount)
	health = min(health + amount, max_health)

/datum/synthetic_internal/plating/get_status()
	return (health / max_health) * 100

/datum/synthetic_internal/plating/replace_health(new_max_health)
	max_health = new_max_health
	health = new_max_health

/obj/item/synth_plating
	name = "synthetic steel plating"
	desc = "These steel plates are replacements for the steel plating lining a synthetic's internal components. They are welded to the chassis in order to safeguard the component in question."
	icon = 'icons/obj/ipc_utilities.dmi'
	icon_state = "ipc_repair_plates"
	matter = list(MATERIAL_STEEL = 40000)
	surgerysound = 'sound/weapons/saw/drillhit1.ogg'

/obj/item/synth_plating/mechanics_hints()
	. = ..()
	. += list("These plates are used to replace broken internal plating around a synthetic's organ. \
			While normally you can repair it with normal steel plates, in the case that it is broken, \
			you'll need to substitute the plating entirely with this item.")
