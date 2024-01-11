#define BATTLE_MONSTERS_GEN_PREFIX 1
#define BATTLE_MONSTERS_GEN_ROOT 2
#define BATTLE_MONSTERS_GEN_SUFFIX 3
#define BATTLE_MONSTERS_GEN_TRAP 4
#define BATTLE_MONSTERS_GEN_SPELL 5

SUBSYSTEM_DEF(battle_monsters)
	name = "Battle Monsters"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/monster_elements
	var/list/monster_roots
	var/list/monster_titles

	var/list/monster_elements_rng
	var/list/monster_roots_rng
	var/list/monster_titles_rng

	var/list/traps
	var/list/spells

	var/list/traps_rng
	var/list/spells_rng

/datum/controller/subsystem/battle_monsters/Initialize()
	GenerateDatum(BATTLE_MONSTERS_GEN_PREFIX)
	GenerateDatum(BATTLE_MONSTERS_GEN_ROOT)
	GenerateDatum(BATTLE_MONSTERS_GEN_SUFFIX)
	GenerateDatum(BATTLE_MONSTERS_GEN_TRAP)
	GenerateDatum(BATTLE_MONSTERS_GEN_SPELL)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/battle_monsters/proc/CreateCard(var/identifier,var/turf/cardloc)
	var/list/splitstring = dd_text2List(identifier,",")
	var/obj/item/battle_monsters/card/new_card

	if(splitstring[1] == "spell_type")
		new_card = new(cardloc,null,null,null,null,splitstring[2])
	else if(splitstring[1] == "trap_type")
		new_card = new(cardloc,null,null,null,splitstring[2],null)
	else
		new_card = new(cardloc,splitstring[1],splitstring[2],splitstring[3],null,null)

	return new_card

/datum/controller/subsystem/battle_monsters/proc/GenerateDatum(var/generation_type)

	var/list/datum_paths

	switch(generation_type)
		if(BATTLE_MONSTERS_GEN_PREFIX)
			datum_paths = subtypesof(/datum/battle_monsters/element)
		if(BATTLE_MONSTERS_GEN_ROOT)
			datum_paths = subtypesof(/datum/battle_monsters/monster)
		if(BATTLE_MONSTERS_GEN_SUFFIX)
			datum_paths = subtypesof(/datum/battle_monsters/title)
		if(BATTLE_MONSTERS_GEN_TRAP)
			datum_paths = subtypesof(/datum/battle_monsters/trap)
		if(BATTLE_MONSTERS_GEN_SPELL)
			datum_paths = subtypesof(/datum/battle_monsters/spell)

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
		if(BATTLE_MONSTERS_GEN_TRAP)
			traps = id_datum_list
			traps_rng = id_rng_list
		if(BATTLE_MONSTERS_GEN_SPELL)
			spells = id_datum_list
			spells_rng = id_rng_list

