/obj/item/clothing/mask/chewable
	name = "chewable item master"
	desc = "If you are seeing this, ahelp it."
	icon = 'icons/obj/clothing/masks.dmi'
	drop_sound = 'sound/items/drop/food.ogg'
	body_parts_covered = 0

	var/type_butt = null
	var/chem_volume = 0
	var/chewtime = 0
	var/brand
	var/list/filling = list()
	var/wrapped = FALSE

/obj/item/clothing/mask/chewable/attack_self(mob/user)
	if(wrapped)
		wrapped = FALSE
		to_chat(user, span("notice", "You unwrap \the [name]."))
		playsound(src.loc, 'sound/items/drop/wrapper.ogg', 50, 1)
		slot_flags = SLOT_EARS | SLOT_MASK
		update_icon()

/obj/item/clothing/mask/chewable/update_icon()
	cut_overlays()
	if(wrapped)
		var/mutable_appearance/base_overlay = mutable_appearance(icon, "[initial(icon_state)]_wrapper")
		base_overlay.appearance_flags = RESET_COLOR
		add_overlay(base_overlay)

obj/item/clothing/mask/chewable/Initialize()
	. = ..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	for(var/R in filling)
		reagents.add_reagent(R, filling[R])
	if(wrapped)
		slot_flags = null
		update_icon()

/obj/item/clothing/mask/chewable/equipped(var/mob/living/user, var/slot)
	..()
	if(slot == slot_wear_mask)
		var/mob/living/carbon/human/C = user
		if(C.check_has_mouth())
			START_PROCESSING(SSprocessing, src)
		else
			to_chat(user, span("notice", "You don't have a mouth, and can't make much use of \the [src]."))

/obj/item/clothing/mask/chewable/dropped()
	STOP_PROCESSING(SSprocessing, src)
	..()

obj/item/clothing/mask/chewable/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/chewable/proc/chew()
	chewtime--
	if(reagents && reagents.total_volume)
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth())
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2)
		else
			STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/chewable/process()
	chew()
	if(chewtime < 1)
		spitout()

/obj/item/clothing/mask/chewable/tobacco
	name = "wad"
	desc = "A chewy wad of tobacco. Cut in long strands and treated with syrup so it doesn't taste like an ash-tray when you stuff it into your face."
	throw_speed = 0.5
	icon_state = "chew"
	type_butt = /obj/item/trash/spitwad
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	chem_volume = 50
	chewtime = 300
	brand = "tobacco"

/obj/item/trash/spitwad
	name = "spit wad"
	desc = "A disgusting spitwad."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "spit-chew"

/obj/item/clothing/mask/chewable/proc/spitout(var/mob/user, var/no_message)
	STOP_PROCESSING(SSprocessing, src)
	if (type_butt)
		var/obj/item/butt = new type_butt(get_turf(src))
		transfer_fingerprints_to(butt)
		butt.color = color
		if(brand)
			butt.desc += " This one is \a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if (!no_message)
				to_chat(M, span("notice", "You spit out the [name]."))
		qdel(src)

/obj/item/clothing/mask/chewable/tobacco/bad
	name = "chewing tobacco"
	desc = "A chewy wad of cheap tobacco. Cut in long strands and treated with syrup so it tastes less like an ash-tray when you stuff it into your face."
	filling = list("tobaccobad" = 2)

/obj/item/clothing/mask/chewable/tobacco/generic
	name = "chewing tobacco"
	desc = "A chewy wad of tobacco. Cut in long strands and treated with syrup so it doesn't taste like an ash-tray when you stuff it into your face."
	filling = list("tobacco" = 2)

/obj/item/clothing/mask/chewable/tobacco/fine
	name = "chewing tobacco"
	desc = "A chewy wad of fine tobacco. Cut in long strands and treated with syrup so it doesn't taste like an ash-tray when you stuff it into your face."
	filling = list("tobaccofine" = 2)

