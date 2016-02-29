//handles saving to SQL Format
//MAKE SURE YOU KEEP THIS UP TO DATE!
//if the db can't be updated, return 0
//if the db was updated, return 1
var/chardata[]
var/jobsdata[]
var/flavourdata[]
var/miscdata[]
var/DBQuery/query
var/TextQuery
var/char_id
var/char_slot
/datum/preferences/proc/SQLsave_character(var/cslot)
	char_slot = cslot
	for(var/ckey in preferences_datums)
		var/datum/preferences/D = preferences_datums[ckey]
		log_debug("Ckey is [ckey]")
		if(D == src)
			establish_db_connection()
			if(!dbcon.IsConnected())
				return 0
			else
				log_debug("db connected, real name is [real_name]")
				if(!getCharId(ckey))
					log_debug("New Character")
					query = dbcon.NewQuery("INSERT INTO ss13_characters (ckey, slot) VALUES ('[ckey]', '[cslot]')")
					query.Execute()
					log_debug(dbcon.ErrorMsg())
					getCharId()
					InsertCharData()
					InsertJobsData()
					InsertFlavourData()
					InsertRobotFlavourData()
					InsertMiscData()
					log_debug(dbcon.ErrorMsg())
					TextQuery = "UPDATE SS13_characters SET Character_key = (SELECT id FROM characters_data WHERE char_id = [char_id]), "
					TextQuery += "Jobs_key = (SELECT id FROM characters_jobs WHERE char_id = [char_id]), "
					TextQuery += "Flavour_key = (SELECT id FROM characters_flavour WHERE char_id = [char_id]), "
					TextQuery += "Misc_key = (SELECT id FROM characters_misc WHERE char_id = [char_id]), "
					TextQuery += "Robot_key = (SELECT id FROM characters_robot_flavour WHERE char_id = [char_id]) WHERE id = [char_id] "
					query = dbcon.NewQuery(TextQuery)
					query.Execute()
					log_debug(dbcon.ErrorMsg())
				else
					log_debug("ID = [char_id]")
					log_debug("Update entry")
					UpdateCharData()
					UpdateJobsData()
					UpdateFlavourData()
					UpdateRobotFlavourData()
					UpdateMiscData()
			log_debug("Save query executed")
			return 1
	log_debug("No ckey in datums")
	return 0

/datum/preferences/proc/SQLload_character(slot)
	char_slot = slot
	if(!getCharId())
		return 0
	log_debug("Loading character ID [char_id] from slot [char_slot]")
	if(LoadCharData())
		if(LoadJobsData())
			if(LoadFlavourData())
				if(LoadRobotFlavourData())
					if(LoadMiscData())
						return 1
	return 0

/datum/preferences/proc/getCharId(var/ckey)
	TextQuery = "SELECT id FROM ss13_characters WHERE ckey='[ckey]' AND slot = '[char_slot]'"
	log_debug(TextQuery)
	query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey='[ckey]' AND slot = '[char_slot]'")
	log_debug("Query ready")
	query.Execute()
	var/rowDebug = query.RowCount()
	log_debug("Query executed, [rowDebug] rows")
	if(!query.RowCount())
		return null
	query.NextRow()
	char_id = query.item[1]
	log_debug("GetCharId : [char_id]")
	return char_id

