// Definitions for shield modes. Names, descriptions and power usage multipliers can be changed here.
// Do not change the mode_flag variables without a good reason!

/datum/shield_mode
	var/mode_name			// User-friendly name of this mode.
	var/mode_desc			// A short description of what the mode does.
	var/mode_flag			// Mode bitflag. See defines file.
	var/renwicks			// How many renwicks this mode uses passively. Most modes 0.2 - 0.5. High tier 1-2
	var/greedy = TRUE

/datum/shield_mode/proc/use_excess(var/renwicks)
	return

/datum/shield_mode/proc/adjust_damage(var/severity, var/damage, var/damage_flags)
	return severity

/datum/shield_mode/hyperkinetic
	mode_name = "Hyperkinetic Projectiles"
	mode_desc = "This mode blocks various fast moving physical objects, such as bullets, blunt weapons, meteors and other."
	mode_flag = MODEFLAG_HYPERKINETIC
	renwicks = 0.5

/datum/shield_mode/hyperkinetic/use_excess(renwicks)
	var/datum/component/armor/A = GetComponent(/datum/component/armor)
	if(istype(A))
		A.RemoveComponent()

	var/list/armor
	if(renwicks > 1.5)
		armor = list(melee = ARMOR_MELEE_KEVLAR,
					bullet = ARMOR_BALLISTIC_MEDIUM,
					bomb = ARMOR_BOMB_PADDED)
	else if(renwicks > 1)
		armor = list(melee = ARMOR_MELEE_KNIVES,
					bullet = ARMOR_BALLISTIC_PISTOL,
					bomb = ARMOR_BOMB_PADDED)
	else if(renwicks > 0.5)
		armor = list(melee = ARMOR_MELEE_SMALL,
					bullet = ARMOR_BALLISTIC_SMALL,
					bomb = ARMOR_BOMB_MINOR)
	else
		armor = list(melee = ARMOR_MELEE_MINOR,
					bullet = ARMOR_BALLISTIC_MINOR,
					bomb = ARMOR_BOMB_MINOR)
	AddComponent(/datum/component/armor, armor)

/datum/shield_mode/hyperkinetic/adjust_damage(severity, damage, damage_flags)
	var/datum/component/armor/A = GetComponent(/datum/component/armor)
	if(A)
		var/list/modified_damage = A.apply_damage_modifications(severity, damage, damage_flags, silent = TRUE)
		return modified_damage[1]
	return severity

/datum/shield_mode/photonic
	mode_name = "Photonic Dispersion"
	mode_desc = "This mode blocks majority of light. This includes beam weaponry and most of the visible light spectrum."
	mode_flag = MODEFLAG_PHOTONIC
	renwicks = 0.5

/datum/shield_mode/photonic/use_excess(renwicks)
	var/datum/component/armor/A = GetComponent(/datum/component/armor)
	if(istype(A))
		A.RemoveComponent()

	var/list/armor
	if(renwicks > 1.5)
		armor = list(laser = ARMOR_LASER_MEDIUM,
					energy = ARMOR_ENERGY_RESISTANT,
					bomb = ARMOR_BOMB_PADDED)
	else if(renwicks > 1)
		armor = list(laser = ARMOR_LASER_KEVLAR,
					energy = ARMOR_ENERGY_RESISTANT,
					bomb = ARMOR_BOMB_PADDED)
	else if(renwicks > 0.5)
		armor = list(laser = ARMOR_LASER_SMALL,
					energy = ARMOR_ENERGY_SMALL,
					bomb = ARMOR_BOMB_MINOR)
	else
		armor = list(laser = ARMOR_LASER_MINOR,
					energy = ARMOR_ENERGY_MINOR,
					bomb = ARMOR_BOMB_MINOR)
	AddComponent(/datum/component/armor, armor)

/datum/shield_mode/photonic/adjust_damage(severity, damage, damage_flags)
	var/datum/component/armor/A = GetComponent(/datum/component/armor)
	if(A)
		var/list/modified_damage = A.apply_damage_modifications(severity, damage, damage_flags, silent = TRUE)
		return modified_damage[1]
	return severity

/datum/shield_mode/humanoids
	mode_name = "Humanoid Lifeforms"
	mode_desc = "This mode blocks various humanoid lifeforms. Does not affect fully synthetic humanoids."
	mode_flag = MODEFLAG_HUMANOIDS
	renwicks = 1
	var/delay = 0

/datum/shield_mode/humanoids/use_excess(renwicks)
	delay = (5 + (10 * renwicks)) SECONDS
	delay = 10 //Another test line. Remove when done.

/datum/shield_mode/silicon
	mode_name = "Silicon Lifeforms"
	mode_desc = "This mode blocks various silicon based lifeforms."
	mode_flag = MODEFLAG_INORGANIC
	renwicks = 1
	var/delay = 0

/datum/shield_mode/silicon/use_excess(renwicks)
	delay = (5 + (10 * renwicks)) SECONDS

/datum/shield_mode/mobs
	mode_name = "Unknown Lifeforms"
	mode_desc = "This mode blocks various other non-humanoid and non-silicon lifeforms. Typical uses include blocking carps."
	mode_flag = MODEFLAG_NONHUMANS
	renwicks = 0.5
	var/delay = 0

