/obj/item/cargo_backpack
	name = "cargo pack"
	desc = "A robust set of rigs and buckles that allows the wearer to carry two additional Orion Express delivery packages on their back."
	icon = 'icons/obj/orion_delivery.dmi'
	icon_state = "package_pack"
	item_state = "package_pack"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = SLOT_BACK
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	var/list/contained_packages

/obj/item/cargo_backpack/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "To load packages onto your back, equip this item on the back slot, then click on it with a package in-hand."
	. += "To unload a package, click on this item with an empty hand."

/obj/item/cargo_backpack/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(length(contained_packages))
		. += SPAN_NOTICE("\[?\] There are some packages loaded. <a href='byond://?src=[REF(src)];show_package_data=1>\[Show Package Data\]</a>")

/obj/item/cargo_backpack/Destroy()
	QDEL_LIST(contained_packages)
	return ..()

/obj/item/cargo_backpack/Topic(href, href_list)
	if(href_list["show_package_data"])
		ui_interact(usr)
	return ..()

/obj/item/cargo_backpack/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CargoPack", "Cargo Pack", 500, 115)
		ui.open()

/obj/item/cargo_backpack/ui_data(mob/user)
	var/list/data = list()

	data["cargo_pack_details"] = list()
	for(var/obj/item/cargo_package/package in contained_packages)
		var/delivery_site = "Unknown"
		if(package.delivery_point_sector)
			var/obj/effect/overmap/visitable/delivery_sector = package.delivery_point_sector.resolve()
			if(delivery_sector)
				delivery_site = delivery_sector.name
		data["cargo_pack_details"] += list(list("package_id"= REF(package), "delivery_point_sector" = delivery_site, "delivery_point_coordinates" = package.delivery_point_coordinates, "delivery_point_id" = package.delivery_point_id))

	return data

/obj/item/cargo_backpack/proc/update_state(mob/user)
	if(LAZYLEN(contained_packages))
		slowdown = 1
	else
		slowdown = 0
	update_icon()
	user.update_equipment_speed_mods()

/obj/item/cargo_backpack/update_icon()
	if(LAZYLEN(contained_packages))
		item_state = "[initial(item_state)]_[length(contained_packages)]"
	else
		item_state = initial(item_state)
	if(ishuman(loc))
		var/mob/living/carbon/human/courier = loc
		courier.update_inv_back()

/obj/item/cargo_backpack/get_mob_overlay(mob/living/carbon/human/courier, var/mob_icon, var/mob_state, var/slot, var/main_call = TRUE)
	var/image/mob_overlay = ..()
	if(main_call)
		var/image/north_overlay = get_mob_overlay(courier, mob_icon, mob_state + "_over", slot, FALSE)
		north_overlay.layer = courier.layer + 0.01 // we want the tall backpack to render over hair and helmets
		north_overlay.appearance_flags |= KEEP_APART
		mob_overlay.AddOverlays(north_overlay)
	return add_color_tag_to_overlay(mob_overlay)

/obj/item/cargo_backpack/proc/add_color_tag_to_overlay(var/image/mob_overlay)
	if(!mob_overlay)
		return

	for(var/package_index = 1 to length(contained_packages))
		var/obj/item/cargo_package/package = contained_packages[package_index]
		var/image/package_tag = image(icon, icon_state = "package_pack_[package_index]_tag")
		package_tag.color = package.accent_color
		mob_overlay.AddOverlays(package_tag)
		package_index++

	return mob_overlay

/obj/item/cargo_backpack/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return ..()
	if(!LAZYLEN(contained_packages))
		return ..()

	if(user.species.mob_size < 12)
		var/obj/A = user.get_inactive_hand()
		if(A)
			to_chat(user, SPAN_WARNING("Your other hand is occupied!"))
			return

	user.visible_message("<b>[user]</b> starts unloading a package from \the [src]...", SPAN_NOTICE("You start unloading a package from \the [src]..."))
	if(do_after(user, 1 SECONDS, src, DO_UNIQUE))
		if(user.species.mob_size < 12)
			var/obj/A = user.get_inactive_hand()
			if(A)
				to_chat(user, SPAN_WARNING("Your other hand is occupied!"))
				return
		user.visible_message("<b>[user]</b> unloads a package from \the [src]!", SPAN_NOTICE("You unload a package from \the [src]!"))
		var/obj/item/cargo_package/package = contained_packages[1]
		user.put_in_hands(package)
		if(user.species.mob_size < 12)
			package.wield(user)
		LAZYREMOVE(contained_packages, package)
		update_state(user)

/obj/item/cargo_backpack/attackby(obj/item/attacking_item, mob/user)
	if(!ishuman(user))
		return ..()
	if(user.back != src)
		if(istype(attacking_item, /obj/item/cargo_package))
			to_chat(user, SPAN_WARNING("Put \the [src] on your back before you load packages onto it!"))
			return
		return ..()
	if(!istype(attacking_item, /obj/item/cargo_package))
		return ..()

	if(LAZYLEN(contained_packages) >= 2)
		to_chat(user, SPAN_WARNING("\The [src] is already fully loaded!"))
		return

	user.visible_message("<b>[user]</b> starts loading \the [attacking_item] onto \the [src]...", SPAN_NOTICE("You start loading \the [attacking_item] onto \the [src]..."))
	if(do_after(user, 1 SECONDS, src, DO_UNIQUE))
		user.visible_message("<b>[user]</b> loads \the [attacking_item] onto \the [src]!", SPAN_NOTICE("You load \the [attacking_item] onto \the [src]!"))
		user.drop_from_inventory(attacking_item, src)
		LAZYADD(contained_packages, attacking_item)
		update_state(user)