/datum/preferences/proc/InsertCharData()
	TextQuery = "INSERT INTO characters_data (age, backbag, b_type, char_id, eyes_B, eyes_G, eyes_R, facial_B, facial_G, facial_R, facial_style, "
	TextQuery += "gender, hair_B, hair_G, hair_R, hair_style, isRandom, language, name, OOC,skin_B, skin_G, skin_R, skin_tone, spawnpoint, species, undershirt, underwear) VALUES "
	TextQuery += "('[age]', '[backbag]', '[b_type]', '[char_id]', '[b_eyes]', '[g_eyes]', '[r_eyes]', '[b_facial]', '[g_facial]', '[r_facial]', '[f_style]', "
	TextQuery += "'[gender]', '[b_hair]', '[g_hair]', '[r_hair]', '[h_style]', '[be_random_name]', '[language]', '[real_name]', "
	TextQuery += "'[metadata]', '[b_skin]', '[g_skin]', '[r_skin]', '[s_tone]', '[spawnpoint]', '[species]', '[undershirt]', '[underwear]')"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateCharData()
	TextQuery = "UPDATE characters_data SET age = '[age]', backbag='[backbag]', b_type='[b_type]', eyes_B = '[b_eyes]', eyes_G='[g_eyes]', eyes_R='[r_eyes]',"
	TextQuery += "facial_B='[b_facial]', facial_G='[g_facial]', facial_R='[r_facial]', facial_style='[f_style]', gender = '[gender]', hair_B='[b_hair]', hair_G='[g_hair]',"
	TextQuery += "hair_R='[r_hair]', hair_style='[h_style]', isRandom='[be_random_name]', language='[language]', name='[real_name]', OOC='[metadata]',skin_B='[b_skin]', skin_G='[g_skin]',"
	TextQuery += "skin_R='[r_skin]', skin_tone='[s_tone]', spawnpoint='[spawnpoint]', species='[species]', undershirt='[undershirt]', underwear='[underwear]' "
	TextQuery += "WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadCharData()
	TextQuery = "SELECT age, backbag, b_type, eyes_B, eyes_G, eyes_R, facial_B, facial_G, facial_R, facial_style, gender, "
	TextQuery += "hair_B, hair_G, hair_R, hair_style, isRandom, language, name, OOC, skin_B, skin_G, skin_R, skin_tone, spawnpoint, species, undershirt, underwear "
	TextQuery += "FROM character_data WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	log_debug("Load query executed successfully")
	query.NextRow()
	age = query.item[1]
	backbag = query.item[2]
	b_type = query.item[3]
	b_eyes = query.item[4]
	g_eyes = query.item[5]
	r_eyes = query.item[6]
	b_facial = query.item[7]
	g_facial = query.item[8]
	r_facial = query.item[9]
	f_style = query.item[10]
	gender = query.item[11]
	b_hair = query.item[12]
	g_hair = query.item[13]
	r_hair = query.item[14]
	h_style = query.item[15]
	be_random_name = query.item[16]
	language = query.item[17]
	real_name = query.item[18]
	metadata = query.item[19]
	b_skin = query.item[20]
	g_skin = query.item[21]
	r_skin = query.item[22]
	s_tone = query.item[23]
	spawnpoint = query.item[24]
	species = query.item[25]
	undershirt = query.item[26]
	underwear = query.item[27]
	return 1

/datum/preferences/proc/InsertJobsData()
	TextQuery = "INSERT INTO characters_jobs (char_id, Alternate, civ_high, civ_med, civ_low, medsci_high, medsci_med, medsci_low, engsec_high, engsec_med, engsec_low) "
	TextQuery += " VALUES ('[alternate_option]', '[job_civilian_high]', '[job_civilian_med]', '[job_civilian_low]', '[job_medsci_high]', '[job_medsci_med]', '[job_medsci_low]', "
	TextQuery += "'[job_engsec_high]', '[job_engsec_med]', '[job_engsec_low]')"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateJobsData()
	TextQuery = "UPDATE characters_jobs SET Alternate='[alternate_option]', civ_high='[job_civilian_high]', civ_med='[job_civilian_med]', civ_low='[job_civilian_low]', "
	TextQuery += "medsci_high='[job_medsci_high]', medsci_med='[job_medsci_med]', medsci_low='[job_medsci_low]', "
	TextQuery += "engsec_high='[job_engsec_high]', engsec_med='[job_engsec_med]', engsec_low='[job_engsec_low]' WHERE char_id = [char_id] "
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadJobsData()
	TextQuery = "SELECT * FROM characters_jobs WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	log_debug("Load query executed successfully")
	query.NextRow()
	alternate_option = query.item[3]
	job_civilian_high = query.item[4]
	job_civilian_med = query.item[5]
	job_civilian_low = query.item[6]
	job_medsci_high = query.item[7]
	job_medsci_med = query.item[8]
	job_medsci_low = query.item[9]
	job_engsec_high = query.item[10]
	job_engsec_med = query.item[11]
	job_engsec_low = query.item[12]
	return 1

