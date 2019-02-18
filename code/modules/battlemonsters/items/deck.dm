/obj/item/battle_monsters/deck
	name = "battle monsters deck"
	icon_state = "stack"
	w_class = ITEMSIZE_SMALL
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
			span("notice","\The [user] draws a card from their [src]."),\
			span("notice","You draw a card from their [src].")\
		)
	else
		user.visible_message(\
			span("notice","\The [user] takes a card from their hand."),\
			span("notice","You take a card from your hand.")\
		)

	take_specific_card(user,get_top_card())

/obj/item/battle_monsters/deck/proc/take_specific_card(var/mob/user, var/card_id)
	if(card_id in stored_card_names)
		var/obj/item/battle_monsters/card/new_card = SSbattlemonsters.CreateCard(card_id,src.loc)

		if(!user.get_active_hand())
			user.put_in_active_hand(new_card)
		else if(!user.get_inactive_hand())
			user.put_in_inactive_hand(new_card)
		else
			to_chat(user,span("notice","Your hands are full!"))
			return

		new_card.pickup(user)
		stored_card_names -= card_id


	if(stored_card_names.len <= 0)
		qdel(src)
		return

	update_icon()

/obj/item/battle_monsters/deck/MouseDrop_T(var/atom/movable/C, mob/user) //Dropping C onto the card

	if(istype(C,/obj/item/battle_monsters/deck/))

		var/obj/item/battle_monsters/deck/added_deck = C
		stored_card_names += added_deck.stored_card_names

		user.visible_message(\
			span("notice","\The [user] combines two decks together."),\
			span("notice","You combine two decks together.")\
		)

		qdel(C)
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

	if (use_check(usr, USE_DISALLOW_SILICONS))
		return

	if(icon_state == "hand")
		usr.visible_message(\
			span("notice","\The [usr] turns their hand into a stack of cards."),\
			span("notice","You turn your hand into a stack of cards.")\
		)
		icon_state = "stack"
	else
		usr.visible_message(\
			span("notice","\The [usr] turns their stack of cards into a hand."),\
			span("notice","You turn your stack of cards into a hand.")\
		)
		icon_state = "hand"

	update_icon()

/obj/item/battle_monsters/deck/verb/shuffle_deck()
	set category = "Object"
	set name = "Shuffle Deck"
	set src in view(1)

	if (use_check(usr, USE_DISALLOW_SILICONS))
		return

	usr.visible_message(\
		span("notice","\The [usr] shuffles \the [src]."),\
		span("notice","You shuffle \the [src].")\
	)

	playsound(src.loc, 'sound/items/cardshuffle.ogg', 100, 1, -4)

	stored_card_names = shuffle(stored_card_names)

/obj/item/battle_monsters/deck/attack_hand(var/mob/user)
	if(isturf(src.loc))
		take_card(user)
	else
		. = ..()

/obj/item/battle_monsters/deck/attackby(var/obj/item/attacking, var/mob/user)
	if(istype(attacking,/obj/item/battle_monsters/card) && attacking != src)
		var/obj/item/battle_monsters/card/adding_card = attacking
		add_card(user,adding_card)

/obj/item/battle_monsters/deck/attack_self(mob/user)

	if(user != src.loc) //Idk how this is possible but you never know.
		to_chat(user,span("notice","You'll have to pick up \the [src] to examine the cards!"))
		return

	if(icon_state != "hand")
		user.visible_message(\
			span("notice","\The [usr] begins searching through \the [src]..."),\
			span("notice","You begin searching through your deck...")\
		)
		if(!do_after(user, 5 + stored_card_names.len, act_target = src))
			user.visible_message(\
				span("notice","\The [usr] stops and thinks better of it."),\
				span("notice","You stop and think better of it.")\
			)
			return

	BrowseDeck(user)

/obj/item/battle_monsters/deck/proc/BrowseDeck(var/mob/user)
	var/browse_data = ""
	for(var/cardname in stored_card_names)
		var/list/splitstring = dd_text2List(cardname,",")
		var/formatted_data
		if(splitstring[1] == "spell_type")
			formatted_data = SSbattlemonsters.FormatSpellText(SSbattlemonsters.GetSpellFormatting(),SSbattlemonsters.FindMatchingSpell(splitstring[2]))
		else if(splitstring[1] == "trap_type")
			formatted_data = SSbattlemonsters.FormatSpellText(SSbattlemonsters.GetTrapFormatting(),SSbattlemonsters.FindMatchingTrap(splitstring[2]))
		else
			var/datum/battle_monsters/element/prefix_datum = SSbattlemonsters.FindMatchingPrefix(splitstring[1])
			var/datum/battle_monsters/monster/root_datum = SSbattlemonsters.FindMatchingRoot(splitstring[2])
			var/datum/battle_monsters/title/suffix_datum = SSbattlemonsters.FindMatchingSuffix(splitstring[3])
			formatted_data = SSbattlemonsters.FormatMonsterText(SSbattlemonsters.GetMonsterFormatting(),prefix_datum,root_datum,suffix_datum)

		browse_data = "[formatted_data]<br><a href='?src=\ref[src];selection=[cardname]'>Draw Card</a><br><hr>[browse_data]"

	to_chat(user, browse(browse_data, "window=battlemonsters_hand"))

/obj/item/battle_monsters/deck/Topic(href,href_list)
	if(..())
		return 1

	if(href_list["selection"])
		take_specific_card(usr, href_list["selection"])
		BrowseDeck(usr)
