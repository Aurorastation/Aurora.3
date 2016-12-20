/obj/item/weapon/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = 4.0
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	var/recentpump = 0 // to prevent spammage

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/shotgun/pump/can_wield()
	return 1

/obj/item/weapon/gun/projectile/shotgun/pump/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/shotgun/pump/verb/wield_shotgun()
	set name = "Wield shotgun"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	if(!wielded)
		M << "<span class='warning'>You cannot rack the shotgun without gripping it with both hands!</span>"
		return

	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hesphaistos Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/weapon/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = 4
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2)
		)

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/weapon/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter))
		user << "<span class='notice'>You begin to shorten the barrel of \the [src].</span>"
		if(loaded.len)
			for(var/i in 1 to max_shells)
				afterattack(user, user)	//will this work? //it will. we call it twice, for twice the FUN
				playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = 3
			force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			user << "<span class='warning'>You shorten the barrel of \the [src]!</span>"
	else
		..()

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = 3
	force = 5

/obj/item/weapon/gun/projectile/shotgun/pump/boltaction
	name = "\improper bolt action rifle"
	desc = "A cheap ballistic rifle often found in the hands of crooks and frontiersmen."
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK
	load_method = SINGLE_CASING|SPEEDLOADER
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	max_shells = 5

/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter) && w_class != 3)
		user << "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>"
		if(loaded.len)
			afterattack(user, user)
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "obrez"
			w_class = 3
			recoil = 2
			accuracy = -2
			item_state = "gun"
			slot_flags &= ~SLOT_BACK
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
			name = "\improper obrez"
			desc = "A shortened bolt action rifle, not really acurate. Uses 7.62mm rounds."
			user << "<span class='warning'>You shorten the barrel and stock of the rifle!</span>"
	else
		..()

/obj/item/weapon/gun/projectile/shotgun/pump/boltaction/obrez
	name = "obrez"
	desc = "A shortened bolt action rifle, not really accurate. Uses 7.62mm rounds."
	icon_state = "obrez"
	item_state = "gun"
	w_class = 3
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER
