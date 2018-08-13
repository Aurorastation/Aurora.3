#define BATTLE_MONSTERS_GEN_PREFIX 1
#define BATTLE_MONSTERS_GEN_ROOT 2
#define BATTLE_MONSTERS_GEN_SUFFIX 3

var/datum/controller/subsystem/battle_monsters/SSbattlemonsters

/datum/controller/subsystem/battle_monsters
	name = "Battle Monsters"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE
	var/list/monster_elements
	var/list/monster_roots
	var/list/monster_titles

	var/list/monster_elements_rng
	var/list/monster_roots_rng
	var/list/monster_titles_rng

/datum/controller/subsystem/battle_monsters/New()
    NEW_SS_GLOBAL(SSbattlemonsters)

/datum/controller/subsystem/battle_monsters/Initialize()
	GenerateDatum(BATTLE_MONSTERS_GEN_PREFIX)
	GenerateDatum(BATTLE_MONSTERS_GEN_ROOT)
	GenerateDatum(BATTLE_MONSTERS_GEN_SUFFIX)

/datum/controller/subsystem/battle_monsters/proc/GenerateDatum(var/generation_type)

	var/list/datum_paths

	switch(generation_type)
		if(BATTLE_MONSTERS_GEN_PREFIX)
			datum_paths = subtypesof(/datum/battle_monsters/element)
		if(BATTLE_MONSTERS_GEN_ROOT)
			datum_paths = subtypesof(/datum/battle_monsters/monster)
		if(BATTLE_MONSTERS_GEN_SUFFIX)
			datum_paths = subtypesof(/datum/battle_monsters/title)

	var/list/id_datum_list = list()
	var/list/id_rng_list = list()

	for(var/path in datum_paths)
		var/datum/battle_monsters/generated = new path()
		if(!generated.id)
			continue
		id_datum_list[generated.id] = generated
		id_rng_list[generated.id] = generated.rarity

	switch(generation_type)
		if(BATTLE_MONSTERS_GEN_PREFIX)
			monster_elements = id_datum_list
			monster_elements_rng = id_rng_list
		if(BATTLE_MONSTERS_GEN_ROOT)
			monster_roots = id_datum_list
			monster_roots_rng = id_rng_list
		if(BATTLE_MONSTERS_GEN_SUFFIX)
			monster_titles = id_datum_list
			monster_titles_rng = id_rng_list

/datum/controller/subsystem/battle_monsters/proc/GetRandomPrefix()
	return FindMatchingPrefix(pickweight(monster_elements_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomRoot()
	return FindMatchingRoot(pickweight(monster_roots_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomSuffix()
	return FindMatchingSuffix(pickweight(monster_titles_rng))

/datum/controller/subsystem/battle_monsters/proc/FindMatchingPrefix(var/text,var/failsafe = FALSE)
	if(monster_elements[text])
		return monster_elements[text]
	else if(failsafe)
		return GetRandomPrefix()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/FindMatchingRoot(var/text,var/failsafe = FALSE)
	if(monster_roots[text])
		return monster_roots[text]
	else if(failsafe)
		return GetRandomRoot()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/FindMatchingSuffix(var/text,var/failsafe = FALSE)
	if(monster_titles[text])
		return monster_titles[text]
	else if(failsafe)
		return GetRandomSuffix()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/GetSpecies(var/obj/item/battle_monsters/card/card_data)
	if(card_data.card_defense_type == BATTLE_MONSTERS_DEFENSETYPE_HUMAN)
		return "human"
	else if(BATTLE_MONSTERS_DEFENSETYPE_HUMAN & card_data.card_defense_type)
		return "humanoid"
	else
		return "monster"

/datum/controller/subsystem/battle_monsters/proc/GetWeapons(var/obj/item/battle_monsters/card/card_data, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"staff" = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER,
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_data.card_elements))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "body", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetElements(var/obj/item/battle_monsters/card/card_data,var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"normal" = BATTLE_MONSTERS_ELEMENT_NEUTRAL,
		"fire" = BATTLE_MONSTERS_ELEMENT_FIRE,
		"energy" = BATTLE_MONSTERS_ELEMENT_ENERGY,
		"water" = BATTLE_MONSTERS_ELEMENT_WATER,
		"ice" = BATTLE_MONSTERS_ELEMENT_ICE,
		"earth" = BATTLE_MONSTERS_ELEMENT_EARTH,
		"stone" = BATTLE_MONSTERS_ELEMENT_STONE,
		"dark" = BATTLE_MONSTERS_ELEMENT_DARK,
		"light" = BATTLE_MONSTERS_ELEMENT_LIGHT,
		"god" = BATTLE_MONSTERS_ELEMENT_GOD
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_data.card_elements))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "normal", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/FormatText(var/obj/item/battle_monsters/card/card_data, var/text)

	var/list/replacements = list(
		"%NAME" = card_data.card_name,
		"%SPECIES" = GetSpecies(card_data),
		"%TYPE" = card_data.card_type,
		"%ELEMENT_AND" = GetElements(card_data),
		"%ELEMENT_OR" = GetElements(card_data, " or "),
		"%ELEMENT_LIST" = GetElements(card_data,", "),
		"%WEAPON_AND" = GetWeapons(card_data)
	)

	for(var/word in replacements)
		if(!(word in replacements))
			continue
		text = replacetext(text,word,replacements[word])

	return text

