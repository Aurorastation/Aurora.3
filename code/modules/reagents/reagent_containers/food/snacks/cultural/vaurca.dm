
/obj/item/reagent_containers/food/snacks/friedkois
	name = "fried k'ois"
	desc = "K'ois, freshly bathed in the radiation of a microwave."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "friedkois"
	filling_color = "#E6E600"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/kois = 6, /singleton/reagent/toxin/phoron = 9)

/obj/item/reagent_containers/food/snacks/friedkois/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/rods))
		new /obj/item/reagent_containers/food/snacks/koiskebab1(src)
		to_chat(user, "You skewer the fried k'ois.")
		qdel(src)
		qdel(attacking_item)
	if(istype(attacking_item, /obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/soup/kois(src)
		to_chat(user, "You crush the fried K'ois into a paste, and pour it into a bowl.")
		qdel(src)

/obj/item/reagent_containers/food/snacks/koiskebab1
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It looks like you could fit more."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisbab1"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/kois = 8, /singleton/reagent/toxin/phoron = 12)

/obj/item/reagent_containers/food/snacks/koiskebab1/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/friedkois))
		new /obj/item/reagent_containers/food/snacks/koiskebab2(src)
		to_chat(user, "You add fried K'ois to the kebab.")
		qdel(src)
		qdel(attacking_item)

/obj/item/reagent_containers/food/snacks/koiskebab2
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It looks like you could fit more."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisbab2"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 6
	reagents_to_add = list(/singleton/reagent/kois = 12, /singleton/reagent/toxin/phoron = 16)

/obj/item/reagent_containers/food/snacks/koiskebab2/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item,/obj/item/reagent_containers/food/snacks/friedkois))
		new /obj/item/reagent_containers/food/snacks/koiskebab3(src)
		to_chat(user, "You add fried K'ois to the kebab.")
		qdel(src)
		qdel(attacking_item)

/obj/item/reagent_containers/food/snacks/koiskebab3
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It doesn't look like you can fit anymore."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisbab3"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 9
	reagents_to_add = list(/singleton/reagent/kois = 16, /singleton/reagent/toxin/phoron = 20)

/obj/item/reagent_containers/food/snacks/soup/kois
	name = "k'ois paste"
	desc = "A thick K'ois goop, piled into a bowl."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koissoup"
	filling_color = "#4E6E600"
	bitesize = 6

	reagents_to_add = list(/singleton/reagent/kois = 15, /singleton/reagent/toxin/phoron = 15)

/obj/item/reagent_containers/food/snacks/koiswaffles
	name = "k'ois waffles"
	desc = "Rock-hard 'waffles' composed entirely of microwaved K'ois goop."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koiswaffles"
	trash = /obj/item/trash/waffles
	drop_sound = /singleton/sound_category/tray_hit_sound
	filling_color = "#E6E600"
	bitesize = 8
	reagents_to_add = list(/singleton/reagent/kois = 25, /singleton/reagent/toxin/phoron = 15)

/obj/item/reagent_containers/food/snacks/koisjelly
	name = "k'ois jelly"
	desc = "Enriched K'ois paste, filled to the brim with the good stuff."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisjelly"
	filling_color = "#E6E600"
	bitesize = 10
	reagents_to_add = list(/singleton/reagent/kois = 25, /singleton/reagent/oculine = 20, /singleton/reagent/toxin/phoron = 25)


/obj/item/reagent_containers/food/snacks/koissteak
	name = "k'ois steak"
	desc = "Some well-done k'ois, grilled to perfection."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_steak"
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/kois = 20, /singleton/reagent/toxin/phoron = 15)
	bitesize = 7

/obj/item/reagent_containers/food/snacks/donut/kois
	name = "k'ois donut"
	desc = "Deep fried k'ois shaped into a donut."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_donut"
	item_state = "kois_donut"
	filling_color = "#E6E600"
	overlay_state = "box-kois_donut"
	reagents_to_add = list(/singleton/reagent/kois = 15, /singleton/reagent/toxin/phoron = 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koismuffin
	name = "k'ois muffin"
	desc = "Baked k'ois goop, molded into a little cake."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_muffin"
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/kois = 10, /singleton/reagent/toxin/phoron = 15)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koisburger
	name = "k'ois burger"
	desc = "K'ois inside k'ois. Peak Vaurcesian cuisine."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_burger"
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/kois = 20, /singleton/reagent/toxin/phoron = 20)
	bitesize = 8

/obj/item/reagent_containers/food/snacks/nakarka_burger
	name = "nakarka burger"
	desc = "A k'ois burger with a slice of soft, tangy nakarka cheese."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "nakarka_burger"
	filling_color = "#92cc34"
	bitesize = 8

