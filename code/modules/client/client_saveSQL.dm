//handles saving to SQL Format
//MAKE SURE YOU KEEP THIS UP TO DATE!
//if the db can't be updated, return 0
//if the db was updated, return 1

/datum/preferences/proc/SQLsave_character(var/cslot)
	char_slot = cslot
	if(!cslot)
		error("No character slot sent during SQL saving.")
		return 0
	for(var/ckey in preferences_datums)
		var/datum/preferences/D = preferences_datums[ckey]
		if(D == src)
			establish_db_connection(dbcon)
			if(!dbcon.IsConnected())
				error("Error with SQL saving: no database.")
				return 0
			else
				if(!getCharId(ckey))
					query = dbcon.NewQuery("INSERT INTO ss13_characters (ckey, slot) VALUES ('[ckey]', '[cslot]')")
					query.Execute()

					getCharId(ckey)
					InsertCharData()
					InsertJobsData()
					InsertFlavourData()
					InsertRobotFlavourData()
					InsertMiscData()
					InsertSkillsData()
					InsertGearData()
					InsertOrgansData()
				else
					UpdateCharData()
					UpdateJobsData()
					UpdateFlavourData()
					UpdateRobotFlavourData()
					UpdateMiscData()
					UpdateSkillsData()
					UpdateGearData()
					UpdateOrgansData()
			TextQuery = "UPDATE SS13_characters SET Character_Name = (SELECT name FROM characters_data WHERE char_id = '[char_id]') WHERE id = '[char_id]'"
			query = dbcon.NewQuery(TextQuery)
			query.Execute()

			return 1

	return 0

/datum/preferences/proc/SQLload_character(var/slot, var/pckey)
	establish_db_connection(dbcon)
	if(!dbcon.IsConnected())
		return 0
	char_slot = slot
	if(!getCharId(pckey))
		return 0

	if(LoadCharData())
		if(LoadJobsData())
			if(LoadFlavourData())
				if(LoadRobotFlavourData())
					if(LoadMiscData())
						if(LoadSkillsData())
							if(LoadGearData())
								if(LoadOrgansData())
									SanitizeCharacter()
									return 1
	return 0

/datum/preferences/proc/getCharId(var/ckey)
	TextQuery = "SELECT id FROM ss13_characters WHERE ckey='[ckey]' AND slot = '[char_slot]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()

	if(!query.RowCount())
		return 0

	query.NextRow()
	char_id = text2num(query.item[1])
	return char_id