/datum/preferences/proc/InsertFlavourData()
	TextQuery = "INSERT INTO characters_flavour (char_id, generals, head, face, eyes, torso, arms, hands, legs, feet) "
	TextQuery += " VALUES ('[char_id]','[flavor_texts["general"]]', '[flavor_texts["head"]]', '[flavor_texts["face"]]', '[flavor_texts["eyes"]]', '[flavor_texts["torso"]]', "
	TextQuery += "'[flavor_texts["arms"]]', '[flavor_texts["hands"]]', '[flavor_texts["legs"]]', '[flavor_texts["feet"]]')"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateFlavourData()
	TextQuery = "UPDATE characters_flavour SET generals='[flavor_texts["general"]]', head='[flavor_texts["head"]]', face='[flavor_texts["face"]]', eyes='[flavor_texts["eyes"]]', "
	TextQuery += "torso='[flavor_texts["torso"]]', arms='[flavor_texts["arms"]]', hands='[flavor_texts["hands"]]', legs='[flavor_texts["legs"]]', feet='[flavor_texts["feet"]]' "
	TextQuery += "WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadFlavourData()
	TextQuery = "SELECT * FROM characters_flavour WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	log_debug("Load query executed successfully")
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
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateRobotFlavourData()
	TextQuery = "UPDATE characters_robot_flavour SET Default_Robot='[flavour_texts_robot["Default"]]', Standard='[flavour_texts_robot["Standard"]]', Engineering='[flavour_texts_robot["Engineering"]]', "
	TextQuery += "Construction='[flavour_texts_robot["Construction"]]', Surgeon='[flavour_texts_robot["Surgeon"]]', Crisis='[flavour_texts_robot["Crisis"]]', Miner='[flavour_texts_robot["Miner"]]', "
	TextQuery += "Janitor='[flavour_texts_robot["Janitor"]]', Service='[flavour_texts_robot["Service"]]', Clerical='[flavour_texts_robot["Clerical"]]', "
	TextQuery += "Security='[flavour_texts_robot["Security"]]', Research='[flavour_texts_robot["Research"]]' WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadRobotFlavourData()
	TextQuery = "SELECT * FROM characters_robot_flavour WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	log_debug("Load query executed successfully")
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
	TextQuery = "INSERT INTO characters_misc (char_id, med_rec, sec_rec, gen_rec, alt_titles, disab, used_skill, skills, skills_spec, organ_dat, limb_dat, gear,"
	TextQuery += "home_sys, citizen, faction, religion, NT_relation, uplink_loc, exploit_rec) VALUES ("
	TextQuery += "'[char_id]', '[med_record]', '[sec_record]', '[gen_record]', '[player_alt_titles]', '[disabilities]', '[used_skillpoints]', '[skills]', "
	TextQuery += "'[skill_specialization]', '[organ_data]', '[rlimb_data]', '[gear]', '[home_system]', '[citizenship]', '[faction]', '[religion]', '[nanotrasen_relation]', "
	TextQuery += "'[uplinklocation]', '[exploit_record]')"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdateMiscData()
	TextQuery = "UPDATE characters_misc SET med_rec='[med_record]', sec_rec='[sec_record]', gen_rec='[gen_record]', alt_titles='[player_alt_titles]', disab='[disabilities]', "
	TextQuery += "used_skill='[used_skillpoints]', skills='[skills]', skills_spec='[skill_specialization]', organ_dat='[organ_data]', limb_dat='[rlimb_data]', gear='[gear]', "
	TextQuery += "home_sys='[home_system]', citizen='[citizenship]', faction='[faction]', religion='[religion]', NT_relation='[nanotrasen_relation]', uplink_loc='[uplinklocation]', "
	TextQuery += "exploit_rec='[exploit_record]' WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadMiscData()
	TextQuery = "SELECT * FROM characters_misc WHERE char_id = [char_id]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return 0
	log_debug("Load query executed successfully")
	query.NextRow()
	med_record = query.item[3]
	sec_record = query.item[4]
	gen_record = query.item[5]
	player_alt_titles = query.item[6]
	disabilities = query.item[7]
	used_skillpoints = query.item[8]
	skills = query.item[9]
	skill_specialization = query.item[10]
	organ_data = query.item[11]
	rlimb_data = query.item[12]
	gear = query.item[13]
	home_system = query.item[14]
	citizenship = query.item[15]
	faction = query.item[16]
	religion = query.item[17]
	nanotrasen_relation = query.item[18]
	uplinklocation = query.item[19]
	exploit_record = query.item[20]
	return 1

/datum/preferences/proc/SavePrefData(var/ckey)
	TextQuery = "SELECT * FROM characters_misc WHERE ckey = [ckey]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(query.RowCount())
		return UpdatePrefData(ckey)
	sanitizePrefs()
	TextQuery = "INSERT INTO player_preferences (ckey, ooccolor, lastchangelog, UI_style, default_slot, toggles, UI_style_color, UI_style_alpha, be_special) "
	TextQuery += "VALUES ('[ckey]', '[ooccolor]','[lastchangelog]', '[UI_style]', '[default_slot]', '[toggles]', '[UI_style_color]', '[UI_style_alpha]','[be_special]')"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/UpdatePrefData(var/ckey)
	sanitizePrefs()
	TextQuery = "UPDATE player_preferences SET ooccolor='[ooccolor]', lastchangelog='[lastchangelog]', UI_style='[UI_style]', default_slot='[default_slot]', toggles='[toggles]', "
	TextQuery += "UI_style_color='[UI_style_color]', UI_style_alpha='[UI_style_alpha]', be_special='[be_special]') WHERE ckey = [ckey]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	return 1

/datum/preferences/proc/LoadPrefData(var/ckey)
	TextQuery = "SELECT * FROM characters_misc WHERE ckey = [ckey]"
	log_debug(TextQuery)
	query = dbcon.NewQuery(TextQuery)
	query.Execute()
	if(!query.RowCount())
		return SavePrefData(ckey)
	log_debug("Load query executed successfully")
	query.NextRow()
	ooccolor = query.item[3]
	lastchangelog = query.item[4]
	UI_style = query.item[5]
	default_slot = query.item[6]
	toggles = query.item[7]
	UI_style_color = query.item[8]
	UI_style_alpha = query.item[9]
	be_special = query.item[10]
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