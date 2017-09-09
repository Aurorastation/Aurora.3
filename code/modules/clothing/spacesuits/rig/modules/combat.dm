/*
 * Contains
 * /obj/item/rig_module/grenade_launcher
 * /obj/item/rig_module/mounted
 * /obj/item/rig_module/mounted/taser
 * /obj/item/rig_module/shield
 * /obj/item/rig_module/fabricator
 * /obj/item/rig_module/device/flash
 */

/obj/item/rig_module/device/flash
	name = "mounted flash"
	desc = "You are the law."
	icon_state = "flash"
	interface_name = "mounted flash"
	interface_desc = "Stuns your target by blinding them with a bright light."
	device_type = /obj/item/device/flash

/obj/item/rig_module/grenade_launcher

	name = "mounted grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser."
	selectable = 1
	icon_state = "grenade"

	interface_name = "integrated grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/weapon/grenade/flashbang,  3),
		list("smoke bomb",  "smoke bomb",  /obj/item/weapon/grenade/smokebomb,  3),
		list("EMP grenade", "EMP grenade", /obj/item/weapon/grenade/empgrenade, 3)
		)

/obj/item/rig_module/grenade_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(!istype(input_device) || !istype(user))
		return 0

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return 0

	if(accepted_item.charges >= 5)
		user << "<span class='danger'>Another grenade of that type will not fit into the module.</span>"
		return 0

	user << "<font color='blue'><b>You slot \the [input_device] into the suit module.</b></font>"
	user.drop_from_inventory(input_device)
	qdel(input_device)
	accepted_item.charges++
	return 1

/obj/item/rig_module/grenade_launcher/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		H << "<span class='danger'>You have not selected a grenade type.</span>"
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		H << "<span class='danger'>Insufficient grenades!</span>"
		return 0

	charge.charges--
	var/obj/item/weapon/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message("<span class='danger'>[H] launches \a [new_grenade]!</span>")
	new_grenade.activate(H)
	new_grenade.throw_at(target,fire_force,fire_distance)

/obj/item/rig_module/grenade_launcher/frag

	name = "mounted frag grenade launcher"
	desc = "A shoulder-mounted fragmentation explosives dispenser."
	selectable = 1
	icon_state = "grenade"

	interface_name = "integrated frag grenade launcher"
	interface_desc = "Discharges loaded frag grenades against the wearer's location."

	charges = list(
		list("frag grenade",   "frag grenade",   /obj/item/weapon/grenade/frag,  3)
		)

/obj/item/rig_module/grenade_launcher/cleaner
	name = "mounted cleaning grenade launcher"
	desc = "A specialty shoulder-mounted micro-explosive dispenser."

	charges = list(
		list("cleaning grenade",   "cleaning grenade",   /obj/item/weapon/grenade/chem_grenade/cleaner,  9)
		)

/obj/item/rig_module/mounted

	name = "mounted laser cannon"
	desc = "A shoulder-mounted battery-powered laser cannon mount."
	selectable = 1
	usable = 1
	module_cooldown = 0
	icon_state = "lcannon"

	engage_string = "Configure"

	interface_name = "mounted laser cannon"
	interface_desc = "A shoulder-mounted cell-powered laser cannon."

	var/gun_type = /obj/item/weapon/gun/energy/lasercannon/mounted
	var/obj/item/weapon/gun/gun

/obj/item/rig_module/mounted/New()
	..()
	gun = new gun_type(src)

/obj/item/rig_module/mounted/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		gun.attack_self(holder.wearer)
		return 1

	gun.Fire(target,holder.wearer)
	return 1

/obj/item/rig_module/mounted/egun

	name = "mounted energy gun"
	desc = "A forearm-mounted energy projector."
	icon_state = "egun"
	construction_cost= list(DEFAULT_WALL_MATERIAL=7000,"glass"=2250,"uranium"=3250,"gold"=2500)
	construction_time = 300

	interface_name = "mounted energy gun"
	interface_desc = "A forearm-mounted suit-powered energy gun."

	gun_type = /obj/item/weapon/gun/energy/gun/mounted

/obj/item/rig_module/mounted/taser

	name = "mounted taser"
	desc = "A palm-mounted nonlethal energy projector."
	icon_state = "taser"
	construction_cost = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 5250)
	construction_time = 300

	usable = 0

	suit_overlay_active = "mounted-taser"
	suit_overlay_inactive = "mounted-taser"

	interface_name = "mounted taser"
	interface_desc = "A shoulder-mounted cell-powered taser."

	gun_type = /obj/item/weapon/gun/energy/taser/mounted

/obj/item/rig_module/mounted/pulse

	name = "mounted pulse rifle"
	desc = "A shoulder-mounted battery-powered pulse rifle mount."
	icon_state = "pulse"

	interface_name = "mounted pulse rifle"
	interface_desc = "A shoulder-mounted cell-powered pulse rifle."

	gun_type = /obj/item/weapon/gun/energy/pulse/mounted

