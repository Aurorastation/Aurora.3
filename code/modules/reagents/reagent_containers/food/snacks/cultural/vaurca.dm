
/obj/item/reagent_containers/food/snacks/friedkois
	name = "fried k'ois"
	desc = "K'ois, freshly bathed in the radiation of a microwave."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "friedkois"
	filling_color = "#E6E600"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/kois = 6, /singleton/reagent/toxin/phoron = 9)

/obj/item/reagent_containers/food/snacks/friedkois/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/rods))
		new /obj/item/reagent_containers/food/snacks/koiskebab1(src)
		to_chat(user, "You skewer the fried k'ois.")
		qdel(src)
		qdel(W)
	if(istype(W,/obj/item/material/kitchen/rollingpin))
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

/obj/item/reagent_containers/food/snacks/koiskebab1/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/friedkois))
		new /obj/item/reagent_containers/food/snacks/koiskebab2(src)
		to_chat(user, "You add fried K'ois to the kebab.")
		qdel(src)
		qdel(W)

/obj/item/reagent_containers/food/snacks/koiskebab2
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It looks like you could fit more."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "koisbab2"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 6
	reagents_to_add = list(/singleton/reagent/kois = 12, /singleton/reagent/toxin/phoron = 16)

/obj/item/reagent_containers/food/snacks/koiskebab2/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/friedkois))
		new /obj/item/reagent_containers/food/snacks/koiskebab3(src)
		to_chat(user, "You add fried K'ois to the kebab.")
		qdel(src)
		qdel(W)

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
	filling_color = "#dcd9cd"
	reagents_to_add = list(/singleton/reagent/kois = 20, /singleton/reagent/toxin/phoron = 15)
	bitesize = 7

/obj/item/reagent_containers/food/snacks/donut/kois
	name = "k'ois donut"
	desc = "Deep fried k'ois shaped into a donut."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_donut"
	item_state = "kois_donut"
	filling_color = "#dcd9cd"
	overlay_state = "box-kois_donut"
	reagents_to_add = list(/singleton/reagent/kois = 15, /singleton/reagent/toxin/phoron = 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koismuffin
	name = "k'ois muffin"
	desc = "Baked k'ois goop, molded into a little cake."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_muffin"
	filling_color = "#dcd9cd"
	reagents_to_add = list(/singleton/reagent/kois = 10, /singleton/reagent/toxin/phoron = 15)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koisburger
	name = "k'ois burger"
	desc = "K'ois inside k'ois. Peak Vaurcesian cuisine."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "kois_burger"
	filling_color = "#dcd9cd"
	reagents_to_add = list(/singleton/reagent/kois = 20, /singleton/reagent/toxin/phoron = 20)
	bitesize = 8

/obj/item/storage/box/fancy/vkrexitaffy
	name = "V'krexi Snax"
	desc = "A packet of V'krexi taffy. Made from free-range V'krexi!"
	desc_extended = "V'krexi, while edible, hold no nutritional value, either for humans or Vaurca. The V'krexi meat was mostly neglected until human food-processing techniques were introduced to the Zo'ra Hive."
	icon = 'icons/obj/item/reagent_containers/food/cultural/vaurca.dmi'
	icon_state = "vkrexitaffy"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_food.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_food.dmi',
		)
	item_state = "vkrexi"
	icon_type = "vkrexi taffy"
	storage_type = "packaging"
	starts_with = list(/obj/item/reagent_containers/food/snacks/vkrexitaffy = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/vkrexitaffy)
	max_storage_space = 6

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
