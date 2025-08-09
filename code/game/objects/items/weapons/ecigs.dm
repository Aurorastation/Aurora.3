/obj/item/clothing/mask/smokable/ecig
	name = "electronic cigarette"
	desc = "A battery powered cigarette."
	icon = 'icons/obj/ecig.dmi'
	contained_sprite = TRUE
	item_icons = null // Needs to nuke this because Contained Sprites and all
	sprite_sheets = null // This as well
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una", "taj")
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("attacked", "poked", "battered")
	body_parts_covered = 0
	chem_volume = 0 //ecig has no storage on its own but has reagent container created by parent obj
	item_state = "ecigoff"

	/// If the electronic cigarette is working or not.
	var/active = FALSE
	/// The cigarette's attached cell item.
	var/obj/item/cell/cig_cell
	/// The type of cell to spawn.
	var/cell_type = /obj/item/cell/device
	/// The electronic cigarette's cartridge object, a reagent container.
	var/obj/item/reagent_containers/ecig_cartridge/ec_cartridge
	/// The type of cartridge to spawn.
	var/cartridge_type = /obj/item/reagent_containers/ecig_cartridge/med_nicotine
	/// The icon of the electronic cigarette when it's empty.
	var/icon_empty
	/// Value for simple ecig, divide by 5 to get the charge needed for 1 cartridge.
	var/power_usage = 250
	/// A list of colours for the icon. On Initialize it picks() between these.
	var/ecig_colors = list(null, COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_PURPLE_GRAY)
	/// If it's idling. Ticks up on process(), so not a boolean. When idle is >= idle_threshold, the cigarette shuts off.
	var/idle = 0
	/// The threshold to equal before the cigarette shuts down automatically.
	var/idle_threshold = 30

/obj/item/clothing/mask/smokable/ecig/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "While holding \the [src], ALT-click it to remove the cartridge."

/obj/item/clothing/mask/smokable/ecig/simple/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(ec_cartridge)
		. += "There are <b>[round(ec_cartridge.reagents.total_volume, 1)] unit\s</b> of liquid remaining."
	else
		. += "There's no cartridge connected."

/obj/item/clothing/mask/smokable/ecig/Initialize()
	. = ..()
	if(ispath(cell_type))
		cig_cell = new cell_type(src)
	ec_cartridge = new cartridge_type(src)

/obj/item/clothing/mask/smokable/ecig/get_cell()
	return cig_cell

/obj/item/clothing/mask/smokable/ecig/proc/deactivate()
	active = FALSE
	idle = 0
	STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/clothing/mask/smokable/ecig/process()
	if(!cig_cell)
		deactivate()
		return

	if(!ec_cartridge)
		deactivate()
		return

	if(idle >= idle_threshold) //idle too long -> automatic shut down
		visible_message(SPAN_NOTICE("\The [src] powers down automatically."), null, 2)
		deactivate()
		return

	idle ++

	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc

		if (!active || !ec_cartridge || !ec_cartridge.reagents.total_volume)//no cartridge
			if(!ec_cartridge.reagents.total_volume)
				to_chat(C, SPAN_NOTICE("There's no liquid left in \the [src], so you shut it down."))
			deactivate()
			return

		if (src == C.wear_mask && C.check_has_mouth()) //transfer, but only when not disabled
			idle = 0
			//here we'll reduce battery by usage, and check powerlevel - you only use battery while smoking
			if(!cig_cell.checked_use(power_usage * CELLRATE)) //if this passes, there's not enough power in the battery
				deactivate()
				to_chat(C,SPAN_NOTICE("\The [src]'s power meter flashes a low battery warning and shuts down."))
				return
			/// Electronic cigarettes are a bit more efficient than normal cigarettes, owing to having a bit more reagent capacity.
			ec_cartridge.reagents.trans_to_mob(C, 0.003 * ec_cartridge.reagents.total_volume, CHEM_BREATHE, 0.75)

