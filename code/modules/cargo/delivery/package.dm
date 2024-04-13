/obj/item/cargo_package
	name = "cargo package"
	desc = "An Orion Express cargo package, these packages generally find their way to researchers bunkered up on exoplanets. Always pays an extra 2% tip to the courier."
	desc_info = "You can deliver this package to a delivery site on an exoplanet to get additional funds for the cargo department's account. An additional 2% is added to your account on delivery. Can be loaded into a cargo pack."
	icon = 'icons/obj/orion_delivery.dmi'
	icon_state = "express_package"
	item_state = "express_package"
	contained_sprite = TRUE
	w_class = ITEMSIZE_HUGE
	force = 15

	slowdown = 1

	var/delivery_point_id = ""
	var/datum/weakref/delivery_point_sector
	/// Site name displayed to player when examining the package. This should clearly state where the player should go, and be lore accurate. This is typically overridden by either sectorname or one set by receptacle
	var/delivery_site = "Unknown"
	var/delivery_point_coordinates = ""

	var/datum/weakref/associated_delivery_point
	var/pay_amount = 69420

	/// If true, pay_amount goes into Operations Account
	var/pays_horizon_account = TRUE

/obj/item/cargo_package/Initialize(mapload, obj/structure/cargo_receptacle/delivery_point)
	. = ..()
	pay_amount = rand(4, 7) * 1000
	if(prob(3))
		pay_amount = rand(12, 17) * 1000
	if(delivery_point)
		setup_delivery_point(delivery_point)
	color = pick("#FFFFFF", "#EEEEEE", "#DDDDDD", "#CCCCCC", "#BBBBBB", "#FFDDDD", "#DDDDFF", "#FFFFDD", "#886600")

/obj/item/cargo_package/proc/setup_delivery_point(var/obj/structure/cargo_receptacle/delivery_point)
	associated_delivery_point = WEAKREF(delivery_point)
	delivery_point_id = delivery_point.delivery_id
	delivery_point_sector = delivery_point.delivery_sector
	if(delivery_point.override_name)
		delivery_site = delivery_point.override_name
	delivery_point_coordinates = "[delivery_point.x]-[delivery_point.y]"
	pay_amount = pay_amount * delivery_point.payment_modifier

/obj/item/cargo_package/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(delivery_point_id)
		// if name not already set by cargo receptacle, acquire the sector name instead
		if(delivery_site == "Unknown")
			if(delivery_point_sector)
				var/obj/effect/overmap/visitable/delivery_sector = delivery_point_sector.resolve()
				if(delivery_sector)
					delivery_site = delivery_sector.name
		. += SPAN_NOTICE("The label on the package reads: SITE: <b>[delivery_site]</b> | COORD: <b>[delivery_point_coordinates]</b> | ID: <b>[delivery_point_id]</b>")
		. += SPAN_NOTICE("The price tag on the package reads: <b>[pay_amount]电</b>.")

/obj/item/cargo_package/do_additional_pickup_checks(var/mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE

	if(user.species.mob_size < 12)
		var/obj/A = user.get_inactive_hand()
		if(A)
			to_chat(user, SPAN_WARNING("Your other hand is occupied!"))
			return

	user.visible_message("<b>[user]</b> tightens their grip on \the [src] and starts heaving...", SPAN_NOTICE("You tighten your grip on \the [src] and start heaving..."))
	if(do_after(user, 1 SECONDS, src, DO_UNIQUE))
		user.visible_message("<b>[user]</b> heaves \the [src] up!", SPAN_NOTICE("You heave \the [src] up!"))
		// larger mobs, such as industrials, can hold two pieces of cargo
		if(user.species.mob_size < 12)
			wield(user)
			slowdown = 2
		else
			slowdown = 0
		return TRUE
	return FALSE

/obj/item/cargo_package/proc/wield(var/mob/living/carbon/human/user)
	var/obj/A = user.get_inactive_hand()
	if(A)
		to_chat(user, SPAN_WARNING("Your other hand is occupied!"))
		return
	item_state += "_wielded"
	var/obj/item/offhand/O = new(user)
	O.name = "[initial(name)] - offhand"
	O.desc = "Your second grip on \the [initial(name)]."
	user.put_in_inactive_hand(O)

/obj/item/cargo_package/dropped(mob/user)
	..()
	item_state = initial(item_state)
	if(user)
		var/obj/item/offhand/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()

/obj/item/cargo_package/can_swap_hands(var/mob/user)
	var/obj/item/offhand/O = user.get_inactive_hand()
	if(istype(O))
		return FALSE
	return TRUE

/obj/item/cargo_package/too_heavy_to_throw()
	return TRUE


/obj/item/cargo_package/offship
	pays_horizon_account = FALSE
	/// Whether this package is guaranteed to deliver to the horizon or not
	var/horizon_delivery = FALSE

/obj/item/cargo_package/offship/Initialize(mapload, obj/structure/cargo_receptacle/delivery_point)
	. = ..()

	if(!delivery_point)
		// add a timer before we pick the delivery point, in case any ships or ruins still need to load
		addtimer(CALLBACK(src, PROC_REF(get_delivery_point)), 3 MINUTES)

/obj/item/cargo_package/offship/proc/get_delivery_point()
	var/obj/effect/overmap/visitable/ship/horizon = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/sccv_horizon)

	var/turf/current_turf = get_turf(src)

	var/list/eligible_delivery_points = list()
	for(var/obj/structure/cargo_receptacle/delivery_point in all_cargo_receptacles)
		var/obj/effect/overmap/visitable/my_sector = GLOB.map_sectors["[current_turf.z]"]
		var/obj/effect/overmap/visitable/delivery_point_sector = GLOB.map_sectors["[delivery_point.z]"]
		// no delivering to ourselves
		if(my_sector == delivery_point_sector)
			continue
		// guaranteed horizon, has to go to horizon
		if(horizon_delivery && delivery_point_sector.name != horizon.name)
			continue
		eligible_delivery_points += delivery_point

	if(!length(eligible_delivery_points))
		qdel(src)
		return

	var/obj/structure/cargo_receptacle/selected_delivery_point = pick(eligible_delivery_points)
	setup_delivery_point(selected_delivery_point)

/obj/item/cargo_package/offship/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!delivery_point_id)
		. += SPAN_NOTICE("Delivery site still being calculated, please check back later!")

/obj/item/cargo_package/offship/to_horizon
	horizon_delivery = TRUE
