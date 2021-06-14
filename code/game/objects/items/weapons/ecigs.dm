/obj/item/clothing/mask/smokable/ecig
	name = "electronic cigarette"
	desc = "Device with modern approach to smoking."
	icon = 'icons/obj/ecig.dmi'
	var/active = FALSE
	var/obj/item/cell/cigcell
	var/cartridge_type = /obj/item/reagent_containers/ecig_cartridge/med_nicotine
	var/obj/item/reagent_containers/ecig_cartridge/ec_cartridge
	var/cell_type = /obj/item/cell/crap/cig
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("attacked", "poked", "battered")
	body_parts_covered = 0
	var/brightness_on = TRUE
	chem_volume = 0 //ecig has no storage on its own but has reagent container created by parent obj
	item_state = "ecigoff"
	var/icon_empty
	var/power_usage = 500 //value for simple ecig, divide by 5 to get the charge needed for 1 cartridge
	var/ecig_colors = list(null, COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_PURPLE_GRAY)
	var/idle = 0
	var/idle_treshold = 30

/obj/item/clothing/mask/smokable/ecig/New()
	..()
	if(ispath(cell_type))
		cigcell = new cell_type
	ec_cartridge = new cartridge_type(src)

/obj/item/clothing/mask/smokable/ecig/get_cell()
	return cigcell

/obj/item/clothing/mask/smokable/ecig/simple
	name = "cheap electronic cigarette"
	desc = "A cheap Lucky 1337 electronic cigarette, styled like a traditional cigarette."
	icon_state = "ccigoff"
	icon_off = "ccigoff"
	icon_empty = "ccigoff"
	icon_on = "ccigon"

