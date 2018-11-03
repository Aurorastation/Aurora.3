/obj/item/battle_monsters/wrapped/species
	name = "battle monsters human boosterpack"
	desc = "A battle monsters 10 card boosterpack, containing exclusively human monsters."
	contained_cards = 10
	var/list/species = list(
		"human_male" = 1,
		"human_female" = 1,
		"mage" = 0.5,
		"sage" = 0.5,
		"wizard" = 0.25,
		"warrior" = 0.5,
		"amazon_warrior" = 0.5,
		"knight" = 0.5,
		"king" = 0.1,
		"queen" = 0.1
	)
	rarity_max = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_min = BATTLE_MONSTERS_RARITY_RARE

/obj/item/battle_monsters/wrapped/species/GenerateCards(mob/user,obj/item/battle_monsters/deck/generated_deck)
	var/list/deck_data = list()
	for(var/i=1,i <= contained_cards,i++)
		CHECK_TICK //This stuff is a little intensive I think.
		var/datum/battle_monsters/selected_prefix = SSbattlemonsters.GetRandomPrefix_Filtered(rarity_min,rarity_max)
		var/datum/battle_monsters/selected_root = SSbattlemonsters.FindMatchingRoot(pickweight(species))
		var/datum/battle_monsters/selected_suffix = SSbattlemonsters.GetRandomSuffix_Filtered(rarity_min,rarity_max)
		deck_data += "[selected_prefix.id],[selected_root.id],[(selected_prefix.rarity_score + selected_root.rarity_score) >= 3 ? selected_suffix.id : "no_title"]"

	generated_deck.stored_card_names = deck_data

/obj/item/battle_monsters/wrapped/species/lizard
	name = "battle monsters reptilian boosterpack"
	desc = "A battle monsters 10 card boosterpack, containing exclusively reptilian monsters."
	species = list(
		"dragon" = 0.5,
		"dragon_hybrid" = 0.25,
		"dragon_giant" = 0.25,
		"drake" = 0.5,
		"lizardman" = 1,
		"lizardwoman" = 1
	)

/obj/item/battle_monsters/wrapped/species/cat
	name = "battle monsters feline boosterpack"
	desc = "A battle monsters 10 card boosterpack, containing exclusively feline monsters."
	species = list(
		"catman" = 1,
		"catwoman" = 1
	)

/obj/item/battle_monsters/wrapped/species/ant
	name = "battle monsters insect boosterpack"
	desc = "A battle monsters 10 card boosterpack, containing exclusively insect monsters."
	species = list(
		"antman" = 1,
		"antwoman" = 0.25
	)