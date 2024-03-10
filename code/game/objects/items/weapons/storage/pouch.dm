/obj/item/storage/pouch
	name = "abstract pouch"
	desc = "The physical manifestation of a concept of a pouch. Woah."
	icon = 'icons/obj/clothing/pouches.dmi'
	icon_state = "small_drop"
	w_class = ITEMSIZE_LARGE //does not fit in backpack
	max_w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_POCKET
	storage_slots = 1

	/// If it closes a flap over its contents, and therefore update_icon should lift that flap when opened. If it doesn't have _half and _full iconstates, this doesn't matter either way.
	var/flap = TRUE

/obj/item/storage/pouch/update_icon()
	overlays.Cut()

	if(!length(contents))
		return TRUE //For the pistol pouch to know it's empty.

	if(is_seeing && flap) //If it has a flap and someone's looking inside it, don't close the flap.
		return

	if(isnull(storage_slots))//uses weight instead of slots
		var/fullness = 0
		for(var/obj/item/C as anything in contents)
			fullness += C.w_class
		if(fullness <= max_storage_space * 0.5)
			overlays += "+[icon_state]_half"
		else
			overlays += "+[icon_state]_full"
		return

	else if(length(contents) <= storage_slots * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"


/obj/item/storage/pouch/get_examine_text(mob/user)
	. = ..()
	. += "Can be worn by attaching it to a pocket."

/obj/item/storage/pouch/general
	name = "light general pouch"
	desc = "A general-purpose pouch used to carry a small item, or two tiny ones."
	icon_state = "small_drop"

	max_w_class = ITEMSIZE_NORMAL
	cant_hold = list( //Prevent inventory bloat
		/obj/item/storage/firstaid,
		/obj/item/storage/bible,
		/obj/item/storage/box,
	)
	storage_slots = null
	max_storage_space = 2

/obj/item/storage/pouch/general/medium
	name = "medium general pouch"
	desc = "A general-purpose pouch used to carry a variety of differently sized items."
	icon_state = "medium_drop"
	storage_slots = null
	max_storage_space = 4

/obj/item/storage/pouch/general/large
	name = "large general pouch"
	desc = "A general-purpose pouch used to carry more differently sized items."
	icon_state = "large_drop"
	storage_slots = null
	max_storage_space = 6

/obj/item/storage/pouch/firstaid
	name = "first-aid pouch"
	desc = "It contains, by default, autoinjectors. But it may also hold ointments, bandages, and pill bottles."
	icon_state = "firstaid"
	storage_slots = 4
	can_hold = list(
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint,
	)

/obj/item/storage/pouch/firstaid/full
	desc = "Contains a painkiller autoinjector, first-aid autoinjector, some ointment, and some bandages."

/obj/item/storage/pouch/firstaid/full/fill()
	new /obj/item/reagent_containers/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/perconol(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/emergency(src)

/obj/item/storage/pouch/firstaid/full/alternate/fill()
	new /obj/item/reagent_containers/hypospray/autoinjector/tricord(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/bruise_pack(src)

/obj/item/storage/pouch/pistol
	name = "sidearm pouch"
	desc = "You could carry a pistol in this; more importantly, you could draw it quickly. Useful for emergencies."
	icon_state = "pistol"
	use_sound = null
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun)

	flap = FALSE

	/// The gun it holds, used for referencing later so we can update the icon.
	var/obj/item/gun/current_gun

	/// The underlay we will use for the gun
	var/image/gun_underlay

	/// The X offset of the gun overlay
	var/icon_x = 0

	/// The Y offset of the gun overlay
	var/icon_y = -3

/obj/item/storage/pouch/pistol/Destroy()
	gun_underlay = null
	current_gun = null
	return ..()

/obj/item/storage/pouch/pistol/on_stored_atom_del(atom/movable/AM)
	if(AM == current_gun)
		current_gun = null
		update_gun_icon()

/obj/item/storage/pouch/pistol/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE) //A little more detailed than just 'the pouch is full'.
	. = ..()
	if(!.)
		return
	if(isgun(item))
		var/obj/item/gun/pistol = item
		if(!(pistol.slot_flags & SLOT_HOLSTER))
			to_chat(user, SPAN_WARNING("\The [pistol] doesn't fit in \the [src]!"))
			return FALSE
		if(current_gun)
			if(!stop_messages)
				to_chat(usr, SPAN_WARNING("[src] already holds a gun."))
			return FALSE

/obj/item/storage/pouch/pistol/handle_item_insertion(obj/item/item, prevent_warning = 0, mob/user)
	if(isgun(item))
		current_gun = item
		update_gun_icon()
	return ..()

/obj/item/storage/pouch/pistol/remove_from_storage(obj/item/item, atom/new_location)
	if(item == current_gun)
		current_gun = null
		update_gun_icon()
	return ..()

/obj/item/storage/pouch/pistol/proc/update_gun_icon()
	if(current_gun)
		gun_underlay = image(current_gun.icon, current_gun.icon_state)
		gun_underlay.pixel_x = icon_x
		gun_underlay.pixel_y = icon_y
		var/matrix/gun_matrix = matrix()
		gun_matrix.Turn(90)
		gun_underlay.transform = gun_matrix
		gun_underlay.color = current_gun.color
		underlays += gun_underlay
	else
		underlays -= gun_underlay
		gun_underlay = null

//// MAGAZINE POUCHES /////

/obj/item/storage/pouch/magazine
	name = "magazine pouch"
	desc = "It can carry magazines."
	icon_state = "medium_ammo_mag"
	max_w_class = ITEMSIZE_NORMAL
	storage_slots = 3
	can_hold = list(
		/obj/item/ammo_magazine
	)

/obj/item/storage/pouch/magazine/large
	name = "large magazine pouch"
	desc = "It can carry many magazines."
	icon_state = "large_ammo_mag"
	storage_slots = 4

/obj/item/storage/pouch/magazine/pistol
	name = "pistol magazine pouch"
	desc = "It can carry pistol magazines and revolver speedloaders."
	max_w_class = ITEMSIZE_SMALL
	icon_state = "pistol_mag"
	storage_slots = 3

	can_hold = list(
		/obj/item/ammo_magazine
	)

/obj/item/storage/pouch/magazine/pistol/large
	name = "large pistol magazine pouch"
	desc = "It can carry many pistol magazines or revolver speedloaders."
	storage_slots = 6
	icon_state = "large_pistol_mag"

/obj/item/storage/pouch/shotgun
	name = "shotgun shell pouch"
	desc = "It can contain handfuls of shells, or bullets if you choose to for some reason."
	icon_state = "medium_shotshells"
	max_w_class = ITEMSIZE_SMALL
	storage_slots = 5
	can_hold = list(
		/obj/item/ammo_pile
	)
	flap = FALSE

/obj/item/storage/pouch/shotgun/large
	name = "large shotgun shell pouch"
	desc = "It can contain more handfuls of shells, or bullets if you choose to for some reason."
	icon_state = "large_shotshells"
	storage_slots = 7

/obj/item/storage/pouch/explosive
	name = "explosive pouch"
	desc = "It can carry grenades, plastic explosives, mine boxes, and other explosives."
	icon_state = "large_explosive"
	storage_slots = 6
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/plastique,
		/obj/item/landmine,
		/obj/item/grenade
	)