/datum/preferences/proc/InsertCharData()
	TextQuery = "INSERT INTO characters_data (age, backbag, b_type, char_id, eyes_B, eyes_G, eyes_R, facial_B, facial_G, facial_R, facial_style, "
	TextQuery += "gender, hair_B, hair_G, hair_R, hair_style, isRandom, language, name, OOC,skin_B, skin_G, skin_R, skin_tone, spawnpoint, species, undershirt, underwear) VALUES "
	TextQuery += "('[age]', '[backbag]', '[b_type]', '[char_id]', '[b_eyes]', '[g_eyes]', '[r_eyes]', '[b_facial]', '[g_facial]', '[r_facial]', '[f_style]', "
	TextQuery += "'[gender]', '[b_hair]', '[g_hair]', '[r_hair]', '[h_style]', '[be_random_name]', '[language]', '[real_name]', "
	TextQuery += "'[metadata]', '[b_skin]', '[g_skin]', '[r_skin]', '[s_tone]', '[spawnpoint]', '[species]', '[undershirt]', '[underwear]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateCharData()
	query = dbcon.NewQuery("SELECT id FROM characters_data WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertCharData()
	TextQuery = "UPDATE characters_data SET age = '[age]', backbag='[backbag]', b_type='[b_type]', eyes_B = '[b_eyes]', eyes_G='[g_eyes]', eyes_R='[r_eyes]',"
	TextQuery += "facial_B='[b_facial]', facial_G='[g_facial]', facial_R='[r_facial]', facial_style='[f_style]', gender = '[gender]', hair_B='[b_hair]', hair_G='[g_hair]',"
	TextQuery += "hair_R='[r_hair]', hair_style='[h_style]', isRandom='[be_random_name]', language='[language]', name='[real_name]', OOC='[metadata]',skin_B='[b_skin]', skin_G='[g_skin]',"
	TextQuery += "skin_R='[r_skin]', skin_tone='[s_tone]', spawnpoint='[spawnpoint]', species='[species]', undershirt='[undershirt]', underwear='[underwear]'"
	TextQuery += "WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1


/datum/preferences/proc/LoadCharData()
	TextQuery = "SELECT age, backbag, b_type, eyes_B, eyes_G, eyes_R, facial_B, facial_G, facial_R, facial_style, gender, "
	TextQuery += "hair_B, hair_G, hair_R, hair_style, isRandom, language, name, OOC, skin_B, skin_G, skin_R, skin_tone, spawnpoint, species, undershirt, underwear "
	TextQuery += "FROM characters_data WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	age = text2num(query.item[1])
	backbag = text2num(query.item[2])
	b_type = text2num(query.item[3])
	b_eyes = text2num(query.item[4])
	g_eyes = text2num(query.item[5])
	r_eyes = text2num(query.item[6])
	b_facial = text2num(query.item[7])
	g_facial = text2num(query.item[8])
	r_facial = text2num(query.item[9])
	f_style = query.item[10]
	gender = query.item[11]
	b_hair = text2num(query.item[12])
	g_hair = text2num(query.item[13])
	r_hair = text2num(query.item[14])
	h_style = query.item[15]
	be_random_name = text2num(query.item[16])
	language = query.item[17]
	real_name = query.item[18]
	metadata = query.item[19]
	b_skin = text2num(query.item[20])
	g_skin = text2num(query.item[21])
	r_skin = text2num(query.item[22])
	s_tone = text2num(query.item[23])
	spawnpoint = query.item[24]
	species = query.item[25]
	undershirt = query.item[26]
	underwear = query.item[27]
	return 1

/datum/preferences/proc/InsertJobsData()
	var/alt_titles_list = list2params(player_alt_titles)
	TextQuery = "INSERT INTO characters_jobs (char_id, Alternate, civ_high, civ_med, civ_low, medsci_high, medsci_med, medsci_low, engsec_high, engsec_med, engsec_low, alt_titles) "
	TextQuery += " VALUES ('[char_id]','[alternate_option]', '[job_civilian_high]', '[job_civilian_med]', '[job_civilian_low]', '[job_medsci_high]', '[job_medsci_med]', '[job_medsci_low]', "
	TextQuery += "'[job_engsec_high]', '[job_engsec_med]', '[job_engsec_low]', '[alt_titles_list]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateJobsData()
	query = dbcon.NewQuery("SELECT id FROM characters_jobs WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertJobsData()
	var/alt_titles_list = list2params(player_alt_titles)
	TextQuery = "UPDATE characters_jobs SET Alternate='[alternate_option]', civ_high='[job_civilian_high]', civ_med='[job_civilian_med]', civ_low='[job_civilian_low]', "
	TextQuery += "medsci_high='[job_medsci_high]', medsci_med='[job_medsci_med]', medsci_low='[job_medsci_low]', "
	TextQuery += "engsec_high='[job_engsec_high]', engsec_med='[job_engsec_med]', engsec_low='[job_engsec_low]', alt_titles = '[alt_titles_list]' WHERE char_id = [char_id] "
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadJobsData()
	TextQuery = "SELECT * FROM characters_jobs WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	alternate_option = text2num(query.item[3])
	job_civilian_high = text2num(query.item[4])
	job_civilian_med = text2num(query.item[5])
	job_civilian_low = text2num(query.item[6])
	job_medsci_high = text2num(query.item[7])
	job_medsci_med = text2num(query.item[8])
	job_medsci_low = text2num(query.item[9])
	job_engsec_high = text2num(query.item[10])
	job_engsec_med = text2num(query.item[11])
	job_engsec_low = text2num(query.item[12])
	player_alt_titles = params2list(query.item[13])
	return 1

/datum/preferences/proc/InsertFlavourData()
	TextQuery = "INSERT INTO characters_flavour (char_id, generals, head, face, eyes, torso, arms, hands, legs, feet) "
	TextQuery += " VALUES ('[char_id]','[flavor_texts["general"]]', '[flavor_texts["head"]]', '[flavor_texts["face"]]', '[flavor_texts["eyes"]]', '[flavor_texts["torso"]]', "
	TextQuery += "'[flavor_texts["arms"]]', '[flavor_texts["hands"]]', '[flavor_texts["legs"]]', '[flavor_texts["feet"]]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateFlavourData()
	query = dbcon.NewQuery("SELECT id FROM characters_data WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertFlavourData()
	TextQuery = "UPDATE characters_flavour SET generals='[flavor_texts["general"]]', head='[flavor_texts["head"]]', face='[flavor_texts["face"]]', eyes='[flavor_texts["eyes"]]', "
	TextQuery += "torso='[flavor_texts["torso"]]', arms='[flavor_texts["arms"]]', hands='[flavor_texts["hands"]]', legs='[flavor_texts["legs"]]', feet='[flavor_texts["feet"]]' "
	TextQuery += "WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadFlavourData()
	TextQuery = "SELECT * FROM characters_flavour WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	flavor_texts["general"] = query.item[3]
	flavor_texts["head"] = query.item[4]
	flavor_texts["face"] = query.item[5]
	flavor_texts["eyes"] = query.item[6]
	flavor_texts["torso"] = query.item[7]
	flavor_texts["arms"] = query.item[8]
	flavor_texts["hands"]= query.item[9]
	flavor_texts["legs"] = query.item[10]
	flavor_texts["feet"] = query.item[11]
	return 1

/datum/preferences/proc/InsertRobotFlavourData()
	TextQuery = "INSERT INTO characters_robot_flavour (char_id, Default_Robot, Standard, Engineering, Construction, Surgeon, Crisis, Miner, Janitor, Service, Clerical, Security, Research) "
	TextQuery += " VALUES ('[char_id]','[flavour_texts_robot["Default"]]', '[flavour_texts_robot["Standard"]]', '[flavour_texts_robot["Engineering"]]', '[flavour_texts_robot["Construction"]]', "
	TextQuery += "'[flavour_texts_robot["Surgeon"]]', '[flavour_texts_robot["Crisis"]]', '[flavour_texts_robot["Miner"]]', '[flavour_texts_robot["Janitor"]]', '[flavour_texts_robot["Service"]]', "
	TextQuery += "'[flavour_texts_robot["Clerical"]]', '[flavour_texts_robot["Security"]]','[flavour_texts_robot["Research"]]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateRobotFlavourData()
	query = dbcon.NewQuery("SELECT id FROM characters_robot_flavour WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertRobotFlavourData()
	TextQuery = "UPDATE characters_robot_flavour SET Default_Robot='[flavour_texts_robot["Default"]]', Standard='[flavour_texts_robot["Standard"]]', Engineering='[flavour_texts_robot["Engineering"]]', "
	TextQuery += "Construction='[flavour_texts_robot["Construction"]]', Surgeon='[flavour_texts_robot["Surgeon"]]', Crisis='[flavour_texts_robot["Crisis"]]', Miner='[flavour_texts_robot["Miner"]]', "
	TextQuery += "Janitor='[flavour_texts_robot["Janitor"]]', Service='[flavour_texts_robot["Service"]]', Clerical='[flavour_texts_robot["Clerical"]]', "
	TextQuery += "Security='[flavour_texts_robot["Security"]]', Research='[flavour_texts_robot["Research"]]' WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadRobotFlavourData()
	TextQuery = "SELECT * FROM characters_robot_flavour WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	flavour_texts_robot["Default"] = query.item[3]
	flavour_texts_robot["Standard"] = query.item[4]
	flavour_texts_robot["Engineering"] = query.item[5]
	flavour_texts_robot["Construction"] = query.item[6]
	flavour_texts_robot["Surgeon"] = query.item[7]
	flavour_texts_robot["Crisis"] = query.item[8]
	flavour_texts_robot["Miner"] = query.item[9]
	flavour_texts_robot["Janitor"] = query.item[10]
	flavour_texts_robot["Service"] = query.item[11]
	flavour_texts_robot["Clerical"] = query.item[12]
	flavour_texts_robot["Security"] = query.item[13]
	flavour_texts_robot["Research"] = query.item[14]
	return 1

/datum/preferences/proc/InsertMiscData()
	sanitizePrefs()
	TextQuery = "INSERT INTO characters_misc (char_id, med_rec, sec_rec, gen_rec, disab, used_skill, skills_spec, "
	TextQuery += "home_sys, citizen, faction, religion, NT_relation, uplink_loc, exploit_rec) VALUES ("
	TextQuery += "'[char_id]', '[med_record]', '[sec_record]', '[gen_record]', '[disabilities]', '[used_skillpoints]', "
	TextQuery += "'[skill_specialization]', '[home_system]', '[citizenship]', '[faction]', '[religion]', '[nanotrasen_relation]', "
	TextQuery += "'[uplinklocation]', '[exploit_record]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateMiscData()
	query = dbcon.NewQuery("SELECT id FROM characters_misc WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertMiscData()
	TextQuery = "UPDATE characters_misc SET med_rec='[med_record]', sec_rec='[sec_record]', gen_rec='[gen_record]', disab='[disabilities]', "
	TextQuery += "used_skill='[used_skillpoints]', skills_spec='[skill_specialization]', "
	TextQuery += "home_sys='[home_system]', citizen='[citizenship]', faction='[faction]', religion='[religion]', NT_relation='[nanotrasen_relation]', uplink_loc='[uplinklocation]', "
	TextQuery += "exploit_rec='[exploit_record]' WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadMiscData()
	TextQuery = "SELECT * FROM characters_misc WHERE char_id = [char_id]"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	med_record = query.item[3]
	sec_record = query.item[4]
	gen_record = query.item[5]
	disabilities = text2num(query.item[6])
	used_skillpoints = text2num(query.item[7])
	skill_specialization = query.item[8]
	home_system = query.item[9]
	citizenship = query.item[10]
	faction = query.item[11]
	religion = query.item[12]
	nanotrasen_relation = query.item[13]
	uplinklocation = query.item[14]
	exploit_record = query.item[15]
	return 1

/datum/preferences/proc/InsertSkillsData()
	TextQuery = "INSERT INTO characters_skills (char_id, Command, Botany, Cooking, Close_Combat, Weapons_Expertise, Forensics, NanoTrasen_Law, EVA, "
	TextQuery += "Construction, Electrical, Atmos, Engines, Heavy_Mach, Complex_Devices, Information_Tech, Genetics, Chemistry, Science, Medicine, Anatomy, Virology) VALUES "
	TextQuery += "('[char_id]', '[skills["management"]]', '[skills["botany"]]', '[skills["cooking"]]', '[skills["combat"]]', '[skills["weapons"]]', '[skills["forensics"]]', '[skills["law"]]', '[skills["EVA"]]',"
	TextQuery += " '[skills["construction"]]', '[skills["electrical"]]', '[skills["atmos"]]', '[skills["engines"]]', '[skills["pilot"]]', '[skills["devices"]]', '[skills["computer"]]', '[skills["genetics"]]',"
	TextQuery += " '[skills["chemistry"]]', '[skills["science"]]', '[skills["medical"]]', '[skills["anatomy"]]', '[skills["virology"]]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateSkillsData()
	query = dbcon.NewQuery("SELECT id FROM characters_skills WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertSkillsData()
	TextQuery = "UPDATE characters_skills SET Command='[skills["management"]]', Botany='[skills["botany"]]', Cooking='[skills["cooking"]]', Close_Combat='[skills["combat"]]', "
	TextQuery += "Weapons_Expertise='[skills["weapons"]]', Forensics='[skills["forensics"]]', NanoTrasen_Law='[skills["law"]]', EVA='[skills["EVA"]]', "
	TextQuery += "Construction='[skills["construction"]]', Electrical='[skills["electrical"]]', Atmos='[skills["atmos"]]', Engines='[skills["engines"]]', Heavy_Mach='[skills["pilot"]]', Complex_Devices='[skills["devices"]]', "
	TextQuery += "Information_Tech='[skills["computer"]]', Genetics='[skills["genetics"]]', Chemistry='[skills["chemistry"]]', Science='[skills["science"]]', Medicine='[skills["medical"]]', "
	TextQuery += "Anatomy='[skills["anatomy"]]', Virology='[skills["virology"]]' WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1


/datum/preferences/proc/LoadSkillsData()
	TextQuery = "SELECT * FROM characters_skills WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	skills["management"] = text2num(query.item[3])
	skills["botany"] = text2num(query.item[4])
	skills["cooking"] = text2num(query.item[5])
	skills["combat"] = text2num(query.item[6])
	skills["weapons"] = text2num(query.item[7])
	skills["forensics"] = text2num(query.item[8])
	skills["law"] = text2num(query.item[9])
	skills["EVA"] = text2num(query.item[10])
	skills["construction"] = text2num(query.item[11])
	skills["electrical"] = text2num(query.item[12])
	skills["atmos"] = text2num(query.item[13])
	skills["engines"] = text2num(query.item[14])
	skills["pilot"] = text2num(query.item[15])
	skills["devices"] = text2num(query.item[16])
	skills["computer"] = text2num(query.item[17])
	skills["genetics"] = text2num(query.item[18])
	skills["chemistry"] = text2num(query.item[19])
	skills["science"] = text2num(query.item[20])
	skills["medical"] = text2num(query.item[21])
	skills["anatomy"] = text2num(query.item[22])
	skills["virology"] = text2num(query.item[23])
	return 1

/datum/preferences/proc/InsertGearData()
	var/gear_list = list2params(gear)
	TextQuery = "INSERT INTO characters_gear (char_id, gear) VALUES ('[char_id]', '[gear_list]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateGearData()
	query = dbcon.NewQuery("SELECT id FROM characters_gear WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertGearData()
	var/gear_list = list2params(gear)
	TextQuery = "UPDATE characters_gear SET gear='[gear_list]' WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadGearData()
	TextQuery = "SELECT * FROM characters_gear WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	gear = params2list(query.item[3])
	return 1

/datum/preferences/proc/InsertOrgansData()
	TextQuery = "INSERT INTO characters_organs (char_id, l_leg, r_leg, l_arm, r_arm, l_foot, r_foot, l_hand, r_hand, heart, eyes) VALUES ("
	TextQuery += "'[char_id]', '[organ_data["l_leg"]]', '[organ_data["r_leg"]]', '[organ_data["l_arm"]]', '[organ_data["r_arm"]]', '[organ_data["l_foot"]]', '[organ_data["r_foot"]]', "
	TextQuery += "'[organ_data["l_hand"]]', '[organ_data["r_hand"]]', '[organ_data["heart"]]', '[organ_data["eyes"]]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	InsertRorgansData()
	return 1

/datum/preferences/proc/UpdateOrgansData()
	query = dbcon.NewQuery("SELECT id FROM characters_organs WHERE char_id = '[char_id]'")
	query.Execute()
	if(!query.RowCount())
		InsertOrgansData()
	TextQuery = "UPDATE characters_organs SET char_id='[char_id]', l_leg='[organ_data["l_leg"]]', r_leg='[organ_data["r_leg"]]', l_arm='[organ_data["l_arm"]]', r_arm='[organ_data["r_arm"]]', "
	TextQuery += "l_foot='[organ_data["l_foot"]]', r_foot='[organ_data["r_foot"]]', l_hand='[organ_data["l_hand"]]', r_hand='[organ_data["r_hand"]]', heart='[organ_data["heart"]]', eyes='[organ_data["eyes"]]'"
	TextQuery += " WHERE char_id='[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	UpdateRorgansData()
	return 1

/datum/preferences/proc/LoadOrgansData()
	TextQuery = "SELECT * FROM characters_organs WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	organ_data["l_leg"] = query.item[3]
	organ_data["r_leg"] = query.item[4]
	organ_data["l_arm"] = query.item[5]
	organ_data["r_arm"] = query.item[6]
	organ_data["l_foot"] = query.item[7]
	organ_data["r_foot"] = query.item[8]
	organ_data["l_hand"] = query.item[9]
	organ_data["r_hand"] = query.item[10]
	organ_data["heart"] = query.item[11]
	organ_data["eyes"] = query.item[12]
	LoadRorgansData()
	return 1

/datum/preferences/proc/InsertRorgansData()
	TextQuery = "INSERT INTO characters_rlimb (char_id, l_leg, r_leg, l_arm, r_arm, l_foot, r_foot, l_hand, r_hand) VALUES ("
	TextQuery += "'[char_id]', '[rlimb_data["l_leg"]]', '[rlimb_data["r_leg"]]', '[rlimb_data["l_arm"]]', '[rlimb_data["r_arm"]]', '[rlimb_data["l_foot"]]', '[rlimb_data["r_foot"]]', "
	TextQuery += "'[rlimb_data["l_hand"]]', '[rlimb_data["r_hand"]]')"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateRorgansData()
	TextQuery = "UPDATE characters_rlimb SET char_id='[char_id]', l_leg='[rlimb_data["l_leg"]]', r_leg='[rlimb_data["r_leg"]]', l_arm='[rlimb_data["l_arm"]]', r_arm='[rlimb_data["r_arm"]]', "
	TextQuery += "l_foot='[rlimb_data["l_foot"]]', r_foot='[rlimb_data["r_foot"]]', l_hand='[rlimb_data["l_hand"]]', r_hand='[rlimb_data["r_hand"]]'"
	TextQuery += " WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadRorgansData()
	TextQuery = "SELECT * FROM characters_rlimb WHERE char_id = '[char_id]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	rlimb_data["l_leg"] = query.item[3]
	rlimb_data["r_leg"] = query.item[4]
	rlimb_data["l_arm"] = query.item[5]
	rlimb_data["r_arm"] = query.item[6]
	rlimb_data["l_foot"] = query.item[7]
	rlimb_data["r_foot"] = query.item[8]
	rlimb_data["l_hand"] = query.item[9]
	rlimb_data["r_hand"] = query.item[10]
	return 1

/datum/preferences/proc/SavePrefData(var/ckey)
	TextQuery = "SELECT * FROM player_preferences WHERE ckey = '[ckey]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		sanitizePrefs()
		TextQuery = "INSERT INTO player_preferences (ckey, ooccolor, lastchangelog, UI_style, default_slot, toggles, UI_style_color, UI_style_alpha, be_special) "
		TextQuery += "VALUES ('[ckey]', '[ooccolor]','[lastchangelog]', '[UI_style]', '[default_slot]', '[toggles]', '[UI_style_color]', '[UI_style_alpha]','[be_special]')"
		query = dbcon.NewQuery(TextQuery)
		query.Execute()
		return 1
	else
		return UpdatePrefData(ckey)

/datum/preferences/proc/UpdatePrefData(var/ckey)
	sanitizePrefs()
	TextQuery = "UPDATE player_preferences SET ooccolor='[ooccolor]', lastchangelog='[lastchangelog]', UI_style='[UI_style]', default_slot='[default_slot]', toggles='[toggles]', "
	TextQuery += "UI_style_color='[UI_style_color]', UI_style_alpha='[UI_style_alpha]', be_special='[be_special]' WHERE ckey = '[ckey]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadPrefData(var/ckey)
	establish_db_connection(dbcon)
	if(!dbcon.IsConnected())
		return 0
	TextQuery = "SELECT * FROM player_preferences WHERE ckey = '[ckey]'"
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	query.NextRow()
	ooccolor = query.item[3]
	lastchangelog = text2num(query.item[4])
	UI_style = query.item[5]
	default_slot = text2num(query.item[6])
	toggles = text2num(query.item[7])
	UI_style_color = query.item[8]
	UI_style_alpha = text2num(query.item[9])
	be_special = text2num(query.item[10])
	sanitizePrefs()
	return 1

/datum/preferences/proc/sanitizePrefs()
		ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
		lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
		UI_style		= sanitize_inlist(UI_style, list("White", "Midnight","Orange","old"), initial(UI_style))
		be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
		default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))
		toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
		UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
		UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))
		return 1

/datum/preferences/proc/SanitizeCharacter()

	metadata		= sanitize_text(metadata, initial(metadata))
	real_name		= sanitizeName(real_name)

	if(isnull(species) || !(species in playable_species))
		species = "Human"

	if(isnum(underwear))
		var/list/undies = gender == MALE ? underwear_m : underwear_f
		underwear = undies[undies[underwear]]

	if(isnum(undershirt))
		undershirt = undershirt_t[undershirt_t[undershirt]]

	if(isnull(language)) language = "None"
	if(isnull(spawnpoint)) spawnpoint = "Arrivals Shuttle"
	if(isnull(nanotrasen_relation)) nanotrasen_relation = initial(nanotrasen_relation)
	if(!real_name) real_name = random_name(gender)
	be_random_name	= sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
	gender			= sanitize_gender(gender)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	r_hair			= sanitize_integer(r_hair, 0, 255, initial(r_hair))
	g_hair			= sanitize_integer(g_hair, 0, 255, initial(g_hair))
	b_hair			= sanitize_integer(b_hair, 0, 255, initial(b_hair))
	r_facial		= sanitize_integer(r_facial, 0, 255, initial(r_facial))
	g_facial		= sanitize_integer(g_facial, 0, 255, initial(g_facial))
	b_facial		= sanitize_integer(b_facial, 0, 255, initial(b_facial))
	s_tone			= sanitize_integer(s_tone, -185, 34, initial(s_tone))
	r_skin			= sanitize_integer(r_skin, 0, 255, initial(r_skin))
	g_skin			= sanitize_integer(g_skin, 0, 255, initial(g_skin))
	b_skin			= sanitize_integer(b_skin, 0, 255, initial(b_skin))
	h_style			= sanitize_inlist(h_style, hair_styles_list, initial(h_style))
	f_style			= sanitize_inlist(f_style, facial_hair_styles_list, initial(f_style))
	r_eyes			= sanitize_integer(r_eyes, 0, 255, initial(r_eyes))
	g_eyes			= sanitize_integer(g_eyes, 0, 255, initial(g_eyes))
	b_eyes			= sanitize_integer(b_eyes, 0, 255, initial(b_eyes))
	backbag			= sanitize_integer(backbag, 1, backbaglist.len, initial(backbag))
	b_type			= sanitize_text(b_type, initial(b_type))

	alternate_option = sanitize_integer(alternate_option, 0, 2, initial(alternate_option))
	job_civilian_high = sanitize_integer(job_civilian_high, 0, 65535, initial(job_civilian_high))
	job_civilian_med = sanitize_integer(job_civilian_med, 0, 65535, initial(job_civilian_med))
	job_civilian_low = sanitize_integer(job_civilian_low, 0, 65535, initial(job_civilian_low))
	job_medsci_high = sanitize_integer(job_medsci_high, 0, 65535, initial(job_medsci_high))
	job_medsci_med = sanitize_integer(job_medsci_med, 0, 65535, initial(job_medsci_med))
	job_medsci_low = sanitize_integer(job_medsci_low, 0, 65535, initial(job_medsci_low))
	job_engsec_high = sanitize_integer(job_engsec_high, 0, 65535, initial(job_engsec_high))
	job_engsec_med = sanitize_integer(job_engsec_med, 0, 65535, initial(job_engsec_med))
	job_engsec_low = sanitize_integer(job_engsec_low, 0, 65535, initial(job_engsec_low))

	if(!skills) skills = list()
	if(!used_skillpoints) used_skillpoints= 0
	if(isnull(disabilities)) disabilities = 0
	if(!player_alt_titles) player_alt_titles = new()
	if(!organ_data) src.organ_data = list()
	if(!rlimb_data) src.rlimb_data = list()
	if(!gear) src.gear = list()

	if(!home_system) home_system = "Unset"
	if(!citizenship) citizenship = "None"
	if(!faction)     faction =     "None"
	if(!religion)    religion =    "None"
	return 1
