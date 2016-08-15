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
