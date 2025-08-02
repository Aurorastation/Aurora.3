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

/obj/item/storage/pill_bottle/heroin
	name = "bottle of heroin pills"
	desc = "Highly illegal drug. For quick pain removal."
	starts_with = list(/obj/item/reagent_containers/pill/heroin = 3)

/obj/item/storage/pill_bottle/cocaine
	name = "bottle of cocaine tablets"
	desc = "Supposedly a highly illegal drug... yet the labeling on the bottle is suspiciously perfect..."
	starts_with = list(/obj/item/reagent_containers/pill/cocaine = 5)

/obj/item/storage/pill_bottle/contemplus
	name = "bottle of Contemplus tablets"
	desc = "A Yomi Genetics bottle clearly marked as 'for animal testing only.' You doubt this is followed often on Venus..."
	starts_with = list(/obj/item/reagent_containers/pill/contemplus = 5)

/obj/item/storage/pill_bottle/spotlight
	name = "bottle of Spotlight tablets"
	desc = "A Zavodskoi bottle with a conspicuous 'defective' stamp on it. You doubt this was actually defective."
	starts_with = list(/obj/item/reagent_containers/pill/spotlight = 5)

/obj/item/storage/pill_bottle/sparkle
	name = "bottle of Sparkle tablets"
	desc = "A Zeng-Hu bottle clearly marked as being for 'medical testing purposes only.' As if..."
	starts_with = list(/obj/item/reagent_containers/pill/sparkle = 5)

/obj/item/storage/pill_bottle/smart
	name = "bottle of Smart pills"
	desc = "Highly illegal drug. For exam season."
	starts_with = list(/obj/item/reagent_containers/pill/skrell_nootropic = 7)

/obj/item/reagent_containers/glass/beaker/vial/random
	atom_flags = 0
	var/list/random_reagent_list = list(list(/singleton/reagent/water = 15) = 1, list(/singleton/reagent/spacecleaner = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list(/singleton/reagent/drugs/mindbreaker = 10, /singleton/reagent/drugs/mms = 20)	= 3,
		list(/singleton/reagent/mercury = 15)										= 3,
		list(/singleton/reagent/toxin/carpotoxin = 15)								= 2,
		list(/singleton/reagent/drugs/impedrezene = 15)									= 2,
		list(/singleton/reagent/toxin/dextrotoxin = 10)								= 1,
		list(/singleton/reagent/toxin/spectrocybin = 15)								= 1,
		list(/singleton/reagent/drugs/joy = 10, /singleton/reagent/water = 20)					= 1,
		list(/singleton/reagent/toxin/berserk = 10)                                  = 1,
		list(/singleton/reagent/ammonia = 15)										= 3)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER

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
	atom_flags = 0

/obj/item/reagent_containers/glass/beaker/vial/venenum/Initialize()
	. = ..()
	if(is_open_container())
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	reagents.add_reagent(/singleton/reagent/venenum,volume)
	desc = "Contains venenum."
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/nerveworm_eggs
	atom_flags = 0

/obj/item/reagent_containers/glass/beaker/vial/nerveworm_eggs/Initialize()
	. = ..()
	if(is_open_container())
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	reagents.add_reagent(/singleton/reagent/toxin/nerveworm_eggs, 2)
	desc = "<b>BIOHAZARDOUS! - Nerve Fluke eggs.</b> Purchased from <i>SciSupply Eridani</i>, recently incorporated into <i>Zeng-Hu Pharmaceuticals' Keiretsu</i>!"
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/heartworm_eggs
	atom_flags = 0

/obj/item/reagent_containers/glass/beaker/vial/heartworm_eggs/Initialize()
	. = ..()
	if(is_open_container())
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
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
	w_class = WEIGHT_CLASS_TINY
	volume = 50

/obj/item/reagent_containers/powder/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(reagents)
		. += SPAN_NOTICE("There's about <b>[reagents.total_volume] unit\s</b> here.")

/obj/item/reagent_containers/powder/Initialize()
	. = ..()
	get_appearance()

/obj/item/reagent_containers/powder/proc/get_appearance()
	/// Color based on dominant reagent.
	color = reagents.get_color()

// Proc to shove them up your nose

/obj/item/reagent_containers/powder/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper/cig) || attacking_item.type == /obj/item/spacecash)
		var/mob/living/carbon/human/H = user
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(!H.check_has_mouth())
			to_chat(user, SPAN_WARNING("You cannot seem to snort \the [src]."))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] starts to snort some of \the [src] with \a [attacking_item]!"),
			SPAN_NOTICE("You start to snort some of \the [src] with \the [attacking_item]!")
		)
		playsound(loc, 'sound/effects/snort.ogg', 50, 1)
		if (!do_after(user, 2 SECONDS))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] snorts some of \the [src] with \a [attacking_item]!"),
			SPAN_NOTICE("You snort \the [src] with \the [attacking_item]!")
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
