/obj/item/battle_monsters/
	icon = 'icons/obj/battle_monsters/card.dmi'
	icon_state = ""


/obj/item/battle_monsters/card
	name = "battle monsters card"
	desc = "A battle monster's card."
	var/datum/battle_monsters/element/prefix_datum
	var/datum/battle_monsters/monster/root_datum
	var/datum/battle_monsters/title/suffix_datum

	//Card information here
	var/card_name = ""
	var/card_prefix
	var/card_root
	var/card_suffix
	var/card_description = ""
	var/card_special_effects = ""
	var/card_elements = BATTLE_MONSTERS_ELEMENT_NONE
	var/card_attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE
	var/card_defense_type = BATTLE_MONSTERS_DEFENSETYPE_NONE
	var/card_attack_points = 0
	var/card_defense_points = 0
	var/card_rarity_score = 0
	var/card_power = 0
	var/card_type = "Monster Card"

	var/facedown = FALSE

/obj/item/battle_monsters/card/New(var/prefix,var/root,var/title)
	Generate_Card(prefix, root, title)

/obj/item/battle_monsters/card/proc/Generate_Card(var/prefix,var/root,var/title)

	if(prefix)
		prefix_datum = SSbattlemonsters.FindMatchingPrefix(prefix,TRUE)
	else
		prefix_datum = SSbattlemonsters.GetRandomPrefix()

	if(root)
		root_datum = SSbattlemonsters.FindMatchingRoot(root,TRUE)
	else
		root_datum = SSbattlemonsters.GetRandomRoot()

	var/rarity_score = prefix_datum.rarity_score + root_datum.rarity_score

	if(title)
		suffix_datum = SSbattlemonsters.FindMatchingSuffix(title,TRUE)
	else
		suffix_datum = SSbattlemonsters.GetRandomSuffix()
	else
		suffix_datum = SSbattlemonsters.FindMatchingSuffix("no_title",TRUE)

	card_prefix = prefix_datum.name
	card_root = root_datum.name
	card_suffix = suffix_datum.name

	update_icon()

/obj/item/battle_monsters/card/update_icon()
	//Icon updating also updates it's information.
	card_name = "[prefix_datum.name] [root_datum.name]"
	if(suffix_datum.name)
		card_name += ", [suffix_datum.name]"

	card_description = "[root_datum.description] [prefix_datum.description]"
	if(suffix_datum.description)
		card_description += "<br><i>[suffix_datum.description]</i>"

	if(prefix_datum.special_effects)
		card_special_effects += prefix_datum.special_effects + "<br>"

	if(root_datum.special_effects)
		card_special_effects += root_datum.special_effects + "<br>"

	if(suffix_datum.special_effects)
		card_special_effects += suffix_datum.special_effects + "<br>"

	card_elements = prefix_datum.elements | root_datum.elements | suffix_datum.elements
	card_attack_type = prefix_datum.attack_type | root_datum.attack_type | suffix_datum.attack_type
	card_defense_type = prefix_datum.defense_type | root_datum.defense_type | suffix_datum.defense_type
	card_rarity_score = prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score

	card_attack_points = (prefix_datum.attack_add + root_datum.attack_add + suffix_datum.attack_add) * (prefix_datum.attack_mul * root_datum.attack_mul * suffix_datum.attack_mul)
	card_defense_points = (prefix_datum.defense_add + root_datum.defense_add + suffix_datum.defense_add) * (prefix_datum.defense_mul * root_datum.defense_mul * suffix_datum.defense_mul)
	card_power = (prefix_datum.power_add + root_datum.power_add + suffix_datum.power_add) * (prefix_datum.power_mul * root_datum.power_mul * suffix_datum.power_mul)

	if(card_attack_points >= card_defense_points)
		card_defense_points = card_defense_points/(card_attack_points + card_defense_points)
		card_attack_points = 1 - card_defense_points
	else
		card_attack_points = card_attack_points/(card_attack_points + card_defense_points)
		card_defense_points = 1 - card_attack_points

	card_attack_points = round(card_power * card_attack_points,100)
	card_defense_points = round(card_power * card_defense_points,100)

	var/rounded_rarity_score = min(max(round(card_rarity_score,1),1),4)

	if(facedown)
		icon_state = "back"
	else
		icon_state = "front_r_[rounded_rarity_score]"
		add_overlay("front_label")

		if(prefix_datum.icon_state)
			add_overlay(prefix_datum.icon_state)

		if(root_datum.icon_state)
			add_overlay(root_datum.icon_state)

		if(suffix_datum.icon_state)
			add_overlay(suffix_datum.icon_state)

		if(rounded_rarity_score >= 2)
			add_overlay("rarity_animation")


/obj/item/battle_monsters/card/examine(mob/user)
	..()
	to_chat(user,SSbattlemonsters.FormatText(src,"<b>[card_name]</b> | Level [max(card_rarity_score,1)] %ELEMENT_LIST %TYPE | %SPECIES_C %ATTACKTYPE_LIST"))
	to_chat(user,SSbattlemonsters.FormatText(src,"ATK: [card_attack_points] | DEF: [card_defense_points]"))
	to_chat(user,SSbattlemonsters.FormatText(src,card_special_effects))
	to_chat(user,SSbattlemonsters.FormatText(src,"The card depicts [card_description]"))

/obj/item/battle_monsters/deck
	name = "battle monsters deck"
	icon_state = "stack"
	var/list/stored_card_names = list()

/obj/item/battle_monsters/deck/proc/get_top_card()
	return stored_card_names[stored_card_names.len]

/obj/item/battle_monsters/deck/proc/get_bottom_card()
	return stored_card_names[1]

/obj/item/battle_monsters/deck/proc/add_card(var/user, var/obj/item/battle_monsters/card/added_card)
	stored_card_names += list( list(added_card.card_prefix,added_card.card_root,added_card.card_suffix) )
	qdel(added_card)

/obj/item/battle_monsters/deck/proc/take_card(var/mob/user, var/list/card_name)
	if(card_name in stored_card_names)
		var/obj/item/battle_monsters/card/new_card = new(src.loc,card_name[1],card_name[2],card_name[3])
		user.put_in_active_hand(new_card)
		stored_card_names -= card_name

	if(stored_card_names.len <= 0)
		qdel(src)

/obj/item/battle_monsters/deck/attack_hand(var/mob/user)
	take_card(user,get_top_card())

/obj/item/battle_monsters/deck/attackby(var/obj/item/attacking, var/mob/user)
	if(istype(attacking,/obj/item/battle_monsters/card))
		var/obj/item/battle_monsters/card/adding_card = attacking
		add_card(user,adding_card)

/obj/item/battle_monsters/deck/proc/Generate_Deck()
	for(var/i=1,i < 52,i++)
		stored_card_names += list( list(SSbattlemonsters.GetRandomPrefix(),SSbattlemonsters.GetRandomRoot(),prob(5) ? SSbattlemonsters.GetRandomSuffix() : "no_title") )

/obj/item/battle_monsters/deck/generated/New()
	. = ..()
	Generate_Deck()

