// Definitions for shield modes. Names, descriptions and power usage multipliers can be changed here.
// Do not change the mode_flag variables without a good reason!

/datum/shield_mode
	var/mode_name			// User-friendly name of this mode.
	var/mode_desc			// A short description of what the mode does.
	var/mode_flag			// Mode bitflag. See defines file.
	var/renwicks			// How many renwicks this mode uses passively. Most modes 0.2 - 0.5. High tier 1-2

/datum/shield_mode/proc/use_excess(var/renwicks)
	return

/datum/shield_mode/hyperkinetic
	mode_name = "Hyperkinetic Projectiles"
	mode_desc = "This mode blocks various fast moving physical objects, such as bullets, blunt weapons, meteors and other."
	mode_flag = MODEFLAG_HYPERKINETIC
	renwicks = 0.5

/datum/shield_mode/photonic
	mode_name = "Photonic Dispersion"
	mode_desc = "This mode blocks majority of light. This includes beam weaponry and most of the visible light spectrum."
	mode_flag = MODEFLAG_PHOTONIC
	renwicks = 0.5

/datum/shield_mode/humanoids
	mode_name = "Humanoid Lifeforms"
	mode_desc = "This mode blocks various humanoid lifeforms. Does not affect fully synthetic humanoids."
	mode_flag = MODEFLAG_HUMANOIDS
	renwicks = 1

/datum/shield_mode/silicon
	mode_name = "Silicon Lifeforms"
	mode_desc = "This mode blocks various silicon based lifeforms."
	mode_flag = MODEFLAG_ANORGANIC
	renwicks = 1

/datum/shield_mode/mobs
	mode_name = "Unknown Lifeforms"
	mode_desc = "This mode blocks various other non-humanoid and non-silicon lifeforms. Typical uses include blocking carps."
	mode_flag = MODEFLAG_NONHUMANS
	renwicks = 0.5

/datum/shield_mode/atmosphere
	mode_name = "Atmospheric Containment"
	mode_desc = "This mode blocks air flow and acts as atmosphere containment."
	mode_flag = MODEFLAG_ATMOSPHERIC
	renwicks = 2

/datum/shield_mode/hull
	mode_name = "Hull Shielding"
	mode_desc = "This mode recalibrates the field to cover surface of the installation instead of projecting a bubble shaped field."
	mode_flag = MODEFLAG_HULL
	renwicks = 0.5

/datum/shield_mode/adaptive
	mode_name = "Adaptive Field Harmonics"
	mode_desc = "This mode modulates the shield harmonic frequencies, allowing the field to adapt to various damage types."
	mode_flag = MODEFLAG_MODULATE
	renwicks = 2

/datum/shield_mode/overcharge
	mode_name = "Field Overcharge"
	mode_desc = "This mode polarises the field, causing damage on contact. Does not work with enabled safety protocols."
	mode_flag = MODEFLAG_OVERCHARGE
	renwicks = 3