/obj/item/storage/box/fancy/vkrexitaffy
	name = "V'krexi Snax"
	desc = "A packet of V'krexi taffy. Made from free-range V'krexi!"
	desc_extended = "V'krexi, while edible, hold no nutritional value, either for humans or Vaurca. The V'krexi meat was mostly neglected until human food-processing techniques were introduced to the Zo'ra Hive."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "vkrexitaffy"
	item_state = "vkrexi"
	icon_type = "vkrexi taffy"
	storage_type = "packaging"
	starts_with = list(/obj/item/reagent_containers/food/snacks/vkrexitaffy = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/vkrexitaffy)
	make_exact_fit = TRUE

	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	trash = /obj/item/trash/vkrexitaffy
	closable = FALSE
	icon_overlays = FALSE

/obj/item/reagent_containers/food/snacks/vkrexitaffy
	name = "V'krexi taffy"
	desc = "A delicious V'krexi chewy candy."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "vkrexichewy"
	slot_flags = SLOT_EARS
	filling_color = "#dcd9cd"
	reagents_to_add = list(/singleton/reagent/mental/vkrexi = 0.5)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/phoroncandy
	name = "phoron rock candy"
	desc = "Rock candy popular in Flagsdale. Actually contains phoron."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "rock_candy"
	item_state = "rock_candy"
	filling_color = "#ff22d9"
	reagents_to_add = list(/singleton/reagent/toxin/phoron = 25)
	bitesize = 5
	trash = /obj/item/trash/phoroncandy

/obj/item/reagent_containers/food/snacks/sliceable/koisroulade
	name = "k'ois roulade"
	desc = "Don't worry, there's enough K'ois for everyone!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisroulade"
	trash = /obj/item/trash/plate
	filling_color = "#E6E600"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/kois = 30, /singleton/reagent/toxin/phoron = 20)
	slice_path = /obj/item/reagent_containers/food/snacks/koisrouladeslice
	slices_num = 5
	reagent_data = list(/singleton/reagent/kois = list("k'ois" = 10, "party" = 2))

/obj/item/reagent_containers/food/snacks/koisrouladeslice
	name = "k'ois roulade slice"
	desc = "K'ois, with a twist!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisrouladeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6E600"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koisrouladeslice/filled
	reagents_to_add = list(/singleton/reagent/kois = 6, /singleton/reagent/toxin/phoron = 4)
	reagent_data = list(/singleton/reagent/kois = list("k'ois" = 5, "party" = 2))

/obj/item/reagent_containers/food/snacks/vkrexiwrap/meat
	name = "meat v'krexi wrap"
	desc = "A food invented by Zo'ra Queenless with the intent of appealing to humans, the v'krexi wrap is similar to a burrito but with a special sauce extracted from v'krexi. This one is filled with meat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "vkrexiwrap_meat"
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein = 6, /singleton/reagent/mental/vkrexi = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 8, "bittersweet sauce" = 8), /singleton/reagent/nutriment/protein = list("meat" = 10))

/obj/item/reagent_containers/food/snacks/vkrexiwrap/veggie
	name = "veggie v'krexi wrap"
	desc = "A food invented by Zo'ra Queenless with the intent of appealing to humans, the v'krexi wrap is similar to a burrito but with a special sauce extracted from v'krexi. This one is filled with veggies."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "vkrexiwrap_veggie"
	reagents_to_add = list(/singleton/reagent/nutriment = 9, /singleton/reagent/capsaicin = 4, /singleton/reagent/mental/vkrexi = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("assorted vegetables" = 8, "peppers" = 5, "bittersweet sauce" = 8))

/obj/item/reagent_containers/food/snacks/phoron_river_loaf
	name = "phoron river loaf"
	desc = "A new creation. It is a small baked loaf made of reshaped fried K'ois molded into two mounds, with one river of phoron rock candy running between them, and another one through the center of the loaf. It is carefully baked to give it a mixture of both fluffiness and crunch."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "phoron_river_loaf"
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/kois = 15, /singleton/reagent/toxin/phoron = 35)
	bitesize = 10

/obj/item/reagent_containers/food/snacks/koicomb
	name = "koicomb"
	desc = "vvvell aren't vvve vvvancy? this uncommon confection is often served in large gatherings and events, where it's served as a very large sheet, with guests tearing or slicing off as much as they'd like to have."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koicomb"
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/kois = 20, /singleton/reagent/toxin/phoron = 20, /singleton/reagent/drink/milk/nemiik = 5)
	bitesize = 8

/obj/item/reagent_containers/food/snacks/koicomb/update_icon()
	var/percent_koicomb = round((reagents.total_volume / 45) * 100)
	switch(percent_koicomb)
		if(0 to 50)
			icon_state = "koicomb_bitten"
		if(51 to INFINITY)
			icon_state = "koicomb"
