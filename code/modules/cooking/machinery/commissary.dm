/**
 *	Cigarette shelf
 *	Clothing shelf
 *	Food and drinks shelf
 *	Toy shelf
 *	Cash register
 *	Commissary restock
 *		Cigarettes
 *		Tobacco leaves
 *		Chewing tobacco
 *		Smoking accessories
 *		Electronic cigarette
 *		Snack
 *		Xeno snack
 *		Candy
 *		Microwave meal
 *		Drink
 *		Cheap booze
 *	Restock crate
 */

/obj/machinery/smartfridge/tradeshelf
	name = "cigarette shelf"
	desc = "A commercialized shelf for cigarettes and associated items."
	icon_state = "trade_smokes"
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	active_power_usage = 0
	contents_path = "-cigarettebox"
	accepted_items = list(/obj/item/storage/box/fancy/cigarettes,
	/obj/item/storage/chewables,
	/obj/item/storage/box/fancy/chewables,
	/obj/item/storage/cigfilters,
	/obj/item/storage/box/fancy/cigpaper,
	/obj/item/storage/box/fancy/matches,
	/obj/item/flame/lighter,
	/obj/item/clothing/mask/smokable/ecig,
	/obj/item/reagent_containers/ecig_cartridge,
	/obj/item/spacecash/ewallet/lotto
	)
	display_tiers = 5
	display_tier_amt = 3
	has_emissive = FALSE
	visible_takeout = TRUE

/obj/machinery/smartfridge/tradeshelf/clothing
	name = "clothing shelf"
	desc = "A commercialized shelf for clothing and associated items."
	icon_state = "trade_clothes"
	contents_path = "-clothing"
	accepted_items = list(/obj/item/storage/backpack,
	/obj/item/storage/belt,
	/obj/item/clothing,
	/obj/item/storage/briefcase,
	/obj/item/cane
	)
	display_tiers = 3
	display_tier_amt = 5

/obj/machinery/smartfridge/tradeshelf/food
	name = "food and drinks shelf"
	desc = "A commercialized shelf for food and drinks."
	icon_state = "trade_food"
	contents_path = "-edible"
	use_power = POWER_USE_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	cooling = TRUE
	accepted_items = list(/obj/item/reagent_containers/food,
	/obj/item/storage/box/fancy/cookiesnack,
	/obj/item/storage/box/pineapple,
	/obj/item/storage/box/fancy/gum,
	/obj/item/storage/box/fancy/vkrexitaffy,
	/obj/item/clothing/mask/chewable/candy/lolli,
	/obj/item/storage/box/fancy/admints,
	/obj/item/storage/box/fancy/quick_microwave_pizza,
	/obj/item/reagent_containers/food/snacks/packaged_microwave_mac_and_cheeze,
	/obj/item/reagent_containers/food/snacks/packaged_microwave_fiery_mac_and_cheeze,
	/obj/item/storage/box/fancy/packaged_burger,
	/obj/item/storage/box/fancy/packaged_mossburger,
	/obj/item/storage/box/fancy/toptarts_strawberry,
	/obj/item/storage/box/fancy/toptarts_chocolate_peanutbutter,
	/obj/item/storage/box/fancy/toptarts_blueberry,
	/obj/item/storage/box/unique/donkpockets,
	/obj/item/storage/box/fancy/yoke
	)
	display_tiers = 4
	display_tier_amt = 5
	has_emissive = TRUE

/obj/machinery/smartfridge/tradeshelf/food/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_PEN)
		name_fridge(user)
		return
	. = ..()

/obj/machinery/smartfridge/tradeshelf/food/proc/name_fridge(mob/user)
	var/newname = tgui_input_text(user, "What would you like to rename the fridge? Note that fridge will be appended to the end of it", "Fridge name")
	if(newname)
		name = newname + " fridge"

