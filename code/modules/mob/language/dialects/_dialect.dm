/decl/dialect
	var/name = "dialect"
	var/desc = "Listen up, troublemaker, how did you know about my fever?"
	var/parent_language = LANGUAGE_SOL_COMMON
	var/deviation = 0 //The further away someone is from the BASELINE version, the WORSE their language is at cross understanding.
	var/dialect_to_understanding = list()
	var/culture_restriction
	var/origin_restriction
	//List structure:
	// /decl/dialect/morozi = 95
	//This overrides other speech variables.

/decl/dialect/proc/calculate_cross_understanding(var/decl/dialect/target)
	if(target?.type in dialect_to_understanding)
		return dialect_to_understanding[target.type]
	var/total_understanding = 100
	total_understanding -= deviation //our deviation: 40
	if(target)
		total_understanding -= target.deviation //their deviation: 40, so 20 total
	return max(0, total_understanding) //20 returned

/mob
	var/list/languages_to_dialects = list()