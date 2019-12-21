
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	starts_with = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube = 5)

/obj/item/storage/box/monkeycubes/vkrexicubes
	name = "vkrexi cube box"
	desc = "Drymate brand vkrexi cubes. Just add water!"
	starts_with = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube = 5)

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"
	starts_with = list(/obj/item/card/id = 7)

/obj/item/storage/box/seccarts
	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"
	starts_with = list(/obj/item/cartridge/security = 7)

/obj/item/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"
	starts_with = list(/obj/item/handcuffs = 7)

/obj/item/storage/box/zipties
	name = "box of zipties"
	desc = "A box full of zipties."
	icon_state = "handcuff"
	starts_with = list(/obj/item/handcuffs/ziptie = 7)

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"
	starts_with = list(/obj/item/device/assembly/mousetrap = 6)

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	icon_state = "pillbox"
	starts_with = list(/obj/item/storage/pill_bottle = 7)

/obj/item/storage/box/spraybottles
	name = "box of spray bottles"
	desc = "It has pictures of spray bottles on its front."
	starts_with = list(/obj/item/reagent_containers/spray = 7)

/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	can_hold = list(/obj/item/toy/snappop)
	starts_with = list(/obj/item/toy/snappop = 8)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 1
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/flame/match)
	starts_with = list(/obj/item/flame/match = 10)

/obj/item/storage/box/matches/attackby(obj/item/flame/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		if(prob(25))
			playsound(src.loc, 'sound/items/cigs_lighters/matchstick_lit.ogg', 25, 0, -1)
			user.visible_message("<span class='notice'>[user] manages to light the match on the matchbox.</span>")
			W.lit = 1
			W.damtype = "burn"
			W.icon_state = "match_lit"
			W.item_state = "match_lit"
			START_PROCESSING(SSprocessing, W)
		else
			playsound(src.loc, 'sound/items/cigs_lighters/matchstick_hit.ogg', 25, 0, -1)
	W.update_icon()
	return


/obj/item/storage/box/autoinjectors
	name = "box of empty injectors"
	desc = "Contains empty autoinjectors."
	icon_state = "syringe"
	starts_with = list(/obj/item/reagent_containers/hypospray/autoinjector = 7)

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/storage/box/lights/Initialize()	// TODO-STORAGE: Initialize()?
	. = ..()
	make_exact_fit()

/obj/item/storage/box/lights/bulbs
	starts_with = list(/obj/item/light/bulb = 21)

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
	starts_with = list(/obj/item/light/tube = 21)

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube = 14, /obj/item/light/bulb = 7)

/obj/item/storage/box/lights/coloredmixed
	name = "box of colored lights"
	icon_state = "lightmixed"

/obj/item/storage/box/lights/coloredmixed/fill() // too lazy for this one
	..()
	var/static/list/tube_colors = list(
		/obj/item/light/tube/colored/red,
		/obj/item/light/tube/colored/green,
		/obj/item/light/tube/colored/blue,
		/obj/item/light/tube/colored/magenta,
		/obj/item/light/tube/colored/yellow,
		/obj/item/light/tube/colored/cyan
	)
	var/static/list/bulbs_colors = list(
		/obj/item/light/bulb/colored/red,
		/obj/item/light/bulb/colored/green,
		/obj/item/light/bulb/colored/blue,
		/obj/item/light/bulb/colored/magenta,
		/obj/item/light/bulb/colored/yellow,
		/obj/item/light/bulb/colored/cyan
	)
	for(var/i = 0, i < 14, i++)
		var/type = pick(tube_colors)
		new type(src)
	for(var/i = 0, i < 7, i++)
		var/type = pick(bulbs_colors)
		new type(src)

/obj/item/storage/box/lights/colored/red
	name = "box of red lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube/colored/red = 14, /obj/item/light/bulb/colored/red = 7)

/obj/item/storage/box/lights/colored/green
	name = "box of green lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube/colored/green = 14, /obj/item/light/bulb/colored/green = 7)

/obj/item/storage/box/lights/colored/blue
	name = "box of blue lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube/colored/blue = 14, /obj/item/light/bulb/colored/blue = 7)

/obj/item/storage/box/lights/colored/cyan
	name = "box of cyan lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube/colored/cyan = 14, /obj/item/light/bulb/colored/cyan = 7)

/obj/item/storage/box/lights/colored/yellow
	name = "box of yellow lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube/colored/yellow = 14, /obj/item/light/bulb/colored/yellow = 7)

