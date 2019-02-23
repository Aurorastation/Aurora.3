/obj/item/mecha_parts/mecha_equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "mounted laser carbine"
	desc = "A weapon for combat exosuits. The CH-PS \"Immolator\" laser shoots basic lasers."
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/beam/midlaser
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gatling
	name = "mounted gatling laser"
	desc = "A weapon for combat exosuits. Shoots a burst of basic lasers."
	energy_drain = 45
	projectiles_per_shot = 8
	deviation = 0.7
	fire_time = 5
	projectiles_per_shot = 5
	deviation = 0.5
	fire_cooldown = 10
	fire_time = 10

/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	equip_cooldown = 30
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exo-suits in desperate, or malicious, times."
	icon_state = "mecha_laser"
	energy_drain = 80
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "mounted laser cannon"
	desc = "A weapon for combat exosuits. The CH-LC \"Solaris\" laser cannon is designated to shoot heavy lasers."
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/item/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	equip_cooldown = 40
	name = "heavy ion cannon"
	desc = "A weapon for combat exosuits. The mkIV ion heavy cannon shoots ion bolts designated to disable mechanical threats."
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/item/projectile/ion/heavy
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	equip_cooldown = 30
	name = "heavy pulse cannon"
	icon_state = "mecha_pulse"
	desc = "A weapon for combat exosuits. The eZ-13 mk2 heavy pulse rifle shoots powerful pulse-based beams, capable of destroying structures."
	energy_drain = 120
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 6, TECH_POWER = 4)
	projectile = /obj/item/projectile/beam/pulse/heavy
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	name = "mounted taser carbine"
	desc = "A weapon for combat exosuits. The PBT \"Pacifier\" taser shoots non-lethal stunning beams."
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/item/projectile/beam/stun
	fire_sound = 'sound/weapons/Taser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma
	name = "heavy plasma cutter"
	desc = "The mkII heavy plasma cutter is a large mining tool capable of expelling concentrated plasma bursts, useful for crushing rocks."
	icon_state = "mecha_plasmacutter"
	energy_drain = 60
	equip_cooldown = 25
	projectile = /obj/item/projectile/beam/plasmacutter
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/xray
	name = "gatling xray gun"
	desc = "A weapon for combat exosuits. Shoots a burst of armor penetrating xray beams."
	icon_state = "mecha_xray"
	energy_drain = 60
	equip_cooldown = 25
	projectiles_per_shot = 5
	deviation = 0.5
	fire_cooldown = 10
	fire_time = 10
	projectile = /obj/item/projectile/beam/xray
	fire_sound = 'sound/weapons/laser3.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/tesla
	name = "mounted tesla cannon"
	desc = "A weapon for combat exosuits. Shoots a burst of electric projectiles."
	icon_state = "mecha_tesla"
	energy_drain = 100
	equip_cooldown = 25
	projectiles_per_shot = 5
	deviation = 0.5
	fire_cooldown = 3
	fire_time = 15
	projectile = /obj/item/projectile/energy/tesla
	fire_sound = 'sound/magic/LightningShock.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kin_accelerator
	name = "mounted kinetic accelerator"
	desc = "A very robust mounted kinetic accelerator used by professional mining contractors intended for the use in mining soft metals such as gold on asteroids."

	energy_drain = 40
	projectiles_per_shot = 1
	projectile = /obj/item/projectile/kinetic
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'
	required_type = list(/obj/mecha/combat, /obj/mecha/working/hoverpod/combatpod, /obj/mecha/working/ripley)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kin_accelerator/heavy
	name = "mounted kinetic accelerator"
	energy_drain = 70
	projectiles_per_shot = 3
	projectile = /obj/item/projectile/kinetic
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kin_accelerator/heavy/Initialize()
	desc += " This version shoots 3 projectiles at a time."