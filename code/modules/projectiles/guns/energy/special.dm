/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT."
	icon_state = "ionrifle"
	item_state = "ionrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = 4
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	charge_cost = 300
	max_shots = 10
	projectile_type = /obj/item/projectile/ion

/obj/item/weapon/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/weapon/gun/energy/ionrifle/update_icon()
	..()
	if(power_supply.charge < charge_cost)
		item_state = "ionrifle-empty"
	else
		item_state = initial(item_state)

/obj/item/weapon/gun/energy/ionrifle/mounted
	name = "mounted ion rifle"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10

/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	item_state = "decloner"
	fire_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 3)
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/declone

/obj/item/weapon/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "floramut"
	fire_sound = 'sound/effects/stealthoff.ogg'
	charge_cost = 100
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	modifystate = "floramut"
	self_recharge = 1

	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/item/projectile/energy/floramut, modifystate="floramut"),
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, modifystate="florayield")
		)

/obj/item/weapon/gun/energy/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/weapon/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "meteor_gun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 4
	max_shots = 10
	projectile_type = /obj/item/projectile/meteor
	self_recharge = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0

/obj/item/weapon/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = 1
	slot_flags = SLOT_BELT


/obj/item/weapon/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A custom-built weapon of some kind."
	icon_state = "xray"
	projectile_type = /obj/item/projectile/beam/mindflayer
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/weapon/gun/energy/toxgun
	name = "phoron pistol"
	desc = "A specialized firearm designed to fire lethal bolts of phoron."
	icon_state = "toxgun"
	fire_sound = 'sound/effects/stealthoff.ogg'
	w_class = 3.0
	origin_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	projectile_type = /obj/item/projectile/energy/phoron

/obj/item/weapon/gun/energy/beegun
	name = "\improper NanoTrasen Portable Apiary"
	desc = "An experimental firearm that converts energy into bees, for purely botanical purposes."
	icon_state = "gyrorifle"
	item_state = "arifle"
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/effects/Buzz2.ogg'
	force = 5
	projectile_type = /obj/item/projectile/energy/bee
	slot_flags = SLOT_BACK
	max_shots = 9
	sel_mode = 1
	burst = 3
	burst_delay = 1
	move_delay = 3
	fire_delay = 0
	dispersion = list(0.0, 0.2, -0.2)

/obj/item/weapon/gun/energy/mousegun
	name = "\improper NT \"Arodentia\" Exterminator ray"
	desc = "A highly sophisticated and certainly experimental raygun designed for rapid pest-control."
	icon_state = "floramut100"
	item_state = "floramut"
	charge_meter = 0
	w_class = 3
	fire_sound = 'sound/weapons/taser2.ogg'
	force = 5
	projectile_type = /obj/item/projectile/beam/mousegun
	slot_flags = SLOT_HOLSTER | SLOT_BELT
	max_shots = 6
	sel_mode = 1
	burst = 3
	burst_delay = 1
	move_delay = 0
	fire_delay = 3
	dispersion = list(0.0, 6,0, -6.0)

	var/lightfail = 0

/obj/item/weapon/gun/energy/mousegun/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0, var/playemote = 1)
	var/T = get_turf(user)
	spark(T, 3, alldirs)
	failcheck()
	..()

/obj/item/weapon/gun/energy/mousegun/proc/failcheck()
	lightfail = 0
	if (prob(5))
		for (var/mob/living/M in range(rand(1,4),src)) //Big failure, TIME FOR RADIATION BITCHES
			if (src in M.contents)
				M << "<span class='danger'>[src]'s reactor overloads!</span>"
			M << "<span class='warning'>You feel a wave of heat wash over you.</span>"
			M.apply_effect(300, IRRADIATE)
		//crit_fail = 1 //break the gun so it stops recharging
		STOP_PROCESSING(SSprocessing, src)
		update_icon()
	return 0

/obj/item/weapon/gun/energy/net
	name = "net gun"
	desc = "A gun designed to deploy energy nets to capture animals or unruly crew members."
	icon_state = "netgun"
	projectile_type = /obj/item/projectile/beam/energy_net
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_HOLSTER | SLOT_BELT
	w_class = 3
	max_shots = 4
	fire_delay = 25

/obj/item/weapon/gun/energy/net/mounted
	max_shots = 1
	self_recharge = 1
	use_external_power = 1
	recharge_time = 40

/* Vaurca Weapons */

/obj/item/weapon/gun/energy/vaurca
	name = "Alien Firearm"
	desc = "Vaurcae weapons tend to be specialized and highly lethal. This one doesn't do much"
	var/is_charging = 0 //special var for sanity checks in the three guns that currently use charging as a special_check

