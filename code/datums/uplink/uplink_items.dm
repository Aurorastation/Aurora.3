GLOBAL_DATUM(uplink, /datum/uplink)

/datum/uplink
	var/list/items_assoc
	var/list/datum/uplink_item/items
	var/list/datum/uplink_category/categories

/datum/uplink/New()
	items_assoc = list()
	items = init_subtypes(/datum/uplink_item)
	categories = init_subtypes(/datum/uplink_category)
	sortTim(categories, GLOBAL_PROC_REF(cmp_uplink_category), FALSE)

	for(var/datum/uplink_item/item in items)
		if(!item.name)
			items -= item
			continue

		items_assoc[item.type] = item

		for(var/datum/uplink_category/category in categories)
			if(item.category == category.type)
				category.items += item

	for(var/datum/uplink_category/category in categories)
		sortTim(category.items, GLOBAL_PROC_REF(cmp_uplink_item), FALSE)

/datum/uplink_item
	var/name
	var/desc
	/// A null telecrystal cost means that this item cannot be bought with bluecrystals.
	var/telecrystal_cost
	/// A null bluecrystal cost means that this item cannot be bought with bluecrystals.
	var/bluecrystal_cost
	/// How many times can this item be bought from an uplink (high limit is not shown in the uplink GUI).
	var/item_limit = 999
	/// Item category.
	var/datum/uplink_category/category
	/// Antag roles this item is displayed to. If empty, display to all.
	var/list/datum/antagonist/antag_roles
	/// Antag job this item is displayed to, if empty, display to all.
	var/list/datum/antagonist/antag_job

/datum/uplink_item/item
	var/path

/datum/uplink_item/proc/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/extra_args = extra_args(user)
	if(!extra_args)
		return

	var/can_buy_telecrystals = can_buy_telecrystals(U)
	var/can_buy_bluecrystals = can_buy_bluecrystals(U)
	if(!can_buy_telecrystals && !can_buy_bluecrystals)
		return

	if(U.CanUseTopic(user, GLOB.inventory_state) != STATUS_INTERACTIVE)
		return

	var/goods = get_goods(U, get_turf(user), user, extra_args)
	if(!goods)
		log_admin("Bought item [name] for [user]'s uplink could not be obtained.")
		return

	var/cost
	if(can_buy_bluecrystals)
		cost = bluecrystal_cost(U.bluecrystals)
		U.bluecrystals -= cost
		U.used_bluecrystals += cost
	else if(can_buy_telecrystals)
		cost = telecrystal_cost(U.telecrystals)
		U.telecrystals -= cost
		U.used_telecrystals += cost

	var/obj/item/implanter/implanter = goods
	if(istype(implanter))
		var/obj/item/implant/uplink/uplink_implant = implanter.imp
		if(istype(uplink_implant))
			var/obj/item/device/uplink/hidden/hidden_uplink = uplink_implant.hidden_uplink
			if(istype(hidden_uplink))
				hidden_uplink.purchase_log = U.purchase_log

	purchase_log(U)
	return goods

// Any additional arguments you wish to send to the get_goods
/datum/uplink_item/proc/extra_args(var/mob/user)
	return 1

/datum/uplink_item/proc/can_buy_telecrystals(obj/item/device/uplink/U)
	if(isnull(telecrystal_cost))
		return FALSE

	if(telecrystal_cost(U.telecrystals) > U.telecrystals)
		return FALSE

	if(items_left(U) <= 0)
		return FALSE

	return can_view(U)

/datum/uplink_item/proc/can_buy_bluecrystals(obj/item/device/uplink/U)
	if(isnull(bluecrystal_cost))
		return FALSE

	if(bluecrystal_cost(U.bluecrystals) > U.bluecrystals)
		return FALSE

	if(items_left(U) <= 0)
		return FALSE

	return can_view(U)

/datum/uplink_item/proc/items_left(obj/item/device/uplink/U)
	return item_limit - U.purchase_log[src]

/datum/uplink_item/proc/can_view(obj/item/device/uplink/U)
	// Making the assumption that if no uplink was supplied, then we don't care about antag roles
	if(!U || (!length(antag_roles) && !antag_job))
		return TRUE

	// With no owner, there's no need to check antag status.
	if(!U.uplink_owner)
		return FALSE

	for(var/antag_role in antag_roles)
		var/datum/antagonist/antag = GLOB.all_antag_types[antag_role]
		if(antag.is_antagonist(U.uplink_owner))
			return TRUE

	if (antag_job == U.uplink_owner.assigned_role) //for a quick and easy list of the assigned_role, look in specialty.dm
		return TRUE
	return FALSE

/datum/uplink_item/proc/telecrystal_cost(var/telecrystals)
	return telecrystal_cost

/datum/uplink_item/proc/bluecrystal_cost(var/bluecrystals)
	return bluecrystal_cost

/datum/uplink_item/proc/description()
	return desc

// get_goods does not necessarily return physical objects, it is simply a way to acquire the uplink item without paying
/datum/uplink_item/proc/get_goods(var/obj/item/device/uplink/U, var/loc)
	return FALSE

/datum/uplink_item/proc/log_icon()
	return

/datum/uplink_item/proc/purchase_log(obj/item/device/uplink/U)
	feedback_add_details("traitor_uplink_items_bought", "[src]")
	log_and_message_admins("used \the [U.loc] to buy \a [src]")
	U.purchase_log[src] = U.purchase_log[src] + 1

/********************************
*                           	*
*	Physical Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/item/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/obj/item/I = ..()
	if(!I)
		return

	if(istype(I, /list))
		var/list/L = I
		if(L.len) I = L[1]

	if(istype(I) && ishuman(user))
		var/mob/living/carbon/human/A = user
		A.put_in_any_hand_if_possible(I)
	return I

/datum/uplink_item/item/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/obj/I = new path(loc)
	return I

/datum/uplink_item/item/description()
	if(!desc)
		// Fallback description
		var/obj/temp = src.path
		desc = initial(temp.desc)
	return ..()

/datum/uplink_item/item/log_icon()
	var/obj/I = path
	return "[icon2html(I, usr)]"

/********************************
*                           	*
*	Abstract Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/abstract
	var/static/image/default_abstract_uplink_icon

/datum/uplink_item/abstract/log_icon()
	if(!default_abstract_uplink_icon)
		default_abstract_uplink_icon = image('icons/obj/pda.dmi', "pda-syn")

	return "[icon2html(default_abstract_uplink_icon, usr)]"

/****************
* Support procs *
****************/
/proc/get_random_uplink_items(var/obj/item/device/uplink/U, var/remaining_TC, var/loc)
	var/list/bought_items = list()
	while(remaining_TC)
		var/datum/uplink_item/I = GLOB.default_uplink_selection.get_random_item(remaining_TC, U, bought_items)
		if(!I)
			break
		bought_items += I
		remaining_TC -= I.telecrystal_cost(remaining_TC)

	return bought_items
