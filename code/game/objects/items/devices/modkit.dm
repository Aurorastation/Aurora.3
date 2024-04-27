#define MODKIT_HELMET 1
#define MODKIT_SUIT 2
#define MODKIT_RIG 3
#define MODKIT_FULL 6

/obj/item/device/modkit
	name = "voidsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a voidsuit for another user."
	icon_state = "modkit"
	var/parts = MODKIT_FULL
	var/target_species = BODYTYPE_HUMAN
	var/is_multi_species = FALSE //can this modkit change things for multiple species?

	var/list/permitted_types = list(
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void,
		/obj/item/rig_assembly
		)

/obj/item/device/modkit/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return

	if (!target_species && !is_multi_species)
		return	//it shouldn't be null, okay?

	if(!parts)
		to_chat(user, SPAN_WARNING("This kit has no parts for this modification left!"))
		user.drop_from_inventory(src,O)
		qdel(src)
		return

	var/allowed = 0
	for (var/permitted_type in permitted_types)
		if(istype(O, permitted_type))
			allowed = 1

	var/obj/item/clothing/I = O
	if (!istype(I) || !allowed || !I.refittable)
		to_chat(user, SPAN_NOTICE("\The [src] is unable to modify that."))
		return

	if(is_multi_species)
		target_species = tgui_input_list(user, "Select Species To Refit", "Voidsuit Modkit", I.refittable_species)
		if(!target_species)
			return
	var/excluding = ("exclude" in I.species_restricted)
	var/in_list = (target_species in I.species_restricted)
	if (excluding ^ in_list)
		to_chat(user, SPAN_NOTICE("\The [I] is already modified!"))
		return

	if(!isturf(O.loc))
		to_chat(user, SPAN_WARNING("\The [O] must be safely placed on the ground for modification."))
		return

	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	user.visible_message(
		SPAN_NOTICE("\The [user] opens \the [src] and modifies \the [O]."),
		SPAN_NOTICE("You open \the [src] and modify \the [O].")
	)

	if(I.contained_sprite)
		I.refit_contained(target_species)
	else
		I.refit_for_species(target_species)

	if (istype(I, /obj/item/clothing/head/helmet))
		parts &= ~MODKIT_HELMET
	if (istype(I, /obj/item/clothing/suit))
		parts &= ~MODKIT_SUIT
	if (istype(I, /obj/item/rig))
		parts &= ~MODKIT_RIG

	if(!parts)
		user.drop_from_inventory(src,O)
		qdel(src)

/obj/item/device/modkit/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "It looks as though it modifies voidsuits to fit [is_multi_species ? "users of multiple species" : "[target_species] users"]."

/obj/item/device/modkit/tajaran
	name = "tajaran voidsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a voidsuit for another user. This one looks like it's meant for tajara."
	target_species = BODYTYPE_TAJARA

/obj/item/device/modkit/unathi
	name = "unathi voidsuit modification kit"
	target_species = BODYTYPE_UNATHI

/obj/item/device/modkit/skrell
	name = "skrell voidsuit modification kit"
	target_species = BODYTYPE_SKRELL

/obj/item/device/modkit/ipc
	name = "ipc voidsuit modification kit"
	target_species = BODYTYPE_IPC

/obj/item/device/modkit/multi_species
	name = "multi-species voidsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a voidsuit for another user. This one looks like it's meant for a wide range of alien species."
	is_multi_species = TRUE

/obj/item/voidsuit_modkit
	name = "voidsuit kit"
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"
	desc = "A simple cardboard box containing the requisition forms, permits, and decal kits for a Himean voidsuit."
	desc_info = "In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	var/list/suit_options = list(
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/suit/space/void/mining/himeo,
		/obj/item/clothing/head/helmet/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining/himeo,

		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/suit/space/void/engineering/himeo,
		/obj/item/clothing/head/helmet/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering/himeo,

		/obj/item/clothing/suit/space/void/atmos = /obj/item/clothing/suit/space/void/atmos/himeo,
		/obj/item/clothing/head/helmet/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos/himeo,

		/obj/item/rig_assembly/industrial = /obj/item/rig_assembly/industrial/himeo

	)
	var/parts = MODKIT_FULL

