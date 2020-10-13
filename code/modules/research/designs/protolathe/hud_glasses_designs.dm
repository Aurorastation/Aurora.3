/datum/design/item/hud
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	p_category = "HUD Glasses Designs"

/datum/design/item/hud/health
	req_tech = list('biotech':2,'magnets':3)
	build_path = /obj/item/clothing/glasses/hud/health

/datum/design/item/hud/security
	req_tech = list('magnets':3,'combat':2)
	build_path = /obj/item/clothing/glasses/hud/security
