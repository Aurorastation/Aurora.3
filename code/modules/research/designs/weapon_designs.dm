////////////////////////////////////////
//////////////////Weapons/////////////////
////////////////////////////////////////

/datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TAAAA"

/datum/design/item/weapon/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAAAB"

/datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAAAD"

/datum/design/item/weapon/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list("gold" = 5000,"uranium" = 10000)
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAAAE"

/datum/design/item/weapon/smg
	id = "smg"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "silver" = 2000, "diamond" = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	sort_string = "TAABA"

/datum/design/item/weapon/ammo_9mm
	id = "ammo_9mm"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3750, "silver" = 100)
	build_path = /obj/item/ammo_magazine/c9mm
	sort_string = "TAACA"

/datum/design/item/weapon/stunshell
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TAACB"

/datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 500, "silver" = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TBAAA"

/datum/design/item/weapon/eglaive
	id = "eglaive"
	name = "energy glaive"
	desc = "A Li'idra designed hardlight glaive reverse-engineered from schematics found amongst raider wreckages."
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_MATERIAL = 7, TECH_ILLEGAL = 4,TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 18750, "phoron" = 3000, "silver" = 7500)
	build_path = /obj/item/weapon/melee/energy/glaive
	sort_string = "TVAAA"

/datum/design/item/weapon/gatlinglaser
	id = "gatlinglaser"
	name = "gatling laser"
	desc = "A higly sophisticated rapid-fire laser weapon."
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 18750, "glass" = 7500, "phoron" = 7500, "silver" = 7500, "diamond" = 3000)
	build_path = /obj/item/weapon/gun/energy/vaurca/gatlinglaser
	sort_string = "TVBAA"

/datum/design/item/weapon/railgun
	id = "railgun"
	name = "railgun"
	desc = "An advanced rifle that magnetically propels hyperdense rods at breakneck speeds to devastating effect."
	req_tech = list(TECH_COMBAT = 7, TECH_PHORON = 2, TECH_MATERIAL = 7, TECH_MAGNET = 4, TECH_POWER = 5, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 75000, "glass" = 18750, "phoron" = 11250, "gold" = 7500, "silver" = 7500)
	build_path = /obj/item/weapon/gun/projectile/automatic/railgun
	sort_string = "TVCAA"

/datum/design/item/weapon/zorablaster
	id = "zorablaster"
	name = "zo'ra blaster"
	desc = "A personal defense weapon reverse-engineered from schematics aboard Titan Prime."
	req_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 2000, "phoron" = 6000)
	build_path = /obj/item/weapon/gun/energy/vaurca/blaster
	sort_string = "TVDAA"

/datum/design/item/weapon/lawgiver
	name = "Lawgiver"
	desc = "A highly advanced firearm for the modern police force. It has multiple voice-activated firing modes."
	id = "lawgiver"
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_BLUESPACE = 5, TECH_MATERIAL = 7)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000, "uranium" = 1000, "phoron" = 1000, "diamond" = 3000)
	build_path = /obj/item/weapon/gun/energy/lawgiver
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
 	desc = "A weapon favoured by infiltration teams."
 	id = "ebow"
 	req_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 3, TECH_MATERIAL = 5, TECH_ILLEGAL = 3, TECH_BIO = 4)
 	build_type = PROTOLATHE
 	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 1000, "silver" = 1000)
 	build_path = /obj/item/weapon/gun/energy/crossbow/largecrossbow
 	category = "Weapons"
 	sort_string = "TVGAA"

/datum/design/item/eshield
 	name = "Energy Shield"
 	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
 	id = "eshield"
 	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 4)
 	build_type = PROTOLATHE
 	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 3000, "phoron" = 1000)
 	build_path = /obj/item/weapon/shield/energy
 	category = "Weapons"
 	sort_string = "TVHAA"

/datum/design/item/weapon/lasshotgun
	id = "laser_shotgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1500, "uranium" = 500, "diamond" = 500)
	build_path = /obj/item/weapon/gun/energy/laser/shotgun
	sort_string = "TVIAA"

/datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/rifle/laser/heavy
	sort_string = "TVJAA"

/datum/design/item/weapon/mousegun
	id = "mousegun"
	req_tech = list(TECH_MATERIAL = 1, TECH_BIO = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/mousegun
	sort_string = "TVLAA"

/datum/design/item/weapon/beegun
	id = "beegun"
	req_tech = list(TECH_MATERIAL = 6, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 6, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 500, "diamond" = 3000)
	build_path = /obj/item/weapon/gun/energy/beegun
	sort_string = "TVMAA"

/datum/design/item/weapon/trodpack
	id = "trodpack"
	req_tech = list(TECH_COMBAT = 7, TECH_PHORON = 2, TECH_MATERIAL = 7, TECH_MAGNET = 4, TECH_POWER = 5, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 9750, "phoron" = 5250, "gold" = 1100)
	build_path = /obj/item/ammo_magazine/trodpack
	sort_string = "TVNAA"