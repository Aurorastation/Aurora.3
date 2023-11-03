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

	var/list/permitted_types = list(
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void,
		/obj/item/rig_assembly
		)

/obj/item/device/modkit/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return

	if (!target_species)
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

/obj/item/device/modkit/examine(mob/user)
	. = ..()
	to_chat(user, "It looks as though it modifies voidsuits to fit [target_species] users.")

/obj/item/device/modkit/tajaran
	name = "tajaran voidsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a voidsuit for another user. This one looks like it's meant for tajara."
	target_species = BODYTYPE_TAJARA

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

/obj/item/voidsuit_modkit/srf
	name = "srf voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/srf,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/srf
	)

/obj/item/voidsuit_modkit/league
	name = "league voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/league,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/league
	)

/obj/item/voidsuit_modkit/fsf
	name = "fsf voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/fsf,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/fsf
	)

/obj/item/voidsuit_modkit/ssmd
	name = "ssmd voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/ssmd,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/ssmd
	)

/obj/item/voidsuit_modkit/spg
	name = "spg voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/spg,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/spg
	)

/obj/item/voidsuit_modkit/mrsp
	name = "mrsp voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/mrsp,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/mrsp
	)

/obj/item/voidsuit_modkit/sfa
	name = "sfa voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/sfa,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/sfa
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

/obj/item/voidsuit_modkit/tarwa
	name = "tarwa conglomerate voidsuit kit"
	desc = "A highly complicated device that allows you to convert an Unathi pirate suit into its Tarwa Conglomerate counterpart. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/unathi_pirate = /obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa,
		/obj/item/clothing/suit/space/void/unathi_pirate = /obj/item/clothing/suit/space/void/unathi_pirate/tarwa,
		/obj/item/clothing/head/helmet/space/void/unathi_pirate/captain = /obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa/captain,
		/obj/item/clothing/suit/space/void/unathi_pirate/captain = /obj/item/clothing/suit/space/void/unathi_pirate/tarwa/captain
	)

/obj/item/voidsuit_modkit/kazu
	name = "kazu's techraiders voidsuit kit"
	desc = "A highly complicated device that allows you to convert an Unathi pirate suit into its Techraider counterpart. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/unathi_pirate = /obj/item/clothing/head/helmet/space/void/unathi_pirate/kazu,
		/obj/item/clothing/suit/space/void/unathi_pirate = /obj/item/clothing/suit/space/void/unathi_pirate/kazu,
		/obj/item/clothing/head/helmet/space/void/unathi_pirate/captain = /obj/item/clothing/head/helmet/space/void/unathi_pirate/kazu/captain,
		/obj/item/clothing/suit/space/void/unathi_pirate/captain = /obj/item/clothing/suit/space/void/unathi_pirate/kazu/captain
	)

/obj/item/voidsuit_modkit/hiskyn
	name = "hiskyn revanchist voidsuit kit"
	desc = "A highly complicated device that allows you to convert an Unathi pirate suit into its Hiskyn Revanchist counterpart. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/unathi_pirate = /obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn,
		/obj/item/clothing/suit/space/void/unathi_pirate = /obj/item/clothing/suit/space/void/unathi_pirate/hiskyn,
		/obj/item/clothing/head/helmet/space/void/unathi_pirate/captain = /obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn/captain,
		/obj/item/clothing/suit/space/void/unathi_pirate/captain = /obj/item/clothing/suit/space/void/unathi_pirate/hiskyn/captain
	)

/obj/item/voidsuit_modkit/heph_unathi
	name = "\improper Hephaestus Industries voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Hephaestus Caiman suit into its Unathi-fitted counterpart and vice versa. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item. \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/hephaestus = /obj/item/clothing/head/helmet/space/void/hephaestus/unathi,
		/obj/item/clothing/suit/space/void/hephaestus = /obj/item/clothing/suit/space/void/hephaestus/unathi,
		/obj/item/clothing/head/helmet/space/void/hephaestus/unathi = /obj/item/clothing/head/helmet/space/void/hephaestus,
		/obj/item/clothing/suit/space/void/hephaestus/unathi = /obj/item/clothing/suit/space/void/hephaestus
	)

