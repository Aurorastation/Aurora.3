/obj/item/battle_monsters/deck
	name = "battle monsters deck"
	icon_state = "stack"
	w_class = WEIGHT_CLASS_SMALL
	var/list/stored_card_names = list()
	var/deck_size = 52

/obj/item/battle_monsters/deck/Initialize()
	. = ..()
	update_icon()

/obj/item/battle_monsters/deck/proc/get_top_card()
	return stored_card_names[stored_card_names.len]

/obj/item/battle_monsters/deck/proc/get_bottom_card()
	return stored_card_names[1]

/obj/item/battle_monsters/deck/proc/add_card(var/user, var/obj/item/battle_monsters/card/added_card)

	if(added_card.spell_datum)
		stored_card_names += "spell_type,[added_card.spell_datum.id],no_title"
	else if(added_card.trap_datum)
		stored_card_names += "trap_type,[added_card.trap_datum.id],no_title"
	else
		stored_card_names += "[added_card.prefix_datum.id],[added_card.root_datum.id],[added_card.suffix_datum.id]"

	qdel(added_card)

	update_icon()

/obj/item/battle_monsters/deck/proc/take_card(var/mob/user)

	if(icon_state == "stack") //Deck form
		user.visible_message(\
			SPAN_NOTICE("\The [user] draws a card from their [src]."),\
			SPAN_NOTICE("You draw a card from their [src].")\
		)
	else
		user.visible_message(\
			SPAN_NOTICE("\The [user] takes a card from their hand."),\
			SPAN_NOTICE("You take a card from your hand.")\
		)

	take_specific_card(user,get_top_card())

/obj/item/battle_monsters/deck/proc/take_specific_card(var/mob/user, var/card_id)
	if(card_id in stored_card_names)
		var/obj/item/battle_monsters/card/new_card = SSbattle_monsters.CreateCard(card_id,src.loc)

		if(!user.get_active_hand())
			user.put_in_active_hand(new_card)
		else if(!user.get_inactive_hand())
			user.put_in_inactive_hand(new_card)
		else
			to_chat(user, SPAN_NOTICE("Your hands are full!"))
			return

		new_card.pickup(user)
		stored_card_names -= card_id


	if(stored_card_names.len <= 0)
		qdel(src)
		return

	update_icon()

/obj/item/battle_monsters/deck/mouse_drop_receive(atom/dropped, mob/user, params) //Dropping C onto the card

	if(istype(dropped, /obj/item/battle_monsters/deck/))

		var/obj/item/battle_monsters/deck/added_deck = dropped
		stored_card_names += added_deck.stored_card_names

		user.visible_message(\
			SPAN_NOTICE("\The [user] combines two decks together."),\
			SPAN_NOTICE("You combine two decks together.")\
		)

		qdel(dropped)
		return

	. = ..()

/obj/item/battle_monsters/deck/update_icon()
	if(icon_state == "hand")
		name = "hand of [stored_card_names.len] battlemonster cards"
	else
		name = "deck of [stored_card_names.len] battlemonster cards"

	. = ..()

/obj/item/battle_monsters/deck/verb/toggle_mode()
	set category = "Object"
	set name = "Change Deck Type"
	set src in view(1)

	if (use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	if(icon_state == "hand")
		usr.visible_message(\
			SPAN_NOTICE("\The [usr] turns their hand into a stack of cards."),\
			SPAN_NOTICE("You turn your hand into a stack of cards.")\
		)
		icon_state = "stack"
	else
		usr.visible_message(\
			SPAN_NOTICE("\The [usr] turns their stack of cards into a hand."),\
			SPAN_NOTICE("You turn your stack of cards into a hand.")\
		)
		icon_state = "hand"

	update_icon()

/obj/item/battle_monsters/deck/verb/shuffle_deck()
	set category = "Object"
	set name = "Shuffle Deck"
	set src in view(1)

	if (use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	usr.visible_message(\
		SPAN_NOTICE("\The [usr] shuffles \the [src]."),\
		SPAN_NOTICE("You shuffle \the [src].")\
	)

	playsound(src.loc, 'sound/items/cardshuffle.ogg', 100, 1, -4)

	stored_card_names = shuffle(stored_card_names)

/obj/item/battle_monsters/deck/attack_hand(var/mob/user)
	if(isturf(src.loc))
		take_card(user)
	else
		. = ..()

/obj/item/battle_monsters/deck/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item,/obj/item/battle_monsters/card) && attacking_item != src)
		var/obj/item/battle_monsters/card/adding_card = attacking_item
		add_card(user,adding_card)

/obj/item/battle_monsters/deck/attack_self(mob/user)

	if(user != src.loc) //Idk how this is possible but you never know.
		to_chat(user, SPAN_NOTICE("You'll have to pick up \the [src] to examine the cards!"))
		return

	if(icon_state != "hand")
		user.visible_message(\
			SPAN_NOTICE("\The [usr] begins searching through \the [src]..."),\
			SPAN_NOTICE("You begin searching through your deck...")\
		)
		if(!do_after(user, 5 + stored_card_names.len, src))
			user.visible_message(\
				SPAN_NOTICE("\The [usr] stops and thinks better of it."),\
				SPAN_NOTICE("You stop and think better of it.")\
			)
			return

	BrowseDeck(user)

/obj/item/battle_monsters/deck/proc/BrowseDeck(var/mob/user)
	var/browse_data = ""
	for(var/cardname in stored_card_names)
		var/list/splitstring = dd_text2List(cardname,",")
		var/formatted_data
		if(splitstring[1] == "spell_type")
			formatted_data = SSbattle_monsters.FormatSpellText(SSbattle_monsters.GetSpellFormatting(),SSbattle_monsters.FindMatchingSpell(splitstring[2]))
		else if(splitstring[1] == "trap_type")
			formatted_data = SSbattle_monsters.FormatSpellText(SSbattle_monsters.GetTrapFormatting(),SSbattle_monsters.FindMatchingTrap(splitstring[2]))
		else
			var/datum/battle_monsters/element/prefix_datum = SSbattle_monsters.FindMatchingPrefix(splitstring[1])
			var/datum/battle_monsters/monster/root_datum = SSbattle_monsters.FindMatchingRoot(splitstring[2])
			var/datum/battle_monsters/title/suffix_datum = SSbattle_monsters.FindMatchingSuffix(splitstring[3])
			formatted_data = SSbattle_monsters.FormatMonsterText(SSbattle_monsters.GetMonsterFormatting(),prefix_datum,root_datum,suffix_datum)

		browse_data = "[formatted_data]<br><a href='byond://?src=[REF(src)];selection=[cardname]'>Draw Card</a><br><hr>[browse_data]"

	user << browse(browse_data, "window=battlemonsters_hand")

/obj/item/battle_monsters/deck/Topic(href,href_list)
	if(..())
		return 1

	if(href_list["selection"])
		take_specific_card(usr, href_list["selection"])
		BrowseDeck(usr)
