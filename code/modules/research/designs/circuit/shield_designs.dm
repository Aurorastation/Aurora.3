/datum/design/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	p_category = "Shield Generator Circuit Designs"

/datum/design/circuit/shield/s_matrix
	name = "Shield Matrix"
	build_path = /obj/item/circuitboard/shield_matrix

/datum/design/circuit/shield/bubble
	name = "Bubble Shield Projector"
	build_path = /obj/item/circuitboard/shield_gen

/datum/design/circuit/shield/projector
	name = "Shield Projector"
	build_path = /obj/item/circuitboard/shield_gen_dir

/datum/design/circuit/shield/capacitor
	name = "Capacitor"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/shield_cap

/datum/design/circuit/shield/modulator
	req_tech = list(TECH_ENGINEERING = 2)

/datum/design/circuit/shield/modulator/hyperkinetic
	name = "Hyperkinetic Projectiles Shield Module"
	desc = "A module for altering the behaviour of produced force fields. This mode blocks various fast moving physical objects, such as bullets, blunt weapons, meteors and other."
	build_path = /obj/item/modulator_board/hyperkinetic

/datum/design/circuit/shield/modulator/photonic
	name = "Photonic Dispersion Shield Module"
	desc = "A module for altering the behaviour of produced force fields. This mode blocks majority of light. This includes beam weaponry and most of the visible light spectrum."
	build_path = /obj/item/modulator_board/photonic

/datum/design/circuit/shield/modulator/humanoids
	name = "Humanoid Lifeforms Module"
	desc = "A module for altering the behaviour of produced force fields. This mode blocks various humanoid lifeforms. Does not affect fully synthetic humanoids."
	build_path = /obj/item/modulator_board/humanoids

/datum/design/circuit/shield/modulator/silicon
	name = "Silicon Lifeforms Shield Module"
	desc = "A module for altering the behaviour of produced force fields. This mode blocks various silicon based lifeforms."
	build_path = /obj/item/modulator_board/silicon

/datum/design/circuit/shield/modulator/mobs
	name = "Unknown Lifeforms Shield Module"
	desc = "A module for altering the behaviour of produced force fields. This mode blocks various other non-humanoid and non-silicon lifeforms. Typical uses include blocking carps."
	build_path = /obj/item/modulator_board/mobs

/datum/design/circuit/shield/modulator/atmosphere
	name = "Atmospheric Containment Shield Module"
	desc = "A module for altering the behaviour of produced force fields. This mode blocks air flow and acts as atmosphere containment."
	req_tech = list(TECH_ENGINEERING = 5)
	build_path = /obj/item/modulator_board/atmosphere

/datum/design/circuit/shield/modulator/hull
	name = "Hull Shielding Shield Module"
	desc = "A module for altering the behaviour of produced force fields. This mode recalibrates the field to cover surface of the installation instead of projecting a bubble shaped field."
	build_path = /obj/item/modulator_board/hull

/datum/design/circuit/shield/modulator/adaptive
	name = "Adaptive Field Harmonics Shield Module"
	desc = "A module for altering the behaviour of produced forcefields. This mode modulates the shield harmonic frequencies, allowing the field to adapt to various damage types."
	req_tech = list(TECH_ENGINEERING = 8)
	build_path = /obj/item/modulator_board/adaptive

/datum/design/circuit/shield/modulator/overcharge
	name = "Field Overcharge Shield Module"
	desc = "A module for altering the behaviour of produced forcefields. This mode polarises the field, causing damage on contact."
	req_tech = list(TECH_ENGINEERING = 5)
	build_path = /obj/item/modulator_board/overcharge
