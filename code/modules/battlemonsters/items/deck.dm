/obj/item/battle_monsters/deck
	name = "battle monsters deck"
	icon_state = "stack"
	w_class = ITEMSIZE_SMALL
	var/list/stored_card_names = list()
	var/deck_size = 52

/obj/item/battle_monsters/deck/proc/get_top_card()
	return stored_card_names[stored_card_names.len]

/obj/item/battle_monsters/deck/proc/get_bottom_card()
	return stored_card_names[1]

/obj/item/battle_monsters/deck/proc/add_card(var/user, var/obj/item/battle_monsters/card/added_card)
	stored_card_names += "[added_card.prefix_datum.id],[added_card.root_datum.id],[added_card.suffix_datum.id]"
	qdel(added_card)

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

	var/top_card = get_top_card()
	var/list/splitstring = dd_text2List(top_card,",")
	var/obj/item/battle_monsters/card/new_card = new(src.loc,splitstring[1],splitstring[2],splitstring[3])
	user.put_in_active_hand(new_card)
	new_card.pickup(user)
	stored_card_names -= top_card

	if(stored_card_names.len <= 0)
		qdel(src)

/obj/item/battle_monsters/deck/proc/take_specific_card(var/mob/user, var/card_id)
	if(card_id in stored_card_names)
		var/list/splitstring = dd_text2List(card_id,",")
		var/obj/item/battle_monsters/card/new_card = new(get_turf(src),splitstring[1],splitstring[2],splitstring[3])
		user.put_in_active_hand(new_card)
		new_card.pickup(user)
		stored_card_names -= card_id

	if(stored_card_names.len <= 0)
		qdel(src)

/obj/item/battle_monsters/deck/MouseDrop_T(var/atom/movable/C, mob/user) //Dropping C onto the card
	if(istype(C,/obj/item/battle_monsters/deck/) && C.loc == loc)
		var/obj/item/battle_monsters/deck/added_deck = C
		added_deck.stored_card_names += stored_card_names

		user.visible_message(\
			span("notice","\The [user] combines two decks together."),\
			span("notice","You combine too decks together.")\
		)

		qdel(src)
		return

	. = ..()

/obj/item/battle_monsters/deck/verb/toggle_mode()
	set category = "Object"
	set name = "Change Deck Type"
	set src in view(1)

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

/obj/item/battle_monsters/deck/verb/shuffle()
	set category = "Object"
	set name = "Shuffle Deck"
	set src in view(1)

	usr.visible_message(\
		span("notice","\The [usr] shuffles \the [src]."),\
		span("notice","You shuffle \the [src].")\
	)

	stored_card_names = shuffle(stored_card_names)

/obj/item/battle_monsters/deck/attack_hand(var/mob/user)
	take_card(user)

/obj/item/battle_monsters/deck/attackby(var/obj/item/attacking, var/mob/user)
	if(istype(attacking,/obj/item/battle_monsters/card) && attacking != src)
		var/obj/item/battle_monsters/card/adding_card = attacking
		add_card(user,adding_card)

/obj/item/battle_monsters/deck/proc/Generate_Deck()
	for(var/i=1,i < deck_size,i++)
		CHECK_TICK //This stuff is a little intensive I think.
		var/datum/battle_monsters/selected_root = SSbattlemonsters.GetRandomRoot()
		var/datum/battle_monsters/selected_prefix = SSbattlemonsters.GetRandomPrefix()
		var/datum/battle_monsters/selected_suffix = SSbattlemonsters.GetRandomSuffix()
		stored_card_names += "[selected_root.id],[selected_prefix.id],[(selected_prefix.rarity_score + selected_root.rarity_score) >= 3 ? selected_suffix.id : "no_title"]"

/obj/item/battle_monsters/deck/generated/New()
	. = ..()
	Generate_Deck()

/obj/item/battle_monsters/deck/attack_self(mob/user)

	if(user != src.loc) //Idk how this is possible but you never know.
		to_chat(user,span("notice","You'll have to pick up \the [src] to examine the cards!"))

	if(icon_state != "hand")
		user.visible_message(\
			span("notice","\The [usr] begins searching through \the [src]..."),\
			span("notice","You begin searching through your deck..")\
		)
		if(!do_after(user, 40, act_target = src))
			user.visible_message(\
				span("notice","\The [usr] stops and thinks better of it."),\
				span("notice","You top and think better of it.")\
			)
			return

	var/browse_data = ""

	for(var/cardname in stored_card_names)
		var/list/splitstring = dd_text2List(cardname,",")
		var/datum/battle_monsters/selected_prefix = SSbattlemonsters.FindMatchingPrefix(splitstring[1])
		var/datum/battle_monsters/selected_root = SSbattlemonsters.FindMatchingRoot(splitstring[2])
		var/datum/battle_monsters/selected_suffix = SSbattlemonsters.FindMatchingSuffix(splitstring[3])
		browse_data += SSbattlemonsters.FormatText(SSbattlemonsters.GetFormatting(),selected_prefix,selected_root,selected_suffix) + "<br><a href='?src=\ref[src];selection=[cardname]'>Draw Card</a><br><hr>"

	user << browse(browse_data, "window=battlemonsters_hand")

/obj/item/battle_monsters/deck/Topic(href,href_list)
	if(..())
		return 1

	if(href_list["selection"])
		take_specific_card(usr, href_list["selection"])
		usr << browse(null, "window=battlemonsters_hand")