/obj/item/clothing/mask/smokable/ecig/simple/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,SPAN_NOTICE("There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))

/obj/item/clothing/mask/smokable/ecig/util
	name = "electronic cigarette"
	desc = "A popular utilitarian model electronic cigarette, the ONI-55. Comes in a variety of colors."
	icon_state = "ecigoff1"
	icon_off = "ecigoff1"
	icon_empty = "ecigoff1"
	icon_on = "ecigon"
	cell_type = /obj/item/cell/crap/cig //enough for two cartridges

/obj/item/clothing/mask/smokable/ecig/util/New()
	..()
	color = pick(ecig_colors)

obj/item/clothing/mask/smokable/ecig/util/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,SPAN_NOTICE("There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))
	if(cigcell)
		to_chat(user,SPAN_NOTICE("The power meter shows that there's about [round(cigcell.percent(), 5)]% power remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))
	if(active)
		to_chat(user,SPAN_NOTICE("It is currently turned on."))
	else
		to_chat(user,SPAN_NOTICE("It is currently turned off."))

/obj/item/clothing/mask/smokable/ecig/deluxe
	name = "deluxe electronic cigarette"
	desc = "A premium model eGavana MK3 electronic cigarette, shaped like a cigar."
	icon_state = "pcigoff1"
	icon_off = "pcigoff1"
	icon_empty = "pcigoff2"
	icon_on = "pcigon"
	cell_type = /obj/item/cell/crap //enough for five catridges

/obj/item/clothing/mask/smokable/ecig/deluxe/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,SPAN_NOTICE("There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))
	if(cigcell)
		to_chat(user,SPAN_NOTICE("The power meter shows that there's about [round(cigcell.percent(), 1)]% power remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))

/obj/item/clothing/mask/smokable/ecig/proc/Deactivate()
	active = FALSE
	STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/clothing/mask/smokable/ecig/process()
	if(!cigcell)
		Deactivate()
		return
	if(!ec_cartridge)
		Deactivate()
		return

	if(idle >= idle_treshold) //idle too long -> automatic shut down
		idle = 0
		visible_message(SPAN_NOTICE("\The [src] powers down automatically."), null, 2)
		Deactivate()
		return

	idle ++

	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc

		if (!active || !ec_cartridge || !ec_cartridge.reagents.total_volume)//no cartridge
			if(!ec_cartridge.reagents.total_volume)
				to_chat(C, SPAN_NOTICE("There's no liquid left in \the [src], so you shut it down."))
			Deactivate()
			return

		if (src == C.wear_mask && C.check_has_mouth()) //transfer, but only when not disabled
			idle = 0
			//here we'll reduce battery by usage, and check powerlevel - you only use batery while smoking
			if(!cigcell.checked_use(power_usage * CELLRATE)) //if this passes, there's not enough power in the battery
				Deactivate()
				to_chat(C,SPAN_NOTICE("\The [src]'s power meter flashes a low battery warning and shuts down."))
				return
			ec_cartridge.reagents.trans_to_mob(C, REM, CHEM_BREATHE, 0.4) // Most of it is not inhaled... balance reasons.

/obj/item/clothing/mask/smokable/ecig/update_icon()
	if (active)
		item_state = icon_on
		icon_state = icon_on
		set_light(0.6, 0.5, brightness_on)
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


/obj/item/clothing/mask/smokable/ecig/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/ecig_cartridge))
		if (ec_cartridge)//can't add second one
			to_chat(user, SPAN_NOTICE("A cartridge has already been installed."))
		else //fits in new one
			user.drop_from_inventory(I,src)
			ec_cartridge = I
			update_icon()
			to_chat(user, SPAN_NOTICE("You insert \the [I] into \the [src]."))

	if(istype(I, /obj/item/screwdriver))
		if(cigcell) //if contains powercell
			cigcell.update_icon()
			cigcell.dropInto(loc)
			cigcell = null
			to_chat(user, SPAN_NOTICE("You remove \the [cigcell] from \the [src]."))
		else //does not contains cell
			to_chat(user, SPAN_NOTICE("There's no battery in \the [src]."))

	if(istype(I, /obj/item/cell/crap))
		if(!cigcell && user.unEquip(I))
			I.forceMove(src)
			cigcell = I
			to_chat(user, SPAN_NOTICE("You install \the [cigcell] into \the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("\The [src] already has a battery installed."))


/obj/item/clothing/mask/smokable/ecig/attack_self(mob/user)
	if (active)
		Deactivate()
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
	else
		if(cigcell)
			if (!ec_cartridge)
				to_chat(user, SPAN_NOTICE("You can't use \the [src] with no cartridge installed!"))
				return
			else if(!ec_cartridge.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("You can't use \the [src] with no liquid left!"))
				return
			else if(!cigcell.check_charge(power_usage * CELLRATE))
				to_chat(user, SPAN_NOTICE("\The [src]'s power meter flashes a low battery warning and refuses to operate."))
				return
			active = TRUE
			START_PROCESSING(SSprocessing, src)
			to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
			update_icon()

		else
			to_chat(user, SPAN_WARNING("\The [src] does not have a battery installed."))

/obj/item/clothing/mask/smokable/ecig/attack_hand(mob/user)//eject cartridge
	if(user.get_inactive_hand() == src)//if being hold
		if (ec_cartridge)
			active = FALSE
			user.put_in_hands(ec_cartridge)
			to_chat(user, SPAN_NOTICE("You remove \the [ec_cartridge] from \the [src]."))
			ec_cartridge = null
			update_icon()
	else
		..()

/obj/item/clothing/mask/smokable/ecig/attack(mob/living/carbon/human/C, mob/user, def_zone)
	if(active && C == user && istype(C))
		var/obj/item/blocked = C.check_mouth_coverage()
		if(blocked)
			to_chat(C, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(last_drag <= world.time - 30) 
			if(!cigcell.checked_use(power_usage * CELLRATE)) //if this passes, there's not enough power in the battery
				Deactivate()
				to_chat(C,SPAN_NOTICE("\The [src]'s power meter flashes a low battery warning and shuts down."))
				return
			last_drag = world.time
			idle = 0
			C.visible_message(SPAN_NOTICE("[C.name] takes a drag of their [name].</span>"))
			playsound(C, 'sound/items/cigs_lighters/inhale.ogg', 50, 0, -1)
			ec_cartridge.reagents.trans_to_mob(C, REM, CHEM_BREATHE, 0.4) 
			return TRUE
	return ..()

/obj/item/reagent_containers/ecig_cartridge
	name = "tobacco flavour cartridge"
	desc = "A small metal cartridge, used with electronic cigarettes, which contains an atomizing coil and a solution to be atomized."
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/ecig.dmi'
	icon_state = "ecartridge"
	matter = list(MATERIAL_ALUMINIUM = 50, MATERIAL_GLASS = 10)
	volume = 20
	flags = OPENCONTAINER

/obj/item/reagent_containers/ecig_cartridge/examine(mob/user)//to see how much left
	. = ..()
	to_chat(user, "The cartridge has [reagents.total_volume] units of liquid remaining.")

//flavours
/obj/item/reagent_containers/ecig_cartridge/blank
	name = "ecigarette cartridge"
	desc = "A small metal cartridge which contains an atomizing coil."

/obj/item/reagent_containers/ecig_cartridge/blanknico
	name = "flavorless nicotine cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says you can add whatever flavoring agents you want."
/obj/item/reagent_containers/ecig_cartridge/blanknico/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco/liquid, 5)
	reagents.add_reagent(/decl/reagent/water, 10)

/obj/item/reagent_containers/ecig_cartridge/med_nicotine
	name = "tobacco flavour cartridge"
	desc =  "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored."
/obj/item/reagent_containers/ecig_cartridge/med_nicotine/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco, 5)
	reagents.add_reagent(/decl/reagent/water, 15)

/obj/item/reagent_containers/ecig_cartridge/high_nicotine
	name = "high nicotine tobacco flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored, with extra nicotine."
/obj/item/reagent_containers/ecig_cartridge/high_nicotine/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco, 10)
	reagents.add_reagent(/decl/reagent/water, 10)

/obj/item/reagent_containers/ecig_cartridge/orange
	name = "orange flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its orange flavored."
/obj/item/reagent_containers/ecig_cartridge/orange/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco/liquid, 5)
	reagents.add_reagent(/decl/reagent/water, 10)
	reagents.add_reagent(/decl/reagent/drink/orangejuice, 5)

/obj/item/reagent_containers/ecig_cartridge/watermelon
	name = "watermelon flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its watermelon flavored."
/obj/item/reagent_containers/ecig_cartridge/watermelon/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco/liquid, 5)
	reagents.add_reagent(/decl/reagent/water, 10)
	reagents.add_reagent(/decl/reagent/drink/watermelonjuice, 5)

/obj/item/reagent_containers/ecig_cartridge/grape
	name = "grape flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its grape flavored."
/obj/item/reagent_containers/ecig_cartridge/grape/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco/liquid, 5)
	reagents.add_reagent(/decl/reagent/water, 10)
	reagents.add_reagent(/decl/reagent/drink/grapejuice, 5)

/obj/item/reagent_containers/ecig_cartridge/lemonlime
	name = "lemon-lime flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its lemon-lime flavored."
/obj/item/reagent_containers/ecig_cartridge/lemonlime/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco/liquid, 5)
	reagents.add_reagent(/decl/reagent/water, 10)
	reagents.add_reagent(/decl/reagent/drink/lemon_lime, 5)

/obj/item/reagent_containers/ecig_cartridge/coffee
	name = "coffee flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its coffee flavored."
/obj/item/reagent_containers/ecig_cartridge/coffee/New()
	..()
	reagents.add_reagent(/decl/reagent/toxin/tobacco/liquid, 5)
	reagents.add_reagent(/decl/reagent/water, 10)
	reagents.add_reagent(/decl/reagent/drink/coffee, 5)