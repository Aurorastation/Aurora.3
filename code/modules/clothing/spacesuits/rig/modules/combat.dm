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
	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/grenade_launcher
	name = "mounted grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser."
	selectable = TRUE
	icon_state = "grenade"

	interface_name = "integrated grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	category = MODULE_HEAVY_COMBAT

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/grenade/flashbang,  3),
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/smokebomb,  3),
		list("EMP grenade", "EMP grenade", /obj/item/grenade/empgrenade, 3)
		)

/obj/item/rig_module/grenade_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)
	if(!istype(input_device) || !istype(user))
		return FALSE

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return FALSE

	if(accepted_item.charges >= 5)
		to_chat(user, SPAN_WARNING("Another grenade of that type will not fit into the module."))
		return FALSE

	to_chat(user, SPAN_NOTICE("You slot \the [input_device] into the suit module."))
	qdel(input_device)
	accepted_item.charges++
	return TRUE

/obj/item/rig_module/grenade_launcher/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	if(!target)
		return FALSE

	if(!charge_selected)
		to_chat(user, SPAN_WARNING("You have not selected a grenade type."))
		return FALSE

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return FALSE

	if(charge.charges <= 0)
		to_chat(user, SPAN_WARNING("Insufficient grenades!"))
		return FALSE

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(holder.wearer))
	holder.wearer.visible_message(SPAN_DANGER("[user] launches \a [new_grenade]!"))
	new_grenade.activate(user)
	new_grenade.throw_at(target, fire_force, fire_distance)
	return TRUE

/obj/item/rig_module/grenade_launcher/frag
	name = "mounted frag grenade launcher"
	desc = "A shoulder-mounted fragmentation explosives dispenser."
	selectable = TRUE
	icon_state = "grenade"

	interface_name = "integrated frag grenade launcher"
	interface_desc = "Discharges loaded frag grenades against the wearer's location."

	charges = list(
		list("frag grenade", "frag grenade", /obj/item/grenade/frag, 3)
		)

/obj/item/rig_module/grenade_launcher/cleaner
	name = "mounted cleaning grenade launcher"
	desc = "A specialty shoulder-mounted micro-explosive dispenser."

	category = MODULE_GENERAL

	charges = list(
		list("cleaning grenade", "cleaning grenade", /obj/item/grenade/chem_grenade/cleaner, 9)
		)

/obj/item/rig_module/mounted
	name = "mounted laser cannon"
	desc = "A shoulder-mounted battery-powered laser cannon mount."
	selectable = TRUE
	usable = TRUE
	module_cooldown = 0
	icon_state = "lcannon"

	engage_string = "Configure"

	category = MODULE_HEAVY_COMBAT

	interface_name = "mounted laser cannon"
	interface_desc = "A shoulder-mounted cell-powered laser cannon."

	var/gun_type = /obj/item/gun/energy/lasercannon/mounted
	var/obj/item/gun/gun

/obj/item/rig_module/mounted/New()
	..()
	gun = new gun_type(src)
	if(istype(gun, /obj/item/gun))
		gun.has_safety = FALSE

/obj/item/rig_module/mounted/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	if(!target)
		var/list/extra_mobs = list()
		if(holder.wearer != user)
			extra_mobs += holder.wearer
		gun.toggle_firing_mode(user, extra_mobs)
		return TRUE

	gun.Fire(target, user)
	return TRUE

/obj/item/rig_module/mounted/egun
	name = "mounted energy gun"
	desc = "A forearm-mounted energy projector."
	icon_state = "egun"
	construction_cost= list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 2250, MATERIAL_URANIUM = 3250, MATERIAL_GOLD = 2500)
	construction_time = 300

	interface_name = "mounted energy gun"
	interface_desc = "A forearm-mounted suit-powered energy gun."

	gun_type = /obj/item/gun/energy/gun/mounted

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/mounted/taser
	name = "mounted taser"
	desc = "A palm-mounted nonlethal energy projector."
	icon_state = "taser"
	construction_cost = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 5250)
	construction_time = 300

	usable = FALSE

	suit_overlay_active = "mounted-taser"
	suit_overlay_inactive = "mounted-taser"

	interface_name = "mounted taser"
	interface_desc = "A shoulder-mounted cell-powered taser."

	gun_type = /obj/item/gun/energy/taser/mounted

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/mounted/pulse
	name = "mounted pulse rifle"
	desc = "A shoulder-mounted battery-powered pulse rifle mount."
	icon_state = "pulse"

	interface_name = "mounted pulse rifle"
	interface_desc = "A shoulder-mounted cell-powered pulse rifle."

	gun_type = /obj/item/gun/energy/pulse/mounted

/obj/item/rig_module/mounted/plasma

	name = "mounted plasma cannon"
	desc = "A marvel of Elyran weapons technology which utilizes superheated plasma to pierce thick armor with gruesome results. This one seems fitted for RIG usage."
	icon_state = "plasma"

	interface_name = "mounted plasma cannon"
	interface_desc = "A shoulder-mounted cell-powered burst plasma cannon."

	gun_type = /obj/item/gun/energy/mountedplasma

/obj/item/rig_module/mounted/smg
	name = "mounted submachine gun"
	desc = "A forearm-mounted suit-powered ballistic submachine gun."
	icon_state = "smg"

	interface_name = "mounted submachine gun"
	interface_desc = "A forearm-mounted suit-powered ballistic submachine gun."

	gun_type = /obj/item/gun/energy/mountedsmg