/obj/item/clothing/mask/smokable/ecig/update_icon()
	if (active)
		item_state = icon_on
		icon_state = icon_on
		set_light(1.4, 0.5, COLOR_ORANGE)
	else if (ec_cartridge)
		set_light(0)
		item_state = icon_off
		icon_state = icon_off
	else
		icon_state = icon_empty
		item_state = icon_empty
		set_light(0)
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_l_hand(0)
		M.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/ecig/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/ecig_cartridge))
		if (ec_cartridge)//can't add second one
			to_chat(user, SPAN_WARNING("A cartridge has already been installed."))
		else //fits in new one
			user.drop_from_inventory(attacking_item, src)
			ec_cartridge = attacking_item
			update_icon()
			to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]."))

	if(attacking_item.isscrewdriver())
		if(cig_cell) //if contains powercell
			cig_cell.update_icon()
			user.put_in_hands(cig_cell)
			to_chat(user, SPAN_NOTICE("You remove \the [cig_cell] from \the [src]."))
			cig_cell = null
		else //does not contains cell
			to_chat(user, SPAN_WARNING("There's no battery in \the [src]."))

	if (istype(attacking_item, /obj/item/cell))
		if(cig_cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a battery installed."))
			return
		if (!istype(attacking_item, /obj/item/cell/device))
			to_chat(user, SPAN_WARNING("\The [attacking_item] is too large to be inserted into \the [src]."))
			return
		if(user.unEquip(attacking_item))
			attacking_item.forceMove(src)
			cig_cell = attacking_item
			to_chat(user, SPAN_NOTICE("You install \the [cig_cell] into \the [src]."))
			update_icon()

/obj/item/clothing/mask/smokable/ecig/attack_self(mob/user)
	if (active)
		deactivate()
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
	else
		if(cig_cell)
			if (!ec_cartridge)
				to_chat(user, SPAN_WARNING("You can't use \the [src] with no cartridge installed!"))
				return
			else if(!ec_cartridge.reagents.total_volume)
				to_chat(user, SPAN_WARNING("You can't use \the [src] with no liquid left!"))
				return
			else if(!cig_cell.check_charge(power_usage * CELLRATE))
				to_chat(user, SPAN_WARNING("\The [src]'s power meter flashes a low battery warning and refuses to operate."))
				return
			active = TRUE
			START_PROCESSING(SSprocessing, src)
			to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] does not have a battery installed."))

/obj/item/clothing/mask/smokable/ecig/AltClick(mob/user)
	if(use_check_and_message(user))
		return

	if(user.get_inactive_hand() == src || user.get_active_hand() == src)
		if (ec_cartridge)
			active = FALSE
			user.put_in_hands(ec_cartridge)
			to_chat(user, SPAN_NOTICE("You remove \the [ec_cartridge] from \the [src]."))
			ec_cartridge = null
			update_icon()
	else
		to_chat(user, SPAN_WARNING("\The [src] needs to be in one of your hands."))

