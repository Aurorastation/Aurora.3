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
