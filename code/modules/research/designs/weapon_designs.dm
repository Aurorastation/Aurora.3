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

/datum/design/item/weapon/gun/Fabricate()
	var/obj/item/gun/C = ..()
	if (SSATOMS_IS_PROBABLY_DONE)
		qdel(C.pin)
	else
		C.pin = null
	return C

/datum/design/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "uranium" = 500)
	build_path = /obj/item/gun/energy/floragun
	sort_string = "TBAAA"

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
	build_path = /obj/item/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 500, "silver" = 3000)
	build_path = /obj/item/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/item/weapon/eglaive
	id = "eglaive"
	name = "energy glaive"
	desc = "A Li'idra designed hardlight glaive reverse-engineered from schematics found amongst raider wreckages."
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_MATERIAL = 7, TECH_ILLEGAL = 4,TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 18750, "phoron" = 3000, "silver" = 7500)
	build_path = /obj/item/melee/energy/glaive
	sort_string = "TVAAA"

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

/datum/design/item/eshield
 	name = "Energy Shield"
 	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
 	id = "eshield"
 	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 4)
 	build_type = PROTOLATHE
 	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 3000, "phoron" = 1000)
 	build_path = /obj/item/shield/energy
 	category = "Weapons"
 	sort_string = "TVHAA"

/datum/design/item/weapon/gun/beegun
	id = "beegun"
	req_tech = list(TECH_MATERIAL = 6, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 6, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 500, "diamond" = 3000)
	build_path = /obj/item/gun/energy/beegun
	sort_string = "TVMAA"

///MODULAR WEAPON COMPONENTS
/datum/design/item/weapon/modular_small
	id = "stock_small"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/device/laser_assembly
	sort_string = "TZZAA"

/datum/design/item/weapon/modular_medium
	id = "stock_medium"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/device/laser_assembly/medium
	sort_string = "TZZAB"

/datum/design/item/weapon/modular_large
	id = "stock_large"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000)
	build_path = /obj/item/device/laser_assembly/large
	sort_string = "TZZAC"

/datum/design/item/weapon/modular_cap
	id = "stock_capacitor"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/laser_components/capacitor
	sort_string = "TZZBA"

/datum/design/item/weapon/modular_starch
	id = "stock_starch"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/laser_components/capacitor/potato
	sort_string = "TZZBB"

/datum/design/item/weapon/modular_capacitor_reinforced
	id = "stock_reinforced_cap"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/laser_components/capacitor/reinforced
	sort_string = "TZZBC"

/datum/design/item/weapon/modular_nuke
	id = "stock_nuke_cap"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "uranium" = 1000)
	build_path = /obj/item/laser_components/capacitor/nuclear
	sort_string = "TZZBD"

/datum/design/item/weapon/modular_teranium
	id = "stock_teranium"
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4, TECH_MAGNET = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/laser_components/capacitor/teranium
	sort_string = "TZZBE"

/datum/design/item/weapon/modular_phoron
	id = "stock_phoron"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "phoron" = 3000, "uranium" = 500)
	build_path = /obj/item/laser_components/capacitor/phoron
	sort_string = "TZZBF"

/datum/design/item/weapon/modular_bs
	id = "stock_bs"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 7, TECH_PHORON = 6, TECH_BLUESPACE = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "phoron" = 3000, "uranium" = 500, "diamond" = 1000)
	build_path = /obj/item/laser_components/capacitor/bluespace
	sort_string = "TZZBG"

/datum/design/item/weapon/modular_lens
	id = "stock_lens"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 2000)
	build_path = /obj/item/laser_components/focusing_lens
	sort_string = "TZZCA"

/datum/design/item/weapon/modular_splitter
	id = "stock_splitter"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 2000)
	build_path = /obj/item/laser_components/focusing_lens/shotgun
	sort_string = "TZZCB"

/datum/design/item/weapon/modular_sniper
	id = "stock_sniper"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 2000)
	build_path = /obj/item/laser_components/focusing_lens/sniper
	sort_string = "TZZCC"

/datum/design/item/weapon/modular_reinforced
	id = "stock_strong"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000)
	build_path = /obj/item/laser_components/focusing_lens/strong
	sort_string = "TZZCD"

/datum/design/item/weapon/modular_silent
	id = "stock_silence"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modifier/silencer
	sort_string = "TZZDA"

/datum/design/item/weapon/modular_aeg
	id = "stock_aeg"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/laser_components/modifier/aeg
	sort_string = "TZZDB"

