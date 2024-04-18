//SOLARIAN CIVILIAN
/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12
	multiple_sprites = 1

// COALITION CIVILIAN
/obj/item/ammo_magazine/c10m
	name = "magazine (10mm)"
	icon_state = "45x"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p10mm
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = CALIBER_PISTOL_COC
	max_ammo = 10
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c10m/auto
	name = "extended magazine (10mm)"
	icon_state = "machine_pistol"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p10mm
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = CALIBER_PISTOL_COC
	max_ammo = 16
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c10m/smg
	name = "smg magazine (10mm)"
	icon_state = "smg"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p10mm
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = CALIBER_PISTOL_COC
	max_ammo = 16
	multiple_sprites = TRUE

// SOLARIAN SERVICE
/obj/item/ammo_magazine/c57m
	name = "magazine (5.7mm)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p57mm
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = CALIBER_SERVICE_PISTOL_SOL
	max_ammo = 9
	multiple_sprites = TRUE

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