/obj/item/voidsuit_modkit/zeng_skrell
	name = "\improper Zeng-Hu Pharmaceuticals voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Zeng-Hu Dragon suit into its Skrell-fitted counterpart and vice versa. Practical!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item. \
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/zenghu = /obj/item/clothing/head/helmet/space/void/zenghu/skrell,
		/obj/item/clothing/suit/space/void/zenghu = /obj/item/clothing/suit/space/void/zenghu/skrell,
		/obj/item/clothing/head/helmet/space/void/zenghu/skrell = /obj/item/clothing/head/helmet/space/void/zenghu,
		/obj/item/clothing/suit/space/void/zenghu/skrell = /obj/item/clothing/suit/space/void/zenghu
	)

/obj/item/voidsuit_modkit/nexus
	name = "\improper Nexus voidsuit kit"
	desc = "A highly complicated device that allows you to convert a NanoTrasen hardsuit into its Nexus variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on a hardsuit with this item \
	The same process can be used to convert the hardsuit back into a regular hardsuit. Make sure not to have any modules in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/rig/nanotrasen = /obj/item/rig/nanotrasen/nexus,
		/obj/item/rig/nanotrasen/nexus = /obj/item/rig/nanotrasen
	)

/obj/item/voidsuit_modkit/nt_auxiliary
	name = "\improper NanoTrasen corporate auxiliary voidsuit kit"
	desc = "A highly complicated device that allows you to convert a NanoTrasen hardsuit into its corporate auxiliary variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on a hardsuit with this item \
	The same process can be used to convert the hardsuit back into a regular hardsuit. Make sure not to have any modules in the suit \
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/rig/nanotrasen = /obj/item/rig/nanotrasen/corporate_auxiliary,
		/obj/item/rig/nanotrasen/corporate_auxiliary = /obj/item/rig/nanotrasen
	)

/obj/item/storage/box/srf
	name = "srf modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/srf = 4)

/obj/item/storage/box/league
	name = "league modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/league = 4)

/obj/item/storage/box/fsf
	name = "fsf modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/fsf = 4)

/obj/item/storage/box/ssmd
	name = "ssmd modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/ssmd = 4)

/obj/item/storage/box/spg
	name = "spg modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/spg = 4)

/obj/item/storage/box/mrsp
	name = "mrsp modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/mrsp = 4)

/obj/item/storage/box/sfa
	name = "sfa modkit box"
	desc = "Contains modkits to convert Solarian voidsuits into a warlord variant."
	starts_with = list(/obj/item/voidsuit_modkit/sfa = 4)

/obj/item/storage/box/dominianvoid
	name = "dominian voidsman's modkit box"
	desc = "Contains modkits to convert Dominian voidsuits into a voidsman's variant."
	starts_with = list(/obj/item/voidsuit_modkit/dominianvoid = 4)

/obj/item/storage/box/tarwa
	name = "tarwa conglomerate modkit box"
	desc = "Contains modkits to convert Unathi pirate voidsuits into a Tarwa Conglomerate variant."
	starts_with = list(/obj/item/voidsuit_modkit/tarwa = 4)

/obj/item/storage/box/kazu
	name = "kazu's techraiders modkit box"
	desc = "Contains modkits to convert Unathi pirate voidsuits into a Techraider variant."
	starts_with = list(/obj/item/voidsuit_modkit/kazu = 4)

/obj/item/storage/box/hiskyn
	name = "hiskyn revanchists modkit box"
	desc = "Contains modkits to convert Unathi pirate voidsuits into a Hiskyn Revanchist variant."
	starts_with = list(/obj/item/voidsuit_modkit/hiskyn = 4)

/obj/item/storage/box/nanotrasen_nexus
	name = "\improper Nexus modkit box"
	desc = "Contains modkits to convert NanoTrasen hardsuits into a Nexus variant."
	starts_with = list(/obj/item/voidsuit_modkit/nexus = 4)

/obj/item/storage/box/nanotrasen_auxiliary
	name = "\improper NanoTrasen corporate auxiliary modkit box"
	desc = "Contains modkits to convert NanoTrasen hardsuits into an NT corporate auxiliary variant."
	starts_with = list(/obj/item/voidsuit_modkit/nt_auxiliary = 4)


#undef MODKIT_HELMET
#undef MODKIT_SUIT
#undef MODKIT_RIG
#undef MODKIT_FULL