/datum/design/item/weapon/modular_surge
	id = "stock_surge"
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/laser_components/modifier/surge
	sort_string = "TZZDC"

/datum/design/item/weapon/modular_repeater
	id = "stock_repeater"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/laser_components/modifier/repeater
	sort_string = "TZZDD"

/datum/design/item/weapon/modular_aux
	id = "stock_aux"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/laser_components/modifier/auxiliarycap
	sort_string = "TZZDE"

/datum/design/item/weapon/modular_overcharge
	id = "stock_repeater"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/laser_components/modifier/overcharge
	sort_string = "TZZDF"

/datum/design/item/weapon/modular_gatling
	id = "stock_gat"
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 3000, "phoron" = 2000, "silver" = 2000, "diamond" = 1000)
	build_path = /obj/item/laser_components/modifier/gatling
	sort_string = "TZZDG"

/datum/design/item/weapon/modular_scope
	id = "stock_scope"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500)
	build_path = /obj/item/laser_components/modifier/scope
	sort_string = "TZZDH"

/datum/design/item/weapon/modular_barrel
	id = "stock_barrel"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/barrel
	sort_string = "TZZDI"

/datum/design/item/weapon/modular_vents
	id = "stock_vents"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/vents
	sort_string = "TZZDJ"

/datum/design/item/weapon/modular_stock
	id = "stock_stock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/stock
	sort_string = "TZZDK"

/datum/design/item/weapon/modular_bayonet
	id = "stock_bayonet"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/bayonet
	sort_string = "TZZDL"

/datum/design/item/weapon/modular_ebayonet
	id = "stock_ebayonet"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "silver" = 500, "phoron" = 500)
	build_path = /obj/item/laser_components/modifier/ebayonet
	sort_string = "TZZDM"

/datum/design/item/weapon/modular_grip
	id = "stock_grip"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/grip
	sort_string = "TZZDN"

/datum/design/item/weapon/modular_taser
	id = "stock_taser"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/laser_components/modulator/taser
	sort_string = "TZZEA"

/datum/design/item/weapon/modular_tesla
	id = "stock_supertaser"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 6, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "silver" = 1000, "phoron" = 2000)
	build_path = /obj/item/laser_components/modulator/tesla
	sort_string = "TZZEB"

/datum/design/item/weapon/modular_ion
	id = "stock_ion"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 500, "phoron" = 2000)
	build_path = /obj/item/laser_components/modulator/ion
	sort_string = "TZZEC"

/datum/design/item/weapon/modular_soma
	id = "stock_soma"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 250, "uranium" = 250)
	build_path = /obj/item/laser_components/modulator/floramut
	sort_string = "TZZED"

/datum/design/item/weapon/modular_beta
	id = "stock_beta"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 250, "uranium" = 250)
	build_path = /obj/item/laser_components/modulator/floramut2
	sort_string = "TZZEE"

/datum/design/item/weapon/modular_pest
	id = "stock_pest"
	req_tech = list(TECH_MATERIAL = 1, TECH_BIO = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/laser_components/modulator/arodentia
	sort_string = "TZZEF"

/datum/design/item/weapon/modular_tag1
	id = "stock_tag1"
	req_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/red
	sort_string = "TZZEG"

/datum/design/item/weapon/modular_tag2
	id = "stock_tag2"
	req_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/blue
	sort_string = "TZZEH"

/datum/design/item/weapon/modular_tag3
	id = "stock_tag3"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/omni
	sort_string = "TZZEI"

/datum/design/item/weapon/modular_practice
	id = "stock_practice"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/practice
	sort_string = "TZZEJ"

/datum/design/item/weapon/modular_decloner
	id = "stock_declone"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/laser_components/modulator/decloner
	sort_string = "TZZEK"

/datum/design/item/weapon/modular_ebow
	id = "stock_ebow"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/laser_components/modulator/ebow
	sort_string = "TZZEL"

/datum/design/item/weapon/modular_blaster
	id = "stock_blaster"
	req_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 2000, "phoron" = 6000)
	build_path = /obj/item/laser_components/modulator/blaster
	sort_string = "TZZEM"

/datum/design/item/weapon/modular_laser
	id = "stock_laser"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 500, "phoron" = 1000)
	build_path = /obj/item/laser_components/modulator
	sort_string = "TZZEN"

/datum/design/item/weapon/modular_tox
	id = "stock_tox"
	req_tech = list(TECH_COMBAT = 4, TECH_PHORON = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "glass" = 1000, "phoron" = 2000)
	build_path = /obj/item/laser_components/modulator/tox
	sort_string = "TZZEO"

