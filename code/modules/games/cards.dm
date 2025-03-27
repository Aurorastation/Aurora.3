/datum/playingcard
	var/name = "playing card"
	var/desc = null
	var/card_icon = "card_back"
	var/back_icon = "card_back"

/obj/item/deck
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/item/playing_cards.dmi'
	var/list/cards = list()
	var/hand_type

/obj/item/deck/attack(mob/living/target_mob, mob/living/user, target_zone)
	if (user.a_intent == I_HURT)
		. = ..()
	if(length(cards))
		if(target_mob == user)
			attack_self(user)
		else
			deal_card(user, target_mob)

/obj/item/deck/attack_self(mob/user, modifiers)
	if(length(cards) && (user.l_hand == src || user.r_hand == src))
		deal_card(user, user)
	. = ..()

/obj/item/deck/proc/generate_deck() //the procs that creates the cards
	return

/obj/item/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	desc_info = "Ctrl-click to draw/deal. Alt-click to shuffle."
	icon_state = "deck"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	hand_type = /obj/item/hand/cards

/obj/item/deck/Initialize()
	. = ..()
	generate_deck()

/obj/item/deck/cards/generate_deck()
	var/datum/playingcard/P
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten", "jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[number]_[suit]"
			P.back_icon = "card_back"
			cards += P

	for(var/i = 0,i<2,i++)
		P = new()
		P.name = "joker"
		P.card_icon = "joker"
		cards += P

/obj/item/deck/attack_hand(mob/user)
	if(length(cards))
		deal_card(user, user)
	else
		..()

/obj/item/deck/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/hand))
		var/obj/item/hand/H = attacking_item
		for(var/datum/playingcard/P in H.cards)
			cards += P
		qdel(attacking_item)
		return
	..()

/obj/item/deck/verb/drawcard()
	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from the deck."
	set src in view(1)

	draw_card(usr)

/obj/item/deck/proc/draw_card(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	var/obj/item/hand/H
	if(user.l_hand && istype(user.l_hand, /obj/item/hand))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand, /obj/item/hand))
		H = user.r_hand
	else
		H = new hand_type(get_turf(src))
		H.concealed = TRUE
		if(!user.put_in_hands(H))
			return

	if(!H || !user)
		return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.update_icon()
	balloon_alert_to_viewers("<b>\The [user]</b> draws a card.")
	if(!length(cards))
		qdel(src)

/obj/item/deck/verb/pickcard()
	set category = "Object"
	set name = "Pick"
	set desc = "Pick a card from the deck."
	set src in view(1)

	pick_card(usr)

/obj/item/deck/proc/pick_card(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	var/obj/item/hand/H
	if(user.l_hand && istype(user.l_hand,/obj/item/hand))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/hand))
		H = user.r_hand
	else
		H = new hand_type(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user)
		return

	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/discarding = tgui_input_list(user, "Which card do you wish to pick?", "Deck of Cards", to_discard)
	if(!discarding || !to_discard[discarding] || !user || !src)
		return

	var/datum/playingcard/P = to_discard[discarding]
	H.cards += P
	cards -= P
	H.update_icon()
	balloon_alert_to_viewers("<b>\The [user]</b> picks out a card.")
	if(!length(cards))
		qdel(src)

/obj/item/deck/verb/dealcard()
	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from the deck."
	set src in view(1)

	deal_card(usr, FALSE)

/obj/item/deck/proc/deal_card(mob/user, mob/living/target)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	if(!target)
		var/list/players = list()
		for(var/mob/living/player in viewers(3))
			if(!player.stat)
				players += player

		target = tgui_input_list(usr, "Who do you wish to deal a card?", "Deal", players)

	if(target == user)
		draw_card(user)
		return

	if(istype(get_step(target,target.dir), /obj/machinery/door/window) || istype(get_step(target,target.dir), (/obj/structure/window)))
		return // should stop you from dragging through windows

	if(!length(cards))
		to_chat(user, SPAN_WARNING("There are no cards in the deck."))
		return

	var/obj/item/hand/H = new hand_type(user.loc)

	H.randpixel = 6
	H.randpixel_xy()

	H.cards += cards[1]
	cards -= cards[1]
	H.concealed = TRUE
	H.update_icon()
	user.do_attack_animation(src, null)
	balloon_alert_to_viewers("<b>\The [user]</b> deals a card.")
	H.throw_at(get_step(target,target.dir), 10, 1, user, FALSE)
	if(!length(cards))
		qdel(src)

/obj/item/hand/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/hand))
		var/obj/item/hand/H = attacking_item
		user.visible_message("<b>\The [user]</b> adds \the [H] to their hand.", SPAN_NOTICE("You add \the [H] to your hand."))
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		qdel(src)
		H.update_icon()
		return
	if(istype(attacking_item, /obj/item/deck))
		var/obj/item/deck/D = attacking_item
		for(var/datum/playingcard/P in cards)
			D.cards += P
		qdel(src)
		return
	..()

/obj/item/deck/afterattack(obj/target, mob/user, proximity)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(target == user)
		return
	if (H in range(user, 3))
		deal_card(user, H)

/obj/item/deck/CtrlClick(var/mob/user as mob)
	draw_card(user)

