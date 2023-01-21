/obj/item/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = "decloner"
	item_state = "decloner"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 3)
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/declone

/obj/item/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon = 'icons/obj/guns/flora.dmi'
	icon_state = "floramut100"
	item_state = "floramut"
	has_item_ratio = FALSE
	fire_sound = 'sound/effects/stealthoff.ogg'
	charge_cost = 100
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	modifystate = "floramut"
	self_recharge = 1
	var/singleton/plantgene/gene = null

	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/item/projectile/energy/floramut, modifystate="floramut"),
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, modifystate="florayield"),
		list(mode_name="induce specific mutations", projectile_type=/obj/item/projectile/energy/floramut/gene, modifystate="floramut"),
		)

	needspin = FALSE

/obj/item/gun/energy/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/gun/energy/floragun/verb/select_gene()
	set name = "Select Gene"
	set category = "Object"
	set src in view(1)

	var/genemask = input("Choose a gene to modify.") as null|anything in SSplants.plant_gene_datums

	if(!genemask)
		return

	gene = SSplants.plant_gene_datums[genemask]

	to_chat(usr, SPAN_INFO("You set \the [src]\s targeted genetic area to [genemask]."))

	return

/obj/item/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon = 'icons/obj/guns/meteor_gun.dmi'
	icon_state = "meteor_gun"
	item_state = "meteor_gun"
	has_item_ratio = FALSE
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	max_shots = 10
	projectile_type = /obj/item/projectile/meteor
	self_recharge = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0
	can_turret = 1
	turret_sprite_set = "meteor"

/obj/item/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	contained_sprite = FALSE
	icon_state = "pen"
	item_state = "pen"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT
	can_turret = 0


/obj/item/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A custom-built weapon of some kind."
	icon = 'icons/obj/guns/xray.dmi'
	icon_state = "xray"
	item_state = "xray"
	has_item_ratio = FALSE
	projectile_type = /obj/item/projectile/beam/mindflayer
	fire_sound = 'sound/weapons/laser1.ogg'
	can_turret = 1
	turret_sprite_set = "xray"

/obj/item/gun/energy/toxgun
	name = "phoron pistol"
	desc = "A specialized firearm designed to fire lethal bolts of phoron."
	icon = 'icons/obj/guns/toxgun.dmi'
	icon_state = "toxgun"
	item_state = "toxgun"
	has_item_ratio = FALSE
	fire_sound = 'sound/effects/stealthoff.ogg'
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	projectile_type = /obj/item/projectile/energy/phoron
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "net"

/obj/item/gun/energy/mousegun
	name = "pest gun"
	desc = "The NT \"Arodentia\" Pesti-Shock is a highly sophisticated and probably safe beamgun designed for rapid pest-control."
	desc_antag = "This gun can be emagged to make it fire damaging beams and get more max shots. It doesn't do a lot of damage, but it is concealable."
	icon = 'icons/obj/guns/pestishock.dmi'
	icon_state = "pestishock"
	item_state = "pestishock"
	has_item_ratio = FALSE
	w_class = ITEMSIZE_NORMAL
	fire_sound = 'sound/weapons/taser2.ogg'
	force = 5
	projectile_type = /obj/item/projectile/beam/mousegun
	slot_flags = SLOT_HOLSTER | SLOT_BELT
	max_shots = 6
	sel_mode = 1
	var/emagged = FALSE
	needspin = FALSE

/obj/item/gun/energy/mousegun/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0, var/playemote = 1)
	var/T = get_turf(user)
	spark(T, 3, alldirs)
	..()

/obj/item/gun/energy/mousegun/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, SPAN_WARNING("You overload \the [src]'s shock modulator."))
		max_shots = initial(max_shots) + 4
		projectile_type = /obj/item/projectile/beam/mousegun/emag
		emagged = TRUE
		QDEL_NULL(power_supply)
		power_supply = new /obj/item/cell/device/variable(src, max_shots * charge_cost)
		return TRUE

/obj/item/gun/energy/mousegun/xenofauna
	name = "xenofauna gun"
	desc = "The NT \"Xenovermino\" Zap-Blast is a highly sophisticated and probably safe beamgun designed to deal with hostile xenofauna."
	icon = 'icons/obj/guns/xenogun.dmi'
	icon_state = "xenogun"
	item_state = "xenogun"
	projectile_type = /obj/item/projectile/beam/mousegun/xenofauna
	max_shots = 12

/obj/item/gun/energy/net
	name = "net gun"
	desc = "A gun designed to deploy energy nets to capture animals or unruly crew members."
	icon = 'icons/obj/guns/netgun.dmi'
	icon_state = "netgun"
	item_state = "netgun"
	has_item_ratio = FALSE
	projectile_type = /obj/item/projectile/beam/energy_net
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_HOLSTER | SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	max_shots = 4
	fire_delay = 25
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "net"

/obj/item/gun/energy/net/mounted
	max_shots = 2
	self_recharge = TRUE
	use_external_power = TRUE
	has_safety = FALSE
	recharge_time = 30
	can_turret = FALSE

/* Vaurca Weapons */

