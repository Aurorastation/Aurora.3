/**
 * Adding a currency requires a unique acceptance flag, a subtype here, and item types pointing
 * currency_definition at it. Populate denomination_types and bundle_type for automatic
 * same-currency change and ATM output. Machines then only need the new flag in their bitfield.
 */
/singleton/currency
	/// identifier used by UIs and machine actions.
	var/id = "currency"
	var/display_name = "Currency"
	var/unit_name = "unit"
	var/unit_name_plural = "units"
	/// The machinery acceptance bit associated with this currency.
	var/acceptance_flag = NONE
	/// Number of this currency's units equal to one Biesel Standard Credit.
	var/units_per_credit = 1
	/// Smallest representable subdivision. `100` means values are stored to hundredths.
	var/subunits_per_unit = 100
	/// Whether ATMs should offer this currency as a physical withdrawal option.
	var/atm_withdrawal_enabled = FALSE
	var/atm_withdrawal_fee = 0
	var/atm_icon = "coins"
	/// Map of scaled currency subunits (as text) to exact denomination item types.
	var/list/denomination_types
	/// Bundle used when no exact denomination exists.
	var/bundle_type

/singleton/currency/proc/to_credits(var/currency_value)
	if(units_per_credit <= 0)
		CRASH("[type] must have a positive units_per_credit value.")
	return currency_value / units_per_credit

/singleton/currency/proc/from_credits(var/credit_value)
	if(units_per_credit <= 0)
		CRASH("[type] must have a positive units_per_credit value.")
	return credit_value * units_per_credit

/singleton/currency/proc/format_value(var/currency_value)
	return "[currency_value] [currency_value == 1 ? unit_name : unit_name_plural]"

/singleton/currency/proc/get_deposit_purpose()
	return "[display_name] deposit"

/// Creates physical currency worth credit_value credits using the definition's denomination map.
/singleton/currency/proc/spawn_credit_value(var/credit_value, var/spawnloc, var/mob/living/carbon/human/human_user)
	if(subunits_per_unit <= 0)
		CRASH("[type] must have a positive subunits_per_unit value.")
	var/currency_subunits = round(from_credits(credit_value) * subunits_per_unit)
	var/denomination_type = denomination_types?["[currency_subunits]"]
	var/obj/item/currency/created
	if(denomination_type)
		created = new denomination_type(spawnloc)
	else
		if(!bundle_type)
			CRASH("[type] has neither an exact denomination nor a bundle type for [currency_subunits / subunits_per_unit] units.")
		created = new bundle_type(spawnloc)
		created.worth = currency_subunits / subunits_per_unit
		created.update_icon()
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(created)
	return created

/singleton/currency/credits
	id = "credits"
	display_name = "Credit"
	unit_name = "credit"
	unit_name_plural = "credits"
	acceptance_flag = CURRENCY_CREDITS
	bundle_type = /obj/item/spacecash/bundle

/singleton/currency/credits/spawn_credit_value(var/credit_value, var/spawnloc, var/mob/living/carbon/human/human_user)
	return spawn_money(credit_value, spawnloc, human_user)

/singleton/currency/adhomian_knuckles
	id = "adhomian_knuckles"
	display_name = "Adhomian knuckle"
	unit_name = "knuckle"
	unit_name_plural = "knuckles"
	acceptance_flag = CURRENCY_ADHOMIAN_KNUCKLES
	units_per_credit = ADHOMIAN_KNUCKLES_PER_CREDIT
	atm_withdrawal_enabled = TRUE
	atm_withdrawal_fee = ADHOMIAN_KNUCKLE_WITHDRAWAL_FEE
	atm_icon = "coins"
	bundle_type = /obj/item/adhomian_knuckle/bundle
	denomination_types = list(
		"1" = /obj/item/adhomian_knuckle/k001,
		"4" = /obj/item/adhomian_knuckle/k004,
		"8" = /obj/item/adhomian_knuckle/k008,
		"100" = /obj/item/adhomian_knuckle/k1,
		"400" = /obj/item/adhomian_knuckle/k4,
		"800" = /obj/item/adhomian_knuckle/k8,
		"3200" = /obj/item/adhomian_knuckle/k32,
		"6400" = /obj/item/adhomian_knuckle/k64,
		"12800" = /obj/item/adhomian_knuckle/k128,
		"25600" = /obj/item/adhomian_knuckle/k256,
		"51200" = /obj/item/adhomian_knuckle/k512,
		"102400" = /obj/item/adhomian_knuckle/k1024
	)