/obj/item/weapon/gun/energy/vaurca/bfg
	name = "BFG 9000"
	desc = "'Bio-Force Gun'. Yeah, right."
	icon_state = "bfg"
	item_state = "bfg"
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/bfg
	slot_flags = SLOT_BACK
	max_shots = 3
	sel_mode = 1
	fire_delay = 10
	accuracy = 20
	muzzle_flash = 10

/obj/item/weapon/gun/energy/vaurca/gatlinglaser
	name = "gatling laser"
	desc = "A highly sophisticated rapid fire laser weapon."
	icon_state = "gatling"
	item_state = "gatling"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6)
	charge_meter = 0
	slot_flags = SLOT_BACK
	w_class = 4
	force = 10
	projectile_type = /obj/item/projectile/beam/gatlinglaser
	max_shots = 80
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 10
	dispersion = list(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)

	firemodes = list(
		list(mode_name="concentrated burst", burst=10, burst_delay = 1, fire_delay = 10, dispersion = list(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)),
		list(mode_name="spray", burst=20, burst_delay = 1, move_delay = 5, fire_delay = 30, dispersion = list(0.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.0, 3.25))
		)

	action_button_name = "Wield gatling laser"
	charge_cost = 50

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/can_wield()
	return 1

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/verb/wield_rifle()
	set name = "Wield gatling laser"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/special_check(var/mob/user)
	..()
	if(is_charging)
		user << "<span class='danger'>\The [src] is already spinning!</span>"
		return 0
	if(!wielded)
		user << "<span class='danger'>You cannot fire this weapon with just one hand!</span>"
		return 0
	playsound(src, 'sound/weapons/chainsawstart.ogg', 90, 1)
	user.visible_message(
					"<span class='danger'>\The [user] begins spinning [src]'s barrels!</span>",
					"<span class='danger'>You begin spinning [src]'s barrels!</span>",
					"<span class='danger'>You hear the spin of a rotary gun!</span>"
					)
	is_charging = 1
	sleep(30)
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))
	return 1

/obj/item/weapon/gun/energy/vaurca/blaster
	name = "\improper Zo'ra Blaster"
	desc = "An elegant weapon for a more civilized time."
	icon_state = "blaster"
	item_state = "blaster"
	origin_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4)
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BACK | SLOT_HOLSTER | SLOT_BELT
	w_class = 3
	force = 10
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 6
	sel_mode = 1
	burst = 1
	burst_delay = 1
	fire_delay = 0

	firemodes = list(
		list(mode_name="single shot", burst=1, burst_delay = 1, fire_delay = 0),
		list(mode_name="concentrated burst", burst=3, burst_delay = 1, fire_delay = 5)
		)

/obj/item/weapon/gun/energy/vaurca/typec
	name = "thermal lance"
	desc = "A powerful piece of Zo'rane energy artillery, converted to be portable...if you weigh a metric tonne, that is."
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	icon_state = "megaglaive0"
	item_state = "megaglaive"
	item_icons = list(//DEPRECATED. USE CONTAINED SPRITES IN FUTURE
		slot_l_hand_str = 'icons/mob/species/breeder/held_l.dmi',
		slot_r_hand_str = 'icons/mob/species/breeder/held_r.dmi'
		)
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 8)
	fire_sound = 'sound/magic/lightningbolt.ogg'
	attack_verb = list("sundered", "annihilated", "sliced", "cleaved", "slashed", "pulverized")
	slot_flags = SLOT_BACK
	w_class = 5
	force = 60
	projectile_type = /obj/item/projectile/beam/megaglaive
	max_shots = 36
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 30
	sharp = 1
	edge = 1
	anchored = 0
	armor_penetration = 40
	flags = NOBLOODY
	can_embed = 0
	self_recharge = 1
	recharge_time = 2

	action_button_name = "Wield thermal lance"

/obj/item/weapon/gun/energy/vaurca/typec/can_wield()
	return 1

/obj/item/weapon/gun/energy/vaurca/typec/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/typec/verb/wield_rifle()
	set name = "Wield thermal lance"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/typec/attack(atom/A, mob/living/user, def_zone)
	return ..() //Pistolwhippin'

/obj/item/weapon/gun/energy/vaurca/typec/special_check(var/mob/user)
	..()
	if(is_charging)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	if(!wielded)
		user << "<span class='danger'>You could never fire this weapon with merely one hand!</span>"
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	sleep(20)
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))
	return 1