/obj/machinery/smartfridge/tradeshelf/toy
	name = "toy shelf"
	desc = "A commercialized shelf for toys and associated items."
	icon_state = "trade_toys"
	contents_path = "-toy"
	accepted_items = list(/obj/item/toy,
	/obj/item/lipstick,
	/obj/item/paicard,
	/obj/item/camera,
	/obj/item/synthesized_instrument,
	/obj/item/storage/box/unique/snappops,
	/obj/item/haircomb,
	/obj/item/storage/box/fancy/crayons,
	/obj/item/melee/dinograbber,
	/obj/item/laser_pointer,
	/obj/item/deck,
	/obj/item/storage/pill_bottle/dice,
	/obj/item/pen,
	/obj/item/storage/stickersheet,
	/obj/item/gun/projectile/revolver/capgun,
	/obj/item/gun/bang,
	/obj/item/eightball,
	/obj/item/bikehorn,
	/obj/item/camera_film,
	/obj/item/ammo_magazine/caps,
	/obj/item/pack,
	/obj/item/storage/card,
	/obj/item/music_cartridge
	)
	display_tiers = 4
	display_tier_amt = 5

/obj/machinery/smartfridge/tradeshelf/mouse_drop_receive(atom/dropping, mob/user, params)
	LoadComponent(/datum/component/leanable, dropping)

// -------------------------------------------------
/obj/structure/cash_register/commissary
	storage_type = null
	req_one_access = list(ACCESS_BAR, ACCESS_GALLEY, ACCESS_CARGO)
	var/destination = "Operations"

/obj/structure/cash_register/commissary/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	. += "Alt-click with credits in hand, to deposit them."
	. += "Alt-click while having the proper access, to withdraw credits from it."
	. += "Items can be paid for with id cards, charge cards or physical credits, and a receipt will be printed."
	. += "The register can print a paper which can be used to quickly fill it out in the future by using it on the register."

/obj/structure/cash_register/commissary/Initialize()
	. = ..()
	src.LoadComponent(/datum/component/quikpay_shop, req_one_access, destination)

/obj/structure/cash_register/commissary/AltClick(var/mob/user)
	. = ..()
	var/datum/component/quikpay_shop/qp_shop = src.GetComponent(/datum/component/quikpay_shop)
	if(!qp_shop)
		return
	qp_shop.take_give_credits(user, loc)

/obj/structure/cash_register/commissary/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	var/datum/component/quikpay_shop/qp_shop = src.GetComponent(/datum/component/quikpay_shop)
	if(!qp_shop)
		return
	qp_shop.interact_object(attacking_item, user)

/obj/structure/cash_register/commissary/attack_hand(mob/living/user)
	. = ..()
	var/datum/component/quikpay_shop/qp_shop = src.GetComponent(/datum/component/quikpay_shop)
	if(!qp_shop)
		return
	qp_shop.ui_interact(user)

/obj/machinery/commissary_wall_shop
	name = "self-serve shop teller"
	desc = "An ordering terminal designed by Idris for quicker expedition."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "orderterminal"
	idle_power_usage = 10
	anchored = TRUE
	var/turned_on = FALSE
	req_one_access = list(ACCESS_BAR, ACCESS_GALLEY, ACCESS_CARGO)
	var/destination = "Operations"

/obj/machinery/commissary_wall_shop/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Items can be paid for with id cards or charge cards, and a receipt will be printed."
	. += "The terminal can print a paper which can be used to quickly fill it out in the future by using it on the register."
	. += "With the proper access, ctrl-click to turn the machine on and off."

/obj/machinery/commissary_wall_shop/Initialize()
	. = ..()
	src.LoadComponent(/datum/component/quikpay_shop/orderterminal, req_one_access, destination)
	update_icon()

/obj/machinery/commissary_wall_shop/attackby(obj/item/attacking_item, mob/user)
	if(!turned_on)
		balloon_alert(user, "turned off")
		return
	if(stat & NOPOWER)
		balloon_alert(user, "no power")
		return
	var/datum/component/quikpay_shop/orderterminal/qp_shop = src.GetComponent(/datum/component/quikpay_shop/orderterminal)
	if(!qp_shop)
		return
	qp_shop.interact_object(attacking_item, user)

/obj/machinery/commissary_wall_shop/attack_hand(mob/living/user)
	if(!turned_on)
		balloon_alert(user, "turned off")
		return
	if(stat & NOPOWER)
		balloon_alert(user, "no power")
		return
	var/datum/component/quikpay_shop/orderterminal/qp_shop = src.GetComponent(/datum/component/quikpay_shop/orderterminal)
	if(!qp_shop)
		return
	qp_shop.ui_interact(user)