/obj/item/currency
	name = "physical currency"
	desc = "Money intended to be exchanged by hand."
	gender = PLURAL
	opacity = 0
	density = 0
	anchored = 0
	force = 1
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_SMALL
	var/worth = 0
	var/can_bundle = TRUE
	/// Singleton containing all behavior for this currency.
	var/currency_definition = /singleton/currency/credits

/obj/item/currency/proc/get_currency_definition()
	return GET_SINGLETON(currency_definition)

/obj/item/currency/proc/get_credit_value()
	var/singleton/currency/definition = get_currency_definition()
	return definition.to_credits(worth)

/obj/item/currency/proc/transfer_forensics_to(var/atom/target)
	if(!target)
		return
	transfer_fingerprints_to(target)
	if(suit_fibers)
		if(!target.suit_fibers)
			target.suit_fibers = list()
		target.suit_fibers |= suit_fibers.Copy()

/obj/item/currency/attackby(obj/item/attacking_item, mob/user)
	if(!can_bundle || !istype(attacking_item, /obj/item/currency))
		return ..()
	var/obj/item/currency/other_currency = attacking_item
	if(!other_currency.can_bundle || other_currency.currency_definition != currency_definition)
		return ..()
	var/singleton/currency/definition = get_currency_definition()
	if(!definition.bundle_type)
		return ..()

	var/obj/item/currency/bundle
	if(istype(other_currency, definition.bundle_type))
		bundle = other_currency
	else
		bundle = new definition.bundle_type(src.loc)
		bundle.worth += other_currency.worth
		other_currency.transfer_forensics_to(bundle)
		qdel(other_currency)
	bundle.worth += worth
	transfer_forensics_to(bundle)
	bundle.update_icon()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		human_user.drop_from_inventory(src)
		human_user.drop_from_inventory(bundle)
		human_user.put_in_hands(bundle)
	to_chat(user, SPAN_NOTICE("You combine the currency into a bundle worth [definition.format_value(bundle.worth)]."))
	qdel(src)
	return TRUE

/obj/item/currency/proc/is_bundle()
	var/singleton/currency/definition = get_currency_definition()
	return definition.bundle_type && istype(src, definition.bundle_type)

/obj/item/currency/proc/deduct_credit_value(var/credit_value)
	var/singleton/currency/definition = get_currency_definition()
	if(definition.subunits_per_unit <= 0)
		CRASH("[definition.type] must have a positive subunits_per_unit value.")
	worth = round(worth - definition.from_credits(credit_value), 1 / definition.subunits_per_unit)
	if(is_bundle())
		update_icon()
	return worth

/obj/item/currency/proc/spawn_change(var/credit_value, var/spawnloc, var/mob/living/carbon/human/human_user)
	var/singleton/currency/definition = get_currency_definition()
	var/obj/item/currency/change = definition.spawn_credit_value(credit_value, spawnloc, human_user)
	transfer_forensics_to(change)
	return change

/obj/proc/accepts_currency(var/obj/item/currency/cash)
	if(!cash)
		return FALSE
	var/singleton/currency/definition = cash.get_currency_definition()
	return CURRENCY_CREDITS & definition.acceptance_flag

/obj/structure/machinery/accepts_currency(var/obj/item/currency/cash)
	if(!cash)
		return FALSE
	var/singleton/currency/definition = cash.get_currency_definition()
	return accepted_currencies & definition.acceptance_flag