/obj/item/voidsuit_modkit/afterattack(obj/item/W as obj, mob/user as mob, proximity)
	if(!proximity)
		return

	if(!parts)
		to_chat(user, "<span class='warning'>This kit has no parts for this modification left.</span>")
		user.drop_from_inventory(src,W)
		qdel(src)
		return

	var/reconverting = FALSE
	var/voidsuit_product = suit_options[W.type]
	if(!voidsuit_product)
		for(var/thing in suit_options)
			if(suit_options[thing] == W.type)
				voidsuit_product = thing
				reconverting = TRUE
				break
	if(voidsuit_product)
		if(istype(W, /obj/item/clothing/suit/space/void) && W.contents.len)
			to_chat(user, SPAN_NOTICE("Remove any accessories, helmets, magboots, or oxygen tanks before attempting to convert this voidsuit."))
			return

		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		var/obj/item/P = new voidsuit_product(get_turf(W))

		if(!reconverting)
			to_chat(user, SPAN_NOTICE("Your permit for [P] has been processed. Enjoy!"))
		else
			to_chat(user, SPAN_NOTICE("Your voidsuit part has been reconverted into [P]."))

		if (istype(W, /obj/item/clothing/head/helmet))
			parts &= ~MODKIT_HELMET
		if (istype(W, /obj/item/clothing/suit))
			parts &= ~MODKIT_SUIT
		if (istype(W, /obj/item/rig_assembly/industrial/himeo))
			parts &= ~MODKIT_RIG

		qdel(W)

		if(!parts)
			user.drop_from_inventory(src)
			qdel(src)

/obj/item/voidsuit_modkit/himeo
	name = "himeo voidsuit kit"
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "himeo_kit"
	item_state = "himeo_kit"
	desc = "A simple cardboard box containing the requisition forms, permits, and decal kits for a Himean voidsuit."
	desc_extended = "Despite the vast amounts of supplementary paperwork involved, the Stellar Corporate Conglomerate continues to import specialty industrialwear through an Orion Express subsidiary to \
	boost morale among Himean staff. With success in the previous Type-76 'Fish Fur' program, the Chainlink has also authorized a number of Type-86 'Cicada' industrial hardsuits for use \
	on a number of installations, such as the Horizon."
	desc_info = "In order to convert a voidsuit, simply click on voidsuit or helmet with this item. The same process can be used to convert the voidsuit back into a regular voidsuit, or \
	to turn an industrial hardsuit assembly into a Himeo variant. Make sure not to have a helmet or tank in the suit, or else it will be deleted."


/obj/item/voidsuit_modkit/himeo/tajara
	name = "tajaran himeo voidsuit kit"
	desc = "A simple cardboard box containing the requisition forms, permits, and decal kits for a Himean voidsuit fitted for Tajara."
	suit_options = list(
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/suit/space/void/mining/himeo/tajara,
		/obj/item/clothing/head/helmet/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining/himeo/tajara,

		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/suit/space/void/engineering/himeo/tajara,
		/obj/item/clothing/head/helmet/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering/himeo/tajara,

		/obj/item/clothing/suit/space/void/atmos = /obj/item/clothing/suit/space/void/atmos/himeo/tajara,
		/obj/item/clothing/head/helmet/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos/himeo/tajara,

		/obj/item/rig_assembly/industrial = /obj/item/rig_assembly/industrial/himeo
	)

/obj/item/voidsuit_modkit/dominianvoid
	name = "dominian voidsman's voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Dominian prejoroub combat suit into its voidsman counterpart. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/dominia = /obj/item/clothing/head/helmet/space/void/dominia/voidsman,
		/obj/item/clothing/suit/space/void/dominia = /obj/item/clothing/suit/space/void/dominia/voidsman
	)

/obj/item/storage/box/dominianvoid
	name = "dominian voidsman's modkit box"
	desc = "Contains modkits to convert Dominian voidsuits into a voidsman's variant."
	starts_with = list(/obj/item/voidsuit_modkit/dominianvoid = 4)

/obj/item/storage/box/species_modkit
	name = "multi-species modkit box"
	desc = "Contains modkits to convert a voidsuit to a wide range of available species."
	starts_with = list(/obj/item/device/modkit/multi_species = 4)

/obj/item/storage/box/unathi_modkit
	name = "multi-species modkit box"
	desc = "Contains modkits to convert a voidsuit for an Unathi wearer."
	starts_with = list(/obj/item/device/modkit/unathi = 4)

/obj/item/storage/box/ipc_modkit
	name = "ipc modkit box"
	desc = "Contains modkits to convert a voidsuit for an IPC wearer."
	starts_with = list(/obj/item/device/modkit/ipc = 4)

/obj/item/voidsuit_modkit_multi //for converting between a large range of options instead of having 5000 subtypes
	name = "voidsuit kit"
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"
	desc = "A simple cardboard box designed to modify a voidsuit to a selection of alternate options."
	desc_info = "In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	var/list/suit_options = list()
	var/list/helmet_options = list()
	var/list/rig_options = list()
	var/parts = MODKIT_FULL

