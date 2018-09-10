/obj/item/battle_monsters/wrapped
	name = "battle monsters starterpack"
	desc = "A battle monsters 52 card deck starterpack. Contains 52 basic cards and a lifetime of sadness."
	icon_state = "pack1"
	w_class = ITEMSIZE_SMALL
	var/contained_cards = 52
	var/rarity_max = BATTLE_MONSTERS_RARITY_COMMON
	var/rarity_min = BATTLE_MONSTERS_RARITY_UNCOMMON

/obj/item/battle_monsters/wrapped/proc/GenerateCards(mob/user,obj/item/battle_monsters/deck/generated_deck)
	var/list/deck_data = list()
	for(var/i=1,i <= contained_cards,i++)
		CHECK_TICK //This stuff is a little intensive I think.
		if(prob(25))
			if(prob(50))
				var/datum/battle_monsters/selected_trap = SSbattlemonsters.GetRandomTrap()
				deck_data += "trap_type,[selected_trap.id],no_title"
			else
				var/datum/battle_monsters/selected_spell = SSbattlemonsters.GetRandomSpell()
				deck_data += "spell_type,[selected_spell.id],no_title"
			continue

		var/datum/battle_monsters/selected_prefix = SSbattlemonsters.GetRandomPrefix_Filtered(rarity_min,rarity_max)
		var/datum/battle_monsters/selected_root = SSbattlemonsters.GetRandomRoot_Filtered(rarity_min,rarity_max)
		var/datum/battle_monsters/selected_suffix = SSbattlemonsters.GetRandomSuffix_Filtered(rarity_min,rarity_max)
		deck_data += "[selected_prefix.id],[selected_root.id],[(selected_prefix.rarity_score + selected_root.rarity_score) >= 3 ? selected_suffix.id : "no_title"]"

	generated_deck.stored_card_names = deck_data

/obj/item/battle_monsters/wrapped/attack_self(mob/user)

	user.visible_message(\
		span("notice","\The [user] unwraps \the [src]."),\
		span("notice","You unwrap \the [src].")\
	)
	var/obj/item/battle_monsters/deck/generated_deck = new(get_turf(src))
	GenerateCards(user,generated_deck)
	user.drop_from_inventory(src)
	user.put_in_active_hand(generated_deck)
	generated_deck.update_icon()
	qdel(src)

/obj/item/battle_monsters/wrapped/pro
	name = "battle monsters booster pack"
	desc = "A pack of 10 rare battle monster cards, with a chance of having legendary cards."
	icon_state = "pack2"
	contained_cards = 10
	rarity_max = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_min = BATTLE_MONSTERS_RARITY_LEGENDARY

/obj/item/battle_monsters/wrapped/rare
	name = "battle monsters rare booster pack"
	desc = "A pack of 10 ultra-rare battle monster cards."
	icon_state = "pack2"
	contained_cards = 10
	rarity_max = BATTLE_MONSTERS_RARITY_RARE
	rarity_min = BATTLE_MONSTERS_RARITY_LEGENDARY

/obj/item/battle_monsters/wrapped/legendary
	name = "battle monsters rare booster pack"
	desc = "A pack of 4 legendary battle monster cards."
	icon_state = "pack2"
	contained_cards = 4
	rarity_max = BATTLE_MONSTERS_RARITY_LEGENDARY
	rarity_min = BATTLE_MONSTERS_RARITY_LEGENDARY