/obj/item/spacecash
	parent_type = /obj/item/currency
	name = "0 credit chip"
	desc = "It's worth 0电."
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
	access = /datum/access/crate_cash::id
	currency_definition = /singleton/currency/credits
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

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
	desc = "They are worth 0电."
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
	src.desc = "A bundle of Biesel Standard Credits. Combined, this is worth [worth]电."

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
			transfer_forensics_to(bundle)
			user.put_in_any_hand_if_possible(bundle)
		else
			var/obj/item/currency/cash = new cashtype(user.loc)
			transfer_forensics_to(cash)
			user.put_in_any_hand_if_possible(cash)

	// coin denominations
	else if(cents_out in list(25, 10, 5, 1))
		var/cashtype = text2path("/obj/item/spacecash/coin/[coin_typepath_suffix(cents_out / 100.0)]")
		if(isnull(cashtype))
			var/obj/item/spacecash/bundle/bundle = new(user.loc)
			bundle.worth = cents_out / 100.0
			bundle.update_icon()
			transfer_forensics_to(bundle)
			user.put_in_any_hand_if_possible(bundle)
		else
			var/obj/item/currency/cash = new cashtype(user.loc)
			transfer_forensics_to(cash)
			user.put_in_any_hand_if_possible(cash)

	// fallback for weird edge cases
	else
		var/obj/item/spacecash/bundle/bundle = new(user.loc)
		bundle.worth = cents_out / 100.0
		bundle.update_icon()
		transfer_forensics_to(bundle)
		user.put_in_any_hand_if_possible(bundle)

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
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 5电."
	worth = 5

/obj/item/spacecash/c10
	name = "10 credit chip"
	icon_state = "spacecash10"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 10电."
	worth = 10

/obj/item/spacecash/c20
	name = "20 credit chip"
	icon_state = "spacecash20"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 20电."
	worth = 20

/obj/item/spacecash/c50
	name = "50 credit chip"
	icon_state = "spacecash50"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 50电."
	worth = 50

/obj/item/spacecash/c100
	name = "100 credit chip"
	icon_state = "spacecash100"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 100电."
	worth = 100

/obj/item/spacecash/c200
	name = "200 credit chip"
	icon_state = "spacecash200"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 200电."
	worth = 200

/obj/item/spacecash/c500
	name = "500 credit chip"
	icon_state = "spacecash500"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 500电."
	worth = 500

/obj/item/spacecash/c1000
	name = "1000 credit chip"
	icon_state = "spacecash1000"
	desc = "A Biesel Standard Credit chip, used for transactions large and small. This one is worth 1000电."
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
	desc = "A Biesel Standard Credit coin, called a 'unie'. This is worth 0.01电."
	worth = 0.01

/obj/item/spacecash/coin/c005
	name = "5 cent quin coin"
	icon_state = "spacecash0.05"
	desc = "A Biesel Standard Credit coin, called a 'quin'. This is worth 0.05电."
	worth = 0.05

/obj/item/spacecash/coin/c010
	name = "10 cent dece coin"
	icon_state = "spacecash0.10"
	desc = "A Biesel Standard Credit coin, called a 'dece'. This is worth 0.10电."
	worth = 0.10

/obj/item/spacecash/coin/c025
	name = "25 cent quarter coin"
	icon_state = "spacecash0.25"
	desc = "A Biesel Standard Credit coin, called a 'quarter'. This is worth 0.25电."
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
			return cash

	// spawn a bundle for mixed/odd amounts
	var/obj/item/spacecash/bundle/bundle = new(spawnloc)
	bundle.worth = cents / 100.0
	bundle.update_icon()
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(bundle)
	return bundle

