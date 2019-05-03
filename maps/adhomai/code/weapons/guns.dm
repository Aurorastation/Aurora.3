// RIFLES
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka
	name = "service rifle"
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	contained_sprite = TRUE
	desc = "The standard issue rifle of the levy Alam'ard."
	accuracy = -1
	can_sawoff = FALSE
	has_wield_state = TRUE

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped
	name = "scoped service rifle"
	desc = "A cheap ballistic rifle often found in the hands of tajaran soldiers. This one has been outfitted with a telescopic sight."
	icon_state = "scope"
	item_state = "scope"
	scoped_accuracy = 3
	can_bayonet = FALSE
	load_method = SINGLE_CASING

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/weapon/gun/projectile/grenadier
	name = "semi-automatic rifle"
	desc = "A semi-automatic ballistic rifle issued to the Royal Grenadiers."
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "semi"
	item_state = "semi"
	contained_sprite = TRUE
	w_class = 4
	load_method = MAGAZINE
	max_shells = 5
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a762/nka
	magazine_type = /obj/item/ammo_magazine/boltaction/nka/enbloc
	allowed_magazines = list(/obj/item/ammo_magazine/boltaction/nka/enbloc)
	fire_sound = 'sound/weapons/rifleshot.ogg'
	auto_eject_sound = 'maps/adhomai/sound/ping.ogg'
	accuracy = -1
	auto_eject = 1
	recoil = 3
	fire_delay = 5
	jam_chance = 2

	recoil_wielded = 1
	accuracy_wielded = 1

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/grenadier/can_wield()
	return TRUE

/obj/item/weapon/gun/projectile/grenadier/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/grenadier/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/projectile/automatic/rifle/pra
	desc = "An automatic rifle issued to the forces of the Republican Army."
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "pra_rifle"
	item_state = "pra_rifle"
	contained_sprite = TRUE
	jam_chance = 5

/obj/item/weapon/gun/projectile/automatic/rifle/pra/update_icon()
	..()
	icon_state = (ammo_magazine)? "pra_rifle" : "pra_rifle-empty"
	if(wielded)
		item_state = (ammo_magazine)? "pra_rifle-wielded" : "pra_rifle-wielded-empty"
	else
		item_state = (ammo_magazine)? "pra_rifle" : "pra_rifle-empty"
	update_held_icon()

// PISTOLS AND REVOLVERS
/obj/item/weapon/gun/projectile/nka
	name = "service automatic"
	desc = "A somewhat reliable, open bolt sidearm issued to members of the Imperial Adhomian Army."
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "nka"
	contained_sprite = TRUE
	ammo_type = /obj/item/ammo_casing/c38/nka
	magazine_type = /obj/item/ammo_magazine/nka
	allowed_magazines = list(/obj/item/ammo_magazine/nka)
	auto_eject = 1
	jam_chance = 10
	caliber = "38"
	accuracy = 1
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/nka/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "nka"
	else
		icon_state = "nka-empty"

/obj/item/weapon/gun/projectile/nka/kt_76
	name = "KT-76 service pistol"
	desc = "A more reliable, clip-fed sidearm issued to officers and survival personnel of the Imperial Adhomian Army."
	icon_state = "kt_76"
	jam_chance = 1
	max_shells = 10
	load_method = SINGLE_CASING|SPEEDLOADER

/obj/item/weapon/gun/projectile/nka/kt_76/update_icon()
	..()
	if(loaded.len)
		icon_state = "kt_76"
	else
		icon_state = "kt_76-empty"

/obj/item/weapon/gun/projectile/revolver/detective/constable
	desc = "A cheap revolver produced by the Royal Firearms industries, commonly issued to constables. Uses .38-Special rounds."
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "constable_gun"
	item_state = "gun"
	contained_sprite = TRUE
	ammo_type = /obj/item/ammo_casing/c38/nka
	allowed_magazines = list(/obj/item/ammo_magazine/nka)

/obj/item/weapon/gun/projectile/revolver/detective/constable/update_icon()
	..()
	if(loaded.len)
		icon_state = "constable_gun"
	else
		icon_state = "constable_gun-empty"

// EXPLOSIVES
/obj/item/weapon/gun/projectile/rocket
	name = "anti-tank launcher"
	desc = "A cheap metal tube with a high-explosive warhead attached to the end."
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "rocket"
	item_state = "rocket"
	contained_sprite = TRUE
	w_class = 4
	load_method = SINGLE_CASING
	max_shells = 1
	caliber = "rpg"
	ammo_type = /obj/item/ammo_casing/rpg
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	accuracy = -1
	recoil = 3

	recoil_wielded = 1
	accuracy_wielded = 1

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/rocket/update_icon()
	..()
	if(loaded.len)
		icon_state = "rocket"
	else
		icon_state = "rocket_empty"

/obj/item/weapon/gun/projectile/rocket/can_wield()
	return TRUE

/obj/item/weapon/gun/projectile/rocket/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/rocket/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

// MACHINE GUNS
/obj/item/weapon/gun/projectile/automatic/tommygun/adhomai
	name = "submachine gun"
	desc = "A popular personal defense weapon, manufactured by Royal Firearms Industries."
	icon = 'icons/adhomai/weapons/guns.dmi'
	icon_state = "tommygun"
	w_class = 3
	jam_chance = 7

//ENERGY GUNS
/obj/item/weapon/gun/energy/lawgiver/nka
	name = "\improper Lawbringer Mk I"
	desc = "A prototype firearm produced by the Grrmhrvar Industries. It has multiple voice-activated firing modes."