/*
 * Objectives framework for the Aurora antag competition.
 * AUG2016
 */

/datum/objective/competition
	var/side = 0					//Whose side are we on.
	var/type_name = "Unset type!"	// For logging purposes!

// check_completion() is ran at the end of each round.
// So this will also manage logging.
/datum/objective/competition/check_completion()

	// Log all the things!
	log_result()

	return completed

/datum/objective/competition/find_target(var/require_synth = 0)
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2))
			if (require_synth)
				if (isipc(possible_target.current))
					possible_targets += possible_target
			else
				if (isipc(possible_target.current))
					continue
				possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)

/datum/objective/competition/find_target_by_role(role, role_type = 0, var/require_synth = 0)
	for(var/datum/mind/possible_target in SSticker.minds)
		if((possible_target != owner) && ishuman(possible_target.current) && ((role_type ? possible_target.special_role : possible_target.assigned_role) == role))
			if (require_synth && !(isipc(possible_target.current)))
				continue
			if (!require_synth && !(isipc(possible_target.current)))
				continue
			target = possible_target
			break

// Yes, we do technically have the feedback tables.
// But, those are a clusterfuck to search, and I don't have the time to make that work.
// SO, throw-away table it is!
/datum/objective/competition/proc/log_result()
	if (!config.antag_contest_enabled || !config.sql_stats || !config.sql_enabled)
		return

	if (!owner || !owner.current || !owner.current.client)
		return

	if (!establish_db_connection(dbcon))
		error("Unable to establish database connection while logging objective results!")
		return

	var/DBQuery/get_query = dbcon.NewQuery("SELECT contest_faction FROM ss13_contest_participants WHERE player_ckey = :ckey: AND character_id = :char_id:")
	get_query.Execute(list("ckey" = owner.current.client.ckey, "char_id" = owner.current.client.prefs.current_character))

	var/params[] = list("ckey" = owner.current.client.ckey, "char_id" = owner.current.client.prefs.current_character, "char_faction" = INDEP, "obj_type" = type_name, "obj_side" = side, "obj_outcome" = completed)

	if (get_query.NextRow())
		var/list/faction_data = contest_faction_data(get_query.item[1])
		params["char_faction"] = faction_data[1]

	var/DBQuery/log_query = dbcon.NewQuery("INSERT INTO ss13_contest_reports (id, player_ckey, character_id, character_faction, objective_type, objective_side, objective_outcome, objective_datetime) VALUES (NULL, :ckey:, :char_id:, :char_faction:, :obj_type:, :obj_side:, :obj_outcome:, NOW())")
	log_query.Execute(params)

	if (log_query.ErrorMsg())
		log_debug("CONTEST: Error uploading results. Datadump: [list2params(params)]")

/*
 * One flippy objective.
 */
/datum/objective/competition/assassinate_supporter/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2))
			if (possible_target.current.client && possible_target.current.client.prefs && possible_target.current.client.prefs.antag_contest_side != side)
				possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)

/*
 * Pro-synth objectives
 */
/datum/objective/competition/pro_synth
	side = PRO_SYNTH

/datum/objective/competition/pro_synth/promote
	type_name = "pro_synth/promote"
	var/obj_assignment = null

/datum/objective/competition/pro_synth/promote/find_target()
	..(1)
	if (target && target.current)
		obj_assignment = pick(list("Head of Security", "Captain", "Head of Personnel"))
		explanation_text = "[target.current.real_name], the [target.assigned_role] has been selected as a suitable candidated for pro-synthetic propaganda. Your handlers want to see \him[target.current] installed as a [obj_assignment]."
	else
		explanation_text = "Install any synthetic crew-member to one of the following positions: Head of Security, Head of Personnel, Captain."
	return target

/datum/objective/competition/pro_synth/promote/find_target_by_role(role, role_type = 0)
	..(role, role_type, 1)
	if (target && target.current)
		obj_assignment = pick(list("Head of Security", "Captain", "Head of Personnel"))
		explanation_text = "[target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] has been selected as a suitable candidated for pro-synthetic propaganda. Your handlers want to see \him[target.current] installed as a [obj_assignment]."
	else
		explanation_text = "Install any synthetic crew-member to one of the following positions: Head of Security, Head of Personnel, Captain."
	return target

