/obj/item/weapon/gun/projectile/automatic/rifle/w556
	name = "\improper Neyland 556mi 'Ranger'"
	desc = "A lightweight scout-rifle used within the Sol Navy and Nanotrasen Emergency Response Teams. Equipped with a scope and designed for medium to long range combat, with medium stopping power. Chambered in 5.56 rounds."
	icon_state = "w556rifle"
	item_state = "heavysniper"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	caliber = "a556"
	recoil = 4
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/Gunshot_DMR.ogg'
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/a556/ap
	magazine_type = /obj/item/ammo_magazine/a556/ap
	allowed_magazines = list(/obj/item/ammo_magazine/a556/ap)
	accuracy = -2
	scoped_accuracy = 3
	recoil_wielded = 2
	accuracy_wielded = 0
	multi_aim = 0 //Definitely a fuck no. Being able to target one person at this range is plenty.

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/weapon/gun/projectile/automatic/rifle/w556/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		usr << "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>"