/obj/item/rig_module/mounted/smg

	name = "mounted submachine gun"
	desc = "A forearm-mounted suit-powered ballistic submachine gun."
	icon_state = "smg"

	interface_name = "mounted submachine gun"
	interface_desc = "A forearm-mounted suit-powered ballistic submachine gun."

	gun_type = /obj/item/weapon/gun/energy/mountedsmg

/obj/item/rig_module/mounted/xray

	name = "mounted xray laser gun"
	desc = "A forearm-mounted suit-powered xray laser gun."
	icon_state = "xray"

	interface_name = "mounted xray laser gun"
	interface_desc = "A forearm-mounted suit-powered xray laser gun."

	gun_type = /obj/item/weapon/gun/energy/xray/mounted

/obj/item/rig_module/mounted/ion

	name = "mounted ion rifle"
	desc = "A shoulder-mounted battery-powered ion rifle mount."
	icon_state = "ion"

	interface_name = "mounted ion rifle"
	interface_desc = "A shoulder-mounted cell-powered ion rifle."

	gun_type = /obj/item/weapon/gun/energy/ionrifle/mounted

/obj/item/rig_module/mounted/plasmacutter
	name = "hardsuit plasma cutter"
	desc = "A forearm mounted kinetic accelerator"
	icon_state = "plasmacutter"
	interface_name = "plasma cutter"
	interface_desc = "A self-sustaining plasma arc capable of cutting through walls."
	suit_overlay_active = "plasmacutter"
	suit_overlay_inactive = "plasmacutter"
	construction_cost = list("glass" = 5250, DEFAULT_WALL_MATERIAL = 30000, "silver" = 5250, "phoron" = 7250)
	construction_time = 300

	gun_type = /obj/item/weapon/gun/energy/plasmacutter/mounted

/obj/item/rig_module/mounted/kinetic_accelerator
	name = "hardsuit kinetic accelerator"
	desc = "A lethal-looking industrial cutter."
	icon_state = "kineticgun"
	interface_name = "kinetic accelerator"
	interface_desc = "A ranged mining tool that does increased damage in low pressure."

	gun_type = /obj/item/weapon/gun/energy/kinetic_accelerator/cyborg

/obj/item/rig_module/mounted/thermalldrill
	name = "hardsuit thermal drill"
	desc = "An incredibly lethal looking thermal drill."
	icon_state = "thermaldrill"
	interface_name = "thermal drill"
	interface_desc = "A potent drill that can pierce rock walls over long distances."

	gun_type = /obj/item/weapon/gun/energy/vaurca/mountedthermaldrill


/obj/item/rig_module/mounted/energy_blade

	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0

	gun_type = /obj/item/weapon/gun/energy/crossbow/ninja

/obj/item/rig_module/mounted/energy_blade/process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/weapon/melee/energy/blade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/energy_blade/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		M << "<span class='danger'>Your hands are full.</span>"
		deactivate()
		return

	var/obj/item/weapon/melee/energy/blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/mounted/energy_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/weapon/melee/energy/blade/blade in M.contents)
		M.drop_from_inventory(blade)
		qdel(blade)

/obj/item/rig_module/fabricator

	name = "matter fabricator"
	desc = "A self-contained microfactory system for hardsuit integration."
	selectable = 1
	usable = 1
	use_power_cost = 15
	icon_state = "enet"

	engage_string = "Fabricate Star"

	interface_name = "death blossom launcher"
	interface_desc = "An integrated microfactory that produces poisoned throwing stars from thin air and electricity."

	var/fabrication_type = /obj/item/weapon/material/star/ninja
	var/fire_force = 30
	var/fire_distance = 10

/obj/item/rig_module/fabricator/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/H = holder.wearer

	if(target)
		var/obj/item/firing = new fabrication_type()
		firing.forceMove(get_turf(src))
		H.visible_message("<span class='danger'>[H] launches \a [firing]!</span>")
		firing.throw_at(target,fire_force,fire_distance)
	else
		if(H.l_hand && H.r_hand)
			H << "<span class='danger'>Your hands are full.</span>"
		else
			var/obj/item/new_weapon = new fabrication_type()
			new_weapon.forceMove(H)
			H << "<font color='blue'><b>You quickly fabricate \a [new_weapon].</b></font>"
			H.put_in_hands(new_weapon)

	return 1

/obj/item/rig_module/fabricator/sign
	name = "wet floor sign fabricator"
	engage_string = "Fabricate Sign"

	interface_name = "wet floor sign launcher"
	interface_desc = "An integrated microfactory that produces wet floor signs from thin air and electricity."

	fabrication_type = /obj/item/weapon/caution
