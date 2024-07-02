//SOLARIAN CIVILIAN (50 steel, 20 lead)
/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MATERIAL_STEEL = 600, MATERIAL_LEAD = 240)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12
	multiple_sprites = 1

// COALITION CIVILIAN (65 steel, 25 lead)
/obj/item/ammo_magazine/c10m
	name = "magazine (10mm)"
	icon_state = "45x"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p10mm
	matter = list(MATERIAL_STEEL = 750, MATERIAL_LEAD = 250)
	caliber = CALIBER_PISTOL_COC
	max_ammo = 10
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c10m/auto
	name = "extended magazine (10mm)"
	icon_state = "machine_pistol"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p10mm
	matter = list(MATERIAL_STEEL = 1190, MATERIAL_LEAD = 400) //+150 steel for extended mag
	caliber = CALIBER_PISTOL_COC
	max_ammo = 16
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c10m/smg
	name = "smg magazine (10mm)"
	icon_state = "smg"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p10mm
	matter = list(MATERIAL_STEEL = 1190, MATERIAL_LEAD = 400)
	caliber = CALIBER_PISTOL_COC
	max_ammo = 16
	multiple_sprites = TRUE

// SOLARIAN SERVICE (75 steel, 20 lead)
/obj/item/ammo_magazine/c57m
	name = "magazine (5.7mm)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p57mm
	matter = list(MATERIAL_STEEL = 725, MATERIAL_LEAD = 180)
	caliber = CALIBER_SERVICE_PISTOL_SOL
	max_ammo = 9
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c57m/rubber
	ammo_type = /obj/item/ammo_casing/p57mm/rubber
	matter = list(MATERIAL_STEEL = 725, MATERIAL_PLASTIC = 90)

/obj/item/ammo_magazine/c57m/extended
	name = "extended-capacity magazine (5.7mm)"
	desc = "A custom 5.7mm pistol magazine fitted with an extended baseplate, increasing capacity to eleven rounds."
	icon_state = "45e"
	max_ammo = 11

/obj/item/ammo_magazine/c57m/double
	name = "double-capacity magazine (5.7mm)"
	desc = "A custom 5.7mm pistol magazine made by welding two together. Has double the capacity of a normal magazine at eighteen rounds."
	icon_state = "45l"
	max_ammo = 18

/obj/item/ammo_magazine/c57m/dominia
	name = "dominian service pistol magazine (5.7mm)"
	desc = "A magazine specifically designed for a Dominian service pistol."
	icon = 'icons/obj/guns/dominia_pistol.dmi'
	icon_state = "dom_pistol_mag"
	max_ammo = 11

// COALITION SERVICE
/obj/item/ammo_magazine/c46m
	name = "magazine (4.6mm)"
	icon_state = "4.6x30p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_SERVICE_PISTOL_COC
	ammo_type = /obj/item/ammo_casing/p46mm
	max_ammo = 12
	multiple_sprites = TRUE

// COALITION SERVICE CASELESS
/obj/item/ammo_magazine/u46m
	name = "magazine (4.6mm caseless)"
	icon_state = "4.6x30p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_SERVICE_PISTOL_CASELESS_COC
	desc = "A magazine designed for the dNAC-4.6 pistol."
	ammo_type = /obj/item/ammo_casing/p46mm/caseless
	max_ammo = 15
	multiple_sprites = TRUE

/obj/item/ammo_magazine/u46m/extended
	name = "extended magazine (4.6mm caseless)"
	icon_state = "4.6x30p_extended"
	origin_tech = list(TECH_COMBAT = 3)
	desc = "A magazine designed for the dNAC-4.6 II submachine gun, but can also be used in the dNAC-4.6 pistol."
	max_ammo = 30

// SPECIAL

/obj/item/ammo_magazine/spitterpistol
	name = "spitter pistol magazine"
	icon_state = "spitterpistol_mag"
	caliber = CALIBER_HEGEMONY_PISTOL
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/moghes_pistol
	max_ammo = 8

/obj/item/ammo_magazine/c50m
	name = "magazine (.50)"
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_FRONTIER_DEAGLE
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = TRUE