/datum/controller/subsystem/battle_monsters/proc/GetRandomPrefix()
	return FindMatchingPrefix(pickweight(monster_elements_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomRoot()
	return FindMatchingRoot(pickweight(monster_roots_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomSuffix()
	return FindMatchingSuffix(pickweight(monster_titles_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomTrap()
	return FindMatchingTrap(pickweight(traps_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomSpell()
	return FindMatchingSpell(pickweight(spells_rng))

/datum/controller/subsystem/battle_monsters/proc/GetRandomPrefix_Filtered(var/raremin,var/raremax)
	var/list/edited_list = list()

	for(var/id in monster_elements_rng)
		var/score = monster_elements_rng[id]
		if(score > raremax)
			continue
		if(score < raremin)
			continue
		edited_list[id] = score

	if(edited_list.len <= 0)
		edited_list = monster_elements_rng

	return FindMatchingPrefix(pickweight(edited_list))

/datum/controller/subsystem/battle_monsters/proc/GetRandomRoot_Filtered(var/raremin,var/raremax)
	var/list/edited_list = list()

	for(var/id in monster_roots_rng)
		var/score = monster_roots_rng[id]
		if(score > raremax)
			continue
		if(score < raremin)
			continue
		edited_list[id] = score

	if(edited_list.len <= 0)
		edited_list = monster_roots_rng

	return FindMatchingRoot(pickweight(edited_list))

/datum/controller/subsystem/battle_monsters/proc/GetRandomSuffix_Filtered(var/raremin,var/raremax)
	var/list/edited_list = list()

	for(var/id in monster_titles_rng)
		var/score = monster_titles_rng[id]
		if(score > raremax)
			continue
		if(score < raremin)
			continue
		edited_list[id] = score

	if(edited_list.len <= 0)
		edited_list = monster_titles_rng

	return FindMatchingSuffix(pickweight(edited_list))


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

/datum/controller/subsystem/battle_monsters/proc/FindMatchingTrap(var/text,var/failsafe = FALSE)
	if(traps[text])
		return traps[text]
	else if(failsafe)
		return GetRandomTrap()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/FindMatchingSpell(var/text,var/failsafe = FALSE)
	if(spells[text])
		return spells[text]
	else if(failsafe)
		return GetRandomSpell()
	else
		return

/datum/controller/subsystem/battle_monsters/proc/GetSpeciesGeneral(var/card_defense_type)
	switch(card_defense_type)
		if(BATTLE_MONSTERS_DEFENSETYPE_NONE)
			return "monster"
		if(BATTLE_MONSTERS_DEFENSETYPE_GIANT_DRAGON)
			return "giant dragon"
		if(BATTLE_MONSTERS_DEFENSETYPE_FERALDRAGON)
			return "feral dragon"
		if(BATTLE_MONSTERS_DEFENSETYPE_DRAGONHYBRID)
			return "human-dragon hybrid"
		if(BATTLE_MONSTERS_DEFENSETYPE_DRAGON)
			return "dragon"
		if(BATTLE_MONSTERS_DEFENSETYPE_DEMIGOD)
			return "demi-god"
		if(BATTLE_MONSTERS_DEFENSETYPE_CYBORG)
			return "cyborg"
		if(BATTLE_MONSTERS_DEFENSETYPE_HYBRID)
			return "hybrid"
		if(BATTLE_MONSTERS_DEFENSETYPE_CATMAN)
			return "catman"
		if(BATTLE_MONSTERS_DEFENSETYPE_LIZARDMAN)
			return "lizardman"
		if(BATTLE_MONSTERS_DEFENSETYPE_ANTMAN)
			return "antman"
		if(BATTLE_MONSTERS_DEFENSETYPE_GIANT)
			return "colossus"
		if(BATTLE_MONSTERS_DEFENSETYPE_REPTILE)
			return "reptile"
		if(BATTLE_MONSTERS_DEFENSETYPE_HUMAN)
			return "human"
		if(BATTLE_MONSTERS_DEFENSETYPE_INSECT)
			return "insect"
		if(BATTLE_MONSTERS_DEFENSETYPE_GOD)
			return "god"
		if(BATTLE_MONSTERS_DEFENSETYPE_FELINE)
			return "feline"
		if(BATTLE_MONSTERS_DEFENSETYPE_MACHINE)
			return "machine"
		if(BATTLE_MONSTERS_DEFENSETYPE_CREATURE)
			return "creature"
		if(BATTLE_MONSTERS_DEFENSETYPE_COLOSSUS)
			return "colossus"
		if(BATTLE_MONSTERS_DEFENSETYPE_FLYING)
			return "winged monster"
		else
			return GetSpecies(card_defense_type," mixed with ")

/datum/controller/subsystem/battle_monsters/proc/GetSpecies(card_defense_type, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"Human" = BATTLE_MONSTERS_DEFENSETYPE_HUMAN,
		"God" = BATTLE_MONSTERS_DEFENSETYPE_GOD,
		"Machine" = BATTLE_MONSTERS_DEFENSETYPE_MACHINE,
		"Creature" = BATTLE_MONSTERS_DEFENSETYPE_CREATURE,
		"Flying" = BATTLE_MONSTERS_DEFENSETYPE_FLYING,
		"Colossus" = BATTLE_MONSTERS_DEFENSETYPE_COLOSSUS,
		"Reptile" = BATTLE_MONSTERS_DEFENSETYPE_REPTILE,
		"Feline" = BATTLE_MONSTERS_DEFENSETYPE_FELINE,
		"Insect" = BATTLE_MONSTERS_DEFENSETYPE_INSECT,
		"Demon" = BATTLE_MONSTERS_DEFENSETYPE_DEMON
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_defense_type))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "Monster", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetAttackType(var/card_attack_type, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"Spellcaster" = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER,
		"Warrior" = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN,
		"Commander" = BATTLE_MONSTERS_ATTACKTYPE_ARMY,
		"Warrior" = BATTLE_MONSTERS_ATTACKTYPE_CLAWS,
		"Warrior" = BATTLE_MONSTERS_ATTACKTYPE_TEETH,
		"Warrior" = BATTLE_MONSTERS_ATTACKTYPE_CLUB,
		"Defender" = BATTLE_MONSTERS_ATTACKTYPE_SHIELD
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_attack_type))
			continue
		if(translation in included_elements)
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "Regular", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetWeapons(var/card_attack_type, var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"staff" = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER,
		"sword" = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN,
		"army" = BATTLE_MONSTERS_ATTACKTYPE_ARMY,
		"claws" = BATTLE_MONSTERS_ATTACKTYPE_CLAWS,
		"club" = BATTLE_MONSTERS_ATTACKTYPE_CLUB,
		"fangs" = BATTLE_MONSTERS_ATTACKTYPE_TEETH,
		"shield" = BATTLE_MONSTERS_ATTACKTYPE_SHIELD
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_attack_type))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "fists", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetElements(var/card_elements,var/and_text = " and ")

	//This list looks odd to prevent runtime errors related to out of bounds indexes
	var/list/translations = list(
		"Neutral" = BATTLE_MONSTERS_ELEMENT_NEUTRAL,
		"Fire" = BATTLE_MONSTERS_ELEMENT_FIRE,
		"Energy" = BATTLE_MONSTERS_ELEMENT_ENERGY,
		"Water" = BATTLE_MONSTERS_ELEMENT_WATER,
		"Ice" = BATTLE_MONSTERS_ELEMENT_ICE,
		"Earth" = BATTLE_MONSTERS_ELEMENT_EARTH,
		"Stone" = BATTLE_MONSTERS_ELEMENT_STONE,
		"Dark" = BATTLE_MONSTERS_ELEMENT_DARK,
		"Light" = BATTLE_MONSTERS_ELEMENT_LIGHT,
	)

	var/list/included_elements = list()

	for(var/translation in translations)
		if(!(translations[translation] & card_elements))
			continue
		included_elements.Add(translation)

	return english_list(included_elements, nothing_text = "Neutral", and_text = and_text)

/datum/controller/subsystem/battle_monsters/proc/GetStarLevel(var/power_rating,var/attack_points,var/defense_points)

	var/power_mod = (power_rating / 2) + (max(attack_points,defense_points)/2)

	if(power_mod <= BATTLE_MONSTERS_POWER_PETTY)
		return 1
	if(power_mod <= BATTLE_MONSTERS_POWER_LESSER)
		return 2
	if(power_mod <= BATTLE_MONSTERS_POWER_COMMON)
		return 3
	if(power_mod <= BATTLE_MONSTERS_POWER_GREATER)
		return 4
	if(power_mod <= BATTLE_MONSTERS_POWER_GRAND)
		return 5
	else
		return 5 + round((power_mod - BATTLE_MONSTERS_POWER_GRAND)/BATTLE_MONSTERS_POWER_UPGRADE)

/datum/controller/subsystem/battle_monsters/proc/GetSummonRequirements(var/starlevel)
	if(starlevel <= 2)
		return "None."
	else if(starlevel <= 4)
		return "Must sacrifice one monster on your side of the field to summon."
	else if(starlevel <= 6)
		return "Must sacrifice two monsters on your side of the field to summon."
	else if(starlevel <= 8)
		return "Must sacrifice three monsters on your side of the field to summon."
	else
		return "Must sacrifice four monsters on your side of the field to summon."

/datum/controller/subsystem/battle_monsters/proc/FormatMonsterText(var/text,var/datum/battle_monsters/element/prefix_datum,var/datum/battle_monsters/monster/root_datum,var/datum/battle_monsters/title/suffix_datum, var/include_description = TRUE)

	var/list/generated_stats = SSbattle_monsters.GenerateMonsterStats(prefix_datum,root_datum,suffix_datum)

	if(!generated_stats || generated_stats.len == 0)
		return "Something went wrong... go bother the monsterous devs about it."

	var/list/replacements = list(
		"%NAME" = generated_stats["name"],

		"%DESCRIPTION" = generated_stats["desc"],
		"%SPECIAL_EFFECTS" = generated_stats["special_effects"],

		"%ELEMENT_AND" = GetElements(generated_stats["elements"]),
		"%ELEMENT_OR" = GetElements(generated_stats["elements"], " or "),
		"%ELEMENT_LIST" = GetElements(generated_stats["elements"], ", "),

		"%TYPE" = GetAttackType(generated_stats["attack_type"]),
		"%ATTACKTYPE_LIST" = GetAttackType(generated_stats["attack_type"], ", "),
		"%WEAPON_AND" = GetWeapons(generated_stats["attack_type"]),

		"%SPECIES_C" = capitalize(GetSpeciesGeneral(generated_stats["defense_type"])),
		"%SPECIES_LIST" = GetSpecies(generated_stats["defense_type"], ", "),
		"%SPECIES" = GetSpeciesGeneral(generated_stats["defense_type"]),

		"%ATTACK_POINTS" = generated_stats["attack_points"],
		"%DEFENSE_POINTS" = generated_stats["defense_points"],

		"%STAR_LEVEL" = generated_stats["star_level"],

		"%SUMMON_REQUIREMENTS" = GetSummonRequirements(generated_stats["star_level"])
	)
	if(!include_description)
		replacements -= "%DESCRIPTION"

	for(var/word in replacements)
		text = replacetext(text,word,replacements[word])

	for(var/word in replacements)//2 passes for good measure.
		text = replacetext(text,word,replacements[word])

	return text

/datum/controller/subsystem/battle_monsters/proc/FormatSpellText(var/text,var/datum/battle_monsters/spell_datum,var/include_description = TRUE)
	var/list/generated_stats = SSbattle_monsters.GenerateSpellStats(spell_datum)

	if(!generated_stats || generated_stats.len == 0)
		return "Something went wrong... go bother the wizardly devs about it."

	var/list/replacements = list(
		"%NAME" = generated_stats["name"],

		"%DESCRIPTION" = generated_stats["desc"],
		"%SPECIAL_EFFECTS" = generated_stats["special_effects"],

		"%ELEMENT_AND" = GetElements(generated_stats["elements"]),
		"%ELEMENT_OR" = GetElements(generated_stats["elements"], " or "),
		"%ELEMENT_LIST" = GetElements(generated_stats["elements"], ", ")
	)
	if(!include_description)
		replacements -= "%DESCRIPTION"

	for(var/word in replacements)
		text = replacetext(text,word,replacements[word])

	for(var/word in replacements)//2 passes for good measure.
		text = replacetext(text,word,replacements[word])

	return text

/datum/controller/subsystem/battle_monsters/proc/GetMonsterFormatting(var/include_description = TRUE)
	return "<b>%NAME</b> | %STAR_LEVEL Star Monster | %ELEMENT_LIST %TYPE | %SPECIES_C<br>\
			Keywords: %SPECIES_LIST<br>\
			ATK: %ATTACK_POINTS | DEF: %DEFENSE_POINTS<br>\
			Summoning Requirements: %SUMMON_REQUIREMENTS<br>\
			%SPECIAL_EFFECTS[include_description ? "<br>The card depicts %DESCRIPTION" : ""]"

/datum/controller/subsystem/battle_monsters/proc/GetSpellFormatting(var/include_description = TRUE)
	return "<b>%NAME</b> | Spell | %ELEMENT_LIST<br>\
			%SPECIAL_EFFECTS[include_description ? "<br>The card depicts %DESCRIPTION" : ""]"

/datum/controller/subsystem/battle_monsters/proc/GetTrapFormatting(var/include_description = TRUE)
	return "<b>%NAME</b> | Trap | %ELEMENT_LIST<br>\
			%SPECIAL_EFFECTS[include_description ? "<br>The card depicts %DESCRIPTION" : ""]"

/datum/controller/subsystem/battle_monsters/proc/ExamineMonsterCard(var/mob/user,var/datum/battle_monsters/element/prefix_datum,var/datum/battle_monsters/monster/root_datum,var/datum/battle_monsters/title/suffix_datum)
	to_chat(user,FormatMonsterText(GetMonsterFormatting(),prefix_datum,root_datum,suffix_datum))

/datum/controller/subsystem/battle_monsters/proc/ExamineSpellCard(var/mob/user,var/datum/battle_monsters/spell/spell_datum)
	to_chat(user,FormatSpellText(GetSpellFormatting(),spell_datum))

/datum/controller/subsystem/battle_monsters/proc/ExamineTrapCard(var/mob/user,var/datum/battle_monsters/trap/trap_datum)
	to_chat(user,FormatSpellText(GetTrapFormatting(),trap_datum))

/datum/controller/subsystem/battle_monsters/proc/GenerateMonsterStats(var/datum/battle_monsters/element/prefix_datum,var/datum/battle_monsters/monster/root_datum,var/datum/battle_monsters/title/suffix_datum, var/limiter = BATTLE_MONSTERS_GENERATION_ALL)

	var/returning_list[0] //Byond documentation told me this is how you make an assoc list.

	returning_list["name"] = root_datum.name
	if(prefix_datum.name)
		returning_list["name"] = "[prefix_datum.name] [returning_list["name"]]"
	if(suffix_datum.name)
		returning_list["name"] = "[returning_list["name"]], [suffix_datum.name]"

	returning_list["desc"] = root_datum.description
	if(prefix_datum.description)
		returning_list["desc"] += " [prefix_datum.description]"
	if(suffix_datum.description)
		returning_list["desc"] += "<br><i>[suffix_datum.description]</i>"

	returning_list["special_effects"] = ""
	if(prefix_datum.special_effects)
		returning_list["special_effects"] = trim("[returning_list["special_effects"]][prefix_datum.special_effects]<br>")
	if(root_datum.special_effects)
		returning_list["special_effects"] = trim("[returning_list["special_effects"]][root_datum.special_effects]<br>")
	if(suffix_datum.special_effects)
		returning_list["special_effects"] = trim("[returning_list["special_effects"]][suffix_datum.special_effects]<br>")

	returning_list["elements"] = prefix_datum.elements | root_datum.elements | suffix_datum.elements
	returning_list["attack_type"] = prefix_datum.attack_type | root_datum.attack_type | suffix_datum.attack_type
	returning_list["defense_type"] = prefix_datum.defense_type | root_datum.defense_type | suffix_datum.defense_type

	returning_list["rarity_score"] = prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score
	returning_list["attack_points"] = (prefix_datum.attack_add + root_datum.attack_add + suffix_datum.attack_add) * (prefix_datum.attack_mul * root_datum.attack_mul * suffix_datum.attack_mul)
	returning_list["defense_points"] = (prefix_datum.defense_add + root_datum.defense_add + suffix_datum.defense_add) * (prefix_datum.defense_mul * root_datum.defense_mul * suffix_datum.defense_mul)
	returning_list["power"] = (prefix_datum.power_add + root_datum.power_add + suffix_datum.power_add) * (prefix_datum.power_mul * root_datum.power_mul * suffix_datum.power_mul)
	if(returning_list["attack_points"] >= returning_list["defense_points"])
		returning_list["defense_points"] = returning_list["defense_points"]/(returning_list["attack_points"] + returning_list["defense_points"])
		returning_list["attack_points"] = 1 - returning_list["defense_points"]
	else
		returning_list["attack_points"] = returning_list["attack_points"]/(returning_list["attack_points"] + returning_list["defense_points"])
		returning_list["defense_points"] = 1 - returning_list["attack_points"]

	returning_list["attack_points"] = round(returning_list["power"] * returning_list["attack_points"],100)
	returning_list["defense_points"] = round(returning_list["power"] * returning_list["defense_points"],100)
	returning_list["star_level"] = GetStarLevel(returning_list["power"],returning_list["attack_points"],returning_list["defense_points"])

	return returning_list

/datum/controller/subsystem/battle_monsters/proc/GenerateSpellStats(var/datum/battle_monsters/spell_datum)
	var/returning_list[0] //Byond documentation told me this is how you make an assoc list.
	returning_list["name"] = spell_datum.name
	returning_list["desc"] = spell_datum.description
	returning_list["special_effects"] = spell_datum.special_effects
	returning_list["elements"] = spell_datum.elements
	returning_list["rarity_score"] = spell_datum.rarity_score
	return returning_list

#undef BATTLE_MONSTERS_GEN_PREFIX
#undef BATTLE_MONSTERS_GEN_ROOT
#undef BATTLE_MONSTERS_GEN_SUFFIX
#undef BATTLE_MONSTERS_GEN_TRAP
#undef BATTLE_MONSTERS_GEN_SPELL
