/obj/item/gun/energy/laser/prototype/pistol
	name = "modular pistol"
	desc = "A standard-issue modular energy pistol provided to Nanotrasen security forces."
	pin = /obj/item/device/firing_pin
	named = TRUE
	described = TRUE

/obj/item/gun/energy/laser/prototype/pistol/Initialize(mapload)
	. = ..(mapload,
		"small_3",
		CHASSIS_SMALL,
		new /obj/item/laser_components/capacitor/reinforced(src),
		new /obj/item/laser_components/focusing_lens/strong(src),
		new /obj/item/laser_components/modulator/taser(src)
		)
	power_supply.give(power_supply.maxcharge)