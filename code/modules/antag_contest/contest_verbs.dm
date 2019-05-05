/*
 * Client verbs for the antag contest. Disable this file when the contest is over!
 * AUG2016
 */

// Displays a simple little guide.
/client/verb/contest_help()
	set name = "Contest Help"
	set category = "Contest"
	set desc = "Information about the contest."

	if (!config.antag_contest_enabled)
		to_chat(src, "<span class='warning'>The contest isn't running yet!</span>")
		return

	var/help = file2text('ingame_manuals/antag_contest.html')

	if (!help)
		to_chat(src, "<span class='warning'>Unable to open the document required! Please contact administration or a coder!</span>")
		return

	src << browse(help, "window=antag_contest_help;size=600x500")

/client/verb/contest_my_characters()
	set name = "My Character Status"
	set category = "Contest"
	set desc = "Displays information to you about your characters, and their standings."

	if (!config.antag_contest_enabled)
		to_chat(src, "<span class='warning'>The contest isn't running yet!</span>")
		return

	if (!establish_db_connection(dbcon))
		to_chat(src, "<span class='warning'>Failed to establish SQL connection! Contact a member of staff!</span>")
		return

	var/DBQuery/character_query = dbcon.NewQuery("SELECT id, name FROM ss13_characters WHERE ckey = :ckey: AND deleted_at IS NULL")
	character_query.Execute(list("ckey" = src.ckey))
	var/list/char_ids = list()

	while (character_query.NextRow())
		char_ids[character_query.item[1]] = list("name" = character_query.item[2], "assigned" = 0, "side_str" = "Independent", "side_int" = INDEP)

	if (!char_ids.len)
		to_chat(src, "<span class='warning'>Something went horribly wrong! Apparently you don't have any saved characters?</span>")
		return

	var/DBQuery/participation_query = dbcon.NewQuery("SELECT character_id, contest_faction FROM ss13_contest_participants WHERE character_id IN :char_ids:")
	participation_query.Execute(list("char_ids" = char_ids))

	while (participation_query.NextRow())
		char_ids[participation_query.item[1]]["assigned"] = 1
		// Lazy and convoluted, but I give 0 shits right now.
		var/list/faction_data = contest_faction_data(participation_query.item[2])
		char_ids[participation_query.item[1]]["side_int"] = faction_data[1]
		char_ids[participation_query.item[1]]["side_str"] = faction_data[2]

	var/data = "<center><b>Welcome to the character setup screen!</b></center>"
	data += "<br><center>Here is the list of your characters, and their allegience</center><hr>"

	var/colour = "#000000"
	for (var/char_id in char_ids)
		if (char_ids[char_id]["side_int"] in contest_factions_prosynth)
			colour = "#0040FF"
		else if (char_ids[char_id]["side_int"] in contest_factions_antisynth)
			colour = "#FF0000"
		else
			colour = "#00BF00"

		data += "[char_ids[char_id]["name"]] -- <font color=[colour]>[char_ids[char_id]["side_str"]]</font> -- <a href='?src=\ref[src];contest_action=modify;char_id=[char_id];current_side=[char_ids[char_id]["side_int"]];previously_assigned=[char_ids[char_id]["assigned"]]'>Modify</a><br>"

	src << browse(data, "window=antag_contest_chars;size=300x200")