/obj/item/weapon/gun/energy/vaurca/typec/attack_hand(mob/user as mob)
	if(loc != user)
		var/mob/living/carbon/human/H = user
		if(istype(H))
			if(H.species.name == "Vaurca Breeder")
				playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
				anchored = 1
				user << "<span class='notice'>\The [src] is now energised.</span>"
				icon_state = "megaglaive1"
				..()
				return
		user << "<span class='warning'>\The [src] is far too large for you to pick up.</span>"
		return

/obj/item/weapon/gun/energy/vaurca/typec/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		icon_state = "megaglaive0"
		anchored = 0

/obj/item/weapon/gun/energy/vaurca/typec/update_icon()
	return

/obj/item/weapon/gun/energy/vaurca/thermaldrill
	name = "thermal drill"
	desc = "Pierce the heavens? Son, there won't <i>be</i> any heavens when you're through with it."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "thermaldrill"
	item_state = "thermaldrill"
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 8)
	fire_sound = 'sound/magic/lightningbolt.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	force = 15
	projectile_type = /obj/item/projectile/beam/thermaldrill
	max_shots = 90
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 20
	self_recharge = 1
	recharge_time = 1
	charge_meter = 1
	charge_cost = 50

	firemodes = list(
		list(mode_name="2 second burst", burst=10, burst_delay = 1, fire_delay = 20),
		list(mode_name="4 second burst", burst=20, burst_delay = 1, fire_delay = 40),
		list(mode_name="6 second burst", burst=30, burst_delay = 1, fire_delay = 60)
		)

	action_button_name = "Wield thermal drill"

/obj/item/weapon/gun/energy/vaurca/thermaldrill/can_wield()
	return 1

/obj/item/weapon/gun/energy/vaurca/thermaldrill/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/thermaldrill/verb/wield_rifle()
	set name = "Wield thermal drill"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/thermaldrill/special_check(var/mob/user)
	..()
	if(is_charging)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	if(!wielded)
		user << "<span class='danger'>You cannot fire this weapon with just one hand!</span>"
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	sleep(40)
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	return 1

/obj/item/weapon/gun/energy/vaurca/mountedthermaldrill
	name = "mounted thermal drill"
	desc = "Pierce the heavens? Son, there won't <i>be</i> any heavens when you're through with it."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "thermaldrill"
	item_state = "thermaldrill"
	origin_tech = "combat=6;phorontech=8,"
	fire_sound = 'sound/magic/lightningbolt.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	force = 15
	projectile_type = /obj/item/projectile/beam/thermaldrill
	max_shots = 90
	sel_mode = 1
	burst = 30
	burst_delay = 1
	fire_delay = 20
	self_recharge = 1
	recharge_time = 1
	charge_meter = 1
	use_external_power = 1
	charge_cost = 25

/obj/item/weapon/gun/energy/vaurca/mountedthermaldrill/special_check(var/mob/user)
	..()
	if(is_charging)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	sleep(20)
	is_charging = 0
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))
	return 1

/*/obj/item/weapon/gun/energy/vaurca/flamer
	name = "Vaurcae Incinerator"
	desc = "A devious flamethrower device that procedurally converts atmosphere to fuel for a virtually unlimited tank."
	icon_state = "incinerator"
	item_state = "incinerator"
	fire_sound = 'sound/effects/extinguish.ogg'
	charge_meter = 0
	slot_flags = SLOT_BACK
	w_class = 3
	force = 10
	projectile_type = /obj/item/projectile/energy/flamer
	self_recharge = 1
	recharge_time = 2
	max_shots = 80
	firemodes = list(
		list(mode_name="spray", burst = 20, burst_delay = -1, fire_delay = 10, dispersion = list(0.5, 0.5, 1.0, 1.0, 1.5, 1.5, 2.0, 2.0, 2.5, 2.5, 3.0, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.0, 6.0)),
		)*/

/obj/item/weapon/gun/energy/tesla
	name = "tesla gun"
	desc = "A gun that shoots a projectile that bounces from living thing to living thing. Keep your distance from whatever you are shooting at."
	icon_state = "tesla"
	item_state = "tesla"
	icon = 'icons/obj/gun.dmi'
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/tesla
	slot_flags = SLOT_BACK
	max_shots = 3
	sel_mode = 1
	fire_delay = 10
	accuracy = 80
	muzzle_flash = 15

/obj/item/weapon/gun/energy/gravity_gun
	name = "gravity gun"
	desc = "This nifty gun disables the gravity in the area you shoot at. Use with caution."
	icon_state = "gravity_gun"
	item_state = "gravity_gun"
	icon = 'icons/obj/gun.dmi'
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/magic/Repulse.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/gravitydisabler
	slot_flags = SLOT_BACK
	max_shots = 2
	sel_mode = 1
	fire_delay = 20
	accuracy = 40
	muzzle_flash = 10