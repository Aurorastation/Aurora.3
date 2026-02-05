/datum/trader
	/// The name of the trader in question
	var/name = "unsuspicious trader"
	/// The place that they are trading from
	var/origin = "some place"
	/// Possible names of the trader origin
	var/list/possible_origins
	/// The current disposition of them to us.
	var/disposition = 0
	/// Flags
	var/trade_flags = TRADER_MONEY
	/// If this is set to a language name this will generate a name from the language
	var/name_language
	/// The icon that shows up in the menu @TODO
	var/icon/portrait
	/// List of species that trader will have a bias against (type = variant)
	var/list/species_bias = list() //for silicons (robots), use "Silicon"

	/// What items they enjoy trading for. Structure is (type = known/unknown)
	var/list/wanted_items = list()
	/// List of all possible wanted items. Structure is (type = mode)
	var/list/possible_wanted_items
	/// List of all possible trading items. Structure is (type = mode)
	var/list/possible_trading_items
	/// What items they are currently trading away.
	var/list/trading_items = list()
	/// Things they will automatically refuse
	var/list/blacklisted_trade_items = list(/mob/living/carbon/human)
	/// Which sector(s) this merchant can show up
	var/list/allowed_space_sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_TABITI, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL,
										SECTOR_GAKAL, SECTOR_UUEOAESA)

	/// The list of all their replies and messages. Structure is (id = talk)
	var/list/speech = list()

	/*SPEECH IDS:
	hail_generic		When merchants hail a person
	hail_[race]			Race specific hails
	hail_deny			When merchant denies a hail

	insult_good			When the player insults a merchant while they are on good disposition
	insult_bad			When a player insults a merchatn when they are not on good disposition
	complement_accept	When the merchant accepts a complement
	complement_deny		When the merchant refuses a complement

	how_much			When a merchant tells the player how much something is.
	trade_complete		When a trade is made
	trade_refuse		When a trade is refused

	what_want			What the person says when they are asked if they want something

	*/
	/// How much wanted items are multiplied by when traded for
	var/want_multiplier = 2
	/// How far disposition drops on insult
	var/insult_drop = 5
	/// How far compliments increase disposition
	var/compliment_increase = 5
	/// Whether they refuse further communication
	var/refuse_comms = FALSE

	/// What message gets sent to mobs that get sold.
	var/mob_transfer_message = "You are transported to ORIGIN."

