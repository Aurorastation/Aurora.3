/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup
	name = "coffee cup"
	desc = "A plain white coffee cup."
	icon = 'icons/obj/drink_glasses/coffecup.dmi'
	icon_state = "coffeecup"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_food.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_food.dmi',
		)
	item_state = "coffeecup"
	volume = 30
	var/fillsource = "coffeecup"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drink_glasses/coffecup.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 39)
				filling.icon_state = null
				return
			if(40 to 79) 	filling.icon_state = "[fillsource]40"
			if(80 to 99)	filling.icon_state = "[fillsource]80"
			if(100 to INFINITY)	filling.icon_state = "[fillsource]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

// Nations
/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/sol
	name = "\improper sol coffee cup"
	desc = "A blue coffee cup emblazoned with the crest of the Sol Alliance."
	icon_state = "coffeecup_sol"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/dom
	name = "\improper Dominian coffee cup"
	desc = "A coffee cup with Dominia's flag proudly displayed on it."
	icon_state = "coffeecup_dom"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/nka
	name = "\improper NKA coffee cup"
	desc = "A coffee cup imprinted with the tree symbolising the flag of the New Kingdom of Adhomai."
	icon_state = "coffeecup_nka"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/pra
	name = "\improper PRA coffee cup"
	desc = "A coffee cup bearing the flag of the People's Republic of Adhomai."
	icon_state = "coffeecup_pra"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/dpra
	name = "\improper DPRA coffee cup"
	desc = "A metal coffee cup bearing the flag of the Democratic People's Republic of Adhomai."
	icon_state = "coffeecup_dpra"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/sedantis
	name = "\improper Sedantis coffee cup"
	desc = "A metal coffee cup bearing the flag of Sedantis."
	icon_state = "coffeecup_sedantis"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/coc
	name = "\improper CoC coffee cup"
	desc = "A metallic coffee cup proudly bearing the flag of the Coalition of Colonies."
	icon_state = "coffeecup_coc"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/eridani
	name = "\improper Eridani coffee cup"
	desc = "An expensive coffee cup bearing the flag of the Eridani Federation."
	icon_state = "coffeecup_eridani"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/elyra
	name = "\improper Elyra coffee cup"
	desc = "A coffee cup bearing the flag of the Republic of Elyra."
	icon_state = "coffeecup_elyra"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/hegemony
	name = "\improper Hegemony coffee cup"
	desc = "A coffee cup bearing the flag of the Izweski Hegemony."
	icon_state = "coffeecup_hegemony"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/jargon
	name = "\improper Nralakk coffee cup"
	desc = "A purple coffee cup emblazoned with the flag of the Nralakk Federation."
	icon_state = "coffeecup_jarg"

// Organisations
/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/nt
	name = "\improper NT coffee cup"
	desc = "A blue NanoTrasen coffee cup."
	icon_state = "coffeecup_NT"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tcfl
	name = "\improper Tau Ceti Foreign Legion coffee cup"
	desc = "A coffee cup with the TCFL emblem emblazoned on it."
	icon_state = "coffeecup_tcfl"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/hepht
	name = "\improper Hephaestus coffee cup"
	desc = "A strong coffee cup with the hephaestus logo emblazoned on it."
	icon_state = "coffeecup_hepht"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/idris
	name = "\improper Idris coffee cup"
	desc = "An Idris Incorporated coffee cup."
	icon_state = "coffeecup_idris"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/zeng
	name = "\improper Zeng-Hu coffee cup"
	desc = "A coffee cup bearing the Zeng-Hu logo."
	icon_state = "coffeecup_zeng"

// Symbols, markings
/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/one
	name = "#1 coffee cup"
	desc = "A white coffee cup, prominently featuring a #1."
	icon_state = "coffeecup_one"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/puni
	name = "#1 monkey coffee cup"
	desc = "A white coffee cup, prominently featuring a \"#1 monkey\" decal."
	icon_state = "coffeecup_puni"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/heart
	name = "heart coffee cup"
	desc = "A white coffee cup, it prominently features a red heart."
	icon_state = "coffeecup_heart"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/pawn
	name = "pawn coffee cup"
	desc = "A black coffee cup adorned with the image of a red chess pawn."
	icon_state = "coffeecup_pawn"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/diona
	name = "diona nymph coffee cup"
	desc = "A green coffee cup featuring the image of a diona nymph."
	icon_state = "coffeecup_diona"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/britcup
	name = "british coffee cup"
	desc = "A coffee cup with the British flag emblazoned on it."
	icon_state = "coffeecup_brit"

// Pure colors & other
/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/black
	name = "black coffee cup"
	desc = "A sleek black coffee cup."
	icon_state = "coffeecup_black"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/green
	name = "green coffee cup"
	desc = "A pale green and pink coffee cup."
	icon_state = "coffeecup_green"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/green/dark
	desc = "A dark green coffee cup."
	icon_state = "coffeecup_corp"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/rainbow
	name = "rainbow coffee cup"
	desc = "A rainbow coffee cup. The colors are almost as blinding as a welder."
	icon_state = "coffeecup_rainbow"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal
	name = "metal coffee cup"
	desc = "A metal coffee cup. You're not sure which metal."
	icon_state = "coffeecup_metal"
	flags = OPENCONTAINER | CONDUCT
	fragile = 0

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/glass
	name = "glass coffee cup"
	desc = "A glass coffee cup, using space age technology to keep it cool for use."
	icon_state = "glasscoffeecup"
	fillsource = "glasscoffeecup"

// Tall coffee cups
/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall
	name = "tall coffee cup"
	desc = "An unreasonably tall coffee cup, for when you really need to wake up in the morning."
	icon = 'icons/obj/drink_glasses/coffecup_tall.dmi'
	icon_state = "coffeecup_tall"
	fillsource = "coffeecup_tall"
	volume = 60

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/drink_glasses/coffecup_tall.dmi', src, null)
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 69)
				filling.icon_state = null
				return
			if(70 to 89) 	filling.icon_state = "[fillsource]70"
			if(90 to 99)	filling.icon_state = "[fillsource]90"
			if(100 to INFINITY)	filling.icon_state = "[fillsource]100"
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/black
	name = "tall black coffee cup"
	desc = "An unreasonably tall coffee cup, for when you really need to wake up in the morning. This one is black."
	icon_state = "coffeecup_tall_black"

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/metal
	name = "tall metal coffee cup"
	desc = "An unreasonably tall coffee cup, for when you really need to wake up in the morning. This one is made of metal."
	icon_state = "coffeecup_tall_metal"
	flags = OPENCONTAINER | CONDUCT
	fragile = 0

/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/rainbow
	name = "tall rainbow coffee cup"
	desc = "An unreasonably tall coffee cup, for when you really need to wake up in the morning. This one is rainbow colored."
	icon_state = "coffeecup_tall_rainbow"