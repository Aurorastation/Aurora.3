#define MODKIT_HELMET 1
#define MODKIT_SUIT 2
#define MODKIT_FULL 3

/obj/item/device/modkit
	name = "voidsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a voidsuit for another user."
	icon_state = "modkit"
	var/parts = MODKIT_FULL
	var/target_species = BODYTYPE_HUMAN

	var/list/permitted_types = list(
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void
		)

/obj/item/device/modkit/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return

	if (!target_species)
		return	//it shouldn't be null, okay?

	if(!parts)
		to_chat(user, "<span class='warning'>This kit has no parts for this modification left.</span>")
		user.drop_from_inventory(src,O)
		qdel(src)
		return

	var/allowed = 0
	for (var/permitted_type in permitted_types)
		if(istype(O, permitted_type))
			allowed = 1

	var/obj/item/clothing/I = O
	if (!istype(I) || !allowed || !I.refittable)
		to_chat(user, "<span class='notice'>[src] is unable to modify that.</span>")
		return

	var/excluding = ("exclude" in I.species_restricted)
	var/in_list = (target_species in I.species_restricted)
	if (excluding ^ in_list)
		to_chat(user, "<span class='notice'>[I] is already modified.</span>")
		return

	if(!isturf(O.loc))
		to_chat(user, "<span class='warning'>[O] must be safely placed on the ground for modification.</span>")
		return

	playsound(user.loc, 'sound/items/screwdriver.ogg', 100, 1)

	user.visible_message("<span class='notice'>\The [user] opens \the [src] and modifies \the [O].</span>","<span class='notice'>You open \the [src] and modify \the [O].</span>")

	I.refit_for_species(target_species)

	if (istype(I, /obj/item/clothing/head/helmet))
		parts &= ~MODKIT_HELMET
	if (istype(I, /obj/item/clothing/suit))
		parts &= ~MODKIT_SUIT

	if(!parts)
		user.drop_from_inventory(src,O)
		qdel(src)

/obj/item/device/modkit/examine(mob/user)
	..(user)
	to_chat(user, "It looks as though it modifies hardsuits to fit [target_species] users.")

/obj/item/device/modkit/tajaran
	name = "tajaran hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a voidsuit for another user. This one looks like it's meant for Tajara."
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
		/obj/item/clothing/head/helmet/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos/himeo
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
	desc_fluff = "As part of a cost-cutting and productivity-enhancing initiative, NanoTrasen has authorized a number of Himean Type-76 'Fish Fur'\
	for use by miners originating from the planet. Most of these suits are assembled in Cannington and painstakingly optimized on-site by their\
	individual operator leading to a large trail of red tape as NanoTrasen is forced to inspect these suits to ensure their safety."

/obj/item/voidsuit_modkit/himeo/tajara
	name = "tajaran himeo voidsuit kit"
	desc = "A simple cardboard box containing the requisition forms, permits, and decal kits for a Himean voidsuit fitted for Tajara."
	desc_fluff = "As part of a cost-cutting and productivity-enhancing initiative, NanoTrasen has authorized a number of Himean Type-76 'Fish Fur'\
	for use by miners and engineers originating from the planet. Most of these suits are assembled in Cannington and painstakingly optimized on-site by their\
	individual operator leading to a large trail of red tape as NanoTrasen is forced to inspect these suits to ensure their safety."
	suit_options = list(
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/suit/space/void/mining/himeo/tajara,
		/obj/item/clothing/head/helmet/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining/himeo/tajara,

		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/suit/space/void/engineering/himeo/tajara,
		/obj/item/clothing/head/helmet/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering/himeo/tajara,

		/obj/item/clothing/suit/space/void/atmos = /obj/item/clothing/suit/space/void/atmos/himeo/tajara,
		/obj/item/clothing/head/helmet/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos/himeo/tajara
	)

/obj/item/voidsuit_modkit/srf
	name = "srf voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
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
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/fsf,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/fsf
	)

/obj/item/voidsuit_modkit/ssmd
	name = "ssmd voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/ssmd,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/ssmd
	)

/obj/item/voidsuit_modkit/spg
	name = "spg voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/spg,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/spg
	)

/obj/item/voidsuit_modkit/mrsp
	name = "mrsp voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/mrsp,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/mrsp
	)

/obj/item/voidsuit_modkit/sfa
	name = "sfa voidsuit kit"
	desc = "A highly complicated device that allows you to convert a Solarian voidsuit into a warlord variant. Wow!"
	desc_info = "This is an OOC item, don't let anyone see it! In order to convert a voidsuit simply click on voidsuit or helmet with this item\
	The same process can be used to convert the voidsuit back into a regular voidsuit. Make sure not to have a helmet or tank in the suit\
	or else it will be deleted."
	w_class = ITEMSIZE_SMALL
	suit_options = list(
		/obj/item/clothing/head/helmet/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol/sfa,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/suit/space/void/sol/sfa
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