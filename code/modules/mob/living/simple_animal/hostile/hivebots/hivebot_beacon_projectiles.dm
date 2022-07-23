/obj/item/projectile/beam/hivebot
	name = "electrical discharge"
	damage = 20
	damage_type = BURN
	agony = 20
	armor_penetration = 40
	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/hivebot/harmless
	name = "harmless electrical discharge"
	damage = 0
	damage_type = PAIN
	agony = 0

/obj/item/projectile/beam/hivebot/incendiary
	name = "archaic energy welder"
	damage_type = BURN
	damage = 20
	armor_penetration = 15
	incinerate = 5
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue