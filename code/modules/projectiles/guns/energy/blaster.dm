/obj/item/gun/energy/blaster
	name = "blaster pistol"
	desc = "A tiny energy pistol converted to fire off energy bolts rather than lasers beams."
	icon = 'icons/obj/guns/blaster_pistol.dmi'
	icon_state = "blaster_pistol"
	item_state = "blaster_pistol"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = 2
	force = 5
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 6

	burst_delay = 2
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=2,    burst_accuracy=list(1,0,0),       dispersion=list(0, 10, 15))
		)

/obj/item/gun/energy/blaster/mounted/mech
	name = "rapidfire blaster"
	desc = "An aged but reliable rapidfire blaster tuned to expel projectiles at high fire rates."
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/item/projectile/energy/blaster/heavy
	burst = 5
	burst_delay = 3
	max_shots = 30
	charge_cost = 100
	use_external_power = TRUE
	self_recharge = TRUE
	recharge_time = 1.5
	dispersion = list(3,6,9,12)

/obj/item/gun/energy/blaster/revolver
	name = "blaster revolver"
	desc = "A robust eight-shot blaster.."
	icon = 'icons/obj/guns/blaster_revolver.dmi'
	icon_state = "blaster_revolver"
	item_state = "blaster_revolver"
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 8
	w_class = 3

/obj/item/gun/energy/blaster/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"
	var/mob/living/carbon/human/user
	if(istype(usr,/mob/living/carbon/human))
		user = usr
	else
		return

	user.visible_message(SPAN_WARNING("\The [user] spins the cylinder of \the [src]!"), SPAN_WARNING("You spin the cylinder of \the [src]!"), SPAN_NOTICE("You hear something metallic spin and click."))
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)

/obj/item/gun/energy/blaster/revolver/pilot
	name = "pilot's sidearm"
	desc = "A robust, low in maintenance, eight-shot blaster. Perfect for self-defense purposes."

/obj/item/gun/energy/blaster/carbine
	name = "blaster carbine"
	desc = "A short-barreled blaster carbine meant for easy handling and comfort when in combat."
	icon = 'icons/obj/guns/blaster_carbine.dmi'
	icon_state = "blaster_carbine"
	item_state = "blaster_carbine"
	max_shots = 12
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/energy/blaster
	slot_flags = SLOT_BELT
	w_class = 3

/obj/item/gun/energy/blaster/rifle
	name = "bolt slinger"
	desc = "A blaster rifle which seems to work by accelerating particles and flinging them out in destructive bolts."
	icon = 'icons/obj/guns/blaster_rifle.dmi'
	icon_state = "blaster_rifle"
	item_state = "blaster_rifle"
	max_shots = 20
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	projectile_type = /obj/item/projectile/energy/blaster/heavy

	slot_flags = SLOT_BACK
	w_class = 4

	fire_delay = 25
	w_class = 4
	accuracy = -3
	scoped_accuracy = 4

	fire_delay_wielded = 10
	accuracy_wielded = 1

	is_wieldable = TRUE

/obj/item/gun/energy/blaster/rifle/update_icon()
	..()
	if(wielded)
		item_state = "blaster_rifle-wielded"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/gun/energy/blaster/rifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")


/obj/item/gun/energy/secblaster
	name = "service blaster"
	desc = "The NT BP-7 is a multi-mode blaster pistol developed and produced by Nanotrasen for its internal security departments." // Placeholder for the PR. If there's a loreman who wants to describe this monstrosity, just hmu
	icon = 'icons/obj/guns/secblaster/secblasters.dmi'
	icon_state = "secblaster"
	item_state = "secblaster"
	fire_sound = 'sound/weapons/secblasterstun.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_SMALL
	force = 5
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/energy/stunblaster
	secondary_projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 12 //12 shots stun, 8 shots lethal.
	charge_cost = 50
	has_item_ratio = FALSE
	modifystate = "secblasterstun"
	pin = /obj/item/device/firing_pin/security_pin
	sel_mode = 1
	var/selectframecheck = FALSE
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/energy/stunblaster, modifystate="secblasterstun", charge_cost = 50, fire_sound = 'sound/weapons/secblasterstun.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/energy/blaster, modifystate="secblasterkill", recoil = 1, charge_cost = 75, fire_sound = 'sound/weapons/secblasterlethal.ogg')
		)

/obj/item/gun/energy/secblaster/verb/select_frame()
	set name = "Select Model"
	set category = "Object"
	set desc = "Click to select the model of your gun."

	var/mob/M = usr
	var/user_reply

	if(!M.mind)	return FALSE

	user_reply = input("Select your frame.") in list("sub-compact","service","magnum")
	if(!use_check_and_message(usr))
		if(user_reply == "sub-compact")
			icon = 'icons/obj/guns/secblaster/secblasterc.dmi'
			name = "sub-compact blaster"
		if(user_reply == "service")
			icon = 'icons/obj/guns/secblaster/secblasters.dmi'
			name = "service blaster"
		if(user_reply == "magnum")
			icon = 'icons/obj/guns/secblaster/secblasterm.dmi'
			name = "magnum blaster"
		update_icon()
		to_chat(M, "You select the [user_reply] model.")
		user_reply = input("Is this what you wanted?") in list("Yes","No")
		if(!use_check_and_message(usr))
			if (user_reply == "Yes")
				selectframecheck = TRUE
				verbs -= /obj/item/gun/energy/secblaster/verb/select_frame
				return TRUE
	icon = 'icons/obj/guns/secblaster/secblasters.dmi'
	name = "service blaster"
	return TRUE

/obj/item/gun/energy/secblaster/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/card/id))
		if(istype(pin, /obj/item/device/firing_pin/security_pin))
			var/obj/item/device/firing_pin/security_pin/thispin = pin
			thispin.register_user(C, user)
			return
		to_chat(user, SPAN_NOTICE("You press your ID card against \the [name] but nothing happens."))
	return

/obj/item/gun/energy/secblaster/unlocked
	pin = /obj/item/device/firing_pin