/obj/item/storage/pouch/medical
	name = "medical pouch"
	desc = "It can carry small medical supplies."
	icon_state = "medical"
	storage_slots = 4

	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/reagent_containers/hypospray
	)

/obj/item/storage/pouch/medical/full/fill()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)

/obj/item/storage/pouch/medical/full/pills/fill()
	new /obj/item/storage/pill_bottle/perconol(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/dexalin(src)

/obj/item/storage/pouch/medical/socmed
	name = "tactical medical pouch"
	desc = "A heavy pouch containing everything one needs to get themselves back on their feet. Quite the selection."
	icon_state = "socmed"
	storage_slots = 13
	can_hold = list(
		/obj/item/stack/medical,
		/obj/item/storage/pill_bottle,
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_containers/hypospray
	)

/obj/item/storage/pouch/vials
	name = "vial pouch"
	desc = "A pouch for carrying glass vials."
	icon_state = "vial"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)

/obj/item/storage/pouch/vials/full/fill()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_containers/glass/beaker/vial(src)

/obj/item/storage/pouch/chem
	name = "chemist pouch"
	desc = "A pouch for carrying glass beakers."
	icon_state = "chemist"
	storage_slots = 2
	can_hold = list(
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
	)

/obj/item/storage/pouch/chem/fill()
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/glass/beaker(src)