/datum/shield_mode/mobs/use_excess(renwicks)
	delay = (5 + (10 * renwicks)) SECONDS

/datum/shield_mode/atmosphere
	mode_name = "Atmospheric Containment"
	mode_desc = "This mode blocks air flow and acts as atmosphere containment."
	mode_flag = MODEFLAG_ATMOSPHERIC
	renwicks = 2
	greedy = FALSE

/datum/shield_mode/hull
	mode_name = "Hull Shielding"
	mode_desc = "This mode recalibrates the field to cover surface of the installation instead of projecting a bubble shaped field."
	mode_flag = MODEFLAG_HULL
	renwicks = 0.5
	greedy = FALSE

/datum/shield_mode/adaptive
	mode_name = "Adaptive Field Harmonics"
	mode_desc = "This mode modulates the shield harmonic frequencies, allowing the field to adapt to various damage types."
	mode_flag = MODEFLAG_MODULATE
	renwicks = 2
	var/resonance = 0 //The higher the resonance, the better the armour we get from adapting
	var/adaption = ADAPTION_NEUTRAL

/datum/shield_mode/adaptive/use_excess(renwicks)
	if(renwicks > 1.5)
		resonance = 3
	else if(renwicks > 1)
		resonance = 2
	else
		resonance = 1

/datum/shield_mode/adaptive/adjust_damage(severity, damage, damage_flags)
	update_adaptive_armour(damage)
	var/datum/component/armor/A = GetComponent(/datum/component/armor)
	if(A)
		var/list/modified_damage = A.apply_damage_modifications(severity, damage, damage_flags, silent = TRUE)
		return modified_damage[1]
	return severity

/datum/shield_mode/adaptive/proc/update_adaptive_armour(var/damage)
	if(!damage)
		return
	var/datum/component/armor/A = GetComponent(/datum/component/armor)
	if(istype(A))
		A.RemoveComponent()

	if(damage == DAMAGE_BRUTE)
		adaption = min(adaption + resonance, ADAPTION_BALLISTIC_SUPER)
	else if (damage == DAMAGE_BURN)
		adaption = max(adaption - resonance, ADAPTION_LASER_SUPER)

	var/list/armor = list()
	switch(adaption)
		if(ADAPTION_BALLISTIC_SUPER)
			armor = list(melee = ARMOR_MELEE_MAJOR,
					bullet = ARMOR_BALLISTIC_RIFLE,
					bomb = ARMOR_BOMB_RESISTANT)
		else if(ADAPTION_LASER_SUPER)
			armor = list(laser = ARMOR_LASER_MAJOR,
					energy = ARMOR_ENERGY_STRONG,
					bomb = ARMOR_BOMB_RESISTANT)
		else if(ADAPTION_BALLISTIC_HIGH)
			armor = list(melee = ARMOR_MELEE_RESISTANT,
					bullet = ARMOR_BALLISTIC_CARBINE,
					bomb = ARMOR_BOMB_RESISTANT)
		else if(ADAPTION_LASER_HIGH)
			armor = list(laser = ARMOR_LASER_RIFLE,
					energy = ARMOR_ENERGY_RESISTANT,
					bomb = ARMOR_BOMB_RESISTANT)
		else if(ADAPTION_BALLISTIC_MEDIUM)
			armor = list(melee = ARMOR_MELEE_KEVLAR,
					bullet = ARMOR_BALLISTIC_MEDIUM,
					bomb = ARMOR_BOMB_PADDED,
					laser = ARMOR_LASER_MINOR,
					energy = ARMOR_ENERGY_MINOR)
		else if(ADAPTION_LASER_MEDIUM)
			armor = list(laser = ARMOR_LASER_MEDIUM,
					energy = ARMOR_ENERGY_RESISTANT,
					bomb = ARMOR_BOMB_PADDED,
					melee = ARMOR_MELEE_MINOR,
					bullet = ARMOR_BALLISTIC_MINOR)
		else if(ADAPTION_BALLISTIC_LOW)
			armor = list(melee = ARMOR_MELEE_KNIVES,
					bullet = ARMOR_BALLISTIC_PISTOL,
					bomb = ARMOR_BOMB_MINOR,
					laser = ARMOR_LASER_MINOR,
					energy = ARMOR_ENERGY_MINOR)
		else if(ADAPTION_LASER_LOW)
			armor = list(laser = ARMOR_LASER_KEVLAR,
					energy = ARMOR_ENERGY_SMALL,
					bomb = ARMOR_BOMB_MINOR,
					melee = ARMOR_MELEE_MINOR,
					bullet = ARMOR_BALLISTIC_MINOR)
		else
			armor = list(laser = ARMOR_LASER_SMALL,
					energy = ARMOR_ENERGY_SMALL,
					bomb = ARMOR_BOMB_MINOR,
					melee = ARMOR_MELEE_SMALL,
					bullet = ARMOR_BALLISTIC_SMALL)
	AddComponent(/datum/component/armor, armor)

/datum/shield_mode/overcharge
	mode_name = "Field Overcharge"
	mode_desc = "This mode polarises the field, causing damage on contact."
	mode_flag = MODEFLAG_OVERCHARGE
	renwicks = 3
	var/charge = 1

/datum/shield_mode/overcharge/use_excess(renwicks)
	if(renwicks > 1)
		charge = 2
	else
		charge = 1
