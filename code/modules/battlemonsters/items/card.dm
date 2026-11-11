/obj/item/battle_monsters/card
	name = "battle monsters card"
	desc = "A battle monster's card."

	var/card_type = BATTLE_MONSTERS_CARDTYPE_MONSTER
	var/datum/battle_monsters/element/prefix_datum
	var/datum/battle_monsters/monster/root_datum
	var/datum/battle_monsters/title/suffix_datum

	var/datum/battle_monsters/spell/spell_datum
	var/datum/battle_monsters/trap/trap_datum

	w_class = WEIGHT_CLASS_TINY
	drop_sound = null

	//Card information here

/obj/item/battle_monsters/card/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()

	if(facedown && src.loc != user)
		. += SPAN_NOTICE("You can't examine \the [src] while it's face down!")
		return

	if(trap_datum)
		SSbattle_monsters.ExamineTrapCard(user,trap_datum)
	else if(spell_datum)
		SSbattle_monsters.ExamineSpellCard(user,spell_datum)
	else
		SSbattle_monsters.ExamineMonsterCard(user,prefix_datum,root_datum,suffix_datum)

/obj/item/battle_monsters/card/Initialize(var/mapload,var/prefix,var/root,var/title,var/trap,var/spell)
	. = ..()
	Generate_Card(prefix, root, title, trap, spell)

/obj/item/battle_monsters/card/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item,/obj/item/battle_monsters/card) && attacking_item != src)
		var/obj/item/battle_monsters/card/adding_card = attacking_item
		make_deck(user,adding_card)

/obj/item/battle_monsters/card/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(istype(A,/obj/structure/table) || istype(A,/obj/structure/dueling_table))
		user.visible_message(\
			SPAN_NOTICE("\The [user] plays \the [src]!"),\
			SPAN_NOTICE("You play \the [src]!")\
		)
	..(A, user, click_parameters)

/obj/item/battle_monsters/card/attack_self(mob/user as mob)
	flip_card(user)

/obj/item/battle_monsters/card/proc/make_deck(var/mob/user,var/obj/item/battle_monsters/card/adding_card)

	var/obj/item/battle_monsters/deck/new_deck = new(src.loc)

	if(src.loc == user)
		//Make a hand.
		user.drop_from_inventory(src)
		new_deck.icon_state = "hand"
		user.put_in_inactive_hand(new_deck)
		to_chat(user, SPAN_NOTICE("You combine \the [src] and the [adding_card] to form a hand."))
	else
		new_deck.set_dir(dir)
		new_deck.pixel_x = pixel_x
		new_deck.pixel_y = pixel_y
		new_deck.layer = max(layer,new_deck.layer)
		user.visible_message(\
			SPAN_NOTICE("\The [user] combines \the [src] and the [adding_card] to form a deck."),\
			SPAN_NOTICE("You combine \the [src] and the [adding_card] to form a deck.")\
		)

	new_deck.add_card(user,src)
	new_deck.add_card(user,adding_card)

/obj/item/battle_monsters/card/proc/flip_card(var/mob/user)
	facedown = !facedown

	if(src.loc == user)
		if(!facedown)
			to_chat(user, SPAN_NOTICE("You reveal \the [name] to yourself, preparing to play it face up."))
		else
			to_chat(user, SPAN_NOTICE("You prepare \the [name] to be played face down."))
	else
		if(!facedown)
			user.visible_message(\
				SPAN_NOTICE("\The [user] flip the card face up and reveals \the [name]."),\
				SPAN_NOTICE("You flip the card face up and reveal \the [name].")\
			)
		else
			user.visible_message(\
				SPAN_NOTICE("\The [user] flips \the [name] face down."),\
				SPAN_NOTICE("You flip \the [name] face down.")\
			)

	update_icon()

/obj/item/battle_monsters/card/proc/Generate_Card(var/prefix,var/root,var/title,var/trap,var/spell)

	if(trap)
		trap_datum = SSbattle_monsters.FindMatchingTrap(trap,TRUE)
		update_icon()
		return

	if(spell)
		spell_datum = SSbattle_monsters.FindMatchingSpell(spell,TRUE)
		update_icon()
		return

	if(prefix)
		prefix_datum = SSbattle_monsters.FindMatchingPrefix(prefix,TRUE)
	else
		prefix_datum = SSbattle_monsters.GetRandomPrefix()

	if(root)
		root_datum = SSbattle_monsters.FindMatchingRoot(root,TRUE)
	else
		root_datum = SSbattle_monsters.GetRandomRoot()

	var/rarity_score = prefix_datum.rarity_score + root_datum.rarity_score

	if(title)
		suffix_datum = SSbattle_monsters.FindMatchingSuffix(title,TRUE)
	else if(rarity_score >= 3)
		suffix_datum = SSbattle_monsters.GetRandomSuffix()
	else
		suffix_datum = SSbattle_monsters.FindMatchingSuffix("no_title",TRUE)

/obj/item/battle_monsters/card/update_icon()

	ClearOverlays()

	if(facedown)
		icon_state = "back"
	else

		var/rounded_rarity_score

		if(trap_datum)
			rounded_rarity_score = trap_datum.rarity_score
		else if(spell_datum)
			rounded_rarity_score = spell_datum.rarity_score
		else
			rounded_rarity_score = prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score

		rounded_rarity_score = min(max(round(rounded_rarity_score,1),1),4)

		icon_state = "front_r_[rounded_rarity_score]"
		AddOverlays("front_label")

		if(trap_datum && trap_datum.icon_state)
			AddOverlays(trap_datum.icon_state)

		if(spell_datum && spell_datum.icon_state)
			AddOverlays(spell_datum.icon_state)

		if(prefix_datum && prefix_datum.icon_state)
			AddOverlays(prefix_datum.icon_state)

		if(root_datum && root_datum.icon_state)
			AddOverlays(root_datum.icon_state)

		if(suffix_datum && suffix_datum.icon_state)
			AddOverlays(suffix_datum.icon_state)

		if(rounded_rarity_score >= 2)
			AddOverlays("rarity_animation")

	var/matrix/M = matrix()
	switch(dir)
		if(NORTH)
			M.Turn(0)
		if(SOUTH)
			M.Turn(180)
		if(WEST)
			M.Turn(270)
		if(EAST)
			M.Turn(90)

	transform = M

/obj/item/battle_monsters/card/MouseEntered(location, control, params)
	. = ..()
	if(!facedown || Adjacent(usr))
		var/card_title = name
		var/card_content = desc
		if(trap_datum)
			card_title = trap_datum.name
			card_content = SSbattle_monsters.FormatSpellText(SSbattle_monsters.GetTrapFormatting(FALSE), trap_datum, FALSE)
		else if(spell_datum)
			card_title = spell_datum.name
			card_content = SSbattle_monsters.FormatSpellText(SSbattle_monsters.GetSpellFormatting(FALSE), spell_datum, FALSE)
		else
			card_title = root_datum.name
			card_content = SSbattle_monsters.FormatMonsterText(SSbattle_monsters.GetMonsterFormatting(FALSE), prefix_datum, root_datum, suffix_datum, FALSE)
		openToolTip(usr, src, params, card_title, card_content)

/obj/item/battle_monsters/card/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)
