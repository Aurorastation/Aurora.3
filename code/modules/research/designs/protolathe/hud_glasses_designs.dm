/datum/design/item/hud
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	p_category = "HUD Glasses Designs"

/datum/design/item/hud/health
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health

/datum/design/item/hud/security
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security

/datum/design/item/hud/mesons
	desc = "These glasses make use of meson-scanning technology to allow the wearer to see through solid walls and floors."
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/clothing/glasses/meson