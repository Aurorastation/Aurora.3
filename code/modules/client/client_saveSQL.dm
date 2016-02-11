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
				if(!getCharId())
					log_debug("New Character")
					query = dbcon.NewQuery("INSERT INTO ss13_characters (ckey, slot) VALUES ('[ckey]', '[cslot]')")
					query.Execute()
					log_debug(dbcon.ErrorMsg())
					getCharId()
					InsertCharData()
					log_debug(dbcon.ErrorMsg())
					query = dbcon.NewQuery("UPDATE SS13_characters SET Character_key = (SELECT id FROM characters_data WHERE char_id = [char_id]) WHERE id = [char_id] ")
					query.Execute()
					log_debug(dbcon.ErrorMsg())
				else
					log_debug("ID = [char_id]")
					log_debug("Update entry")
					UpdateCharData()
			log_debug("Save query executed")
			return 1
	log_debug("No ckey in datums")
	return 0

/datum/preferences/proc/SQLload_character(slot)
	char_slot = slot
	if(!getCharId())
		return 0
	log_debug("Loading character ID [char_id] from slot [char_slot])
	return LoadCharData()

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
	eyes_B = query.item[4]
	eyes_G = query.item[5]
	eyes_R = query.item[6]
	facial_R = query.item[7]
	facial_G = query.item[8]
	facial_R = query.item[9]
	facial_style = query.item[10]
	gender = query.item[11]
	hair_B = query.item[12]
	hair_G = query.item[13]
	hair_R = query.item[14]
	hair_style = query.item[15]
	isRandom = query.item[16]
	language = query.item[17]
	name = query.item[18]
	OOC = query.item[19]
	skin_B = query.item[20]
	skin_G = query.item[21]
	skin_R = query.item[22]
	skin_tone = query.item[23]
	spawnpoint = query.item[24]
	species = query.item[25]
	undershirt = query.item[26]
	underwear = query.item[27]
	return 1

/datum/preferences/proc/getCharId()
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

/*	//Character
	chardata.Add(age)
	chardata.Add(backbag)
	chardata.Add(metadata)
	chardata.Add(real_name)
	chardata.Add(be_random_name)
	chardata.Add(gender)
	chardata.Add(species)
	chardata.Add(language)
	chardata.Add(r_hair)
	chardata.Add(g_hair)
	chardata.Add(b_hair)
	chardata.Add(r_facial)
	chardata.Add(g_facial)
	chardata.Add(b_facial)
	chardata.Add(s_tone)
	chardata.Add(r_skin)
	chardata.Add(g_skin)
	chardata.Add(b_skin)
	chardata.Add(h_style)
	chardata.Add(f_style)
	chardata.Add(r_eyes)
	chardata.Add(g_eyes)
	chardata.Add(b_eyes)
	chardata.Add(underwear)
	chardata.Add(undershirt)
	chardata.Add(b_type)
	chardata.Add(spawnpoint)

	//Jobs
	S["alternate_option"]	<< alternate_option
	S["job_civilian_high"]	<< job_civilian_high
	S["job_civilian_med"]	<< job_civilian_med
	S["job_civilian_low"]	<< job_civilian_low
	S["job_medsci_high"]	<< job_medsci_high
	S["job_medsci_med"]		<< job_medsci_med
	S["job_medsci_low"]		<< job_medsci_low
	S["job_engsec_high"]	<< job_engsec_high
	S["job_engsec_med"]		<< job_engsec_med
	S["job_engsec_low"]		<< job_engsec_low

	//Flavour Text
	S["flavor_texts_general"]	<< flavor_texts["general"]
	S["flavor_texts_head"]		<< flavor_texts["head"]
	S["flavor_texts_face"]		<< flavor_texts["face"]
	S["flavor_texts_eyes"]		<< flavor_texts["eyes"]
	S["flavor_texts_torso"]		<< flavor_texts["torso"]
	S["flavor_texts_arms"]		<< flavor_texts["arms"]
	S["flavor_texts_hands"]		<< flavor_texts["hands"]
	S["flavor_texts_legs"]		<< flavor_texts["legs"]
	S["flavor_texts_feet"]		<< flavor_texts["feet"]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] << flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] << flavour_texts_robot[module]

	//Miscellaneous
	S["med_record"]			<< med_record
	S["sec_record"]			<< sec_record
	S["gen_record"]			<< gen_record
	S["player_alt_titles"]		<< player_alt_titles
	S["be_special"]			<< be_special
	S["disabilities"]		<< disabilities
	S["used_skillpoints"]	<< used_skillpoints
	S["skills"]				<< skills
	S["skill_specialization"] << skill_specialization
	S["organ_data"]			<< organ_data
	S["rlimb_data"]			<< rlimb_data
	S["gear"]				<< gear
	S["home_system"] 		<< home_system
	S["citizenship"] 		<< citizenship
	S["faction"] 			<< faction
	S["religion"] 			<< religion

	S["nanotrasen_relation"] << nanotrasen_relation
	//S["skin_style"]			<< skin_style

	S["uplinklocation"] << uplinklocation
	S["exploit_record"]	<< exploit_record

	S["UI_style_color"]		<< UI_style_color
	S["UI_style_alpha"]		<< UI_style_alpha*/


/*/datum/preferences/proc/SQLSave_Preferences()
		//Sanitize
		ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
		lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
		UI_style		= sanitize_inlist(UI_style, list("White", "Midnight","Orange","old"), initial(UI_style))
		be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
		default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))
		toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
		UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
		UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))

			query = dbcon.Query("INSERT INTO (oocolor, lastchangelog, UI_style, be_special, default_slot, toggles, UI_style_color, UI_style_alpha) VALUES ([oocolor], [lastchangelog], [UI_style], [be_special], [default_slot], [toggles], [UI_style_color], [UI_style_alpha])")
		else
			var/id = query.item[2]
			query = dbcon.Query("UPDATE aurora_characters SET ooccolor=[ooccolor], lastchangelog=[lastchangelog], UI_style=[UI_style], be_special=[be_special], default_slot=[default_slot], toggles = [toggles], UI_style_color = [UI_style_color], UI_style_alpha = [UI_style_alpha] WHERE aurora_characters.id=[id]")
		query.Execute()
	return 1

/datum/preferences/proc/savefile_update()
	if(savefile_version < 8)	//lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in preferences_datums)
			var/datum/preferences/D = preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return 0

	if(savefile_version == SAVEFILE_VERSION_MAX)	//update successful.
		save_preferences()
		save_character()
		return 1
	return 0

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] >> savefile_version
	//Conversion
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update())  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return 0

	//general preferences
	S["ooccolor"]			>> ooccolor
	S["lastchangelog"]		>> lastchangelog
	S["UI_style"]			>> UI_style
	S["be_special"]			>> be_special
	S["default_slot"]		>> default_slot
	S["toggles"]			>> toggles
	S["UI_style_color"]		>> UI_style_color
	S["UI_style_alpha"]		>> UI_style_alpha

	//Sanitize
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("White", "Midnight","Orange","old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))

	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] << savefile_version

	//general preferences
	S["ooccolor"]			<< ooccolor
	S["lastchangelog"]		<< lastchangelog
	S["UI_style"]			<< UI_style
	S["be_special"]			<< be_special
	S["default_slot"]		<< default_slot
	S["toggles"]			<< toggles

	return 1

/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot
	slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		S["default_slot"] << slot
	S.cd = "/character[slot]"

	//Character
	S["OOC_Notes"]			>> metadata
	S["real_name"]			>> real_name
	S["name_is_always_random"] >> be_random_name
	S["gender"]				>> gender
	S["age"]				>> age
	S["species"]			>> species
	S["language"]			>> language
	S["spawnpoint"]			>> spawnpoint

	//colors to be consolidated into hex strings (requires some work with dna code)
	S["hair_red"]			>> r_hair
	S["hair_green"]			>> g_hair
	S["hair_blue"]			>> b_hair
	S["facial_red"]			>> r_facial
	S["facial_green"]		>> g_facial
	S["facial_blue"]		>> b_facial
	S["skin_tone"]			>> s_tone
	S["skin_red"]			>> r_skin
	S["skin_green"]			>> g_skin
	S["skin_blue"]			>> b_skin
	S["hair_style_name"]	>> h_style
	S["facial_style_name"]	>> f_style
	S["eyes_red"]			>> r_eyes
	S["eyes_green"]			>> g_eyes
	S["eyes_blue"]			>> b_eyes
	S["underwear"]			>> underwear
	S["undershirt"]			>> undershirt
	S["backbag"]			>> backbag
	S["b_type"]				>> b_type

	//Jobs
	S["alternate_option"]	>> alternate_option
	S["job_civilian_high"]	>> job_civilian_high
	S["job_civilian_med"]	>> job_civilian_med
	S["job_civilian_low"]	>> job_civilian_low
	S["job_medsci_high"]	>> job_medsci_high
	S["job_medsci_med"]		>> job_medsci_med
	S["job_medsci_low"]		>> job_medsci_low
	S["job_engsec_high"]	>> job_engsec_high
	S["job_engsec_med"]		>> job_engsec_med
	S["job_engsec_low"]		>> job_engsec_low

	//Flavour Text
	S["flavor_texts_general"]	>> flavor_texts["general"]
	S["flavor_texts_head"]		>> flavor_texts["head"]
	S["flavor_texts_face"]		>> flavor_texts["face"]
	S["flavor_texts_eyes"]		>> flavor_texts["eyes"]
	S["flavor_texts_torso"]		>> flavor_texts["torso"]
	S["flavor_texts_arms"]		>> flavor_texts["arms"]
	S["flavor_texts_hands"]		>> flavor_texts["hands"]
	S["flavor_texts_legs"]		>> flavor_texts["legs"]
	S["flavor_texts_feet"]		>> flavor_texts["feet"]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] >> flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] >> flavour_texts_robot[module]

	//Miscellaneous
	S["med_record"]			>> med_record
	S["sec_record"]			>> sec_record
	S["gen_record"]			>> gen_record
	S["be_special"]			>> be_special
	S["disabilities"]		>> disabilities
	S["player_alt_titles"]	>> player_alt_titles
	S["used_skillpoints"]	>> used_skillpoints
	S["skills"]				>> skills
	S["skill_specialization"] >> skill_specialization
	S["organ_data"]			>> organ_data
	S["rlimb_data"]			>> rlimb_data
	S["gear"]				>> gear
	S["home_system"] 		>> home_system
	S["citizenship"] 		>> citizenship
	S["faction"] 			>> faction
	S["religion"] 			>> religion

	S["nanotrasen_relation"] >> nanotrasen_relation
	//S["skin_style"]			>> skin_style

	S["uplinklocation"] >> uplinklocation
	S["exploit_record"]	>> exploit_record

	S["UI_style_color"]		<< UI_style_color
	S["UI_style_alpha"]		<< UI_style_alpha

	//Sanitize
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
	//if(!skin_style) skin_style = "Default"

	if(!home_system) home_system = "Unset"
	if(!citizenship) citizenship = "None"
	if(!faction)     faction =     "None"
	if(!religion)    religion =    "None"

	return 1




#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN*/