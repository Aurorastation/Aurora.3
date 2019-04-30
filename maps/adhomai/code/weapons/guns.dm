/obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka
	name = "service rifle"
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	desc = "The standard issue rifle of the levy Alam'ard."
	accuracy = -1
	has_wield_state = TRUE
	contained_sprite = TRUE

/obj/item/ammo_magazine/boltaction
	name = "loaded stripper clip"
	desc = "A stripper clip issued to members of the Imperial Adhomian Army."

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/nka/scoped
	desc = "A cheap ballistic rifle often found in the hands of tajaran soldiers. This one has been outfitted with a telescopic sight."
	accuracy = -1
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "scope"
	item_state = "scope"
	scoped_accuracy = 3
	can_bayonet = FALSE
	can_sawoff = FALSE
	has_wield_state = TRUE
	contained_sprite = TRUE

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
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "rifle"
	item_state = "moistnugget"
	w_class = 4
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 5
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a762
	fire_sound = 'sound/weapons/rifleshot.ogg'
	accuracy = -1
	recoil = 3
	fire_delay = 5

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

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn/bean
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/weapon/gun/projectile/automatic/rifle/pra
	desc = "An automatic rifle issued to the forces of the Republican Army."
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "pra_rifle"
	item_state = "pra_rifle"
	contained_sprite = TRUE

/obj/item/weapon/gun/projectile/automatic/rifle/pra/update_icon()
	..()
	icon_state = (ammo_magazine)? "pra_rifle" : "pra_rifle-empty"
	if(wielded)
		item_state = (ammo_magazine)? "pra_rifle-wielded" : "pra_rifle-wielded-empty"
	else
		item_state = (ammo_magazine)? "pra_rifle" : "pra_rifle-empty"
	update_held_icon()

/obj/item/weapon/gun/energy/lawgiver/nka
	name = "\improper Lawbringer Mk I"
	desc = "A prototype firearm produced by the Grrmhrvar Industries. It has multiple voice-activated firing modes."

/obj/item/weapon/gun/projectile/revolver/detective/constable
	desc = "A cheap revolver produced by the Royal Firearms industries, commonly issued to constables. Uses .38-Special rounds."
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "constable_gun"
	contained_sprite = TRUE

/obj/item/weapon/gun/projectile/revolver/detective/constable/update_icon()
	..()
	if(loaded.len)
		icon_state = "constable_gun"
	else
		icon_state = "constable_gun-empty"

/obj/item/weapon/gun/projectile/nka
	name = "service automatic"
	desc = "A reliable sidearm issued to members of the Imperial Adhomian Army."
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "nka"
	ammo_type = /obj/item/ammo_casing/a357
	contained_sprite = TRUE

/obj/item/weapon/gun/projectile/colt/nka/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "nka"
	else
		icon_state = "nka-empty"

/obj/item/ammo_magazine/nka
	name = "ammunition magazine"
	desc = "A reliable sidearm magazine issued to members of the Imperial Adhomian Army."
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "ammo"
	max_ammo = 5
	initial_ammo = 5

/obj/item/ammo_magazine/c45m/nka/empty
	name = "ammunition magazine"
	desc = "A reliable sidearm magazine issued to members of the Imperial Adhomian Army."
	icon = 'icons/adhomai/guns.dmi'
	ammo_type = /obj/item/ammo_casing/a357
	initial_ammo = 0

/obj/item/ammo_casing/rpg
	name = "rocket-propelled grenade"
	desc = "A high explosive designed to be fired from a launcher."
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "rpg"
	projectile_type = /obj/item/projectile/bullet/cannon
	caliber = "rpg"


/obj/item/weapon/gun/projectile/rocket
	name = "anti-tank launcher"
	desc = "A cheap metal tube with a high-explosive warhead attached to the end."
	icon = 'icons/adhomai/guns.dmi'
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


/obj/item/weapon/gun/projectile/automatic/tommygun/adhomai
	name = "submachine gun"
	desc = "A popular personal defense weapon, manufactured by Royal Firearms Industries."
	icon = 'icons/adhomai/guns.dmi'
	icon_state = "tommygun"
	w_class = 3
