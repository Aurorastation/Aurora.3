datum/event/viral_infection
	var/datum/disease2/disease/generated/generated_disease
	ic_name = "a viral outbreak"

datum/event/viral_infection/setup()
	announceWhen = rand(40, 60)
	endWhen = announceWhen + 1

	var/has_virologist = FALSE
	var/list/valid_diseases = list()

	for(var/mob/living/carbon/human/H in mob_list)
		if(H.mind && H.stat != DEAD && H.is_client_active(5) && H.get_assignment() == "Virologist")
			has_virologist = TRUE
			break

	for(var/path in subtypesof(/datum/disease2/disease/generated/))
		var/datum/disease2/disease/generated/G = new path
		if(!has_virologist && G.dangerous)
			continue
		valid_diseases += G.type
		qdel(G)

	var/result = pick(valid_diseases)
	generated_disease = new result

datum/event/viral_infection/announce()

	var/disease_name = generated_disease ? generated_disease.generated_name : pick("Xenomorph Transformation", "Wizarditis", "GBS", "The Rhumba Beat")

	var/announcement_body
	var/announcement_title

	if(!generated_disease || generated_disease.dangerous)
		announcement_title = "High Risk Viral Outbreak"
		announcement_body = "Confirmed outbreak of level 7 viral infection classification \"[disease_name]\". Failure to contain outbreak and comply with official orders may result in contract termination and/or death."
	else
		announcement_title = "Viral Outbreak"
		announcement_body = "Confirmed outbreak of level 5 viral infection classification \"[disease_name]\". Please report to the medbay if you show any unusual symptoms."

	command_announcement.Announce(announcement_body, announcement_title)

datum/event/viral_infection/start()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in player_list)
		if(H.mind && H.stat != DEAD && H.is_client_active(5) && !player_is_antag(H.mind))
			var/turf/T = get_turf(H)
			if(T.z in current_map.station_levels)
				candidates += H
	if(!candidates.len)	return
	candidates = shuffle(candidates)

	for(var/i=1,i<=severity,i++)
		if(candidates.len)
			infect_mob(candidates[1], generated_disease.getcopy())
			log_admin("Virus event affecting [candidates[1]] started; Virus: [generated_disease.generated_name] ")
			message_admins("Virus event affecting [candidates[1]] started; Virus: [generated_disease.generated_name] ")
			candidates -= candidates[1]
