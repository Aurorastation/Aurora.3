/obj/item/gun/energy/taser
	name = "taser gun"
	desc = "The NT Mk30 NL is a small, low capacity gun used for non-lethal takedowns."
	icon = 'icons/obj/guns/taser.dmi'
	icon_state = "taser"
	item_state = "taser"
	fire_sound = 'sound/weapons/Taser.ogg'
	max_shots = 5
	accuracy = 1 // More of a buff to secborgs and mounted taser users.
	projectile_type = /obj/item/projectile/energy/electrode
	can_turret = 1
	turret_sprite_set = "carbine"
	turret_is_lethal = 0

/obj/item/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = 1
	use_external_power = 1
	can_turret = 0

/obj/item/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A Hephaestus designed high-tech revolver that fires rechargable stun bolts."
	description_fluff = "The ST-30 is a highly advanced sidearm produced by Hephaestus Industries. It is designed for self-defense in a less-than-lethal manner. While the weapon design itself is not groundbreaking, it fires high velocity energy bolts with rechargable cartridges, possessing unusual high stopping power."
	icon = 'icons/obj/guns/stunrevolver.dmi'
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/gunshot/gunshot1.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	projectile_type = /obj/item/projectile/energy/electrode
	max_shots = 8


/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/crossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	has_item_ratio = FALSE
	w_class = 2.0
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	slot_flags = SLOT_BELT
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 5
	self_recharge = 1
	charge_meter = 0
	can_turret = 1
	turret_sprite_set = "crossbow"
	charge_failure_message = "'s charging socket was removed to make room for a minaturized reactor."

/obj/item/gun/energy/crossbow/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = 4
	force = 10
	icon_state = "crossbowlarge"
	item_state = "crossbow"
	matter = list(DEFAULT_WALL_MATERIAL = 200000)
	projectile_type = /obj/item/projectile/energy/bolt/large