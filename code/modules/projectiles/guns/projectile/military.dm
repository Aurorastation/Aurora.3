
//Service Pistols
/obj/item/weapon/gun/projectile/sec/military
	name = "service pistol"
	desc = "A Colby service sidearm. Uses .45 rounds."
	icon_state = "service"
	item_state = "service"
	magazine_type = /obj/item/ammo_magazine/c45m/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	caliber = ".45"
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE


/obj/item/weapon/gun/projectile/sec/military/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "service"
	else
		icon_state = "service-e"


/obj/item/weapon/gun/projectile/sec/military/senior
	desc = "A Colby service sidearm with silver detailing and a wooden grip, commonly given to Senior Enlisted. Uses .45 rounds."
	icon_state = "nco"
	item_state = "nco"

/obj/item/weapon/gun/projectile/sec/military/senior/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "nco"
	else
		icon_state = "nco-e"


/obj/item/weapon/gun/projectile/sec/military/officer
	desc = "A Colby service sidearm with gold detailing and a redwood grip, given to Officers. Uses .45 rounds."
	icon_state = "snco"
	item_state = "snco"

/obj/item/weapon/gun/projectile/sec/military/officer/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "snco"
	else
		icon_state = "snco-e"


/obj/item/weapon/gun/projectile/sec/military/officer/hop
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/weapon/gun/projectile/sec/military/trooper
	magazine_type = /obj/item/ammo_magazine/c45m

/obj/item/weapon/gun/projectile/sec/military/trooper/flash
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/weapon/gun/projectile/sec/military/officer/commander
	magazine_type = /obj/item/ammo_magazine/c45m


//Service Rifle
/obj/item/weapon/gun/projectile/automatic/rifle/military
	name = "service rifle"
	desc = "A M-N45 Tally, designed with a one-piece stock/grip and upper rail. Uses armor piercing 5.56mm rounds."
	icon_state = "armilitary"
	item_state = "armilitary"
	w_class = 4
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'


	burst_delay = 4
	firemodes = list(
		list(mode_name="semiauto",       burst=1,    fire_delay=10,    move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=3,    use_launcher=null, burst_accuracy=list(2,1,1), dispersion=list(0, 7.5))
		)

/obj/item/weapon/gun/projectile/automatic/rifle/military/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "armilitary-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "armilitary"
	if(wielded)
		item_state = "armilitary_wielded"
	else
		item_state = "armilitary"
	update_held_icon()
	return



//Sniper Rifle
/obj/item/weapon/gun/projectile/automatic/rifle/milsniper
	name = "sniper rifle"
	desc = "A Stilton T100 Scout rifle, for long and medium range. It uses 7.62mm rounds."
	icon_state = "milsniper"
	item_state = "milsniper"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	caliber = "a762"
	recoil = 4
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/c762/sniper
	allowed_magazines = list(/obj/item/ammo_magazine/c762/sniper)
	accuracy = -4
	scoped_accuracy = 3
	recoil_wielded = 2
	accuracy_wielded = 1
	multi_aim = 0

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null)
		)

/obj/item/weapon/gun/projectile/automatic/rifle/milsniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/weapon/gun/projectile/automatic/rifle/milsniper/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "milsniper-[round(ammo_magazine.stored_ammo.len,1)]"
	else
		icon_state = "milsniper"
	if(wielded)
		item_state = "milsniper_wielded"
	else
		item_state = "milsniper"
	update_held_icon()
	return