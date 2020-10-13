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
	req_tech = "{'materials':2,'biotech':3,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 500, MATERIAL_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun

/datum/design/item/weapon/stunshell
	desc = "A stunning shell for a shotgun."
	req_tech = "{'combat':3,'materials':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/item/weapon/chemsprayer
	req_tech = "{'materials':3,'engineering':3,'biotech':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer

/datum/design/item/weapon/rapidsyringe
	req_tech = "{'combat':3,'materials':3,'engineering':3,'biotech':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	req_tech = "{'combat':3,'materials':4,'powerstorage':3,'magnets':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature

/datum/design/item/weapon/large_grenade
	req_tech = "{'combat':3,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large

/datum/design/item/weapon/eglaive
	req_tech = "{'combat':6,'phorontech':4,'materials':7,'syndicate':4,'powerstorage':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 18750, MATERIAL_PHORON = 3000, MATERIAL_SILVER = 7500)
	build_path = /obj/item/melee/energy/glaive

/datum/design/item/weapon/forcegloves
	desc = "These gloves bend gravity and bluespace, dampening inertia and augmenting the wearer's melee capabilities."
	req_tech = "{'combat':3,'bluespace':3,'engineering':3,'magnets':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/clothing/gloves/force/basic

/datum/design/item/weapon/eshield
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	req_tech = "{'magnets':3,'materials':4,'syndicate':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 3000, MATERIAL_PHORON = 1000)
	build_path = /obj/item/shield/energy

/datum/design/item/weapon/gun/beegun
	req_tech = "{'materials':6,'biotech':4,'powerstorage':4,'combat':6,'magnets':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500, MATERIAL_DIAMOND = 3000)
	build_path = /obj/item/gun/energy/beegun