/obj/machinery/commissary_wall_shop/CtrlClick(mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I))
		balloon_alert(user, "no id!")
		return
	if(!has_access(req_one_access = src.req_one_access, accesses = I.access))
		balloon_alert(user, "no access!")
		return
	turned_on = !turned_on
	balloon_alert(user, "turned [turned_on ? "on" : "off"]")
	update_icon()

/obj/machinery/commissary_wall_shop/power_change()
	..()
	update_icon()

/obj/machinery/commissary_wall_shop/update_icon()
	ClearOverlays()
	if(stat & NOPOWER || !turned_on)
		set_light(FALSE)
		return

	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "kitchenterminal-active", plane = ABOVE_LIGHTING_PLANE)
	AddOverlays(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/commissary_wall_shop/process()
	if(stat & NOPOWER || !turned_on)
		ClearOverlays()
		set_light(FALSE)
		return

/obj/item/storage/box/fancy/commissary_restock
	name = "commissary cigarette restock pack"
	icon = 'icons/obj/storage/boxes.dmi'
	icon_state = "commissary_restock"
	item_state = "commissary_restock"
	w_class = WEIGHT_CLASS_NORMAL
	illustration = "sparkler"
	label = null
	foldable = /obj/item/stack/material/cardboard
	color = null
	icon_overlays = FALSE
	display_contents_with_number = TRUE
	allow_quick_gather = TRUE
	make_exact_fit = TRUE
	can_hold_strict = TRUE
	closable = FALSE
	opened_icon_state = "commissary_restock_used"
	starts_with = list(
		// Cigarettes
		/obj/item/storage/box/fancy/cigarettes/pra = 3,
		/obj/item/storage/box/fancy/cigarettes/dpra = 3,
		/obj/item/storage/box/fancy/cigarettes/nka = 3,
		/obj/item/storage/box/fancy/cigarettes/federation = 3,
		/obj/item/storage/box/fancy/cigarettes/dyn = 3,
		/obj/item/storage/box/fancy/cigarettes/oracle = 3,
		/obj/item/storage/box/fancy/cigarettes/koko = 3,
		/obj/item/storage/box/fancy/cigarettes/dromedaryco = 3,
		/obj/item/storage/box/fancy/cigarettes/nicotine = 3,
		/obj/item/storage/box/fancy/cigarettes/cigar = 3
	)

/obj/item/storage/box/fancy/commissary_restock/Initialize()
	. = ..()
	// The copy() at the end is required to avoid every line after this from imploding. Why? I have no idea. It just does.
	can_hold = src.starts_with.Copy()

/obj/item/storage/box/fancy/commissary_restock/rollable
	name = "commissary tobacco leaves restock pack"
	starts_with = list(
		// Rollables
		/obj/item/storage/chewables/rollable = 3,
		/obj/item/storage/chewables/rollable/unathi = 3,
		/obj/item/storage/chewables/rollable/fine = 3,
		/obj/item/storage/chewables/rollable/nico = 3,
		/obj/item/storage/chewables/rollable/oracle = 3,
		/obj/item/storage/chewables/rollable/vedamor = 3
	)

/obj/item/storage/box/fancy/commissary_restock/chewable
	name = "commissary chewing tobacco restock pack"
	starts_with = list(
		// Chewing tobacco
		/obj/item/storage/chewables/tobacco = 3,
		/obj/item/storage/chewables/tobacco/bad = 3,
		/obj/item/storage/chewables/tobacco/fine = 3,
		/obj/item/storage/chewables/tobacco/federation = 3,
		/obj/item/storage/chewables/tobacco/dyn = 3,
		/obj/item/storage/chewables/tobacco/koko = 3,
		/obj/item/storage/box/fancy/chewables/tobacco/nico = 3,
		/obj/item/storage/chewables/oracle = 3,
		/obj/item/storage/chewables/solar_salve = 3
	)

/obj/item/storage/box/fancy/commissary_restock/smoking_accessory
	name = "commissary smoking accessories restock pack"
	starts_with = list(
		// Misc smoking
		/obj/item/storage/cigfilters = 6,
		/obj/item/storage/box/fancy/cigpaper = 3,
		/obj/item/storage/box/fancy/cigpaper/fine = 3,
		// Lighters & stuff
		/obj/item/storage/box/fancy/matches = 5,
		/obj/item/flame/lighter/random = 4,
		/obj/item/flame/lighter/zippo = 4,
		/obj/item/spacecash/ewallet/lotto = 8 // A bit of a risk that hangar techs may just use them instead of selling, but that should be handled IC as theft
	)

/obj/item/storage/box/fancy/commissary_restock/electronic_cig
	name = "commissary electronic cigarette restock pack"
	starts_with = list(
		// Electronic
		/obj/item/clothing/mask/smokable/ecig/util = 3,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 2,
		/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 2,
		/obj/item/reagent_containers/ecig_cartridge/orange = 2,
		/obj/item/reagent_containers/ecig_cartridge/watermelon = 2,
		/obj/item/reagent_containers/ecig_cartridge/grape = 2
	)

/obj/item/storage/box/fancy/commissary_restock/food
	name = "commissary snack restock pack"
	illustration = "snack"
	starts_with = list(
		// Chips
		/obj/item/reagent_containers/food/snacks/chips = 6,
		/obj/item/reagent_containers/food/snacks/chips/chicken = 3,
		/obj/item/reagent_containers/food/snacks/chips/cucumber = 3,
		/obj/item/reagent_containers/food/snacks/chips/dirtberry = 3,
		/obj/item/reagent_containers/food/snacks/chips/phoron = 3, // Not actually phoron
		/obj/item/reagent_containers/food/snacks/algaechips = 2,
		// General
		/obj/item/reagent_containers/food/snacks/no_raisin = 3,
		/obj/item/storage/box/pineapple = 2,
		/obj/item/reagent_containers/food/snacks/ricetub = 4,
		/obj/item/reagent_containers/food/snacks/riceball = 4,
		/obj/item/reagent_containers/food/snacks/seaweed = 4,
		/obj/item/reagent_containers/food/snacks/tuna = 2,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 3,
		/obj/item/reagent_containers/food/snacks/sosjerky = 3
	)

/obj/item/storage/box/fancy/commissary_restock/food/xeno
	name = "commissary xeno snack restock pack"
	illustration = "snack"
	starts_with = list(
		// Skrell
		/obj/item/reagent_containers/food/snacks/skrellsnacks = 3,
		/obj/item/reagent_containers/food/snacks/meatsnack = 2,
		/obj/item/reagent_containers/food/drinks/jyalra = 2,
		/obj/item/reagent_containers/food/drinks/jyalra/cheese = 2,
		/obj/item/reagent_containers/food/drinks/jyalra/apple = 2,
		/obj/item/reagent_containers/food/drinks/jyalra/cherry = 2,
		// Vaurca
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 6,
		// Unathi
		/obj/item/reagent_containers/food/snacks/nathisnack = 2,
		/obj/item/reagent_containers/food/snacks/candy/koko = 3,
		// Tajara
		/obj/item/reagent_containers/food/snacks/adhomian_can = 2,
	)

/obj/item/storage/box/fancy/commissary_restock/food/candy
	name = "commissary candy restock pack"
	starts_with = list(
		// Candy
		/obj/item/reagent_containers/food/snacks/candy = 4,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 4,
		/obj/item/reagent_containers/food/snacks/whitechocolate/wrapped = 4,
		/obj/item/storage/box/fancy/cookiesnack = 3,
		/obj/item/storage/box/fancy/gum = 4,
		/obj/item/storage/box/fancy/vkrexitaffy = 3,
		/obj/item/clothing/mask/chewable/candy/lolli = 5,
		/obj/item/storage/box/fancy/admints = 3,
		/obj/item/reagent_containers/food/drinks/bottle/bestblend = 2,
		/obj/item/storage/box/fancy/foysnack = 3,
		/obj/item/reagent_containers/food/snacks/choctruffles = 3
	)

/obj/item/storage/box/fancy/commissary_restock/food/microwave
	name = "commissary microwave meal restock pack"
	starts_with = list(
		// Microwave meals
		/obj/item/storage/box/fancy/quick_microwave_pizza = 3,
		/obj/item/storage/box/fancy/quick_microwave_pizza/olive = 3,
		/obj/item/storage/box/fancy/quick_microwave_pizza/pepperoni = 3,
		/obj/item/storage/box/fancy/quick_microwave_pizza/district6 = 3,
		/obj/item/reagent_containers/food/snacks/packaged_microwave_mac_and_cheeze = 3,
		/obj/item/reagent_containers/food/snacks/packaged_microwave_fiery_mac_and_cheeze = 3,
		/obj/item/storage/box/fancy/packaged_burger = 3,
		/obj/item/storage/box/fancy/packaged_mossburger = 2,
		/obj/item/reagent_containers/food/snacks/quick_curry = 3,
		/obj/item/reagent_containers/food/snacks/hv_dinner = 3,
		/obj/item/storage/box/fancy/toptarts_strawberry = 3,
		/obj/item/storage/box/fancy/toptarts_chocolate_peanutbutter = 3,
		/obj/item/storage/box/fancy/toptarts_blueberry = 3,
		/obj/item/storage/box/unique/donkpockets = 3
	)

/obj/item/storage/box/fancy/commissary_restock/drink
	name = "commissary drink restock pack"
	illustration = "soda"
	starts_with = list(
		// Soda
		/obj/item/reagent_containers/food/drinks/cans/cola = 5,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 5,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 5,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 5,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 5,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 5,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 5,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 5,
		// Misc
		/obj/item/reagent_containers/food/drinks/waterbottle = 5,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 5,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 5,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 5,
		/obj/item/reagent_containers/food/drinks/cans/cherry_juice = 5,
		/obj/item/reagent_containers/food/drinks/zobo = 5,
		// Skrell
		/obj/item/reagent_containers/food/drinks/cans/dyn = 5,
		// Tajara
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 5,
		/obj/item/reagent_containers/food/drinks/cans/adhomai_milk = 3,
		/obj/item/reagent_containers/food/drinks/cans/earthen_juice = 3,
		// Milk
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 5
	)

/obj/item/storage/box/fancy/commissary_restock/drink/booze_cheap
	name = "commissary cheap booze restock pack"
	starts_with = list(
		// Booze
		/obj/item/storage/box/fancy/yoke/beer = 2,
		/obj/item/storage/box/fancy/yoke/ebisu = 2,
		/obj/item/storage/box/fancy/yoke/shimauma = 2,
		/obj/item/reagent_containers/food/drinks/cans/beer = 6,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice = 6,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma = 6,
		/obj/item/reagent_containers/food/drinks/cans/beer/whistlingforest = 6,
		/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice = 6
	)


/obj/item/storage/box/fancy/commissary_restock/toy
	name = "commissary toy restock pack"
	illustration = "checkers"
	starts_with = list(
		// Toys
		/obj/item/toy/blink = 3,
		/obj/item/storage/box/unique/snappops = 2,
		/obj/item/toy/crossbow = 4,
		/obj/item/toy/ammo/crossbow = 8,
		/obj/item/toy/sword = 3,
		/obj/item/toy/katana = 2,
		/obj/item/gun/projectile/revolver/capgun = 2,
		/obj/item/ammo_magazine/caps = 4,
		/obj/item/toy/balloon = 4,
		/obj/item/toy/waterballoon = 20
	)

/obj/item/storage/box/fancy/commissary_restock/toy/cards_dice
	name = "commissary card and dice restock pack"
	starts_with = list(
		// Cards
		/obj/item/deck/cards = 5,
		/obj/item/deck/tarot = 3,
		/obj/item/deck/tarot/nralakk = 2,
		/obj/item/deck/tarot/nonnralakk = 2,
		/obj/item/deck/tarot/adhomai = 2,
		/obj/item/pack/cardemon = 2,
		/obj/item/pack/spaceball = 2,
		/obj/item/storage/card = 4,
		// Dice
		/obj/item/storage/pill_bottle/dice = 2,
		/obj/item/storage/pill_bottle/dice/gaming = 2,
		/obj/item/storage/pill_bottle/dice/tajara = 2
	)

/obj/item/storage/box/fancy/commissary_restock/toy/mech
	name = "commissary mech toy restock pack"
	starts_with = list(
		// Mech toys
		/obj/item/toy/mech/ripley = 2,
		/obj/item/toy/mech/fireripley = 2,
		/obj/item/toy/mech/deathripley = 2,
		/obj/item/toy/mech/gygax = 2,
		/obj/item/toy/mech/durand = 2,
		/obj/item/toy/mech/marauder = 2,
		/obj/item/toy/mech/seraph = 2,
		/obj/item/toy/mech/mauler = 2,
		/obj/item/toy/mech/odysseus = 2,
		/obj/item/toy/mech/phazon = 2
	)

/obj/item/storage/box/fancy/commissary_restock/toy/comic
	name = "commissary comic restock pack"
	starts_with = list(
		// Comics
		/obj/item/toy/comic = 2,
		/obj/item/toy/comic/inspector = 2,
		/obj/item/toy/comic/stormman = 2,
		/obj/item/toy/comic/outlandish_tales = 2,
		/obj/item/toy/comic/witchfinder = 2
	)

/obj/item/storage/box/fancy/commissary_restock/toy/comic/nka
	starts_with = list(
		// Comics
		/obj/item/toy/comic/azmarian/issue_1 = 2,
		/obj/item/toy/comic/azmarian/issue_2 = 2,
		/obj/item/toy/comic/azmarian/issue_3 = 2,
		/obj/item/toy/comic/azmarian/issue_4 = 2,
		/obj/item/toy/comic/azmarian/issue_5 = 2,
		/obj/item/toy/comic/azmarian/issue_6 = 2,
		/obj/item/toy/comic/azmarian/issue_7 = 2,
		/obj/item/toy/comic/azmarian/issue_8 = 2
	)

/obj/item/storage/box/fancy/commissary_restock/music
	name = "commissary music restock pack"
	illustration = "disk_kit"
	starts_with = list(
		// Music cartridges
		/obj/item/music_cartridge/ss13 = 2,
		/obj/item/music_cartridge/adhomai_swing = 2,
		/obj/item/music_cartridge/adhomai_vibes = 2,
		/obj/item/music_cartridge/europa_various = 2,
		/obj/item/music_cartridge/konyang_retrowave = 2,
		/obj/item/music_cartridge/venus_funkydisco = 2,
		/obj/item/music_cartridge/xanu_rock = 2,
		/obj/item/music_cartridge/audioconsole = 2,
	)

/obj/item/storage/box/fancy/commissary_restock/tea
	name = "commissary tea restock pack"
	illustration = "tea"
	starts_with = list(
		// Music cartridges
	/obj/item/storage/box/unique/tea = 3,
	/obj/item/storage/box/unique/tea/tieguanyin = 3,
	/obj/item/storage/box/unique/tea/jaekseol = 3,
	/obj/item/storage/box/unique/tea/messa = 3,
	/obj/item/storage/box/unique/tea/rasnif = 3
	)

/obj/item/storage/box/fancy/commissary_restock/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This item can be used to restock the commissary shelves."
	. += "Left-click on this when empty to fold it into a sheet if it is empty."

/obj/structure/closet/crate/commissary
	name = "commissary crate"
	desc = "A crate packed with boxes of various goods. Handle with care!"

/obj/structure/closet/crate/commissary/fill()
	for(var/i = 1 to 8)
		new /obj/item/storage/box/unique/papersack(src)
		new /obj/item/storage/bag/plasticbag(src)
	new /obj/item/storage/box/plasticbag(src)
	new /obj/item/tape_roll(src)
	new /obj/item/hand_labeler(src)
	new /obj/item/storage/toolbox/mechanical(src)

/obj/structure/closet/crate/commissary/resupply

/obj/structure/closet/crate/commissary/resupply/fill()
	new /obj/item/storage/box/fancy/commissary_restock/rollable(src)
	new /obj/item/storage/box/fancy/commissary_restock/chewable(src)
	new /obj/item/storage/box/fancy/commissary_restock/smoking_accessory(src)
	new /obj/item/storage/box/fancy/commissary_restock(src)
	new /obj/item/storage/box/fancy/commissary_restock/electronic_cig(src)
	new /obj/item/storage/box/fancy/commissary_restock/food(src)
	new /obj/item/storage/box/fancy/commissary_restock/food/candy(src)
	new /obj/item/storage/box/fancy/commissary_restock/food/xeno(src)
	new /obj/item/storage/box/fancy/commissary_restock/food/microwave(src)
	new /obj/item/storage/box/fancy/commissary_restock/drink(src)
	new /obj/item/storage/box/fancy/commissary_restock/drink/booze_cheap(src)
