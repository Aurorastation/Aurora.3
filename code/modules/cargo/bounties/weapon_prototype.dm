/datum/bounty/weapon_prototype
	reward = 5000
	var/shipped = FALSE
	var/stat_value = 0
	var/stat_name = ""
	var/stat_comparison = "greater than"

/datum/bounty/weapon_prototype/New()
	name = "Weapon ([stat_name] [stat_comparison] [stat_value])"
	description = "[current_map.company_name] is interested in a laser prototype with a [stat_name] stat [stat_comparison] [stat_value]. [current_map.boss_name] will pay handsomely for such a weapon."
	reward += rand(0, 4) * 500
	..()

/datum/bounty/weapon_prototype/completion_string()
	return shipped ? "Shipped" : "Not Shipped"

/datum/bounty/weapon_prototype/can_claim()
	return ..() && shipped

/datum/bounty/weapon_prototype/applies_to(obj/O)
	if(shipped)
		return FALSE
	if(!istype(O, /obj/item/gun/energy/laser/prototype))
		return FALSE
	if(accepts_weapon(O))
		return TRUE
	return FALSE

/datum/bounty/weapon_prototype/ship(obj/O)
	if(!applies_to(O))
		return
	shipped = TRUE

/datum/bounty/weapon_prototype/compatible_with(datum/other_bounty)
	if(!istype(other_bounty, /datum/bounty/weapon_prototype))
		return TRUE
	var/datum/bounty/weapon_prototype/W = other_bounty
	return type != W.type


/datum/bounty/weapon_prototype/proc/accepts_weapon(var/obj/item/gun/energy/laser/prototype/P)
	return TRUE

/datum/bounty/weapon_prototype/burst
	stat_name = "burst"
	stat_value = 3
	stat_comparison = "greater than"

/datum/bounty/weapon_prototype/burst/accepts_weapon(var/obj/item/gun/energy/laser/prototype/P)
	return P.burst > stat_value

/datum/bounty/weapon_prototype/fire_delay
	stat_name = "fire delay"
	stat_value = 1
	stat_comparison = "smaller than"

/datum/bounty/weapon_prototype/fire_delay/accepts_weapon(var/obj/item/gun/energy/laser/prototype/P)
	return P.fire_delay < stat_value

/datum/bounty/weapon_prototype/reliability
	stat_name = "reliability"
	stat_value = 60
	stat_comparison = "greater than"

/datum/bounty/weapon_prototype/reliability/accepts_weapon(var/obj/item/gun/energy/laser/prototype/P)
	return P.reliability > stat_value

/datum/bounty/weapon_prototype/reliability
	stat_name = "accuracy"
	stat_value = 3
	stat_comparison = "greater than"

/datum/bounty/weapon_prototype/reliability/accepts_weapon(var/obj/item/gun/energy/laser/prototype/P)
	return P.accuracy > stat_value