/datum/trader/New()
	..()
	if(name_language)
		if(name_language == TRADER_DEFAULT_NAME)
			name = capitalize(pick(GLOB.first_names_female + GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
		else
			var/datum/language/L = GLOB.all_languages[name_language]
			if(L)
				name = L.get_random_name(pick(MALE,FEMALE))
	if(possible_origins && possible_origins.len)
		origin = pick(possible_origins)

	for(var/i in 5 to 8)
		add_to_pool(trading_items, possible_trading_items, force = 1)
		add_to_pool(wanted_items, possible_wanted_items, force = 1)

//If this hits 0 then they decide to up and leave.
/datum/trader/proc/tick()
	addtimer(CALLBACK(src, PROC_REF(do_after_tick)), 1)
	return 1

/datum/trader/proc/do_after_tick()
	add_to_pool(trading_items, possible_trading_items, 200)
	add_to_pool(wanted_items, possible_wanted_items, 50)
	remove_from_pool(possible_trading_items, 9) //We want the stock to change every so often, so we make it so that they have roughly 10~11 ish items max
	return

/datum/trader/proc/remove_from_pool(var/list/pool, var/chance_per_item)
	if(pool && prob(chance_per_item * pool.len))
		var/i = rand(1,pool.len)
		pool[pool[i]] = null
		pool -= pool[i]

/// Gets bias from trader
/datum/trader/proc/get_bias(var/mob/user)
	var/species
	if(ishuman(user))
		var/mob/living/carbon/human/person = user
		species = person.species.name
	else if (issilicon(user))
		species = "Silicon"

	if(!species || !species_bias) // No species to be biased against
		return FALSE

	// Flatten list
	for(var/item in species_bias)
		var/result = species_bias[item]
		if(islist(item))
			if(species in flatten_list(item))
				return result
		else if(species == item)
			return result
	// At this point, species is not on bias list
	return FALSE

/datum/trader/proc/add_to_pool(var/list/pool, var/list/possible, var/base_chance = 100, var/force = 0)
	var/divisor = 1
	if(pool && pool.len)
		divisor = pool.len
	if(force || prob(base_chance/divisor))
		var/new_item = get_possible_item(possible)
		if(new_item)
			pool |= new_item

/datum/trader/proc/get_possible_item(var/list/trading_pool)
	if(!trading_pool || !trading_pool.len)
		return
	var/list/possible = list()
	for(var/type in trading_pool)
		var/status = trading_pool[type]
		if(status & TRADER_THIS_TYPE)
			possible += type
		if(status & TRADER_SUBTYPES_ONLY)
			possible += subtypesof(type)
		if(status & TRADER_BLACKLIST)
			possible -= type
		if(status & TRADER_BLACKLIST_SUB)
			possible -= subtypesof(type)

	if(possible.len)
		var/picked = pick(possible)
		var/atom/A = picked
		if(initial(A.name) in list("object", "item","weapon", "structure", "machinery", "exosuit", "organ", "snack")) //weed out a few of the common bad types. Reason we don't check types specifically is that (hopefully) further bad subtypes don't set their name up and are similar.
			return
		return picked

/datum/trader/proc/get_response(var/key, var/default)
	var/text
	if(speech && speech[key])
		text = speech[key]
	else
		text = default
	text = replacetext(text, "MERCHANT", name)
	return replacetext(text, "ORIGIN", origin)

/datum/trader/proc/print_trading_items(var/num)
	num = clamp(num,1,trading_items.len)
	if(trading_items[num])
		var/atom/movable/M = trading_items[num]
		return "[initial(M.name)]"

/datum/trader/proc/get_item_value(var/trading_num, var/mob/user)
	if(!trading_items[trading_items[trading_num]])
		var/type = trading_items[trading_num]
		var/value = get_value(type)
		value = round(rand(80,100)/100 * value) //For some reason rand doesn't like decimals.
		trading_items[type] = value
	// Apply Racism
	// defaults at 1, adjusts based on bias
	var/modifier = 1
	var/bias = get_bias(user)
	if(bias == TRADER_BIAS_UPCHARGE)
		modifier = 1.2 // 20% upcharge
	else if(bias == TRADER_BIAS_DISCOUNT)
		modifier = 0.8 // 20% discount
	return round(trading_items[trading_items[trading_num]] * modifier)

/datum/trader/proc/offer_money_for_trade(var/trade_num, var/money_amount, var/mob/user)
	if(!(trade_flags & TRADER_MONEY))
		return TRADER_NO_MONEY
	var/value = get_item_value(trade_num, user)
	if(money_amount < value)
		return TRADER_NOT_ENOUGH

	return value

/datum/trader/proc/offer_items_for_trade(var/list/offers, var/num, var/turf/location, var/mob/user)
	if(!offers || !offers.len)
		return TRADER_NOT_ENOUGH
	num = clamp(num, 1, trading_items.len)
	var/offer_worth = 0
	for(var/item in offers)
		var/atom/movable/offer = item
		var/is_wanted = FALSE
		if(is_type_in_list(offer,wanted_items))
			is_wanted = TRUE
		if(blacklisted_trade_items && blacklisted_trade_items.len)
			if(ishuman(offer))
				var/mob/living/carbon/human/A = offer
				if(is_type_in_list(A.species, blacklisted_trade_items))
					return FALSE
			else if(is_type_in_list(offer,blacklisted_trade_items))
				return FALSE

		if(istype(offer,/obj/item/spacecash))
			if(!(trade_flags & TRADER_MONEY))
				return TRADER_NO_MONEY
		else
			if(!(trade_flags & TRADER_GOODS))
				return TRADER_NO_GOODS
			else if((trade_flags & TRADER_WANTED_ONLY) && !is_wanted)
				return TRADER_FOUND_UNWANTED

		offer_worth += get_value(offer) * (is_wanted ? want_multiplier : 1)
	if(!offer_worth)
		return TRADER_NOT_ENOUGH
	var/trading_worth = get_item_value(num, user)
	if(!trading_worth)
		return TRADER_NOT_ENOUGH
	var/percent = offer_worth/trading_worth
	if(percent > max(0.9,0.9-disposition/100))
		return trade(offers, num, location)
	return TRADER_NOT_ENOUGH

/datum/trader/proc/hail(var/mob/user)
	// specific subspecies
	var/specific
	// species, used if specific hail not found
	var/general
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species)
			var/list/all_lists = list(
				ALL_HUMAN_SPECIES  = "Human",
				ALL_DIONA_SPECIES  = "Diona",
				ALL_SKRELL_SPECIES = "Skrell",
				ALL_TAJARA_SPECIES = "Tajara",
				ALL_VAURCA_SPECIES = "Vaurca",
				ALL_IPC_SPECIES    = "IPC"
			)
			for(var/list/species_list in all_lists)
				if(H.species.name in species_list)
					general = all_lists[species_list]
					break
			// grab subspecies
			specific = H.species.name
	else if(istype(user, /mob/living/silicon))
		specific = "silicon"
	if(!speech["hail_[specific]"])
		//check for generic
		if(speech["hail_[general]"])
			specific = general //we override specific with general to call it
		else
			specific = "generic"
	. = get_response("hail_[specific]", "Greetings, MOB!")
	. = replacetext(., "MOB", user.name)

/datum/trader/proc/can_hail(var/mob/user)
	if(!refuse_comms && prob(-disposition))
		refuse_comms = TRUE
	else if(!refuse_comms && get_bias(user) == TRADER_BIAS_DENY)
		refuse_comms = TRUE

	return !refuse_comms

/datum/trader/proc/insult()
	disposition -= rand(insult_drop, insult_drop * 2)
	if(prob(-disposition/10))
		refuse_comms = 1
	if(disposition > 50)
		return get_response("insult_good","What? I thought we were cool!")
	else
		return get_response("insult_bad", "Right back at you asshole!")

/datum/trader/proc/compliment()
	if(prob(-disposition))
		return get_response("compliment_deny", "Fuck you!")
	if(prob(100-disposition))
		disposition += rand(compliment_increase, compliment_increase * 2)
	return get_response("compliment_accept", "Thank you!")

/datum/trader/proc/trade(var/list/offers, var/num, var/turf/location)
	if(offers && offers.len)
		for(var/offer in offers)
			if(istype(offer,/mob))
				var/text = mob_transfer_message
				to_chat(offer, replacetext(text, "ORIGIN", origin))
			qdel(offer)

	var/type = trading_items[num]

	var/atom/movable/M = new type(location)
	playsound(location, 'sound/effects/teleport.ogg', 50, 1)

	disposition += rand(compliment_increase,compliment_increase*3) //Traders like it when you trade with them

	return M

/datum/trader/proc/how_much_do_you_want(var/num, var/mob/user)
	var/atom/movable/M = trading_items[num]
	. = get_response("how_much", "Hmm.... how about VALUE credits?")
	. = replacetext(.,"VALUE",get_item_value(num, user))
	. = replacetext(.,"ITEM", initial(M.name))

/datum/trader/proc/what_do_you_want()
	if(!(trade_flags & TRADER_GOODS))
		return get_response(TRADER_NO_GOODS, "I don't deal in goods.")

	. = get_response("what_want", "Hm, I want")
	var/list/want_english = list()
	for(var/type in wanted_items)
		var/atom/a = type
		want_english += initial(a.name)
	. += " [english_list(want_english)]"

/datum/trader/proc/sell_items(var/list/offers)
	if(!(trade_flags & TRADER_GOODS))
		return TRADER_NO_GOODS
	if(!offers || !offers.len)
		return TRADER_NOT_ENOUGH

	for(var/offer in offers)
		if(!is_type_in_list(offer,wanted_items))
			return TRADER_FOUND_UNWANTED

	playsound(get_turf(offers[1]), 'sound/effects/teleport.ogg', 50, 1)
	. = 0
	for(var/offer in offers)
		. += get_value(offer) * want_multiplier
		qdel(offer)

/datum/trader/proc/bribe_to_stay_longer(var/amt)
	return get_response("bribe_refusal", "How about... no?")

/datum/trader/proc/system_allowed()
	if(SSatlas.current_sector.name in allowed_space_sectors)
		return TRUE
	else
		return FALSE
