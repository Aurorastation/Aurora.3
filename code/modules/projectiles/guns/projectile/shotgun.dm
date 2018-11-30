/obj/item/weapon/gun/projectile/shotgun
	name = "strange shotgun"
	desc = "A strange shotgun that doesn't seem to belong anywhere. You feel like you shouldn't be able to see this and should... submit an issue?"

	var/can_sawoff = FALSE
	var/sawnoff_workmsg
	var/sawing_in_progress = FALSE

/obj/item/weapon/gun/projectile/shotgun

/obj/item/weapon/gun/projectile/shotgun/attackby(obj/item/A, mob/user)
	if (!can_sawoff || sawing_in_progress)
		return ..()

	var/static/list/barrel_cutting_tools = typecacheof(list(
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/melee/energy,
		/obj/item/weapon/gun/energy/plasmacutter	// does this even work?
	))
	if(is_type_in_typecache(A, barrel_cutting_tools) && w_class != 3)
		to_chat(user, "<span class='notice'>You begin to [sawnoff_workmsg] of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>\The [src] goes off!</span>", "<span class='danger'>\The [src] goes off in your face!</span>")
			return

		sawing_in_progress = TRUE
		if(do_after(user, 30, act_target = src))	//SHIT IS STEALTHY EYYYYY
			sawing_in_progress = FALSE
			saw_off(user, A)
	else
		..()

// called on a SUCCESSFUL saw-off.
/obj/item/weapon/gun/projectile/shotgun/proc/saw_off(mob/user, obj/item/tool)
	to_chat(user, "<span class='notice'>You attempt to cut [src]'s barrel with [tool], but nothing happens.</span>")
	log_debug("shotgun: attempt to saw-off shotgun with no saw-off behavior.")

/obj/item/weapon/gun/projectile/shotgun/pump
	name = "pump shotgun"
	desc = "An ubiquitous unbranded shotgun. Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	force = 10
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/shotgun.ogg'
	var/recentpump = 0 // to prevent spammage
	var/pump_fail_msg = "<span class='warning'>You cannot rack the shotgun without gripping it with both hands!</span>"
	var/pump_snd = 'sound/weapons/shotgunpump.ogg'
	var/has_wield_state = TRUE

	action_button_name = "Wield shotgun"

/obj/item/weapon/gun/projectile/shotgun/pump/can_wield()
	return 1

/obj/item/weapon/gun/projectile/shotgun/pump/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/shotgun/pump/verb/wield_shotgun()
	set name = "Wield"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M)
	if(!wielded)
		to_chat(M, pump_fail_msg)
		return

	playsound(M, pump_snd, 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.forceMove(get_turf(src)) //Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

/obj/item/weapon/gun/projectile/shotgun/pump/update_icon()
	..()
	if(wielded && has_wield_state)
		item_state = "[icon_state]-wielded"
	else
		item_state = "[icon_state]"
	update_held_icon()

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	fire_sound = 'sound/weapons/shotgun_shoot.ogg'
	pin = /obj/item/device/firing_pin/blacklist

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
	fire_sound = 'sound/weapons/shotgun.ogg'

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2)
		)

	can_sawoff = TRUE
	sawnoff_workmsg = "shorten the barrel"

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/saw_off(mob/user, obj/item/tool)
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	w_class = 3
	force = 5
	slot_flags &= ~SLOT_BACK	//you can't sling it on your back
	slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = 3
	force = 5