/obj/item/gun/energy/vaurca
	name = "Alien Firearm"
	desc = "Vaurcae weapons tend to be specialized and highly lethal. This one doesn't do much"
	var/is_charging = 0 //special var for sanity checks in the three guns that currently use charging as a special_check

/obj/item/gun/energy/vaurca/bfg
	name = "BFG 9000"
	desc = "'Bio-Force Gun'. Yeah, right."
	icon = 'icons/obj/guns/bfg.dmi'
	icon_state = "bfg"
	item_state = "bfg"
	has_item_ratio = FALSE
	charge_meter = 0
	w_class = ITEMSIZE_LARGE
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/bfg
	slot_flags = SLOT_BACK
	max_shots = 3
	sel_mode = 1
	fire_delay = 10
	accuracy = 20
	muzzle_flash = 10

#define GATLINGLASER_DISPERSION_CONCENTRATED list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
#define GATLINGLASER_DISPERSION_SPRAY list(0, 5, 5, 10, 10, 15, 15, 20, 20, 25, 25, 25, 30, 30, 35, 40)

/obj/item/gun/energy/vaurca/gatlinglaser
	name = "gatling laser"
	desc = "A highly sophisticated rapid fire laser weapon."
	icon = 'icons/obj/guns/gatling.dmi'
	icon_state = "gatling"
	item_state = "gatling"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6)
	charge_meter = 0
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 10
	projectile_type = /obj/item/projectile/beam/gatlinglaser
	max_shots = 350
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 8
	dispersion = GATLINGLASER_DISPERSION_CONCENTRATED

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="concentrated burst", burst=12, burst_delay = 1, move_delay=5, dispersion = GATLINGLASER_DISPERSION_CONCENTRATED),
		list(mode_name="spray", burst=22, burst_delay = 1, move_delay = 8, dispersion = GATLINGLASER_DISPERSION_SPRAY),
		list(mode_name="massive spray", burst=32, burst_delay = 1, move_delay = 10, dispersion = GATLINGLASER_DISPERSION_SPRAY),
		)

	charge_cost = 40

/obj/item/gun/energy/vaurca/gatlinglaser/special_check(var/mob/user)
	if(is_charging)
		to_chat(user, "<span class='danger'>\The [src] is already spinning!</span>")
		return 0
	if(!wielded)
		to_chat(user, "<span class='danger'>You cannot fire this weapon with just one hand!</span>")
		return 0
	playsound(src, 'sound/weapons/saw/chainsawstart.ogg', 90, 1)
	user.visible_message(
					"<span class='danger'>\The [user] begins spinning [src]'s barrels!</span>",
					"<span class='danger'>You begin spinning [src]'s barrels!</span>",
					"<span class='danger'>You hear the spin of a rotary gun!</span>"
					)
	is_charging = 1
	if(!do_after(user, 30))
		is_charging = 0
		return 0
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

	return ..()

/obj/item/gun/energy/vaurca/blaster
	name = "\improper Zo'ra Blaster"
	desc = "An elegant weapon for a more civilized time."
	icon = 'icons/obj/guns/blaster.dmi'
	icon_state = "blaster"
	item_state = "blaster"
	has_item_ratio = FALSE
	origin_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4)
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BACK | SLOT_HOLSTER | SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	accuracy = 1
	force = 10
	projectile_type = /obj/item/projectile/energy/blaster/incendiary
	max_shots = 7
	sel_mode = 1
	burst = 1
	burst_delay = 1
	fire_delay = 0
	can_turret = 1
	turret_sprite_set = "laser"
	firemodes = list(
		list(mode_name="single shot", burst=1, burst_delay = 1, fire_delay = 0),
		list(mode_name="concentrated burst", burst=3, burst_delay = 1, fire_delay = 5)
		)

/obj/item/gun/energy/vaurca/typec
	name = "thermal lance"
	desc = "A powerful piece of Zo'rane energy artillery, converted to be portable...if you weigh a metric tonne, that is."
	icon = 'icons/mob/species/breeder/inventory.dmi'
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
	w_class = ITEMSIZE_HUGE
	accuracy = 3 // It's a massive beam, okay.
	force = 60
	projectile_type = /obj/item/projectile/beam/megaglaive
	max_shots = 36
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 30
	sharp = 1
	edge = TRUE
	anchored = 0
	armor_penetration = 40
	flags = NOBLOODY
	can_embed = 0
	self_recharge = 1
	recharge_time = 2
	needspin = FALSE

	is_wieldable = TRUE

/obj/item/gun/energy/vaurca/typec/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	user.setClickCooldown(16)
	..()

/obj/item/gun/energy/vaurca/typec/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	..()

/obj/item/gun/energy/vaurca/typec/special_check(var/mob/user)
	if(is_charging)
		to_chat(user, "<span class='danger'>\The [src] is already charging!</span>")
		return 0
	if(!wielded)
		to_chat(user, "<span class='danger'>You could never fire this weapon with merely one hand!</span>")
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	if(!do_after(user, 20))
		is_charging = 0
		return 0
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

	return ..()

