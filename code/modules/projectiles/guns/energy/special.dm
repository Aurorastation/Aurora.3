/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."
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
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, modifystate="florayield"),
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
	icon_state = "riotgun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 4
	projectile_type = /obj/item/projectile/meteor
	cell_type = /obj/item/weapon/cell/potato
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

/* Vaurca Weapons */

/obj/item/weapon/gun/energy/vaurca
	name = "Alien Firearm"
	desc = "Vaurcae weapons tend to be specialized and highly lethal. This one doesn't do much"

/obj/item/weapon/gun/energy/vaurca/bfg
	name = "BFG 9000"
	desc = "'Bio-Force Gun'. Yeah, right."
	icon_state = "bfg"
	item_state = "bfg"
	charge_meter = 0
	w_class = 3
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/sonic
	slot_flags = SLOT_BACK
	max_shots = 40

	firemodes = list(
		list(name="EXTERMINATE", burst=20, burst_delay = 1, move_delay = 20, fire_delay = 40, dispersion = list(3.0, 3.25, 3.5, 3.75, 4.0, 4.25, 4.5, 4.75, 5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9, 6.0, 6.25)),
		)

/obj/item/weapon/gun/energy/vaurca/gatlinglaser
	name = "Gatling Laser"
	desc = "A highly sophisticated rapid fire laser weapon."
	icon_state = "gatling"
	item_state = "gatling"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = "combat=5;materials=2"
	charge_meter = 0
	slot_flags = SLOT_BACK
	w_class = 3
	force = 10
	projectile_type = /obj/item/projectile/beam/gatlinglaser
	max_shots = 80

	firemodes = list(
		list(name="concentrated burst", burst=10, burst_delay = 1, fire_delay = 10, dispersion = list(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)),
		list(name="spray", burst=20, burst_delay = 1, move_delay = 5, fire_delay = 30, dispersion = list(0.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.0, 3.25)),
		)

/obj/item/weapon/gun/energy/vaurca/blaster
	name = "Zo'ra Blaster"
	desc = "An elegant weapon for a more civilized time."
	icon_state = "blaster"
	item_state = "blaster"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BACK
	w_class = 3
	force = 10
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 30

	firemodes = list(
		list(name="single shot", burst=1, burst_delay = 1, fire_delay = 0),
		list(name="concentrated burst", burst=3, burst_delay = 1, fire_delay = 5),
		)

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
		list(name="spray", burst = 20, burst_delay = -1, fire_delay = 10, dispersion = list(0.5, 0.5, 1.0, 1.0, 1.5, 1.5, 2.0, 2.0, 2.5, 2.5, 3.0, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.0, 6.0)),
		)*/

/* Staves */

/obj/item/weapon/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'icons/obj/gun.dmi'
	item_icons = null
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/weapons/emitter.ogg'
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	w_class = 4.0
	max_shots = 5
	projectile_type = /obj/item/projectile/change
	origin_tech = null
	self_recharge = 1
	charge_meter = 0

/obj/item/weapon/gun/energy/staff/special_check(var/mob/user)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		usr << "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>"
		return 0

	return ..()

/obj/item/weapon/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/weapon/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/item/projectile/animate
	max_shots = 10

obj/item/weapon/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	item_state = "focus"
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/forcebolt
	/*
	attack_self(mob/living/user as mob)
		if(projectile_type == "/obj/item/projectile/forcebolt")
			charge_cost = 400
			user << "<span class='warning'>The [src.name] will now strike a small area.</span>"
			projectile_type = "/obj/item/projectile/forcebolt/strong"
		else
			charge_cost = 200
			user << "<span class='warning'>The [src.name] will now strike only a single person.</span>"
			projectile_type = "/obj/item/projectile/forcebolt"
	*/