/obj/item/voidsuit_modkit_multi/afterattack(obj/item/W as obj, mob/user as mob, proximity)
	if(!proximity)
		return

	if(!parts)
		to_chat(user, "<span class='warning'>This kit has no parts for this modification left.</span>")
		user.drop_from_inventory(src,W)
		qdel(src)
		return

	if(!(W.type in list_values(suit_options)) && !(W.type in list_values(helmet_options)) && !(W.type in list_values(rig_options)))
		return

	var/voidsuit_product
	if(istype(W, /obj/item/clothing/suit/space/void))
		var/suit_choice = tgui_input_list(user, "Select a suit modification:", "Voidsuit Modkit", suit_options)
		voidsuit_product = suit_options[suit_choice]
	else if(istype(W, /obj/item/clothing/head/helmet/space/void))
		var/helmet_choice = tgui_input_list(user, "Select a helmet modification:", "Voidsuit Modkit", helmet_options)
		voidsuit_product = helmet_options[helmet_choice]
	else if(istype(W, /obj/item/rig))
		var/rig_choice = tgui_input_list(user, "Select a hardsuit modification:", "Voidsuit Modkit", rig_options)
		voidsuit_product = rig_options[rig_choice]
	if(voidsuit_product)
		if(istype(W, /obj/item/clothing/suit/space/void) && W.contents.len)
			to_chat(user, SPAN_NOTICE("Remove any accessories, helmets, magboots, or oxygen tanks before attempting to convert this voidsuit."))
			return
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		var/obj/item/P = new voidsuit_product(get_turf(W))
		to_chat(user, SPAN_NOTICE("Your voidsuit part has been reconverted into [P]."))

		if(istype(W, /obj/item/clothing/head/helmet))
			parts &= ~MODKIT_HELMET
		if(istype(W, /obj/item/clothing/suit))
			parts &= ~MODKIT_SUIT
		if(istype(W, /obj/item/rig))
			parts &= ~MODKIT_RIG

		qdel(W)

		if(!parts)
			user.drop_from_inventory(src)
			qdel(src)

/obj/item/voidsuit_modkit_multi/sol_warlord
	name = "solarian warlord modkit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	suit_options = list(
		"Solarian Armed Forces" = /obj/item/clothing/suit/space/void/sol,
		"Free Solarian Fleets" = /obj/item/clothing/suit/space/void/sol/fsf,
		"League of Corporate-Free Systems" = /obj/item/clothing/suit/space/void/sol/league,
		"Middle Ring Shield Pact" = /obj/item/clothing/suit/space/void/sol/mrsp,
		"Southern Fleet Administration" = /obj/item/clothing/suit/space/void/sol/sfa,
		"Solarian Provisional Government" = /obj/item/clothing/suit/space/void/sol/spg,
		"Solarian Restoration Front" = /obj/item/clothing/suit/space/void/sol/srf,
		"Southern Solarian Military District" = /obj/item/clothing/suit/space/void/sol/ssmd
	)
	helmet_options = list(
		"Solarian Armed Forces" = /obj/item/clothing/head/helmet/space/void/sol,
		"Free Solarian Fleets" = /obj/item/clothing/head/helmet/space/void/sol/fsf,
		"League of Corporate-Free Systems" = /obj/item/clothing/head/helmet/space/void/sol/league,
		"Middle Ring Shield Pact" = /obj/item/clothing/head/helmet/space/void/sol/mrsp,
		"Southern Fleet Administration" = /obj/item/clothing/head/helmet/space/void/sol/sfa,
		"Solarian Provisional Government" = /obj/item/clothing/head/helmet/space/void/sol/spg,
		"Solarian Restoration Front" = /obj/item/clothing/head/helmet/space/void/sol/srf,
		"Southern Solarian Military District" = /obj/item/clothing/head/helmet/space/void/sol/ssmd
	)

/obj/item/voidsuit_modkit_multi/unathi_pirate
	name = "unathi pirate modkit"
	desc = "A highly complicated device that allows you to convert an Unathi pirate suit into another fleet's counterpart. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		"Izharshan's Raiders" = /obj/item/clothing/suit/space/void/unathi_pirate,
		"Hiskyn's Revanchists" = /obj/item/clothing/suit/space/void/unathi_pirate/hiskyn,
		"Kazu's Techraiders" = /obj/item/clothing/suit/space/void/unathi_pirate/kazu,
		"Tarwa Conglomerate" = /obj/item/clothing/suit/space/void/unathi_pirate/tarwa
	)
	helmet_options = list(
		"Izharshan's Raiders" = /obj/item/clothing/head/helmet/space/void/unathi_pirate,
		"Hiskyn's Revanchists" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn,
		"Kazu's Techraiders" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/kazu,
		"Tarwa Conglomerate" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa
	)

