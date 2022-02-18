/obj/item/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	use_sound = /decl/sound_category/rustle_sound
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'
	starts_with = list(
		/obj/item/stack/dice = 12,
		/obj/item/stack/dice/d20 = 4
	)

/obj/item/storage/pill_bottle/dice/gaming
	name = "pack of gaming dice"
	desc = "It's a small container with gaming dice inside."
	icon_state = "magicdicebag"
	starts_with = list(
		/obj/item/stack/dice/d4 = 4,
		/obj/item/stack/dice/d8 = 4,
		/obj/item/stack/dice/d10 = 4,
		/obj/item/stack/dice/d12 = 4,
		/obj/item/stack/dice/d100 = 4
	)

/obj/item/storage/card
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder_empty"
	can_hold = list(/obj/item/deck, /obj/item/battle_monsters/deck, /obj/item/hand, /obj/item/pack/, /obj/item/card) //sneaky folks can hide ID and other cards
	storage_slots = 1 //can hold one deck
	use_sound = 'sound/items/drop/shoes.ogg'
	drop_sound = 'sound/items/drop/hat.ogg'

/obj/item/storage/card/update_icon()
	if(contents.len)
		icon_state = "card_holder_items"
	else
		icon_state = "card_holder_empty"
	return

/obj/item/storage/box/pineapple
	icon = 'icons/obj/storage.dmi'
	icon_state = "pineapple_rings"
	name = "can of pineapple rings"
	desc = "An aluminium can with fresh pineapple slices."
	use_sound = 'sound/items/pickup/soda.ogg'
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	starts_with = list(/obj/item/reagent_containers/food/snacks/pineapple_ring = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/pineapple_ring)

/obj/item/storage/box/pineapple/fill()
	. = ..()
	update_icon()

//cigarette papers
/obj/item/storage/box/fancy/cigpaper
	name = "\improper Gen. Eric cigarette paper"
	desc = "A ubiquitous brand of cigarette paper, allegedly endorsed by 24th century war hero General Eric Osmundsun for rolling your own cigarettes. Osmundsun died in a freak kayak accident. As it ate him alive during his last campaign. It was pretty freaky."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigpaperbook_generic"
	item_state = "cigpacket"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	w_class = ITEMSIZE_SMALL
	max_storage_space = 10
	throwforce = 2
	slot_flags = SLOT_BELT
	starts_with = list(/obj/item/paper/cig = 10)
	make_exact_fit()

/obj/item/storage/box/fancy/cigpaper/update_icon()
	. = ..()
	if(contents.len)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_empty"

/obj/item/storage/cigfilters
	name = "box of cigarette filters"
	desc = "A box of generic cigarette filters for those who rolls their own but prefers others to inhale the fumes."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigfilters_generic"
	item_state = "cigpacket"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	w_class = ITEMSIZE_SMALL
	starts_with = list(/obj/item/paper/cig/filter = 10)
	make_exact_fit()
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'

/obj/item/storage/box/fancy/cigpaper/fine
	name = "\improper Trident cigarette paper"
	desc = "A fancy brand of Trident cigarette paper, for rolling your own cigarettes. Like a person who appreciates the finer things in life."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigpaperbook_fine"
	item_state = "Dpacket"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	starts_with = list(/obj/item/paper/cig/fine = 10)

//chewing tobacco
/obj/item/storage/chewables
	name = "box of chewing wads master"
	desc = "A generic brand of Waffle Co Wads, unflavored chews. Why do these exist?"
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'
	use_sound = 'sound/items/storage/pillbottle.ogg'
	w_class = ITEMSIZE_SMALL
	throwforce = 2
	slot_flags = SLOT_BELT
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco = 6)
	make_exact_fit()

/obj/item/storage/chewables/tobacco/bad
	name = "can of Rredouane Cuts chewing tobacco"
	desc = "A cheap, widely used replacement for cigarettes, it provided much needed respite for soldiers in Adhomian wars."
	icon_state = "chew_bad"
	item_state = "Fpacket"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/bad = 6)

/obj/item/storage/chewables/tobacco
	name = "tin of Mendell Smooth chewing tobacco"
	desc = "Packaged and shipped straight from District 8, popularised by the city-slickers of Vega De Rosa."
	icon_state = "chew_generic"
	item_state = "cigpacket"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/generic = 6)
	storage_slots = 6

/obj/item/storage/chewables/tobacco/fine
	name = "tin of Taba-Kamu chewing tobacco"
	desc = "Said to be cultivated by employees of Nojusuru Foods in secret, the strand has been released for the public to enjoy."
	icon_state = "chew_fine"
	item_state = "Dpacket"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/fine = 6)

/obj/item/storage/box/fancy/chewables/tobacco/nico
	name = "box of Nico-Tine gum"
	desc = "A Sol-approved brand of nicotine gum. Cut out the middleman for your addiction fix."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "chew_nico"
	item_state = "Epacket"
	icon_type = "gum stick"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/nico = 6)
	storage_slots = 6
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	use_sound = 'sound/items/storage/box.ogg'

/obj/item/storage/box/fancy/chewables/tobacco/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"

//loose leaf

/obj/item/storage/chewables/rollable
	name = "box of Agyre Lake tobacco leaves"
	desc = "Advertised to be grown using fresh water pumped directly from the titular Martian lake."
	starts_with = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco = 8)
	icon_state = "roll_generic"
	item_state = "cigpacket"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	max_storage_space = 8
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	use_sound = 'sound/items/storage/box.ogg'

/obj/item/storage/chewables/rollable/unathi
	name = "box of S'th Kasavakh tobacco leaves"
	desc = "A box of coarse gritty tobacco which still manages to grow against the desertification of Moghes."
	starts_with = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco = 8)
	icon_state = "roll_unathi"
	item_state = "Fpacket"

/obj/item/storage/chewables/rollable/fine
	name = "box of Excelsior Epsilon tobacco leaves"
	desc = "Quality tobacco favored by the Corporates of Eridani - just don't read the label at the bottom."
	starts_with = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/fine = 8)
	icon_state = "roll_fine"
	item_state = "Dpacket"

/obj/item/storage/chewables/rollable/nico
	name = "box of Golden Sol tobacco leaves"
	desc = "A exclusive brand of overpriced tobacco, allegedly grown at a lagrange point station in Sol system."
	starts_with = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/pure = 8)
	icon_state = "roll_nico"
	item_state = "Epacket"