// Adhomian knuckles use their own values, separate from Biesel Standard Credits.
/obj/item/adhomian_knuckle
	parent_type = /obj/item/currency
	name = "0 adhomian knuckle"
	desc = "A piece of Adhomian physical currency."
	icon = 'icons/obj/adhomianknuckle.dmi'
	icon_state = "adhomianknuckle1"
	currency_definition = /singleton/currency/adhomian_knuckles
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/adhomian_knuckle/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 2 || user == loc)
		var/singleton/currency/definition = get_currency_definition()
		. += SPAN_NOTICE("It is worth [definition.format_value(worth)], or [get_credit_value()] credits at the standard exchange rate.")

/obj/item/adhomian_knuckle/bundle
	name = "adhomian knuckles"
	icon_state = ""
	desc = "A bundle of Adhomian knuckles."
	worth = 0

/obj/item/adhomian_knuckle/bundle/update_icon()
	ClearOverlays()
	var/list/overlays_to_add = list()
	var/remaining = round(worth * 100)
	var/number_added = 0
	for(var/denomination in list(102400, 51200, 25600, 12800, 6400, 3200, 800, 400, 100, 8, 4, 1))
		while(remaining >= denomination && number_added < 50)
			remaining -= denomination
			number_added++
			var/denomination_value = denomination / 100
			var/image/knuckle = image('icons/obj/adhomianknuckle.dmi', "adhomianknuckle[denomination_value]")
			var/matrix/transform_matrix = matrix()
			transform_matrix.Translate(rand(-6, 6), rand(-4, 8))
			transform_matrix.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			knuckle.transform = transform_matrix
			overlays_to_add += knuckle
	AddOverlays(overlays_to_add)
	UpdateOverlays()
	desc = "A bundle of Adhomian knuckles."

/obj/item/adhomian_knuckle/bundle/attack_self(mob/user)
	var/amount = tgui_input_number(user, "How many knuckles do you want to take out? (0 to [worth])", "Take Knuckles", min(8, worth), worth, 0, 0, round_value = FALSE)
	if(QDELETED(src) || use_check_and_message(user, USE_FORCE_SRC_IN_USER) || !amount)
		return
	amount = min(round(amount, 0.01), worth)
	worth = round(worth - amount, 0.01)
	update_icon()
	var/obj/item/currency/split_currency = spawn_adhomian_knuckles(amount, user.loc)
	transfer_forensics_to(split_currency)
	user.put_in_any_hand_if_possible(split_currency)
	if(worth <= 0)
		user.drop_from_inventory(src)
		qdel(src)

/obj/item/adhomian_knuckle/k001
	name = "0.01 sani"
	desc = "A silver Adhomian coin of the sani denomination."
	icon_state = "adhomianknuckle0.01"
	worth = 0.01

/obj/item/adhomian_knuckle/k004
	name = "0.04 sani"
	desc = "A silver Adhomian coin of the sani denomination."
	icon_state = "adhomianknuckle0.04"
	worth = 0.04

/obj/item/adhomian_knuckle/k008
	name = "0.08 sani"
	desc = "A silver Adhomian coin of the sani denomination."
	icon_state = "adhomianknuckle0.08"
	worth = 0.08

/obj/item/adhomian_knuckle/k1
	name = "1 sako"
	desc = "An Adhomian coin of the sako denomination."
	icon_state = "adhomianknuckle1"
	worth = 1

/obj/item/adhomian_knuckle/k4
	name = "4 sako"
	desc = "An Adhomian coin of the sako denomination."
	icon_state = "adhomianknuckle4"
	worth = 4

/obj/item/adhomian_knuckle/k8
	name = "8 sako"
	desc = "An Adhomian coin of the sako denomination."
	icon_state = "adhomianknuckle8"
	worth = 8