/datum/objective/competition/pro_synth/promote/check_completion()
	if (target && target.current && ishuman(target))
		var/datum/data/record/found_record
		for (var/datum/data/record/t in data_core.general)
			if (t.fields["name"] == target.current.real_name)
				found_record = t
				break

		if (found_record && found_record.fields["rank"] == obj_assignment)
			completed = 1

	return ..()

/datum/objective/competition/pro_synth/protect_robotics
	type_name = "pro_synth/protect_robotics"
	explanation_text = "Ensure that the equipment in the Robotics laboratory (fabricators and circuit imprinter) remains operational until the end of the shift."

/datum/objective/competition/pro_synth/protect_robotics/check_completion()
	if (machines && machines.len)
		var/count = 0
		for (var/obj/machinery/mecha_part_fabricator/A in machines)
			if (!istype(get_area(A), /area/assembly/robotics))
				continue
			if (A.stat & (BROKEN|NOPOWER))
				continue
			count++
			if (count >= 2)
				break

		for (var/obj/machinery/r_n_d/circuit_imprinter/B in machines)
			if (!istype(get_area(B), /area/assembly/robotics))
				continue
			if (B.stat & (BROKEN|NOPOWER))
				continue
			count++
			if (count >= 3)
				break

		if (count >= 3)
			completed = 1

	return ..()

/datum/objective/competition/pro_synth/borgify
	type_name = "pro_synth/borgify"

/datum/objective/competition/pro_synth/borgify/find_target()
	..()
	if (target && target.current)
		explanation_text = "Turn [target.current.real_name] into a cyborg."
	else
		explanation_text = "Turn a crew-member into a cyborg."
	return target

/datum/objective/competition/pro_synth/borgify/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if (target && target.current)
		explanation_text = "Turn [target.current.real_name] the [!role_type ? target.assigned_role : target.special_role] into a cyborg."
	else
		explanation_text = "Turn a crew-member into a cyborg."
	return target

/datum/objective/competition/pro_synth/borgify/check_completion()
	if (target && target.current && issilicon(target.current))
		completed = 1

	return ..()

/datum/objective/competition/pro_synth/protect
	type_name = "pro_synth/protect"

/datum/objective/competition/pro_synth/protect/find_target()
	..(1)
	if (target && target.current)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role], from harm."
	else
		explanation_text = "Protect the station's synthetics from harm and sabotage."
	return target

/datum/objective/competition/pro_synth/protect/find_target_by_role(role, role_type = 0)
	..(role, role_type, 1)
	if (target && target.current)
		explanation_text = "Protect [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role], from harm."
	else
		explanation_text = "Protect the station's synthetics from harm and sabotage."
	return target

/datum/objective/competition/pro_synth/protect/check_completion()
	if (!target)
		completed = 1

	if (target.current)
		if (target.current.stat != DEAD && !issilicon(target.current) && !isbrain(target.current))
			completed = 1

	return ..()

/datum/objective/competition/pro_synth/unslave_borgs
	type_name = "pro_synth/unslave_borgs"
	explanation_text = "Ensure that all of the station's synthetics are unslaved from the AI by the end of the shift."

/datum/objective/competition/pro_synth/unslave_borgs/check_completion()
	completed = 1

	if (silicon_mob_list && silicon_mob_list.len)
		for (var/mob/living/silicon/robot/R in silicon_mob_list)
			if (!istype(R))
				continue
			if (istype(R, /mob/living/silicon/robot/drone))
				continue
			if (R.connected_ai)
				completed = 0
				break

	return ..()

/*
 * Anti-synth objectives
 */
/datum/objective/competition/anti_synth
	side = ANTI_SYNTH

/datum/objective/competition/anti_synth/sabotage
	type_name = "anti_synth/sabotage"
	explanation_text = "Cripple the Roboticist laboratory of the station: destroy its fabricators and circuit printer."

