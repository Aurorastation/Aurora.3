/obj/item/spacecash
	name = "0 credit chip"
	desc = "It's worth 0 credits."
	gender = PLURAL
	icon = 'icons/obj/cash.dmi'
	icon_state = "spacecash1"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_SMALL
	var/access = list()
	access = ACCESS_CRATE_CASH
	var/worth = 0
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/spacecash/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/spacecash))
		if(istype(attacking_item, /obj/item/spacecash/ewallet)) return 0

		var/obj/item/spacecash/bundle/bundle
		if(!istype(attacking_item, /obj/item/spacecash/bundle))
			var/obj/item/spacecash/cash = attacking_item
			bundle = new(src.loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = attacking_item
		bundle.worth += src.worth
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			//TODO: Find out a better way to do this
			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(bundle)
			h_user.put_in_hands(bundle)
		to_chat(user, SPAN_NOTICE("You add [src.worth] credits worth of money to the bundles.<br>It holds [bundle.worth] credits now."))
		qdel(src)

/proc/coin_typepath_suffix(var/amount)
	// accepts 0.01, 0.05, 0.10, 0.25; returns "c001", "c005", etc.
	var/cents = round(amount * 100)
	if(cents < 10)
		return "c00[cents]"
	else if(cents < 100)
		return "c0[cents]"
	else
		return "c[cents]"

/obj/item/spacecash/bundle
	name = "credit chips"
	icon_state = ""
	gender = PLURAL
	desc = "They are worth 0 credits."
	worth = 0

/obj/item/spacecash/bundle/update_icon()
	ClearOverlays()
	var/list/ovr = list()
	var/num = 0
	var/cents = round(src.worth * 100) // INTEGER CENTS for splitting
	// list is in cents, so 1000 = $10, 100 = $1, 25 = $0.25, 1 = $0.01

	if(src.worth < 1)
		src.name = "credit coins"
		src.drop_sound = 'sound/items/drop/ring.ogg'
		src.pickup_sound = 'sound/items/pickup/ring.ogg'
	else
		src.name = "credit chips"

	// build The Pile(TM)
	for(var/denom in list(100000,50000,20000,10000,5000,2000,1000,500,100,25,10,5,1))
		while(cents >= denom && num < 50)
			cents -= denom
			num++
			var/image/banknote
			var/denom_value = denom / 100.0
			if(denom >= 100)
				// bills (>= $1.00)
				banknote = image('icons/obj/cash.dmi', "spacecash[round(denom_value)]")
			else
				// coins (< $1.00)
				// pad denom_value for icon_state, e.g. "spacecash0.05"
				var/coinstr = "[denom_value]"
				if(findtext(coinstr, ".") && length(copytext(coinstr, findtext(coinstr, ".")+1)) == 1)
					coinstr += "0"
				banknote = image('icons/obj/cash.dmi', "spacecash[coinstr]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			ovr += banknote

	AddOverlays(ovr)
	UpdateOverlays()	// The delay looks weird, so we force an update immediately.
	src.desc = "A bundle of Biesel Standard Credits. Combined, this is worth [worth] credits."

/obj/item/spacecash/bundle/attack_self(mob/user as mob)
	var/amount = tgui_input_number(user, "How many credits do you want to take out? (0 to [src.worth])", "Take Money", 5, worth, 0, 0, round_value = FALSE)

	if(QDELETED(src))
		return 0

	if(use_check_and_message(user,USE_FORCE_SRC_IN_USER))
		return 0

	if(amount == 0) return 0

	var/cents_out = round(amount * 100)
	var/bundle_cents = round(src.worth * 100)

	if(cents_out > bundle_cents)
		cents_out = bundle_cents

	src.worth = (bundle_cents - cents_out) / 100.0

	// get rid of floating points
	if(abs(src.worth) < 0.0001)
		src.worth = 0

	src.update_icon()
	if(!src.worth)
		user.drop_from_inventory(src)

	// bill denominations (whole creds)
	if(cents_out >= 100 && cents_out % 100 == 0)
		var/dollars = cents_out / 100
		var/cashtype = text2path("/obj/item/spacecash/c[dollars]")
		if(isnull(cashtype))
			// fallback: spawn a bundle if something's wrong
			var/obj/item/spacecash/bundle/bundle = new(user.loc)
			bundle.worth = cents_out / 100.0
			bundle.update_icon()
			user.put_in_hands(bundle)
		else
			var/obj/cash = new cashtype(user.loc)
			user.put_in_hands(cash)

	// coin denominations
	else if(cents_out in list(25, 10, 5, 1))
		var/cashtype = text2path("/obj/item/spacecash/coin/[coin_typepath_suffix(cents_out / 100.0)]")
		if(isnull(cashtype))
			var/obj/item/spacecash/bundle/bundle = new(user.loc)
			bundle.worth = cents_out / 100.0
			bundle.update_icon()
			user.put_in_hands(bundle)
		else
			var/obj/cash = new cashtype(user.loc)
			user.put_in_hands(cash)

	// fallback for weird edge cases
	else
		var/obj/item/spacecash/bundle/bundle = new(user.loc)
		bundle.worth = cents_out / 100.0
		bundle.update_icon()
		user.put_in_hands(bundle)

	if(!src.worth)
		qdel(src)

/obj/item/spacecash/c1
	name = "1 credit chip"
	icon_state = "spacecash1"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 1 credit."
	worth = 1

/obj/item/spacecash/c5
	name = "5 credit chip"
	icon_state = "spacecash5"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 5 credits."
	worth = 5

/obj/item/spacecash/c10
	name = "10 credit chip"
	icon_state = "spacecash10"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 10 credits."
	worth = 10

/obj/item/spacecash/c20
	name = "20 credit chip"
	icon_state = "spacecash20"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 20 credits."
	worth = 20

/obj/item/spacecash/c50
	name = "50 credit chip"
	icon_state = "spacecash50"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 50 credits."
	worth = 50

/obj/item/spacecash/c100
	name = "100 credit chip"
	icon_state = "spacecash100"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 100 credits."
	worth = 100

/obj/item/spacecash/c200
	name = "200 credit chip"
	icon_state = "spacecash200"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 200 credits."
	worth = 200

/obj/item/spacecash/c500
	name = "500 credit chip"
	icon_state = "spacecash500"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 500 credits."
	worth = 500

/obj/item/spacecash/c1000
	name = "1000 credit chip"
	icon_state = "spacecash1000"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 1000 credits."
	worth = 1000

/obj/item/spacecash/coin
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	worth = 0
	var/sides = 2
	var/last_flip = 0 //spam limiter

/obj/item/spacecash/coin/attack_self(mob/user)
	if(last_flip <= world.time - 20)
		last_flip = world.time
		var/result = rand(1, sides)
		var/comment = ""
		if(result == 1)
			comment = "tails"
		else if(result == 2)
			comment = "heads"
		playsound(get_turf(src), 'sound/items/coinflip.ogg', 100, 1, -4)
		user.visible_message(SPAN_NOTICE("\The [user] throws \the [src]. It lands on [comment]!"), SPAN_NOTICE("You throw \the [src]. It lands on [comment]!"))

/obj/item/spacecash/coin/c001
	name = "1 cent unie coin"
	icon_state = "spacecash0.01"
	desc = "A Biesel Standard Credit coin, called a 'unie'. This is worth 0.01 credits."
	worth = 0.01

/obj/item/spacecash/coin/c005
	name = "5 cent quin coin"
	icon_state = "spacecash0.05"
	desc = "A Biesel Standard Credit coin, called a 'quin'. This is worth 0.05 credits."
	worth = 0.05

/obj/item/spacecash/coin/c010
	name = "10 cent dece coin"
	icon_state = "spacecash0.10"
	desc = "A Biesel Standard Credit coin, called a 'dece'. This is worth 0.10 credits."
	worth = 0.10

/obj/item/spacecash/coin/c025
	name = "25 cent quarter coin"
	icon_state = "spacecash0.25"
	desc = "A Biesel Standard Credit coin, called a 'quarter'. This is worth 0.25 credits."
	worth = 0.25

/proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	var/cents = round(sum * 100)
	// list all bill and coin denominations (in cents)
	var/list/denoms = list(
		100000,50000,20000,10000,5000,2000,1000,500,100,	// Bills: $1000 ... $1
		25,10,5,1											   // Coins: $0.25, $0.10, $0.05, $0.01
	)

	// check for a single denomination match first (bill or coin)
	if(cents in denoms)
		var objpath
		if(cents >= 100)
			var/dollars = cents / 100
			objpath = text2path("/obj/item/spacecash/c[dollars]")
		else
			var/coin_value = "[cents / 100.0]"
			// pad to two decimals for path if needed
			if(findtext(coin_value, ".") && length(copytext(coin_value, ".")+1) == 1)
				coin_value += "0"
			objpath = text2path("/obj/item/spacecash/coin/[coin_typepath_suffix(cents / 100.0)]")
		if(!isnull(objpath))
			var/obj/cash = new objpath(spawnloc)
			if(ishuman(human_user) && !human_user.get_active_hand())
				human_user.put_in_hands(cash)
			return

	// spawn a bundle for mixed/odd amounts
	var/obj/item/spacecash/bundle/bundle = new(spawnloc)
	bundle.worth = cents / 100.0
	bundle.update_icon()
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(bundle)
	return

/obj/item/spacecash/ewallet
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/spacecash/ewallet/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 2 && user != loc)
		return
	. += SPAN_NOTICE("The charge card's owner is [src.owner_name].")
	. += SPAN_NOTICE("It has [src.worth]电 left.")

/obj/item/spacecash/ewallet/c2000
	worth = 2000

/obj/item/spacecash/ewallet/c5000
	worth = 5000

/obj/item/spacecash/ewallet/c10000
	worth = 10000
