/obj/item/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = list(TECH_POWER = 1)
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 3.0
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)

//currently only used by energy-type guns, that may change in the future.
/obj/item/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "cell" //placeholder
	w_class = 2
	force = 0
	throw_speed = 5
	throw_range = 7
	maxcharge = 1000
	matter = list(MATERIAL_STEEL = 350, MATERIAL_GLASS = 50)

/obj/item/cell/device/variable/New(newloc, charge_amount)
	..(newloc)
	maxcharge = charge_amount
	charge = maxcharge

/obj/item/cell/crap
	name = "\improper rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 500
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 40)

/obj/item/cell/crap/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 40)

/obj/item/cell/secborg/empty/Initialize()
	. = ..()
	charge = 0

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

/obj/item/cell/mecha
	name = "exosuit-grade power cell"
	origin_tech = list(TECH_POWER = 3)
	icon_state = "hcell"
	maxcharge = 15000
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 70)

/obj/item/cell/high/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "scell"
	maxcharge = 20000
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 70)

/obj/item/cell/super/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hpcell"
	maxcharge = 30000
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 80)

/obj/item/cell/hyper/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000 //determines how badly mobs get shocked
	matter = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 80)

	check_charge()
		return 1
	use()
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
	description_info = "This slime core is energized with powerful bluespace energies, allowing it to regenerate ten percent of its charge every minute."
	origin_tech = list(TECH_POWER = 2, TECH_BIO = 4)
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "yellow slime extract"
	maxcharge = 15000
	matter = null
	var/next_recharge

/obj/item/cell/slime/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/cell/slime/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/cell/slime/process()
	if(next_recharge < world.time)
		charge = min(charge + (maxcharge / 10), maxcharge)
		next_recharge = world.time + 1 MINUTE

/obj/item/cell/device/emergency_light
	name = "miniature power cell"
	desc = "A small power cell intended for use with emergency lighting."
	maxcharge = 120	//Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	w_class = ITEMSIZE_TINY
	matter = list(MATERIAL_GLASS = 20)

/obj/item/cell/device/emergency_light/empty/Initialize()
	. = ..()
	charge = 0

/obj/item/cell/proto
	name = "proto power cell"
	desc = "A heavy-duty reliable military-grade power cell. Doesn't look to fit any modern standards."
	icon_state = "proto"
	maxcharge = 25000
	origin_tech = list(TECH_POWER = 6)

/obj/item/cell/proto/empty/Initialize()
	. = ..()
	charge = 0