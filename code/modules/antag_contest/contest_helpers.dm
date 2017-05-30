/*
 * Helpers for the contest.
 * AUG2016
 */

// A helper to translate a string from the mySQL DB into a predefiend integer.
/proc/contest_faction_data(var/faction)
	if (!faction || !istext(faction))
		return list(INDEP, "Independent")

	switch (faction)
		if ("SLF")
			return list(SLF, "Synthetic Liberation Front")
		if ("BIS")
			return list(BIS, "Biesel Intelligence Service")
		if ("ASI")
			return list(ASI, "Alliance Strategic Intelligence")
		if ("PSIS")
			return list(PSIS, "People's Strategic Information Service")
		if ("HSH")
			return list(HSH, "Hegemon Shadow Service")
		if ("TCD")
			return list(TCD, "Tup Commandos Division")
		else
			return list(INDEP, "Independent")

// Helper vars for the datum class. Not for use outside of this module!
/datum/preferences/var/antag_contest_faction	= null
/datum/preferences/var/antag_contest_side		= null

/datum/preferences/proc/load_character_contest(slot)
	if (config.antag_contest_enabled && config.sql_enabled && establish_db_connection(dbcon))
		var/DBQuery/query = dbcon.NewQuery("SELECT contest_faction FROM ss13_contest_participants WHERE character_id = :char_id:")
		query.Execute(list("char_id" = slot))

		if (query.NextRow())
			antag_contest_faction = text2num(query.item[1])

			if (antag_contest_faction in contest_factions_prosynth)
				antag_contest_side = PRO_SYNTH
			else if (antag_contest_faction in contest_factions_antisynth)
				antag_contest_side = ANTI_SYNTH
			else
				antag_contest_side = 0


/mob/living/carbon/human/proc/implant_loyalty_sol(mob/living/carbon/human/M, override = FALSE) // Won't override by default.

	var/obj/item/weapon/implant/loyalty/sol/L = new/obj/item/weapon/implant/loyalty/sol(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/item/organ/external/affected = M.organs_by_name["head"]
	affected.implants += L
	L.part = affected
	L.implanted(src)