/obj/item/storage/box/lights/colored/magenta
	name = "box of magenta lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/light/tube/colored/magenta = 14, /obj/item/light/bulb/colored/magenta = 7)

/obj/item/storage/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/storage.dmi'
	icon_state = "portafreezer"
	item_state = "medicalpack"
	max_w_class = 3
	can_hold = list(/obj/item/organ, /obj/item/reagent_containers/food, /obj/item/reagent_containers/glass)
	max_storage_space = 21
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try
	chewable = FALSE

/obj/item/storage/box/kitchen
	name = "kitchen supplies"
	desc = "Contains an assortment of utensils and containers useful in the preparation of food and drinks."

/obj/item/storage/box/kitchen/fill()
	new /obj/item/material/knife(src)//Should always have a knife

	var/list/utensils = list(
		/obj/item/material/kitchen/rollingpin,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/material/kitchen/utensil/fork,
		/obj/item/reagent_containers/food/condiment/enzyme,
		/obj/item/material/kitchen/utensil/spoon,
		/obj/item/material/kitchen/utensil/knife,
		/obj/item/reagent_containers/food/drinks/shaker
	)
	for (var/i = 0,i<6,i++)
		var/type = pick(utensils)
		new type(src)

/obj/item/storage/box/snack
	name = "rations box"
	desc = "Contains a random assortment of preserved foods. Guaranteed to remain edible* in room-temperature longterm storage for centuries!"

/obj/item/storage/box/snack/fill()
	var/list/snacks = list(
			/obj/item/reagent_containers/food/snacks/koisbar_clean,
			/obj/item/reagent_containers/food/snacks/candy,
			/obj/item/reagent_containers/food/snacks/candy_corn,
			/obj/item/reagent_containers/food/snacks/chips,
			/obj/item/reagent_containers/food/snacks/chocolatebar,
			/obj/item/reagent_containers/food/snacks/chocolateegg,
			/obj/item/reagent_containers/food/snacks/popcorn,
			/obj/item/reagent_containers/food/snacks/sosjerky,
			/obj/item/reagent_containers/food/snacks/no_raisin,
			/obj/item/reagent_containers/food/snacks/spacetwinkie,
			/obj/item/reagent_containers/food/snacks/cheesiehonkers,
			/obj/item/reagent_containers/food/snacks/syndicake,
			/obj/item/reagent_containers/food/snacks/fortunecookie,
			/obj/item/reagent_containers/food/snacks/poppypretzel,
			/obj/item/reagent_containers/food/snacks/cracker,
			/obj/item/reagent_containers/food/snacks/liquidfood,
			/obj/item/reagent_containers/food/snacks/skrellsnacks,
			/obj/item/reagent_containers/food/snacks/tastybread,
			/obj/item/reagent_containers/food/snacks/meatsnack,
			/obj/item/reagent_containers/food/snacks/maps,
			/obj/item/reagent_containers/food/snacks/nathisnack,
			/obj/item/reagent_containers/food/snacks/adhomian_can,
			/obj/item/reagent_containers/food/snacks/tuna
	)
	for (var/i = 0,i<7,i++)
		var/type = pick(snacks)
		new type(src)

/obj/item/storage/box/stims
	name = "stimpack value kit"
	desc = "A box with several stimpack medipens for the economical miner."
	icon_state = "syringe"
	starts_with = list(/obj/item/reagent_containers/hypospray/autoinjector/stimpack = 4)

/obj/item/storage/box/inhalers
	name = "inhaler kit"
	desc = "A box filled with several inhalers and empty inhaler cartridges."
	icon_state = "box_inhalers"
	starts_with = list(/obj/item/personal_inhaler = 2, /obj/item/reagent_containers/personal_inhaler_cartridge = 6)

/obj/item/storage/box/inhalers_large
	name = "combat inhaler kit"
	desc = "A box filled with a combat inhaler and several large empty inhaler cartridges."
	icon_state = "box_inhalers"
	starts_with = list(/obj/item/personal_inhaler/combat = 1, /obj/item/reagent_containers/personal_inhaler_cartridge/large = 6)

/obj/item/storage/box/inhalers_auto
	name = "autoinhaler kit"
	desc = "A box filled with a combat inhaler and several large empty inhaler cartridges."
	icon_state = "box_inhalers"
	starts_with = list(/obj/item/reagent_containers/inhaler = 8)

/obj/item/storage/box/clams
	name = "box of Ras'val clam"
	desc = "A box filled with clams from the Ras'val sea, imported by Njadra'Akhar Enterprises."
	starts_with = list(/obj/item/reagent_containers/food/snacks/clam = 5)