/obj/item/rig_module/mounted/xray
	name = "mounted xray laser gun"
	desc = "A forearm-mounted suit-powered xray laser gun."
	icon_state = "xray"

	interface_name = "mounted xray laser gun"
	interface_desc = "A forearm-mounted suit-powered xray laser gun."

	gun_type = /obj/item/gun/energy/xray/mounted

/obj/item/rig_module/mounted/ion
	name = "mounted ion rifle"
	desc = "A shoulder-mounted battery-powered ion rifle mount."
	icon_state = "ion"

	interface_name = "mounted ion rifle"
	interface_desc = "A shoulder-mounted cell-powered ion rifle."

	gun_type = /obj/item/gun/energy/rifle/ionrifle/mounted

/obj/item/rig_module/mounted/tesla
	name = "mounted tesla carbine"
	desc = "A shoulder-mounted battery-powered tesla carbine mount."
	icon_state = "tesla"

	interface_name = "mounted tesla carbine"
	interface_desc = "A shoulder-mounted cell-powered tesla carbine."

	gun_type = /obj/item/gun/energy/tesla/mounted

/obj/item/rig_module/mounted/plasmacutter
	name = "hardsuit plasma cutter"
	desc = "A forearm mounted kinetic accelerator"
	icon_state = "plasmacutter"
	interface_name = "plasma cutter"
	interface_desc = "A self-sustaining plasma arc capable of cutting through walls."
	suit_overlay_active = "plasmacutter"
	suit_overlay_inactive = "plasmacutter"
	construction_cost = list(MATERIAL_GLASS = 5250, DEFAULT_WALL_MATERIAL = 30000, MATERIAL_SILVER = 5250, MATERIAL_PHORON = 7250)
	construction_time = 300

	category = MODULE_UTILITY

	gun_type = /obj/item/gun/energy/plasmacutter/mounted

/obj/item/rig_module/mounted/thermalldrill
	name = "hardsuit thermal drill"
	desc = "An incredibly lethal looking thermal drill."
	icon_state = "thermaldrill"
	interface_name = "thermal drill"
	interface_desc = "A potent drill that can pierce rock walls over long distances."

	gun_type = /obj/item/gun/energy/vaurca/mountedthermaldrill

	category = MODULE_UTILITY

/obj/item/rig_module/mounted/energy_blade
	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."

	usable = FALSE
	selectable = TRUE
	toggleable = TRUE
	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0

	gun_type = /obj/item/gun/energy/crossbow/ninja

	category = MODULE_SPECIAL

/obj/item/rig_module/mounted/energy_blade/process()
	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/energy/blade) in holder.wearer))
			deactivate(holder.wearer)
			return FALSE

	return ..()

/obj/item/rig_module/mounted/energy_blade/activate(mob/user)
	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		if(M == user)
			to_chat(M, SPAN_WARNING("Your hands are full."))
		else
			to_chat(user, SPAN_WARNING("[M]'s hands are full."))
		deactivate()
		return

	var/obj/item/melee/energy/blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/mounted/energy_blade/deactivate()
	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/energy/blade/blade in M.contents)
		qdel(blade)

/obj/item/rig_module/fabricator
	name = "matter fabricator"
	desc = "A self-contained microfactory system for hardsuit integration."
	selectable = TRUE
	usable = TRUE
	use_power_cost = 10
	icon_state = "enet"

	engage_string = "Fabricate Star"

	interface_name = "death blossom launcher"
	interface_desc = "An integrated microfactory that produces steel throwing stars from thin air and electricity."

	var/fabrication_type = /obj/item/material/star
	var/fire_force = 30
	var/fire_distance = 10

	category = MODULE_SPECIAL

/obj/item/rig_module/fabricator/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	var/mob/living/H = holder.wearer

	if(target)
		var/obj/item/firing = new fabrication_type(get_turf(src))
		holder.wearer.visible_message(SPAN_DANGER("[user] launches \a [firing]!"))
		firing.throw_at(target, fire_force, fire_distance)
	else
		if(H.l_hand && H.r_hand)
			if(H == user)
				to_chat(H, SPAN_WARNING("Your hands are full."))
			else
				to_chat(user, SPAN_WARNING("[H]'s hands are full."))
		else
			var/obj/item/new_weapon = new fabrication_type(H)
			message_user(user, SPAN_NOTICE("You quickly fabricate \a [new_weapon]."), SPAN_NOTICE("\The [user] fabricates \a [new_weapon]."))
			H.put_in_hands(new_weapon)

	return TRUE

/obj/item/rig_module/fabricator/sign
	name = "wet floor sign fabricator"
	engage_string = "Fabricate Sign"

	interface_name = "wet floor sign launcher"
	interface_desc = "An integrated microfactory that produces wet floor signs from thin air and electricity."

	fabrication_type = /obj/item/clothing/suit/caution

	category = MODULE_GENERAL

/obj/item/rig_module/tesla_coil
	name = "mounted tesla coil"
	desc = "A mounted tesla coil that discharges a powerful lightning strike around the user."
	icon_state = "ewar"
	interface_name = "mounted tesla coil"
	interface_desc ="Discharges a powerful lightning strike around the user."

	use_power_cost = 30
	module_cooldown = 100

	usable = TRUE

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/tesla_coil/engage(atom/target, mob/user)
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	H.visible_message(SPAN_DANGER("\The [H] crackles with energy!"))
	playsound(H, 'sound/magic/LightningShock.ogg', 75, 1)
	tesla_zap(H, 5, 5000)
	return TRUE