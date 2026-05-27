ABSTRACT_TYPE(/obj/item/package)
	name = "package"
	icon = 'icons/obj/package.dmi'
	contained_sprite = TRUE
	update_icon_on_init = TRUE
	has_accents = TRUE
	w_class = WEIGHT_CLASS_HUGE
	force = 15
	slowdown = 0.5

/obj/item/package/proc/wield(var/mob/living/carbon/human/user)
	var/obj/A = user.get_inactive_hand()
	if(A)
		to_chat(user, SPAN_WARNING("Your other hand is occupied!"))
		return
	item_state += "_wielded"
	var/obj/item/offhand/O = new(user)
	O.name = "[initial(name)] - offhand"
	O.desc = "Your second grip on \the [initial(name)]."
	user.put_in_inactive_hand(O)

/obj/item/package/dropped(mob/user)
	..()
	item_state = initial(item_state)
	if(user)
		var/obj/item/offhand/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()

/obj/item/package/can_swap_hands(var/mob/user)
	var/obj/item/offhand/O = user.get_inactive_hand()
	if(istype(O))
		return FALSE
	return TRUE

/obj/item/package/too_heavy_to_throw()
	return TRUE

/obj/item/package/do_additional_pickup_checks(var/mob/living/carbon/human/user)
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
			slowdown = 1
		else
			slowdown = 0

		user.update_equipment_speed_mods()

		return TRUE
	return FALSE

/obj/item/package/delivery
	name = "cargo package"
	desc = "\
		An Orion Express cargo package. \
		Always pays an extra 2% tip to the courier.\
	"
	desc_extended = "\
		This package makes use of the small-scale shipping network of Orion Express. \
		It is a common sight all over the Spur, where Orion Express services depend on ordinary people and ships picking up and delivering packages for each other, \
		with Orion Express only delivering to automated stations and other distribution points."
	icon_state = "express_package"
	item_state = "express_package"

	var/delivery_point_id = ""
	var/datum/weakref/delivery_point_sector
	/// Site name displayed to player when examining the package. This should clearly state where the player should go, and be lore accurate. This is typically overridden by either sectorname or one set by receptacle
	var/delivery_site = "Unknown"
	var/delivery_point_coordinates = ""

	var/datum/weakref/associated_delivery_point
	var/pay_amount = 69420

	/// If true, pay_amount goes into Operations Account
	var/pays_horizon_account = TRUE

/obj/item/package/delivery/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can deliver this package to a cargo delivery point."
	. += "An additional 2% is added to your account on delivery, or paid to you directly. Can be loaded into a cargo pack."

/obj/item/package/delivery/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(delivery_point_id)
		// if name not already set by cargo receptacle, acquire the sector name instead
		if(delivery_site == "Unknown")
			if(delivery_point_sector)
				var/obj/effect/overmap/visitable/delivery_sector = delivery_point_sector.resolve()
				if(delivery_sector)
					delivery_site = delivery_sector.name
		. += SPAN_NOTICE("The label on the package reads: SITE: <b>[delivery_site]</b> | COORD: <b>[delivery_point_coordinates]</b> | ID: <b>[delivery_point_id]</b>")
		. += SPAN_NOTICE("The price tag on the package reads: <b>[pay_amount]电</b>.")

/obj/item/package/delivery/Initialize(mapload, obj/structure/cargo_receptacle/delivery_point)
	. = ..()
	pay_amount = rand(4, 7) * 100
	if(prob(3))
		pay_amount = rand(12, 17) * 100
	if(delivery_point)
		setup_delivery_point(delivery_point)
	accent_color = pick(COLOR_RED, COLOR_AMBER, COLOR_PINK, COLOR_YELLOW, COLOR_LIME)

/obj/item/package/delivery/proc/setup_delivery_point(var/obj/structure/cargo_receptacle/delivery_point)
	associated_delivery_point = WEAKREF(delivery_point)
	delivery_point_id = delivery_point.delivery_id
	delivery_point_sector = delivery_point.delivery_sector
	if(delivery_point.override_name)
		delivery_site = delivery_point.override_name
	delivery_point_coordinates = "[delivery_point.x]-[delivery_point.y]"
	pay_amount = pay_amount * delivery_point.payment_modifier

/obj/item/package/delivery/offship
	pays_horizon_account = FALSE
	/// Whether this package is guaranteed to deliver to the horizon or not
	var/horizon_delivery = FALSE

/obj/item/package/delivery/offship/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!delivery_point_id)
		. += SPAN_NOTICE("Delivery site still being calculated, please check back later!")

/obj/item/package/delivery/offship/Initialize(mapload, obj/structure/cargo_receptacle/delivery_point)
	. = ..()

	if(!delivery_point)
		// add a timer before we pick the delivery point, in case any ships or ruins still need to load
		addtimer(CALLBACK(src, PROC_REF(get_delivery_point)), 3 MINUTES)

/obj/item/package/delivery/offship/proc/get_delivery_point()
	var/obj/structure/cargo_receptacle/selected_delivery_point = get_cargo_package_delivery_point(src, horizon_delivery)
	if(!selected_delivery_point)
		qdel(src)
		return
	setup_delivery_point(selected_delivery_point)

/obj/item/package/delivery/offship/to_horizon
	horizon_delivery = TRUE

// Persistent supply packages. These are meant to be spawned by admins and feature no mechanics like the orion deliveries.
/obj/item/package/persistent_supply
	name = "supply package"
	desc = "A supply package. Doesn't qualify for deliveries."
	desc_extended = "\
		Usually each package contains a different set of things one might need as supplies. \
		Unlike the Orion deliveries, these packages are not tied to a specific delivery network and are not eligible for deliveries. \
		Probably more expensive then it should be."
	icon_state = "supply_package"
	item_state = "supply_package"
	persistant_objects_expiration_time_days = 360

/obj/item/package/persistent_supply/Initialize()
	. = ..()
	SSpersistence.objectsRegisterTrack(src)

/obj/item/package/persistent_supply/persistent_objects_get_content()
	return list()

/obj/item/package/persistent_supply/persistent_objects_apply_content(content, x, y, z)
	src.x = x
	src.y = y
	src.z = z

/obj/item/package/persistent_supply/Destroy()
	log_and_message_admins("Persistent supply package at [src] was destroyed!", null, get_turf(src))
	. = ..()