/obj/item/clothing/mask/chewable/tobacco/nico
	name = "nicotine gum"
	desc = "A chewy wad of synthetic rubber, laced with nicotine. Possibly the least disgusting method of nicotine delivery."
	filling = list("nicotine" = 2)
	icon_state = "nic_gum"
	type_butt = /obj/item/trash/spitgum
	wrapped = TRUE

/obj/item/clothing/mask/chewable/candy
	name = "wad"
	desc = "A chewy wad of wadding material."
	throw_speed = 0.5
	icon_state = "chew"
	type_butt = /obj/item/trash/spitgum
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	chem_volume = 50
	chewtime = 300
	filling = list("sugar" = 2)

/obj/item/trash/spitgum
	name = "old gum"
	desc = "A disgusting chewed up wad of gum."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "spit-gum"

/obj/item/clothing/mask/chewable/candy/gum
	name = "chewing gum"
	desc = "A chewy wad of fine synthetic rubber and artificial flavoring."
	icon_state = "gum"
	item_state = "gum"
	wrapped = TRUE

/obj/item/clothing/mask/chewable/candy/gum/Initialize()
	. = ..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),10)
	color = reagents.get_color()
	update_icon()

/obj/item/storage/box/gum
	name = "\improper Chewy Fruit flavored gum"
	desc = "A small pack of chewing gum in various flavors."
	icon = 'icons/obj/food.dmi'
	icon_state = "gum_pack"
	item_state = "candy"
	slot_flags = SLOT_EARS
	w_class = 1
	starts_with = list(/obj/item/clothing/mask/chewable/candy/gum = 5)
	can_hold = list(/obj/item/clothing/mask/chewable/candy/gum,
					/obj/item/trash/spitgum)
	use_sound = 'sound/items/drop/paper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	max_storage_space = 5
	foldable = null

/obj/item/clothing/mask/chewable/candy/lolli
	name = "lollipop"
	desc = "A simple artificially flavored sphere of sugar on a handle. Colloquially known as a sucker. Allegedly one is born every minute."
	type_butt = /obj/item/trash/lollibutt
	icon_state = "lollipop"
	item_state = "lollipop"
	wrapped = TRUE

/obj/item/trash/lollibutt
	name = "popsicle stick"
	desc = "A popsicle stick devoid of pop."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "lollipop_stick"

/obj/item/clothing/mask/chewable/candy/lolli/update_icon()
	cut_overlays()
	var/mutable_appearance/base_overlay = mutable_appearance(icon, "[initial(icon_state)]_stick")
	base_overlay.appearance_flags = RESET_COLOR
	add_overlay(base_overlay)
	if(wrapped)
		add_overlay("[initial(icon_state)]_wrapper")

/obj/item/clothing/mask/chewable/candy/lolli/Initialize()
	. = ..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),20)
	color = reagents.get_color()
	update_icon()

/obj/item/clothing/mask/chewable/candy/lolli/meds
	name = "lollipop"
	desc = "A sucrose sphere on a small handle, it has been infused with medication."
	type_butt = /obj/item/trash/lollibutt
	icon_state = "lollipop"

/obj/item/clothing/mask/chewable/candy/lolli/meds/Initialize()
	. = ..()
	var/datum/reagent/payload = pick(list(
				"paracetamol",
				"tramadol",
				"dylovene"))
	reagents.add_reagent(payload, 15)
	color = reagents.get_color()
	desc = "[desc] This one is labeled '[initial(payload.name)]'."

/obj/item/clothing/mask/chewable/candy/lolli/weak_meds
	name = "medicine lollipop"
	desc = "A sucrose sphere on a small handle, it has been infused with medication."
	filling = list("sugar" = 6)

/obj/item/clothing/mask/chewable/candy/lolli/weak_meds/Initialize()
	. = ..()
	var/datum/reagent/payload = pick(list(
				"dylovene",
				"norepinephrine"))
	reagents.add_reagent(payload, 15)
	color = reagents.get_color()
	desc = "[desc] This one is labeled '[initial(payload.name)]'."