/obj/item/storage/box/produce
	name = "produce box"
	desc = "A large box of random, leftover produce."
	icon_state = "largebox"
	starts_with = list(/obj/random_produce = 12)

/obj/item/storage/box/produce/fill()
	. = ..()
	make_exact_fit()


/obj/item/storage/box/candy
	name = "candy box"
	desc = "A large box of assorted small candy."
	icon_state = "largebox"

/obj/item/storage/box/candy/fill()
	var/list/assorted_list = list(
		/obj/item/reagent_containers/food/snacks/cb01 = 1,
		/obj/item/reagent_containers/food/snacks/cb02 = 1,
		/obj/item/reagent_containers/food/snacks/cb03 = 1,
		/obj/item/reagent_containers/food/snacks/cb04 = 1,
		/obj/item/reagent_containers/food/snacks/cb05 = 1,
		/obj/item/reagent_containers/food/snacks/cb06 = 1,
		/obj/item/reagent_containers/food/snacks/cb07 = 1,
		/obj/item/reagent_containers/food/snacks/cb08 = 1,
		/obj/item/reagent_containers/food/snacks/cb09 = 1,
		/obj/item/reagent_containers/food/snacks/cb10 = 1
	)

	for(var/i in 1 to 24)
		var/chosen_candy = pickweight(assorted_list)
		new chosen_candy(src)

	make_exact_fit()


/obj/item/storage/box/crabmeat
	name = "box of crab legs"
	desc = "A box filled with high-quality crab legs. Shipped to Aurora by popular demand!"
	starts_with = list(/obj/item/reagent_containers/food/snacks/crabmeat = 5)

/obj/item/storage/box/tranquilizer
	name = "box of tranquilizer darts"
	desc = "It has a picture of a tranquilizer dart and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "incendiaryshot_box"
	starts_with = list(/obj/item/ammo_casing/tranq = 8)

/obj/item/storage/box/toothpaste
	can_hold = list(/obj/item/reagent_containers/toothpaste,
					/obj/item/reagent_containers/toothbrush)

	starts_with = list(/obj/item/reagent_containers/toothpaste = 1,
					/obj/item/reagent_containers/toothbrush = 1)

/obj/item/storage/box/toothpaste/green
	starts_with = list(/obj/item/reagent_containers/toothpaste = 1,
					/obj/item/reagent_containers/toothbrush/green = 1)

/obj/item/storage/box/toothpaste/red
	starts_with = list(/obj/item/reagent_containers/toothpaste = 1,
				/obj/item/reagent_containers/toothbrush/red = 1)

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	starts_with = list(/obj/item/clothing/accessory/badge/holo = 4,
				/obj/item/clothing/accessory/badge/holo/cord = 2)

/obj/item/storage/box/sol_visa
	name = "Sol Alliance visa recommendations box"
	desc = "A box full of Sol Aliance visa recommendation slips."
	starts_with = list(/obj/item/clothing/accessory/badge/sol_visa = 6)

/obj/item/storage/box/ceti_visa
	name = "TCFL recruitment papers box"
	desc = "A box full of papers that signify one as a recruit of the Tau Ceti Foreign Legion."
	starts_with = list(/obj/item/clothing/accessory/badge/tcfl_papers = 6)

/obj/item/storage/box/hadii_card
	name = "honorary party member card box"
	desc = "A box full of Hadiist party member cards."
	starts_with = list(/obj/item/clothing/accessory/badge/hadii_card = 6)

/obj/item/storage/box/hadii_manifesto
	name = "hadiist manifesto card box"
	desc = "A box full of hadiist manifesto books."
	starts_with = list(/obj/item/book/manual/pra_manifesto = 6)

/obj/item/storage/box/dominia_honor
	name = "dominian honor codex box"
	desc = "A box full of dominian honor codex "
	starts_with = list(/obj/item/book/manual/dominia_honor = 6)

/obj/item/storage/box/tcfl_pamphlet
	name = "tau ceti foreign legion pamphlets box"
	desc = "A box full of tau ceti foreign legion pamphlets."
	starts_with = list(/obj/item/book/manual/tcfl_pamphlet = 6)

/obj/item/storage/box/sharps
	name = "sharps disposal box"
	desc = "A plastic box for disposal of used needles and other sharp, potentially-contaminated tools. There is a large biohazard sign on the front."
	icon_state = "sharpsbox"
	max_storage_space = 20
	chewable = FALSE
	foldable = null

/obj/item/storage/box/fountainpens
	name = "box of fountain pens"
	starts_with = list(/obj/item/pen/fountain = 7)