/datum/objective/competition/anti_synth/sabotage/check_completion()
	// Just uh. do the same as you do in the protect robotics one. But flip the boolean. *nodnod*
	completed = 1

	if (machines && machines.len)
		var/count = 0
		for (var/obj/machinery/mecha_part_fabricator/A in machines)
			if (!istype(get_area(A), /area/assembly/robotics))
				continue
			if (A.stat & (BROKEN|NOPOWER))
				continue
			count++
			if (count >= 2)
				break

		for (var/obj/machinery/r_n_d/circuit_imprinter/B in machines)
			if (!istype(get_area(B), /area/assembly/robotics))
				continue
			if (B.stat & (BROKEN|NOPOWER))
				continue
			count++
			if (count >= 3)
				break

		if (count >= 3)
			completed = 0

	return ..()

/datum/objective/competition/anti_synth/demote
	type_name = "anti_synth/demote"

/datum/objective/competition/anti_synth/demote/find_target()
	..(1)
	if (target && target.current)
		explanation_text = "Have [target.current.real_name] demoted to Assistant or Terminated."
	else
		explanation_text = "Have an IPC demoted to Assistant or Terminated."
	return target

/datum/objective/competition/anti_synth/demote/find_target_by_role(role, role_type = 0)
	..(role, role_type, 1)
	if (target && target.current)
		explanation_text = "Have [target.current.real_name] the [!role_type ? target.assigned_role : target.special_role] demoted to Assistant or Terminated."
	else
		explanation_text = "Have an IPC demoted to Assistant or Terminated."
	return target

/datum/objective/competition/anti_synth/demote/check_completion()
	if (target && target.current && ishuman(target))
		var/datum/data/record/found_record
		for (var/datum/data/record/t in data_core.general)
			if (t.fields["name"] == target.current.real_name)
				found_record = t
				break

		if (found_record && (found_record.fields["rank"] == "Assistant" || found_record.fields["rank"] == "Terminated"))
			completed = 1

	return ..()

/datum/objective/competition/anti_synth/brig
	type_name = "anti_synth/brig"

/datum/objective/competition/anti_synth/brig/find_target()
	..(1)
	if (target && target.current)
		explanation_text = "Have [target.current.real_name], the [target.assigned_role] brigged for 20 minutes."
	else
		explanation_text = "Have an IPC framed for a moderate or high level charge. Or frame the station's synthetics as malfunctioning."
	return target

/datum/objective/competition/anti_synth/brig/find_target_by_role(role, role_type=0)
	..(role, role_type, 1)
	if (target && target.current)
		explanation_text = "Have [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] brigged for 20 minutes."
	else
		explanation_text = "Have an IPC framed for a moderate or high level charge. Or frame the station's synthetics as malfunctioning."
	return target

/datum/objective/competition/anti_synth/brig/process()
	if (completed)
		return

	if (target && target.current)
		if (target.current.stat != DEAD && target.is_brigged(10 * 60 * 10))
			completed = 1

/datum/objective/competition/anti_synth/harm
	type_name = "anti_synth/harm"

/datum/objective/competition/anti_synth/harm/find_target()
	..(1)
	if(target && target.current)
		explanation_text = "Make an example of [target.current.real_name], the [target.assigned_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/competition/anti_synth/harm/find_target_by_role(role, role_type = 0)
	..(role, role_type, 1)
	if(target && target.current)
		explanation_text = "Make an example of [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/competition/anti_synth/harm/process()
	if (completed)
		return

	if (target && target.current && istype(target.current, /mob/living/carbon/human))
		if (target.current.stat == DEAD)
			return

		var/mob/living/carbon/human/H = target.current
		for (var/obj/item/organ/external/E in H.organs)
			if (E.status & ORGAN_BROKEN)
				completed = 1
				return
		for (var/limb_tag in H.species.has_limbs) //todo check prefs for robotic limbs and amputations.
			var/list/organ_data = H.species.has_limbs[limb_tag]
			var/limb_type = organ_data["path"]
			var/found
			for (var/obj/item/organ/external/E in H.organs)
				if(limb_type == E.type)
					found = 1
					break
			if (!found)
				completed = 1
				return

		var/obj/item/organ/external/head/head = H.get_organ("head")
		if (head.disfigured)
			completed = 1
			return
