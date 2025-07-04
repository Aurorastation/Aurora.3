/obj/item/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/machinery/cell_charger.dmi'
	icon_state = "cell"
	item_state = "cell"
	contained_sprite = TRUE
	origin_tech = list(TECH_POWER = 1)
	force = 11
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)
	recyclable = TRUE

	/// Percentage of maxcharge to recharge per minute, though it will trickle charge every process tick (every ~2 seconds), leave null for no self-recharge
	var/self_charge_percentage

/// Smaller variant, used by energy guns and similar small devices
/obj/item/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "device"
	w_class = WEIGHT_CLASS_SMALL
	force = 0
	throw_speed = 5
	throw_range = 7
	maxcharge = 100
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 5)

/obj/item/cell/device/high
	name = "advanced power cell"
	desc = "A small, advanced power cell designed to power more energy demanding handheld devices."
	icon_state = "hdevice"
	maxcharge = 250
	matter = list(MATERIAL_STEEL = 150, MATERIAL_GLASS = 10)

/obj/item/cell/device/variable/New(newloc, charge_amount)
	..(newloc)
	maxcharge = charge_amount
	charge = maxcharge

/obj/item/cell/crap
	name = "old power cell"
	desc = "A cheap, old power cell. It's probably been in use for quite some time now."
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 500
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 40)

/obj/item/cell/crap/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/crap/cig
	name = "\improper rechargable mini-battery"
	desc = "A miniature power cell designed to power very small handheld devices."
	maxcharge = 200

/obj/item/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 40)

/obj/item/cell/secborg/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/apc
	name = "heavy-duty power cell"
	origin_tech = list(TECH_POWER = 1)
	maxcharge = 5000
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)

/obj/item/cell/high
	name = "high-capacity power cell"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "hcell"
	maxcharge = 10000
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 60)

/obj/item/cell/high/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "scell"
	maxcharge = 20000
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 70)

/obj/item/cell/super/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hpcell"
	maxcharge = 30000
	matter = list(DEFAULT_WALL_MATERIAL = 200, MATERIAL_GOLD = 50, MATERIAL_SILVER = 50, MATERIAL_GLASS = 40)

/obj/item/cell/hyper/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000 //determines how badly mobs get shocked
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 80)

/obj/item/cell/infinite/check_charge()
		return 1

/obj/item/cell/infinite/use()
		return 1

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	minor_fault = 1


/obj/item/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with phoron, it crackles with power."
	desc_info = "This slime core is energized with powerful bluespace energies, allowing it to regenerate ten percent of its charge every minute."
	origin_tech = list(TECH_POWER = 2, TECH_BIO = 4)
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "yellow slime extract"
	maxcharge = 15000
	matter = null

	// slime cores recharges 10% every one minute
	self_charge_percentage = 10

/obj/item/cell/nuclear
	name = "miniaturized nuclear power cell"
	desc = "A small self-charging cell with a thorium core that can store an immense amount of charge."
	origin_tech = list(TECH_POWER = 8, TECH_ILLEGAL = 4)
	icon_state = "icell"
	maxcharge = 50000
	matter = null

	// nuclear cores recharges 20% every one minute
	self_charge_percentage = 10

/obj/item/cell/device/emergency_light
	name = "miniature power cell"
	desc = "A small power cell intended for use with emergency lighting."
	maxcharge = 120	//Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	w_class = WEIGHT_CLASS_TINY
	matter = list(MATERIAL_GLASS = 20)

/obj/item/cell/device/emergency_light/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/proto
	name = "proto power cell"
	desc = "A heavy-duty reliable military-grade power cell. Doesn't look to fit any modern standards."
	icon_state = "proto"
	maxcharge = 25000
	origin_tech = list(TECH_POWER = 6)

/obj/item/cell/proto/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/obj/item/cell/hydrogen
	name = "hydrogen blaster canister"
	desc = "An industrial-grade hydrogen power cell, used in various blaster weapons- or blaster-adjacent power tools- in place of expensive phoron."
	icon_state = "hycell"
	maxcharge = 10000 // hydrogen is actually used today in electric cars
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 70)
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/gascan.ogg'
	pickup_sound = 'sound/items/pickup/gascan.ogg'
	origin_tech = list(TECH_POWER = 4)

/obj/item/cell/mecha
	name = "power core"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "core"
	w_class = WEIGHT_CLASS_BULKY
	maxcharge = 20000
	matter = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000)

/obj/item/cell/mecha/nuclear
	name = "nuclear power core"
	origin_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	icon_state = "nuclear_core"
	maxcharge = 30000
	matter = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000, MATERIAL_URANIUM = 10000)

	// nuclear mecha cores recharges 5% every one minute
	self_charge_percentage = 5

/obj/item/cell/mecha/phoron
	name = "phoron power core"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5)
	icon_state = "phoron_core"
	maxcharge = 50000
	matter = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000, MATERIAL_PHORON = 5000)

	// nuclear mecha cores recharges 10% every one minute
	self_charge_percentage = 10