/obj/item/deck/AltClick(var/mob/user as mob)
	. = ..()
	var/list/newcards = list()
	while(length(cards))
		var/datum/playingcard/P = pick(cards)
		newcards += P
		cards -= P
	cards = newcards
	playsound(src.loc, 'sound/items/cards/cardshuffle.ogg', 100, 1, -4)
	balloon_alert_to_viewers("<b>\The [user]</b> shuffles [src].")

/obj/item/pack
	name = "card pack"
	desc = "For those with disposible income."
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = "card_pack"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = WEIGHT_CLASS_TINY
	var/list/cards = list()

/obj/item/pack/attack_self(var/mob/user as mob)
	user.visible_message("<b>\The [user]</b> rips open \the [src]!")
	var/obj/item/hand/H = new()

	H.cards += cards
	cards.Cut();
	user.drop_from_inventory(src,get_turf(src))
	H.update_icon()
	user.put_in_active_hand(H)
	qdel(src)

/obj/item/hand
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = null
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = WEIGHT_CLASS_TINY
	var/deck_type

	var/concealed = TRUE
	var/list/cards = list()

/obj/item/hand/cards
	deck_type = /obj/item/deck/cards

/obj/item/hand/MouseEntered(location, control, params)
	. = ..()
	if(length(cards) == 1 && !concealed)
		var/datum/playingcard/P = cards[1]
		openToolTip(usr, src, params, P.name)

/obj/item/hand/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/hand/verb/pickcard()
	set category = "Object"
	set name = "Pick"
	set desc = "Pick a card from your hand in front of you."
	set src in usr

	pick_card(usr)

/obj/item/hand/proc/pick_card(var/mob/user, var/deploy_in_front = TRUE)
	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/input_text = "Which card do you wish to [deploy_in_front ? "put down" : "draw"]?"
	var/discarding = tgui_input_list(user, input_text, "Hand of Cards", to_discard)
	if(!discarding || !to_discard[discarding] || !user || !src)
		return

	var/datum/playingcard/card = to_discard[discarding]
	qdel(to_discard)

	var/obj/item/hand/H = new /obj/item/hand(src.loc)
	H.cards += card
	cards -= card
	H.concealed = FALSE
	H.update_icon()
	src.update_icon()
	playsound(src, 'sound/items/cards/cardflip.ogg', 50, TRUE)
	balloon_alert_to_viewers("<b>\The [user]</b> picks out a card.")
	if(deploy_in_front)
		H.forceMove(get_step(usr, usr.dir))
	else
		user.put_in_hands(H)

	if(!length(cards))
		qdel(src)

/obj/item/hand/attack_hand(mob/user)
	if(length(cards) > 1 && (user.l_hand == src || user.r_hand == src))
		pick_card(user, FALSE)
	else
		..()

/obj/item/hand/attack_self(var/mob/user as mob)
	concealed(user)

/obj/item/hand/CtrlClick(var/mob/user as mob)
	pick_card(user)

/obj/item/hand/AltClick(mob/user)
	concealed(user)

/obj/item/hand/proc/concealed(var/mob/user as mob)
	concealed = !concealed
	if(locate(/obj/structure/table) in loc)
		update_icon(user.dir)
	else
		update_icon()
	playsound(src, 'sound/items/cards/cardflip.ogg', 50, TRUE)
	balloon_alert_to_viewers("\The [user] [concealed ? "conceals" : "reveals"] their hand.")

/obj/item/hand/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if((!concealed || src.loc == user) && length(cards))
		if(length(cards) > 1)
			. += "It contains: "
		for(var/datum/playingcard/P in cards)
			. += "The [P.name]. [P.desc ? "<i>[P.desc]</i>" : ""]"

/obj/item/hand/update_icon(var/direction = 0)
	if(randpixel)
		randpixel = 0
		randpixel_xy(0)

	if(!length(cards))
		qdel(src)
		return
	else if(length(cards) > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else
		name = "playing card"
		desc = "A playing card."

	ClearOverlays()

	if(length(cards) == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		AddOverlays(I)
		return

	var/offset = FLOOR(20/length(cards), 1)

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Turn(0)
			if(SOUTH)
				M.Turn(180)
			if(WEST)
				M.Turn(270)
			if(EAST)
				M.Turn(90)
	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		//I.pixel_x = origin+(offset*i)
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.transform = M
		AddOverlays(I)
		i++

/obj/item/hand/dropped(mob/user)
	..()
	if(locate(/obj/structure/table) in get_step(user, user.dir))
		update_icon(user.dir)
	else
		update_icon(0)

/obj/item/hand/pickup(mob/user as mob)
	..()
	update_icon()

/obj/item/hand/verb/deck_card()
	set category = "Object"
	set name = "Deck"
	set desc = "Turn this hand of cards into a deck."
	set src in usr

	create_deck(usr)

/obj/item/hand/proc/create_deck(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return
	if(!deck_type)
		to_chat(usr, SPAN_WARNING("You can't turn \the [src] into a deck."))
		return

	var/obj/item/deck/D = new deck_type(new(user.loc))

	if(!D || !user)
		return

	D.cards = cards
	balloon_alert_to_viewers("<b>\The [user]</b> turns his hand into a deck.")
	qdel(src)
	user.put_in_hands(D)
