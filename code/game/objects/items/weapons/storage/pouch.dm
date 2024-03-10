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


/obj/item/storage/pouch/equipped(mob/user, slot)
	if(slot == slot_l_store || slot == slot_r_store)
		mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
	..()

/obj/item/storage/pouch/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()


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


///Pistol pouch.
/obj/item/storage/pouch/pistol
	name = "sidearm pouch"
	desc = "You could carry a pistol in this; more importantly, you could draw it quickly. Useful for emergencies."
	icon_state = "pistol"
	use_sound = null
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun)

	flap = FALSE

	///Display code pulled from belt.dm gun belt. Can shave quite a lot off because this pouch can only hold one item at a time.
	var/obj/item/gun/current_gun //The gun it holds, used for referencing later so we can update the icon.
	var/image/gun_underlay //The underlay we will use.
	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	var/icon_x = 0
	var/icon_y = -3

/obj/item/storage/pouch/pistol/Destroy()
	gun_underlay = null
	current_gun = null
	. = ..()

/obj/item/storage/pouch/pistol/on_stored_atom_del(atom/movable/AM)
	if(AM == current_gun)
		current_gun = null
		update_gun_icon()

/obj/item/storage/pouch/pistol/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE) //A little more detailed than just 'the pouch is full'.
	. = ..()
	if(!.)
		return
	if(current_gun && isgun(W))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src] already holds a gun."))
		return FALSE

/obj/item/storage/pouch/pistol/handle_item_insertion(obj/item/I, prevent_warning = 0, mob/user)
	if(isgun(I))
		current_gun = I
		update_gun_icon()
	..()

/obj/item/storage/pouch/pistol/remove_from_storage(obj/item/I, atom/new_location)
	if(I == current_gun)
		current_gun = null
		update_gun_icon()
	..()

/obj/item/storage/pouch/pistol/proc/update_gun_icon()
	// if(current_gun)
	// 	playsound(src, drawSound, 15, TRUE)
	// 	gun_underlay = image('icons/obj/items/clothing/belts.dmi', current_gun.base_gun_icon)
	// 	gun_underlay.pixel_x = icon_x
	// 	gun_underlay.pixel_y = icon_y
	// 	gun_underlay.color = current_gun.color
	// 	underlays += gun_underlay
	// else
	// 	playsound(src, sheatheSound, 15, TRUE)
	// 	underlays -= gun_underlay
	// 	gun_underlay = null

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
		/obj/item/explosive/plastic,
		/obj/item/explosive/mine,
		/obj/item/explosive/grenade
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
		/obj/item/stack/sheet,
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
		/obj/item/device/demo_scanner,
		/obj/item/device/reagent_scanner,
		/obj/item/device/assembly,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/explosive/plastic,
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

/obj/item/storage/pouch/sling
	name = "sling strap"
	desc = "Keeps a single item attached to a strap."
	storage_slots = 1
	max_w_class = ITEMSIZE_NORMAL
	icon_state = "sling"

	var/sling_range = 2
	var/obj/item/slung

/obj/item/storage/pouch/sling/get_examine_text(mob/user)
	. = ..()
	if(slung && slung.loc != src)
		. += "\The [slung] is attached to the sling."

/obj/item/storage/pouch/sling/can_be_inserted(obj/item/I, mob/user, stop_messages = FALSE)
	if(slung)
		if(slung != I)
			if(!stop_messages)
				to_chat(usr, SPAN_WARNING("\the [slung] is already attached to the sling."))
			return FALSE
	else if(SEND_SIGNAL(I, COMSIG_DROP_RETRIEVAL_CHECK) & COMPONENT_DROP_RETRIEVAL_PRESENT)
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[I] is already attached to another sling."))
		return FALSE
	return ..()

/obj/item/storage/pouch/sling/handle_item_insertion(obj/item/I, prevent_warning = FALSE, mob/user)
	if(!slung)
		slung = I
		slung.AddElement(/datum/element/drop_retrieval/pouch_sling, src)
		if(!prevent_warning)
			to_chat(user, SPAN_NOTICE("You attach the sling to [I]."))
	..()

/obj/item/storage/pouch/sling/attack_self(mob/user)
	if(slung)
		to_chat(user, SPAN_NOTICE("You retract the sling from [slung]."))
		unsling()
		return
	return ..()

/obj/item/storage/pouch/sling/proc/unsling()
	if(!slung)
		return
	slung.RemoveElement(/datum/element/drop_retrieval/pouch_sling, src)
	slung = null

/obj/item/storage/pouch/sling/proc/sling_return(mob/living/carbon/human/user)
	if(!slung || !slung.loc)
		return FALSE
	if(slung.loc == user)
		return TRUE
	if(!isturf(slung.loc))
		return FALSE
	if(get_dist(slung, src) > sling_range)
		return FALSE
	if(handle_item_insertion(slung))
		if(user)
			to_chat(user, SPAN_NOTICE("[slung] snaps back into [src]."))
		return TRUE

/obj/item/storage/pouch/sling/proc/attempt_retrieval(mob/living/carbon/human/user)
	if(sling_return(user))
		return
	unsling()
	if(user && src.loc == user)
		to_chat(user, SPAN_WARNING("The sling of your [src] snaps back empty!"))

/obj/item/storage/pouch/sling/proc/handle_retrieval(mob/living/carbon/human/user)
	if(slung && slung.loc == src)
		return
	addtimer(CALLBACK(src, PROC_REF(attempt_retrieval), user), 0.3 SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