/obj/item/adhomian_knuckle/k32
	name = "32 kalta"
	desc = "An Adhomian banknote of the kalta denomination."
	icon_state = "adhomianknuckle32"
	worth = 32
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/adhomian_knuckle/k64
	name = "64 kalta"
	desc = "An Adhomian banknote of the kalta denomination."
	icon_state = "adhomianknuckle64"
	worth = 64
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/adhomian_knuckle/k128
	name = "128 kalta"
	desc = "An Adhomian banknote of the kalta denomination."
	icon_state = "adhomianknuckle128"
	worth = 128
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/adhomian_knuckle/k256
	name = "256 kalta"
	desc = "An Adhomian banknote of the kalta denomination."
	icon_state = "adhomianknuckle256"
	worth = 256
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/adhomian_knuckle/k512
	name = "512 kalta"
	desc = "An Adhomian banknote of the kalta denomination."
	icon_state = "adhomianknuckle512"
	worth = 512
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/adhomian_knuckle/k1024
	name = "1024 kalta"
	desc = "An Adhomian banknote of the kalta denomination."
	icon_state = "adhomianknuckle1024"
	worth = 1024
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/proc/spawn_adhomian_knuckles(var/sum, var/spawnloc, var/mob/living/carbon/human/human_user)
	var/singleton/currency/currency = GET_SINGLETON(/singleton/currency/adhomian_knuckles)
	return currency.spawn_credit_value(currency.to_credits(sum), spawnloc, human_user)

/obj/item/spacecash/ewallet
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	can_bundle = FALSE
	var/owner_name = "unknown" //So the ATM can set it so the EFTPOS can put a valid name on transactions.
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/spacecash/ewallet/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 2 && user != loc)
		return
	if(src.owner_name)
		. += SPAN_NOTICE("The charge card's owner is [src.owner_name].")
	. += SPAN_NOTICE("It has [src.worth]电 left.")

/obj/item/spacecash/ewallet/c2000
	worth = 2000

/obj/item/spacecash/ewallet/c5000
	worth = 5000

/obj/item/spacecash/ewallet/c10000
	worth = 10000

// Persistent ewallet that keeps it's value across rounds.
// When spawned, using VV, set "worth", "initial_worth", "owner_name" and "name".
/obj/item/spacecash/ewallet/persistent_charge_card
	name = "specialized charge card"
	desc = "A specialized charge card that holds a certain amount of money. This type of charge card is in use for special purposes and not generally available."
	icon_state = "efundcard_special"
	var/initial_worth = 0 // Used for calculating how much cash was spend, needs to be set using VV after spawning it.
	persistent_objects_expiration_time_days = 360

/obj/item/spacecash/ewallet/persistent_charge_card/Initialize()
	. = ..()
	SSpersistence.objectsRegisterTrack(src)

/obj/item/spacecash/ewallet/persistent_charge_card/persistent_objects_get_content()
	var/list/content = list()
	content["name"] = src.name
	content["initial_worth"] = src.initial_worth
	content["worth"] = src.worth
	content["owner_name"] = src.owner_name
	return content

/obj/item/spacecash/ewallet/persistent_charge_card/persistent_objects_apply_content(content, x, y, z)
	name = isnull(content["name"]) ? src.name : content["name"]
	initial_worth = isnull(content["initial_worth"]) ? 0 : content["initial_worth"]
	worth = isnull(content["worth"]) ? 0 : content["worth"]
	owner_name = isnull(content["owner_name"]) ? src.owner_name : content["owner_name"]

	src.x = x
	src.y = y
	src.z = z

	// While the item features a persistent location, we want to return it to a safe spot if it is not in acceptable areas
	var/area/target_area
	var/area/A = get_area(src)
	if(A && (istype(A, /area/horizon/command) || istype(A, /area/horizon/storage/secure)))
		target_area = A // Command and vault areas are deemed safe
	else
		target_area = locate(/area/horizon/command/heads/xo_office) in GLOB.areas // Non safe area - XO office as fallback

	var/obj/structure/table/T = locate(/obj/structure/table) in target_area // Put it on a table
	if(T)
		src.x = T.x
		src.y = T.y
		src.z = T.z

/obj/item/spacecash/ewallet/persistent_charge_card/Destroy()
	log_and_message_admins("Persistent charge card ([src.name]) at [src] was destroyed!", null, get_turf(src))
	. = ..()