/obj/item/gun/energy/vaurca/typec/attack_hand(mob/user as mob)
	if(loc != user)
		var/mob/living/carbon/human/H = user
		if(H.mob_size >= 30)
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			anchored = 1
			to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
			icon_state = "megaglaive1"
			..()
			return
		to_chat(user, "<span class='warning'>\The [src] is far too large for you to pick up.</span>")
		return

/obj/item/gun/energy/vaurca/typec/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		icon_state = "megaglaive0"
		anchored = 0

/obj/item/gun/energy/vaurca/typec/update_icon()
	return

/obj/item/gun/energy/vaurca/thermaldrill
	name = "thermal drill"
	desc = "Pierce the heavens? Son, there won't <i>be</i> any heavens when you're through with it."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "thermaldrill"
	item_state = "thermaldrill"
	has_item_ratio = FALSE
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 8)
	fire_sound = 'sound/magic/lightningbolt.ogg'
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	accuracy = 0 // Overwrite just in case.
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
	can_turret = 1
	turret_sprite_set = "thermaldrill"

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="2 second burst", burst=10, burst_delay = 1, fire_delay = 20, fire_delay_wielded = 20),
		list(mode_name="4 second burst", burst=20, burst_delay = 1, fire_delay = 40, fire_delay_wielded = 40),
		list(mode_name="6 second burst", burst=30, burst_delay = 1, fire_delay = 60, fire_delay_wielded = 60),
		list(mode_name="point-burst auto", can_autofire = TRUE, burst = 1, fire_delay = 1, fire_delay_wielded = 1, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2))
		)

	needspin = FALSE

/obj/item/gun/energy/vaurca/thermaldrill/special_check(var/mob/user)
	if(is_charging)
		to_chat(user, SPAN_DANGER("\The [src] is already charging!"))
		return FALSE
	if(!wielded)
		to_chat(user, SPAN_DANGER("You cannot fire this weapon with just one hand!"))
		return FALSE
	if(can_autofire)
		return ..()
	user.visible_message(SPAN_DANGER("\The [user] begins charging \the [src]!"), SPAN_DANGER("You begin charging \the [src]!"), SPAN_DANGER("You hear a low pulsing roar!"))
	is_charging = TRUE
	if(!do_after(user, 4 SECONDS))
		is_charging = FALSE
		return FALSE
	is_charging = FALSE
	if(user.get_active_hand() != src)
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	return ..()

/obj/item/gun/energy/vaurca/mountedthermaldrill
	name = "mounted thermal drill"
	desc = "Pierce the heavens? Son, there won't <i>be</i> any heavens when you're through with it."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "thermaldrill"
	item_state = "thermaldrill"
	has_item_ratio = FALSE
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 8)
	fire_sound = 'sound/magic/lightningbolt.ogg'
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
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

/obj/item/gun/energy/vaurca/mountedthermaldrill/special_check(var/mob/user)
	if(is_charging)
		to_chat(user, SPAN_WARNING("\The [src] is already charging!"))
		return FALSE
	user.visible_message(SPAN_DANGER("\The [user] begins charging \the [src]!"), SPAN_DANGER("You begin charging \the [src]!"), SPAN_DANGER("You hear a low pulsing roar!"))
	is_charging = TRUE
	if(!do_after(user, 2 SECONDS))
		is_charging = FALSE
		return FALSE
	is_charging = FALSE
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))
	return ..()

/obj/item/gun/energy/vaurca/tachyon
	name = "tachyon carbine"
	desc = "A Vaurcan carbine that fires a beam of concentrated faster than light particles, capable of passing through most forms of matter."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "tachyoncarbine"
	item_state = "tachyoncarbine"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser3.ogg'
	projectile_type = /obj/item/projectile/beam/tachyon
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	max_shots = 10
	accuracy = 1
	fire_delay = 1
	can_turret = 0

/obj/item/gun/energy/tesla
	name = "tesla gun"
	desc = "A gun that shoots a projectile that bounces from living thing to living thing. Keep your distance from whatever you are shooting at."
	icon = 'icons/obj/guns/tesla.dmi'
	icon_state = "tesla"
	item_state = "tesla"
	has_item_ratio = FALSE
	charge_meter = 0
	w_class = ITEMSIZE_LARGE
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/beam/tesla
	slot_flags = SLOT_BACK
	max_shots = 3
	sel_mode = 1
	fire_delay = 10
	accuracy = 80
	muzzle_flash = 15

/obj/item/gun/energy/tesla/mounted
	name = "mounted tesla carbine"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/gun/energy/gravity_gun
	name = "gravity gun"
	desc = "This nifty gun disables the gravity in the area you shoot at. Use with caution."
	icon = 'icons/obj/guns/gravity_gun.dmi'
	icon_state = "gravity_gun"
	item_state = "gravity_gun"
	has_item_ratio = FALSE
	charge_meter = 0
	w_class = ITEMSIZE_LARGE
	fire_sound = 'sound/magic/Repulse.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/gravitydisabler
	slot_flags = SLOT_BACK
	max_shots = 2
	sel_mode = 1
	fire_delay = 20
	accuracy = 40
	muzzle_flash = 10