/obj/item/storage/pouch/autoinjector
	name = "auto-injector pouch"
	desc = "A pouch specifically for auto-injectors."
	icon_state = "injectors"
	storage_slots = 7
	can_hold = list(/obj/item/reagent_containers/hypospray/autoinjector)

/obj/item/storage/pouch/autoinjector/full/fill()
	new /obj/item/reagent_containers/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/perconol(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/perconol(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/emergency(src)

/obj/item/storage/pouch/syringe
	name = "syringe pouch"
	desc = "It can carry syringes."
	icon_state = "syringe"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/syringe)

/obj/item/storage/pouch/syringe/full/fill()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/pouch/document
	name = "large document pouch"
	desc = "It can contain papers, folders, disks, technical manuals, and clipboards."
	icon_state = "document"
	storage_slots = 21
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 21

	can_hold = list(
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/folder
	)

/obj/item/storage/pouch/document/small
	name = "small document pouch"
	desc = "A smaller version of the document pouch. It can contain papers, folders, disks, technical manuals, and clipboards."
	storage_slots = 7

/obj/item/storage/pouch/flare
	name = "flare pouch"
	desc = "A pouch designed to hold flares."
	max_w_class = ITEMSIZE_SMALL
	storage_slots = 16
	max_storage_space = 16

	icon_state = "flare"
	can_hold = list(/obj/item/device/flashlight/flare)

/obj/item/storage/pouch/flare/full/fill()
	for(var/i = 1 to storage_slots)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/pouch/radio
	name = "radio pouch"
	storage_slots = 2
	icon_state = "radio"

	desc = "It can contain two handheld radios."
	can_hold = list(/obj/item/device/radio)


/obj/item/storage/pouch/electronics
	name = "electronics pouch"
	desc = "It is designed to hold most electronics, power cells and circuit boards."
	icon_state = "electronics"
	storage_slots = 6
	can_hold = list(
		/obj/item/circuitboard,
		/obj/item/cell,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/capacitor
	)

/obj/item/storage/pouch/construction
	name = "construction pouch"
	desc = "It's designed to hold construction materials - glass/metal sheets, metal rods, barbed wire, and cable coil. It also has two hooks for an entrenching tool and light replacer."
	storage_slots = 3
	max_w_class = ITEMSIZE_NORMAL
	icon_state = "construction"
	can_hold = list(
		/obj/item/stack/barbed_wire,
		/obj/item/stack/material,
		/obj/item/stack/rods,
		/obj/item/stack/cable_coil,
		/obj/item/stack/tile,
		/obj/item/shovel,
		/obj/item/device/lightreplacer,
	)

/obj/item/storage/pouch/construction/full/fill()
	new /obj/item/stack/material/plasteel(src, 50)
	new /obj/item/stack/material/steel(src, 50)

/obj/item/storage/pouch/construction/full_barbed_wire/fill()
	new /obj/item/stack/material/plasteel(src, 50)
	new /obj/item/stack/material/steel(src, 50)
	new /obj/item/stack/barbed_wire(src, 20)

/obj/item/storage/pouch/construction/low_grade_full/fill()
	new /obj/item/stack/material/plasteel(src, 30)
	new /obj/item/stack/material/steel(src, 50)
	new /obj/item/stack/barbed_wire(src, 15)

/obj/item/storage/pouch/tools
	name = "tools pouch"
	desc = "It's designed to hold maintenance tools - screwdriver, wrench, cable coil, etc. It also has a hook for an entrenching tool or light replacer."
	storage_slots = 4
	max_w_class = ITEMSIZE_NORMAL
	icon_state = "tools"
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/shovel,
		/obj/item/stack/cable_coil,
		/obj/item/cell,
		/obj/item/circuitboard,
		/obj/item/stock_parts,
		/obj/item/device/reagent_scanner,
		/obj/item/device/assembly,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/plastique,
		/obj/item/device/lightreplacer,
	)

/obj/item/storage/pouch/tools/tactical
	name = "tactical tools pouch"
	desc = "This particular toolkit full of sharp, heavy objects was designed for breaking into things rather than fixing them. Still does the latter pretty well, though."
	icon_state = "soctools"
	storage_slots = 8

/obj/item/storage/pouch/tools/full/fill()
	new /obj/item/screwdriver(src)
	new /obj/item/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/wrench(src)
