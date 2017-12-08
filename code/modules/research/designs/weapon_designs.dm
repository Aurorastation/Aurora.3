////////////////////////////////////////
//////////////////Weapons/////////////////
////////////////////////////////////////

	..()
	name = "Weapon prototype ([item_name])"

	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	sort_string = "TAAAA"

	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 500)
	sort_string = "TAAAB"

	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	sort_string = "TAAAD"

	id = "decloner"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list("gold" = 5000,"uranium" = 10000)
	sort_string = "TAAAE"

	id = "smg"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "silver" = 2000, "diamond" = 1000)
	sort_string = "TAABA"

	id = "ammo_9mm"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3750, "silver" = 100)
	build_path = /obj/item/ammo_magazine/c9mm
	sort_string = "TAACA"

	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TAACB"

	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	sort_string = "TABAA"

	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	sort_string = "TABAB"

	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 500, "silver" = 3000)
	sort_string = "TABAC"

	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	sort_string = "TACAA"

	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "uranium" = 500)
	sort_string = "TBAAA"

	id = "eglaive"
	name = "energy glaive"
	desc = "A Li'idra designed hardlight glaive reverse-engineered from schematics found amongst raider wreckages."
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_MATERIAL = 7, TECH_ILLEGAL = 4,TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 18750, "phoron" = 3000, "silver" = 7500)
	sort_string = "TVAAA"

	id = "gatlinglaser"
	name = "gatling laser"
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 18750, "glass" = 7500, "phoron" = 7500, "silver" = 7500, "diamond" = 3000)
	sort_string = "TVBAA"

	id = "railgun"
	name = "railgun"
	desc = "An advanced rifle that magnetically propels hyperdense rods at breakneck speeds to devastating effect."
	req_tech = list(TECH_COMBAT = 7, TECH_PHORON = 2, TECH_MATERIAL = 7, TECH_MAGNET = 4, TECH_POWER = 5, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 75000, "glass" = 18750, "phoron" = 11250, "gold" = 7500, "silver" = 7500)
	sort_string = "TVCAA"

	id = "zorablaster"
	name = "zo'ra blaster"
	req_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 2000, "phoron" = 6000)
	sort_string = "TVDAA"

	name = "Lawgiver"
	desc = "A highly advanced firearm for the modern police force. It has multiple voice-activated firing modes."
	id = "lawgiver"
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_BLUESPACE = 5, TECH_MATERIAL = 7)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000, "uranium" = 1000, "phoron" = 1000, "diamond" = 3000)
	sort_string = "TVEAA"

/datum/design/item/forcegloves
 	name = "Force Gloves"
 	desc = "These gloves bend gravity and bluespace, dampening inertia and augmenting the wearer's melee capabilities."
 	id = "forcegloves"
 	req_tech = list(TECH_COMBAT = 3, TECH_BLUESPACE = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 3)
 	build_type = PROTOLATHE
 	materials = list(DEFAULT_WALL_MATERIAL = 4000)
 	build_path = /obj/item/clothing/gloves/force/basic
 	category = "Weapons"
 	sort_string = "TVFAA"

/datum/design/item/ebow
 	name = "Energy Crossbow"
 	id = "ebow"
 	req_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 3, TECH_MATERIAL = 5, TECH_ILLEGAL = 3, TECH_BIO = 4)
 	build_type = PROTOLATHE
 	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 1000, "silver" = 1000)
 	category = "Weapons"
 	sort_string = "TVGAA"

/datum/design/item/eshield
 	name = "Energy Shield"
 	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
 	id = "eshield"
 	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 4)
 	build_type = PROTOLATHE
 	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 3000, "phoron" = 1000)
 	category = "Weapons"
 	sort_string = "TVHAA"

	id = "laser_shotgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1500, "uranium" = 500, "diamond" = 500)
	sort_string = "TVIAA"

	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 1000, "diamond" = 2000)
	sort_string = "TVJAA"

	id = "mousegun"
	req_tech = list(TECH_MATERIAL = 1, TECH_BIO = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "uranium" = 500)
	sort_string = "TVLAA"

	id = "beegun"
	req_tech = list(TECH_MATERIAL = 6, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 6, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 500, "diamond" = 3000)
	sort_string = "TVMAA"