/datum/design/item/weapon/modular_net
	id = "stock_net"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4, TECH_ILLEGAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/laser_components/modulator/net
	sort_string = "TZZEP"

//Frames
/datum/design/item/weapon/ka_frame01
	id = "ka_frame01"
	req_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/gun/custom_ka/frame01
	sort_string = "TZZFA"

/datum/design/item/weapon/ka_frame02
	id = "ka_frame02"
	req_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/gun/custom_ka/frame02
	sort_string = "TZZFB"

/datum/design/item/weapon/ka_frame03
	id = "ka_frame03"
	req_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "silver" = 2000)
	build_path = /obj/item/gun/custom_ka/frame03
	sort_string = "TZZFC"

/datum/design/item/weapon/ka_frame04
	id = "ka_frame04"
	req_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "silver" = 2000, "diamond" = 1000)
	build_path = /obj/item/gun/custom_ka/frame04
	sort_string = "TZZFD"

/datum/design/item/weapon/ka_frame05
	id = "ka_frame05"
	req_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "silver" = 4000, "diamond" = 2000)
	build_path = /obj/item/gun/custom_ka/frame05
	sort_string = "TZZFE"

//Cells
/datum/design/item/weapon/ka_cell01
	id = "ka_cell01"
	req_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1,TECH_MAGNET = 1,TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 1000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell01
	sort_string = "TZZGA"

/datum/design/item/weapon/ka_cell02
	id = "ka_cell02"
	req_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 1,TECH_MAGNET = 1,TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "silver" = 1000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell02
	sort_string = "TZZGB"

/datum/design/item/weapon/ka_cell03
	id = "ka_cell03"
	req_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 3,TECH_MAGNET = 2,TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3000, "silver" = 3000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell03
	sort_string = "TZZGC"

/datum/design/item/weapon/ka_cell04
	id = "ka_cell04"
	req_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 4,TECH_MAGNET = 3,TECH_POWER = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 3000, "silver" = 3000, "gold" = 1000, "uranium" = 5000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell04
	sort_string = "TZZGD"

/datum/design/item/weapon/ka_cell05
	id = "ka_cell05"
	req_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 6,TECH_MAGNET = 5,TECH_POWER = 5, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 3000, "silver" = 3000, "gold" = 1000, "phoron" = 5000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell05
	sort_string = "TZZGE"

//Barrels
/datum/design/item/weapon/ka_barrel01
	id = "ka_barrel01"
	req_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1,TECH_MAGNET = 1, TECH_PHORON = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "phoron" = 500)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel01
	sort_string = "TZZHA"

/datum/design/item/weapon/ka_barrel02
	id = "ka_barrel02"
	req_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1,TECH_MAGNET = 3, TECH_PHORON = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "phoron" = 500)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel02
	sort_string = "TZZHB"

/datum/design/item/weapon/ka_barrel03
	id = "ka_barrel03"
	req_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 3,TECH_MAGNET = 3, TECH_PHORON = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "gold" = 2000, "phoron" = 1000)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel03
	sort_string = "TZZHC"

/datum/design/item/weapon/ka_barrel04
	id = "ka_barrel04"
	req_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 3,TECH_MAGNET = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 3000, "gold" = 3000, "phoron" = 3000, "diamond" = 1000)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel04
	sort_string = "TZZHD"

/datum/design/item/weapon/ka_barrel05
	id = "ka_barrel05"
	req_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 5,TECH_MAGNET = 6, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 4000, "gold" = 4000, "phoron" = 4000, "diamond" = 2000)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel05
	sort_string = "TZZHE"

//Upgrades
/datum/design/item/weapon/ka_upgrade01
	id = "ka_upgrade01"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/damage
	sort_string = "TZZIA"

/datum/design/item/weapon/ka_upgrade02
	id = "ka_upgrade02"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/firerate
	sort_string = "TZZIB"

/datum/design/item/weapon/ka_upgrade03
	id = "ka_upgrade03"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/effeciency
	sort_string = "TZZIC"

/datum/design/item/weapon/ka_upgrade04
	id = "ka_upgrade04"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/recoil
	sort_string = "TZZID"

/datum/design/item/weapon/ka_upgrade05
	id = "ka_upgrade05"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/focusing
	sort_string = "TZZIE"

/datum/design/item/weapon/ka_upgrade06
	id = "ka_upgrade06"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/capacity
	sort_string = "TZZIF"

/datum/design/item/weapon/ka_upgrade07
	id = "ka_upgrade07"
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/explosive
	sort_string = "TZZIG"
