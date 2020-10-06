/datum/design/item/weapon
	p_category = "Advanced Weapon Designs"

/datum/design/item/weapon/gun/Fabricate()
	var/obj/item/gun/C = ..()
	if(SSATOMS_IS_PROBABLY_DONE)
		qdel(C.pin)
	else
		C.pin = null
	return C

/datum/design/item/weapon/flora_gun
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 500, MATERIAL_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun

/datum/design/item/weapon/stunshell
	desc = "A stunning shell for a shotgun."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/item/weapon/chemsprayer
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer

/datum/design/item/weapon/rapidsyringe
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature

/datum/design/item/weapon/large_grenade
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large

/datum/design/item/weapon/eglaive
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_MATERIAL = 7, TECH_ILLEGAL = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 18750, MATERIAL_PHORON = 3000, MATERIAL_SILVER = 7500)
	build_path = /obj/item/melee/energy/glaive

/datum/design/item/weapon/forcegloves
	desc = "These gloves bend gravity and bluespace, dampening inertia and augmenting the wearer's melee capabilities."
	req_tech = list(TECH_COMBAT = 3, TECH_BLUESPACE = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/clothing/gloves/force/basic

/datum/design/item/weapon/eshield
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 3000, MATERIAL_PHORON = 1000)
	build_path = /obj/item/shield/energy

/datum/design/item/weapon/gun/beegun
	req_tech = list(TECH_MATERIAL = 6, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 6, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500, MATERIAL_DIAMOND = 3000)
	build_path = /obj/item/gun/energy/beegun

/datum/design/item/weapon/tacticalmask
	desc = "A compact carbon-fiber respirator covering the mouth and nose to protect against the inhalation of smoke and other harmful gasses."
	req_tech = list(TECH_BIO = 4, TECH_COMBAT = 4)
	materials = list(MATERIAL_GLASS = 1000, DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/clothing/mask/gas/tactical

/datum/design/item/weapon/nvg
	desc = "You can totally see in the dark now!"
	req_tech = list(TECH_COMBAT = 6, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 3000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/clothing/glasses/night

/datum/design/item/weapon/gravity_gun //Hello, Gordon!
	desc = "This nifty gun disables the gravity in the area you shoot at. Use with caution."
	req_tech = list(TECH_COMBAT = 4, TECH_BLUESPACE = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 3000, MATERIAL_PHORON = 500)
	build_path = /obj/item/gun/energy/gravity_gun

/datum/design/item/weapon/ammodisplay
	desc = "A device that can be attached to most firearms, providing a holographic display of the remaining ammunition to the user."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/ammo_display

/datum/design/item/weapon/maglight
	desc = "A heavy flashlight designed for security personnel."
	req_tech = light(TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 200, MATERIAL_GLASS = 100)
	build_path = /obj/item/device/flashlight/maglight