/client/verb/request_objective()
	set name = "Request Objective"
	set category = "Contest"
	set desc = "Lets you choose a contest type objective!"

	if (!config.antag_contest_enabled)
		to_chat(src, "<span class='warning'>The contest isn't running yet!</span>")
		return

	if (!src.mob || !isliving(src.mob))
		to_chat(src, "<span class='warning'>Invalid mob type to participate!</span>")
		return

	if (!(src.mob.mind.special_role in list("Traitor", "Mercenary", "Raider")))
		to_chat(src, "<span class='warning'>You do not have a valid role! You must be a traitor, mercenary, or a raider for these to be usable! Contact an admin if you need assignment.</span>")
		return

	if (src.mob.mind.objectives.len >= 3)
		var/uncompleted_objectives = 0
		for (var/datum/objective/O in src.mob.mind.objectives)
			if (!O.completed)
				uncompleted_objectives++

		if (uncompleted_objectives >= 3)
			to_chat(src, span("warning", "You have [uncompleted_objectives] uncompleted objectives underway right now. Please finish them before requesting new ones."))
			return

	if (!establish_db_connection(dbcon))
		to_chat(src, "<span class='warning'>Failed to establish SQL connection! Contact a member of staff!</span>")
		return

	var/DBQuery/part_check = dbcon.NewQuery("SELECT contest_faction FROM ss13_contest_participants WHERE character_id = :char_id: AND player_ckey = :ckey:")
	part_check.Execute(list("char_id" = src.prefs.current_character, "ckey" = src.ckey))

	if (part_check.NextRow())
		var/list/available_objs
		var/side = input("Are you pro-synth or anti-synth?", "Choose wisely") as null|anything in list("Pro-synth", "Anti-synth")
		if (!side)
			to_chat(src, "<span class='notice'>Cancelled.</span>")
			return

		var/list/faction_data = contest_faction_data(part_check.item[1])

		if (side == "Pro-synth")
			if (faction_data[1] in contest_factions_antisynth && alert("This choice goes against your faction's current allegience.\nDo you wish to continue?", "Decisions", "Yes", "No") == "No")
				return

			available_objs = list("Assassinate Anti-Synth Supporter", "Promote a Synth", "Borgify", "Unslave Borgs")
		else
			if (faction_data[1] in contest_factions_prosynth && alert("This choice goes against your faction's current allegience.\nDo you wish to continue?", "Decisions", "Yes", "No") == "No")
				return

			available_objs = list("Assassinate Pro-Synth Supporter", "Sabotage Robotics", "Fire a Synth", "Brig a Synth", "Harm a Synth")

		if (!available_objs)
			to_chat(src, "<span class='warning'>No objectives were found for you! This is odd!</span>")
			return

		var/choice = input("Select objective type:", "Select Objective") as null|anything in available_objs

		if (!choice)
			to_chat(src, "<span class='warning'>Cancelled.</span>")
			return

		var/datum/objective/competition/new_objective
		var/failed_target = 0

		switch (choice)
			if ("Assassinate Pro-Synth Supporter")
				new_objective = new /datum/objective/competition/assassinate_supporter
				new_objective.side = ANTI_SYNTH
				new_objective.type_name = "anti_synth/assassin"
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Assassinate Anti-Synth Supporter")
				new_objective = new /datum/objective/competition/assassinate_supporter
				new_objective.side = PRO_SYNTH
				new_objective.type_name = "pro_synth/assassin"
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Promote a Synth")
				new_objective = new /datum/objective/competition/pro_synth/promote
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Protect Robotics")
				new_objective = new /datum/objective/competition/pro_synth/protect_robotics
			if ("Borgify")
				new_objective = new /datum/objective/competition/pro_synth/borgify
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Protect a Synth")
				new_objective = new /datum/objective/competition/pro_synth/protect
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Unslave Borgs")
				new_objective = new /datum/objective/competition/pro_synth/unslave_borgs
				if (silicon_mob_list && silicon_mob_list.len)
					var/found = 0
					for (var/mob/living/silicon/robot/R in silicon_mob_list)
						if (istype(R) && R.client)
							// We found what we needed.
							found = 1
							break

					if (!found)
						failed_target = 1
				else
					failed_target = 1
			if ("Sabotage Robotics")
				new_objective = new /datum/objective/competition/anti_synth/sabotage
			if ("Fire a Synth")
				new_objective = new /datum/objective/competition/anti_synth/demote
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Brig a Synth")
				new_objective = new /datum/objective/competition/anti_synth/brig
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			if ("Harm a Synth")
				new_objective = new /datum/objective/competition/anti_synth/harm
				new_objective.owner = src.mob.mind
				if (!new_objective.find_target())
					failed_target = 1
			else
				//wtfbbq y r u here
				//go and stay go
				return

		if (failed_target)
			to_chat(src, "<span class='warning'>Objective selection failed! No valid targets found!</span>")
			qdel(new_objective)
			return

		if (!new_objective.owner)
			new_objective.owner = src.mob.mind
		src.mob.mind.objectives += new_objective
		to_chat(src, "<span class='notice'>New objective assigned! Have fun, and roleplay well!</span>")
		log_admin("CONTEST: [key_name(src)] has assigned themselves an objective: [new_objective.type].", ckey=key_name(src))
		return
	else
		to_chat(src, "<span class='warning'>This character hasn't been set up to participate! Consult an admin or change this yourself!</span>")
		return

/client/proc/process_contest_topic(var/list/href)
	if (!href || !href.len || !href["contest_action"])
		return

	if (!config.antag_contest_enabled)
		return

	switch (href["contest_action"])
		if ("modify")
			if (!href["char_id"])
				to_chat(src, "<span class='warning'>Ouch, bad link.</span>")
				return

			if (!establish_db_connection(dbcon))
				to_chat(src, "<span class='warning'>Failed to establish SQL connection! Contact a member of staff!</span>")
				return

			var/choice = input("Choose your side:", "Contest Side") as null|anything in contest_factions

			if (!choice || contest_factions[choice] == href["current_side"])
				to_chat(src, "<span class='notice'>Cancelled</span>")
				return

			var/list/sql_args = list("ckey" = src.ckey, "char_id" = href["char_id"], "new_side" = contest_factions[choice])

			var/query_content = "UPDATE ss13_contest_participants SET contest_faction = :new_side: WHERE player_ckey = :ckey: AND character_id = :char_id:"

			if (text2num(href["previously_assigned"]) == 0)
				query_content = "INSERT INTO ss13_contest_participants (player_ckey, character_id, contest_faction) VALUES (:ckey:, :char_id:, :new_side:)"

			var/DBQuery/query = dbcon.NewQuery(query_content)
			query.Execute(sql_args)

			if (query.ErrorMsg())
				to_chat(src, "<span class='danger'>SQL query ran into an error and was cancelled! Please contact a developer to troubleshoot the logs!</span>")
				return
			else
				to_chat(src, "<span class='notice'>Successfully updated your character's alliegence!</span>")
				src.contest_my_characters()
				return

#undef INDEP
#undef SLF
#undef BIS
#undef ASI
#undef PSIS
#undef HSH
#undef TCD

#undef PRO_SYNTH
#undef ANTI_SYNTH