/obj/item/clothing/mask/smokable/ecig/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/human/C = target_mob

	if(active && C == user && istype(C))
		var/obj/item/blocked = C.check_mouth_coverage()
		if(blocked)
			to_chat(C, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(last_drag <= world.time - 30)
			if(!cig_cell.checked_use(power_usage * CELLRATE)) //if this passes, there's not enough power in the battery
				deactivate()
				to_chat(C,SPAN_WARNING("\The [src]'s power meter flashes a low battery warning and shuts down."))
				return
			last_drag = world.time
			idle = 0
			C.visible_message(SPAN_NOTICE("[C.name] takes a drag of their [name]."))
			playsound(C, 'sound/items/cigs_lighters/inhale.ogg', 50, 0, -1)
			ec_cartridge.reagents.trans_to_mob(C, REM, CHEM_BREATHE, 0.4)
			return TRUE
	return ..()

/obj/item/clothing/mask/smokable/ecig/simple
	name = "cheap electronic cigarette"
	desc = "A cheap Lucky 1337 electronic cigarette, styled like a traditional cigarette."
	icon_state = "ccigoff"
	icon_off = "ccigoff"
	icon_empty = "ccigoff"
	icon_on = "ccigon"

/obj/item/clothing/mask/smokable/ecig/util
	name = "electronic cigarette"
	desc = "A popular utilitarian model electronic cigarette, the ONI-55. Comes in a variety of colors."
	icon_state = "ecigoff1"
	icon_off = "ecigoff1"
	icon_empty = "ecigoff1"
	icon_on = "ecigon"

/obj/item/clothing/mask/smokable/ecig/util/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(ec_cartridge)
		. += "There are <b>[round(ec_cartridge.reagents.total_volume, 1)] unit\s</b> of liquid remaining."
	else
		. += "There's no cartridge connected."

	if(cig_cell)
		. += "The power meter shows that there's about <b>[round(cig_cell.percent(), 5)]%</b> power remaining."
	else
		. += "There's no power cell connected."

	if(active)
		. += "It is currently turned on."
	else
		. += "It is currently turned off."

/obj/item/clothing/mask/smokable/ecig/util/Initialize()
	. = ..()
	color = pick(ecig_colors)

/obj/item/clothing/mask/smokable/ecig/deluxe
	name = "deluxe electronic cigarette"
	desc = "A premium model eGavana MK3 electronic cigarette, shaped like a cigar."
	icon_state = "pcigoff1"
	icon_off = "pcigoff1"
	icon_empty = "pcigoff2"
	icon_on = "pcigon"
	cell_type = /obj/item/cell/device/high

/obj/item/clothing/mask/smokable/ecig/deluxe/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(ec_cartridge)
		. += "There are <b>[round(ec_cartridge.reagents.total_volume, 1)] unit\s</b> of liquid remaining."
	else
		. += "There's no cartridge connected."

	if(cig_cell)
		. += "The power meter shows that there's about <b>[round(cig_cell.percent(), 1)]%</b> power remaining."
	else
		. += "There's no power cell connected."

/obj/item/reagent_containers/ecig_cartridge
	name = "tobacco flavour cartridge"
	desc = "A small metal cartridge, used with electronic cigarettes, which contains an atomizing coil and a solution to be atomized."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/ecig.dmi'
	icon_state = "ecartridge"
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 10)
	volume = 20
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/ecig_cartridge/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The cartridge has <b>[reagents.total_volume] unit\s</b> of liquid remaining."

//flavours
/obj/item/reagent_containers/ecig_cartridge/blank
	name = "ecigarette cartridge"
	desc = "A small metal cartridge which contains an atomizing coil."

/obj/item/reagent_containers/ecig_cartridge/blanknico
	name = "flavorless nicotine cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says you can add whatever flavoring agents you want."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 5, /singleton/reagent/water = 10)

/obj/item/reagent_containers/ecig_cartridge/med_nicotine
	name = "tobacco flavour cartridge"
	desc =  "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 5, /singleton/reagent/water = 15)

/obj/item/reagent_containers/ecig_cartridge/high_nicotine
	name = "high nicotine tobacco flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored, with extra nicotine."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 10, /singleton/reagent/water = 10)

/obj/item/reagent_containers/ecig_cartridge/menthol
	name = "menthol flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says it's menthol flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 5, /singleton/reagent/water = 10, /singleton/reagent/menthol = 5)

/obj/item/reagent_containers/ecig_cartridge/orange
	name = "orange flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its orange flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 5, /singleton/reagent/water = 10, /singleton/reagent/drink/orangejuice = 5)

/obj/item/reagent_containers/ecig_cartridge/watermelon
	name = "watermelon flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its watermelon flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 10, /singleton/reagent/water = 10, /singleton/reagent/drink/watermelonjuice = 5)

/obj/item/reagent_containers/ecig_cartridge/grape
	name = "grape flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its grape flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 10, /singleton/reagent/water = 10, /singleton/reagent/drink/grapejuice = 5)

/obj/item/reagent_containers/ecig_cartridge/lemonlime
	name = "lemon-lime flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its lemon-lime flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 10, /singleton/reagent/water = 10, /singleton/reagent/drink/lemon_lime = 5)

/obj/item/reagent_containers/ecig_cartridge/coffee
	name = "coffee flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its coffee flavored."
	reagents_to_add = list(/singleton/reagent/toxin/tobacco/liquid = 10, /singleton/reagent/water = 10, /singleton/reagent/drink/coffee = 5)

/obj/item/reagent_containers/ecig_cartridge/caromeg
	name = "flavorless caromeg cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says you can add whatever flavoring agents you want."
	reagents_to_add = list(/singleton/reagent/toxin/oracle/liquid = 5, /singleton/reagent/water = 10)