/obj/item/voidsuit_modkit_multi/unathi_pirate/captain
	name = "unathi pirate captain modkit"
	suit_options = list(
		"Izharshan's Raiders" = /obj/item/clothing/suit/space/void/unathi_pirate/captain,
		"Hiskyn's Revanchists" = /obj/item/clothing/suit/space/void/unathi_pirate/hiskyn/captain,
		"Kazu's Techraiders" = /obj/item/clothing/suit/space/void/unathi_pirate/kazu/captain,
		"Tarwa Conglomerate" = /obj/item/clothing/suit/space/void/unathi_pirate/tarwa/captain
	)
	helmet_options = list(
		"Izharshan's Raiders" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/captain,
		"Hiskyn's Revanchists" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn/captain,
		"Kazu's Techraiders" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/kazu/captain,
		"Tarwa Conglomerate" = /obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa/captain
	)

/obj/item/voidsuit_modkit_multi/nanotrasen
	name = "\improper NanoTrasen hardsuit modkit"
	desc = "A highly complicated device that allows you to convert a NanoTrasen hardsuit into its corporate auxiliary or Nexus Security variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on a hardsuit with this item \
	The same process can be used to convert the hardsuit back into a regular hardsuit. Make sure not to have any modules in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	rig_options = list(
		"NanoTrasen Hardsuit" = /obj/item/rig/nanotrasen,
		"Corporate Auxiliary Hardsuit" = /obj/item/rig/nanotrasen/corporate_auxiliary,
		"Nexus Security Hardsuit" = /obj/item/rig/nanotrasen/nexus
	)

/obj/item/voidsuit_modkit_multi/coalition
	name = "coalition of colonies voidsuit modkit"
	suit_options = list(
		"Coalition Vulture" = /obj/item/clothing/suit/space/void/coalition,
		"Xanan Eagle" = /obj/item/clothing/suit/space/void/coalition/xanu,
		"Gadpathurian Vulture-GP" = /obj/item/clothing/suit/space/void/coalition/gadpathur,
		"Himean Buzzard" = /obj/item/clothing/suit/space/void/coalition/himeo,
		"Galatean Jackdaw" = /obj/item/clothing/suit/space/void/coalition/galatea,
		"Assunzionii Rook" = /obj/item/clothing/suit/space/void/coalition/assunzione
	)
	helmet_options = list(
		"Coalition Vulture" = /obj/item/clothing/head/helmet/space/void/coalition,
		"Xanan Eagle" = /obj/item/clothing/head/helmet/space/void/coalition/xanu,
		"Gadpathurian Vulture-GP" = /obj/item/clothing/head/helmet/space/void/coalition/gadpathur,
		"Himean Buzzard" = /obj/item/clothing/head/helmet/space/void/coalition/himeo,
		"Galatean Jackdaw" = /obj/item/clothing/head/helmet/space/void/coalition/galatea,
		"Assunzionii Rook" = /obj/item/clothing/head/helmet/space/void/coalition/assunzione
	)

/obj/item/storage/box/unathi_pirate
	name = "unathi pirate modkit box"
	desc = "Contains modkits to convert Unathi pirate voidsuits into fleet variants."
	starts_with = list(/obj/item/voidsuit_modkit_multi/unathi_pirate = 4)

/obj/item/storage/box/sol_warlord
	name = "solarian warlord modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into warlord variants."
	starts_with = list(/obj/item/voidsuit_modkit_multi/sol_warlord = 4)

/obj/item/storage/box/nanotrasen_hardsuit
	name = "nanotrasen modkit box"
	desc = "Contains modkits to convert NanoTrasen hardsuits into alternate variants."
	starts_with = list(/obj/item/voidsuit_modkit_multi/nanotrasen = 4)

/obj/item/storage/box/coalition
	name = "coalition of colonies modkit box"
	desc = "Contains modkits to convert Coalition voidsuits into member-state variants."
	starts_with = list(/obj/item/voidsuit_modkit_multi/coalition = 4)

#undef MODKIT_HELMET
#undef MODKIT_SUIT
#undef MODKIT_RIG
#undef MODKIT_FULL
