//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	starts_with = list(/obj/item/reagent_containers/pill/happy = 7)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	starts_with = list(/obj/item/reagent_containers/pill/zoom = 7)

/obj/item/storage/pill_bottle/joy
	name = "bottle of Joy pills"
	desc = "Highly illegal drug. Bang - and your stress is gone."
	starts_with = list(/obj/item/reagent_containers/pill/joy = 3)

/obj/item/storage/pill_bottle/smart
	name = "bottle of Smart pills"
	desc = "Highly illegal drug. For exam season."
	starts_with = list(/obj/item/reagent_containers/pill/skrell_nootropic = 7)

/obj/item/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list(/singleton/reagent/water = 15) = 1, list(/singleton/reagent/spacecleaner = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list(/singleton/reagent/mindbreaker = 10, /singleton/reagent/space_drugs = 20)	= 3,
		list(/singleton/reagent/mercury = 15)										= 3,
		list(/singleton/reagent/toxin/carpotoxin = 15)								= 2,
		list(/singleton/reagent/impedrezene = 15)									= 2,
		list(/singleton/reagent/toxin/dextrotoxin = 10)								= 1,
		list(/singleton/reagent/toxin/spectrocybin = 15)								= 1,
		list(/singleton/reagent/joy = 10, /singleton/reagent/water = 20)					= 1,
		list(/singleton/reagent/toxin/berserk = 10)                                  = 1,
		list(/singleton/reagent/ammonia = 15)										= 3)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/_R in reagents.reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()


/obj/item/reagent_containers/glass/beaker/vial/venenum
	flags = 0

/obj/item/reagent_containers/glass/beaker/vial/venenum/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER
	reagents.add_reagent(/singleton/reagent/venenum,volume)
	desc = "Contains venenum."
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/nerveworm_eggs
	flags = 0

/obj/item/reagent_containers/glass/beaker/vial/nerveworm_eggs/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER
	reagents.add_reagent(/singleton/reagent/toxin/nerveworm_eggs, 2)
	desc = "<b>BIOHAZARDOUS! - Nerve Fluke eggs.</b> Purchased from <i>SciSupply Eridani</i>, recently incorporated into <i>Zeng-Hu Pharmaceuticals' Keiretsu</i>!"
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/heartworm_eggs
	flags = 0

/obj/item/reagent_containers/glass/beaker/vial/heartworm_eggs/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER
	reagents.add_reagent(/singleton/reagent/toxin/heartworm_eggs, 2)
	desc = "<b>BIOHAZARDOUS! - Heart Fluke eggs.</b> Purchased from <i>SciSupply Eridani</i>, recently incorporated into <i>Zeng-Hu Pharmaceuticals' Keiretsu</i>!"
	update_icon()

/obj/item/reagent_containers/powder
	name = "chemical powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	item_state = "powder"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = 5
	w_class = ITEMSIZE_TINY
	volume = 50

/obj/item/reagent_containers/powder/examine(mob/user)
	. = ..()
	if(reagents)
		to_chat(user, SPAN_NOTICE("There's about [reagents.total_volume] unit\s here."))

/obj/item/reagent_containers/powder/Initialize()
	. = ..()
	get_appearance()

/obj/item/reagent_containers/powder/proc/get_appearance()
	/// Color based on dominant reagent.
	color = reagents.get_color()

// Proc to shove them up your nose

/obj/item/reagent_containers/powder/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/paper/cig) || istype(W, /obj/item/spacecash))
		var/mob/living/carbon/human/H = user
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return TRUE
		if(!H.check_has_mouth())
			to_chat(user, SPAN_WARNING("You cannot seem to snort \the [src]."))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] starts to snort some of \the [src] with \a [W]!"),
			SPAN_NOTICE("You start to snort some of \the [src] with \the [W]!")
		)
		playsound(loc, 'sound/effects/snort.ogg', 50, 1)
		if (!do_after(user, 2 SECONDS))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] snorts some of \the [src] with \a [W]!"),
			SPAN_NOTICE("You snort \the [src] with \the [W]!")
		)
		playsound(loc, 'sound/effects/snort.ogg', 50, 1)

		if(reagents)
			var/contained = reagentlist()
			var/temp = reagents.get_temperature()
			var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_BREATHE, bypass_checks = TRUE)
			admin_inject_log(user, H, src, contained, temp, trans)
		if(!reagents.total_volume)
			qdel(src)
		return TRUE
	return ..()
