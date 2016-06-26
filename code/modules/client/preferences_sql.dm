/datum/preferences/proc/load_preferences_sql(var/client/C)
	if (!C)
		return 0

	var/DBQuery/query = dbcon.NewQuery({"SELECT
											ooccolor,
											lastchangelog,
											UI_style,
											current_character,
											toggles,
											UI_style_color,
											UI_style_alpha,
											be_special,
											asfx_togs
										FROM ss13_player_preferences
										WHERE ckey = :ckey"})
	query.Execute(list(":ckey" = C.ckey))

	if (!query.NextRow())
		return insert_preferences_sql(C)

	ooccolor			= query.item[1]
	lastchangelog		= query.item[2]
	UI_style			= query.item[3]
	current_character	= text2num(query.item[4])
	toggles				= text2num(query.item[5])
	UI_style_color		= query.item[6]
	UI_style_alpha		= text2num(query.item[7])
	be_special			= text2num(query.item[8])
	asfx_togs			= text2num(query.item[9])

	//Sanitize
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("White", "Midnight","Orange","old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	asfx_togs		= sanitize_integer(asfx_togs, 0, 65535, initial(asfx_togs))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))

	return 1

/datum/preferences/proc/save_preferences_sql(var/client/C)
	if (!C)
		return 0

	var/DBQuery/initial_query = dbcon.NewQuery("SELECT COUNT(*) AS rowsFound FROM ss13_player_preferences WHERE ckey = :ckey")
	initial_query.Execute(list(":ckey" = C.ckey))

	if (!initial_query.NextRow())
		return insert_preferences_sql(C)

	var/DBQuery/update_query = dbcon.NewQuery({"UPDATE ss13_player_preferences SET
													ooccolor = :ooccolor,
													lastchangelog = :lastchangelog,
													UI_style = :ui_style,
													current_character = :current_character,
													toggles = :toggles,
													UI_style_color = :ui_color,
													UI_style_alpha = :ui_alpha,
													be_special = :be_special,
													asfx_togs = :asfx_togs
												WHERE ckey = :ckey"})
	update_query.Execute(get_prefs_update_insert_params(C))

	return 1

/datum/preferences/proc/insert_preferences_sql(var/client/C)
	if (!C)
		return 0

	var/DBQuery/query = dbcon.NewQuery({"INSERT INTO ss13_player_preferences (ckey, ooccolor, lastchangelog, UI_style, current_character, toggles, UI_style_color, UI_style_alpha, be_special, asfx_togs)
	VALUES (:ckey, :ooccolor, :lastchangelog, :ui_style, :current_character, :toggles, :ui_color, :ui_alpha, :be_special, :asfx_togs);"})
	query.Execute(get_prefs_update_insert_params(C))

	return 1

//Helper function.
/datum/preferences/proc/get_prefs_update_insert_params(var/client/C)
	var/params[] = list()

	params[":ckey"] = C.ckey

	params[":ooccolor"]				= ooccolor
	params[":lastchangelog"]		= lastchangelog
	params[":ui_style"]				= UI_style
	params[":current_character"]	= current_character
	params[":toggles"]				= toggles
	params[":ui_color"]				= UI_style_color
	params[":ui_alpha"]				= UI_style_alpha
	params[":be_special"]			= be_special
	params[":asfx_togs"]			= asfx_togs

	return params

/datum/preferences/proc/load_character_sql(slot, var/client/C)
	if (!C)
		return 0

	if (!slot || slot == 0)
		return new_character_sql(C)

	current_character = slot

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		error("Error attempting to connect to MySQL server while loading a character.")
		return 0

	var/DBQuery/initial_query = dbcon.NewQuery("SELECT name FROM ss13_characters WHERE id = :character_id AND ckey = :ckey")
	initial_query.Execute(list(":character_id" = current_character, ":ckey" = C.ckey))

	// In case someone got themselves an invalid character ID.
	if (!initial_query.NextRow())
		error("[C.ckey] attempted to load character #[current_character] and failed. No such character found.")
		new_character_sql(C)
		return 0

	var/DBQuery/character_query = dbcon.NewQuery({"SELECT
												dat.name,
												dat.metadata,
												dat.random_name,
												dat.gender,
												dat.age,
												dat.species,
												dat.language,
												dat.spawnpoint,
												dat.hair_colour,
												dat.facial_colour,
												dat.skin_tone,
												dat.skin_colour,
												dat.hair_style,
												dat.facial_style,
												dat.eyes_colour,
												dat.underwear,
												dat.undershirt,
												dat.backbag,
												dat.b_type,
												dat.jobs,
												dat.alternate_option,
												dat.alternate_titles,
												flv.flavour_general,
												flv.flavour_head,
												flv.flavour_face,
												flv.flavour_eyes,
												flv.flavour_torso,
												flv.flavour_arms,
												flv.flavour_hands,
												flv.flavour_legs,
												flv.flavour_feet,
												flv.robot_default,
												flv.robot_standard,
												flv.robot_engineering,
												flv.robot_construction,
												flv.robot_surgeon,
												flv.robot_crisis,
												flv.robot_miner,
												flv.robot_janitor,
												flv.robot_service,
												flv.robot_clerical,
												flv.robot_security,
												flv.robot_research,
												flv.records_employment,
												flv.records_medical,
												flv.records_security,
												flv.records_exploit,
												dat.disabilities,
												dat.skills,
												dat.skills_specialization,
												dat.home_system,
												dat.citizenship,
												dat.faction,
												dat.religion,
												dat.nt_relation,
												dat.uplink_location,
												dat.organs_data,
												dat.organs_robotic,
												dat.gear
												FROM ss13_characters dat
												JOIN ss13_characters_flavour flv ON dat.id = flv.char_id
												WHERE dat.id = :char_id"})
	if (!character_query.Execute(list(":char_id" = current_character)))
		error("Error loading character #[current_character]. SQL error message: '[character_query.ErrorMsg()]'.")
		new_character_sql(C)
		return 0

	if (!character_query.NextRow())
		error("Error loading character #[current_character]. No such character exists.")
		new_character_sql(C)
		return 0

	var/DBQuery/char_id_update = dbcon.NewQuery("UPDATE ss13_player_preferences SET current_character = :char_id WHERE ckey = :ckey")
	char_id_update.Execute(list(":char_id" = current_character, ":ckey" = C.ckey))

	// Character
	real_name			= character_query.item[1]
	metadata			= character_query.item[2]
	be_random_name		= text2num(character_query.item[3])
	gender				= character_query.item[4]
	age					= text2num(character_query.item[5])
	species				= character_query.item[6]
	language			= character_query.item[7]
	spawnpoint			= character_query.item[8]

	// Other customization data
	var/list/hair_rgb	= length(character_query.item[9]) == 7 ? GetHexColors(character_query.item[9]) : null
	if (hair_rgb)
		r_hair				= hair_rgb[1]
		g_hair				= hair_rgb[2]
		b_hair				= hair_rgb[3]
	var/list/facial_rgb	= length(character_query.item[10]) == 7 ? GetHexColors(character_query.item[10]) : null
	if (facial_rgb)
		r_facial			= facial_rgb[1]
		g_facial			= facial_rgb[2]
		b_facial			= facial_rgb[3]
	s_tone				= text2num(character_query.item[11])
	var/list/skin_rgb	= length(character_query.item[12]) == 7 ? GetHexColors(character_query.item[12]) : null
	if (skin_rgb)
		r_skin				= skin_rgb[1]
		g_skin				= skin_rgb[2]
		b_skin				= skin_rgb[3]
	h_style				= character_query.item[13]
	f_style				= character_query.item[14]
	var/list/eyes_rgb	= length(character_query.item[15]) == 7 ? GetHexColors(character_query.item[15]) : null
	if (eyes_rgb)
		r_eyes				= eyes_rgb[1]
		g_eyes				= eyes_rgb[2]
		b_eyes				= eyes_rgb[3]
	underwear			= character_query.item[16]
	undershirt			= character_query.item[17]
	backbag				= text2num(character_query.item[18])
	b_type				= character_query.item[19]

	var/list/jobs_list	= params2list(character_query.item[20])

	// Job preferences + alt titles and options
	if (jobs_list.len == 9)
		job_civilian_high	= text2num(jobs_list["civ_high"])
		job_civilian_med	= text2num(jobs_list["civ_med"])
		job_civilian_low	= text2num(jobs_list["civ_low"])
		job_medsci_high		= text2num(jobs_list["medsci_high"])
		job_medsci_med		= text2num(jobs_list["medsci_med"])
		job_medsci_low		= text2num(jobs_list["medsci_low"])
		job_engsec_high		= text2num(jobs_list["engsec_high"])
		job_engsec_med		= text2num(jobs_list["engsec_med"])
		job_engsec_low		= text2num(jobs_list["engsec_low"])

	alternate_option	= text2num(character_query.item[21])
	player_alt_titles	= params2list(character_query.item[22])

	// Flavour texts
	flavor_texts["general"]				= character_query.item[23]
	flavor_texts["head"]				= character_query.item[24]
	flavor_texts["face"]				= character_query.item[25]
	flavor_texts["eyes"]				= character_query.item[26]
	flavor_texts["torso"]				= character_query.item[27]
	flavor_texts["arms"]				= character_query.item[28]
	flavor_texts["hands"]				= character_query.item[29]
	flavor_texts["legs"]				= character_query.item[30]
	flavor_texts["feet"]				= character_query.item[31]

	flavour_texts_robot["Default"]		= character_query.item[32]
	flavour_texts_robot["Standard"]		= character_query.item[33]
	flavour_texts_robot["Engineering"]	= character_query.item[34]
	flavour_texts_robot["Construction"]	= character_query.item[35]
	flavour_texts_robot["Surgeon"]		= character_query.item[36]
	flavour_texts_robot["Crisis"]		= character_query.item[37]
	flavour_texts_robot["Miner"]		= character_query.item[38]
	flavour_texts_robot["Janitor"]		= character_query.item[39]
	flavour_texts_robot["Service"]		= character_query.item[40]
	flavour_texts_robot["Clerical"]		= character_query.item[41]
	flavour_texts_robot["Security"]		= character_query.item[42]
	flavour_texts_robot["Research"]		= character_query.item[43]

	// Records
	gen_record				= character_query.item[44]
	med_record				= character_query.item[45]
	sec_record				= character_query.item[46]
	exploit_record			= character_query.item[47]

	// Miscellaneous
	disabilities			= text2num(character_query.item[48])
	skills					= params2list(character_query.item[49])
	skill_specialization	= character_query.item[50]
	home_system				= character_query.item[51]
	citizenship				= character_query.item[52]
	faction					= character_query.item[53]
	religion				= character_query.item[54]
	nanotrasen_relation		= character_query.item[55]

	uplinklocation			= character_query.item[56]

	organ_data				= params2list(character_query.item[57])
	rlimb_data				= params2list(character_query.item[58])
	gear					= params2list(character_query.item[59])

	// Sanitization
	metadata			= sanitize_text(metadata, initial(metadata))
	real_name			= sanitizeName(real_name)

	if (isnull(species) || !(species in playable_species))
		species = "Human"

	if (isnum(underwear))
		var/list/undies = gender == MALE ? underwear_m : underwear_f
		underwear = undies[undies[underwear]]

	if (isnum(undershirt))
		undershirt = undershirt_t[undershirt_t[undershirt]]

	if (isnull(language)) language = "None"
	if (isnull(spawnpoint)) spawnpoint = "Arrivals Shuttle"
	if (isnull(nanotrasen_relation)) nanotrasen_relation = initial(nanotrasen_relation)
	if (!real_name) real_name = random_name(gender)
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

	if (!skills) ZeroSkills(1)
	if (skills.len) CalculateSkillPoints()
	if (!used_skillpoints) used_skillpoints = 0
	if (isnull(disabilities)) disabilities = 0
	if (!player_alt_titles) player_alt_titles = new()
	if (!organ_data) organ_data = list()
	if (!rlimb_data) rlimb_data = list()
	if (!gear) gear = list()

	if (!home_system) home_system = "Unset"
	if (!citizenship) citizenship = "None"
	if (!faction) faction = "None"
	if (!religion) religion = "None"

	return 1

/datum/preferences/proc/save_character_sql(var/client/C)
	if (!C)
		return 0

	if (!current_character)
		return insert_character_sql(C)

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		error("Error attempting to connect to MySQL server while saving a character.")
		return 0

	var/DBQuery/initial_query = dbcon.NewQuery("SELECT COUNT(*) AS rowCount FROM ss13_characters WHERE id = :char_id")
	initial_query.Execute(list(":char_id" = current_character))

	if (!initial_query.NextRow())
		current_character = 0
		return insert_character_sql(C)

	var/DBQuery/update_query = dbcon.NewQuery({"UPDATE ss13_characters dat
											JOIN ss13_characters_flavour flv ON dat.id = flv.char_id
											SET
											dat.name = :real_name,
											dat.metadata = :metadata,
											dat.random_name = :is_random,
											dat.gender = :gender,
											dat.age = :age,
											dat.species = :species,
											dat.language = :language,
											dat.spawnpoint = :spawnpoint,
											dat.hair_colour = :hair_colour,
											dat.facial_colour = :facial_colour,
											dat.skin_tone = :skin_tone,
											dat.skin_colour = :skin_colour,
											dat.hair_style = :hair_style,
											dat.facial_style = :facial_style,
											dat.eyes_colour = :eyes_colour,
											dat.underwear = :underwear,
											dat.undershirt = :undershirt,
											dat.backbag = :backbag,
											dat.b_type = :b_type,
											dat.jobs = :jobs,
											dat.alternate_option = :alternate_option,
											dat.alternate_titles = :alternate_titles,
											dat.disabilities = :disabilities,
											dat.skills = :skills,
											dat.skills_specialization = :specialization,
											dat.home_system = :home_system,
											dat.citizenship = :citizenship,
											dat.faction = :faction,
											dat.religion = :religion,
											dat.nt_relation = :nt_relation,
											dat.uplink_location = :uplink_loc,
											dat.organs_data = :organ_data,
											dat.organs_robotic = :organs_robotic,
											dat.gear = :gear,
											flv.flavour_general = :flv_general,
											flv.flavour_head = :flv_head,
											flv.flavour_face = :flv_face,
											flv.flavour_eyes = :flv_eyes,
											flv.flavour_torso = :flv_torso,
											flv.flavour_arms = :flv_arms,
											flv.flavour_hands = :flv_hands,
											flv.flavour_legs = :flv_legs,
											flv.flavour_feet = :flv_feet,
											flv.robot_default = :robot_default,
											flv.robot_standard = :robot_standard,
											flv.robot_engineering = :robot_engineering,
											flv.robot_construction = :robot_construction,
											flv.robot_surgeon = :robot_surgeon,
											flv.robot_crisis = :robot_crisis,
											flv.robot_miner = :robot_miner,
											flv.robot_janitor = :robot_janitor,
											flv.robot_service = :robot_service,
											flv.robot_clerical = :robot_clerical,
											flv.robot_security = :robot_security,
											flv.robot_research = :robot_research,
											flv.records_medical = :med_rec,
											flv.records_security = :sec_rec,
											flv.records_employment = :gen_rec,
											flv.records_exploit = :exploit_record
											WHERE dat.id = :char_id"})

	update_query.Execute(get_update_insert_params())

	if (update_query.ErrorMsg())
		error("Error updating character #[current_character]: [update_query.ErrorMsg()]")
		return 0

	return 1

/datum/preferences/proc/insert_character_sql(var/client/C)
	if (!C)
		return 0

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		error("Error attempting to connect to MySQL server while inserting a character.")
		return 0

	var/params[] = get_update_insert_params(0, C)

	var/DBQuery/insert_query = dbcon.NewQuery({"INSERT INTO ss13_characters (id, ckey, name, metadata, random_name, gender, age, species, language, hair_colour, facial_colour, skin_tone, skin_colour, hair_style, facial_style, eyes_colour, underwear, undershirt, backbag, b_type, spawnpoint, jobs, alternate_option, alternate_titles, disabilities, skills, skills_specialization, home_system, citizenship, faction, religion, nt_relation, uplink_location, organs_data, organs_robotic, gear)
	VALUES (NULL, :ckey, :real_name, :metadata, :is_random, :gender, :age, :species, :language, :hair_colour, :facial_colour, :skin_tone, :skin_colour, :hair_style, :facial_style, :eyes_colour, :underwear, :undershirt, :backbag, :b_type, :spawnpoint, :jobs, :alternate_option, :alternate_titles, :disabilities, :skills, :specialization, :home_system, :citizenship, :faction, :religion, :nt_relation, :uplink_loc, :organ_data, :organs_robotic, :gear);"})
	insert_query.Execute(params, 1)

	if (insert_query.ErrorMsg())
		return 0

	var/DBQuery/get_query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey AND name = :real_name ORDER BY id DESC LIMIT 1;")
	get_query.Execute(list(":ckey" = C.ckey, ":real_name" = real_name))

	if (get_query.NextRow())
		current_character = text2num(get_query.item[1])
		params[":char_id"]  = current_character

	insert_query = dbcon.NewQuery({"INSERT INTO ss13_characters_flavour (char_id, records_employment, records_medical, records_security, records_exploit, flavour_general, flavour_head, flavour_face, flavour_eyes, flavour_torso, flavour_arms, flavour_hands, flavour_legs, flavour_feet, robot_default, robot_standard, robot_engineering, robot_construction, robot_surgeon, robot_crisis, robot_miner, robot_janitor, robot_service, robot_clerical, robot_security, robot_research)
	VALUES (:char_id, :gen_rec, :med_rec, :sec_rec, :exploit_record, :flv_general, :flv_head, :flv_face, :flv_eyes, :flv_torso, :flv_arms, :flv_hands, :flv_legs, :flv_feet, :robot_default, :robot_standard, :robot_engineering, :robot_construction, :robot_surgeon, :robot_crisis, :robot_miner, :robot_janitor, :robot_service, :robot_clerical, :robot_security, :robot_research);"})
	insert_query.Execute(params, 1)

	if (insert_query.ErrorMsg())
		return 0

	return 1

// Helper function.
// Returns an array to be used in save_character_sql and insert_character_sql.
/datum/preferences/proc/get_update_insert_params(var/include_id = 1, var/client/C = null)
	var/hair_hex = "#" + num2hex(r_hair) + num2hex(g_hair) + num2hex(b_hair)
	var/facial_hex = "#" + num2hex(r_facial) + num2hex(g_facial) + num2hex(b_facial)
	var/eyes_hex = "#" + num2hex(r_eyes) + num2hex(g_eyes) + num2hex(b_eyes)
	var/skin_hex = "#" + num2hex(r_skin) + num2hex(g_skin) + num2hex(b_skin)

	var/language_string = "None"
	if (!istext(language))
		if (istype(language, /datum/language))
			for (var/L in all_languages)
				if (language == all_languages[L])
					language_string = L
					break
	else
		language_string = language

	var/jobs_list[] = list()
	jobs_list["civ_high"] = job_civilian_high
	jobs_list["civ_med"] = job_civilian_med
	jobs_list["civ_low"] = job_civilian_low
	jobs_list["medsci_high"] = job_medsci_high
	jobs_list["medsci_med"] = job_medsci_med
	jobs_list["medsci_low"] = job_medsci_low
	jobs_list["engsec_high"] = job_engsec_high
	jobs_list["engsec_med"] = job_engsec_med
	jobs_list["engsec_low"] = job_engsec_low

	var/params[] = list()

	params[":real_name"] = real_name
	params[":metadata"] = metadata
	params[":is_random"] = be_random_name
	params[":gender"] = gender
	params[":age"] = age
	params[":species"] = species
	params[":language"] = language_string
	params[":spawnpoint"] = spawnpoint
	params[":hair_colour"] = hair_hex
	params[":facial_colour"] = facial_hex
	params[":skin_tone"] = s_tone
	params[":skin_colour"] = skin_hex
	params[":hair_style"] = h_style
	params[":facial_style"] = f_style
	params[":eyes_colour"] = eyes_hex
	params[":underwear"] = underwear
	params[":undershirt"] = undershirt
	params[":backbag"] = backbag
	params[":b_type"] = b_type

	params[":alternate_option"] = alternate_option
	params[":jobs"] = list2params(jobs_list)
	params[":alternate_titles"] = list2params(player_alt_titles)

	params[":flv_general"] = flavor_texts["general"]
	params[":flv_head"] = flavor_texts["head"]
	params[":flv_face"] = flavor_texts["face"]
	params[":flv_eyes"] = flavor_texts["eyes"]
	params[":flv_torso"] = flavor_texts["torso"]
	params[":flv_arms"] = flavor_texts["arms"]
	params[":flv_hands"] = flavor_texts["hands"]
	params[":flv_legs"] = flavor_texts["legs"]
	params[":flv_feet"] = flavor_texts["feet"]
	params[":robot_default"] = flavour_texts_robot["Default"]
	params[":robot_standard"] = flavour_texts_robot["Standard"]
	params[":robot_engineering"] = flavour_texts_robot["Engineering"]
	params[":robot_construction"] = flavour_texts_robot["Construction"]
	params[":robot_surgeon"] = flavour_texts_robot["Surgeon"]
	params[":robot_crisis"] = flavour_texts_robot["Crisis"]
	params[":robot_miner"] = flavour_texts_robot["Miner"]
	params[":robot_janitor"] = flavour_texts_robot["Janitor"]
	params[":robot_service"] = flavour_texts_robot["Service"]
	params[":robot_clerical"] = flavour_texts_robot["Clerical"]
	params[":robot_security"] = flavour_texts_robot["Security"]
	params[":robot_research"] = flavour_texts_robot["Research"]

	params[":med_rec"] = med_record
	params[":sec_rec"] = sec_record
	params[":gen_rec"] = gen_record
	params[":disabilities"] = disabilities
	params[":skills"] = list2params(skills)
	params[":specialization"] = skill_specialization
	params[":home_system"] = home_system
	params[":citizenship"] = citizenship
	params[":faction"] = faction
	params[":religion"] = religion
	params[":nt_relation"] = nanotrasen_relation
	params[":uplink_loc"] = uplinklocation
	params[":exploit_record"] = exploit_record
	params[":organ_data"] = list2params(organ_data)
	params[":organs_robotic"] = list2params(rlimb_data)
	params[":gear"] = list2params(gear)

	if (include_id)
		params[":char_id"] = current_character

	if (C)
		params[":ckey"] = C.ckey

	return params

/datum/preferences/proc/new_character_sql(var/client/C)
	if (!C)
		return 0

	current_character = 0

	var/DBQuery/char_id_update = dbcon.NewQuery("UPDATE ss13_player_preferences SET current_character = '0' WHERE ckey = :ckey")
	char_id_update.Execute(list(":ckey" = C.ckey))

	species = "Human"
	language = "None"
	spawnpoint = "Arrivals Shuttle"
	nanotrasen_relation = initial(nanotrasen_relation)

	gender = pick(MALE, FEMALE)
	real_name = random_name(gender, species)
	gear = list()

	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
	return 1

/datum/preferences/proc/delete_character_sql(var/client/C)
	if (!C)
		return 0

	if (!current_character)
		return 0

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		error("Error attempting to connect to MySQL server while deleting a character.")
		return 0

	var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) AS rowCount FROM ss13_characters WHERE id = :char_id AND ckey = :ckey")
	query.Execute(list(":char_id" = current_character, ":ckey" = C.ckey))

	if (!query.NextRow())
		return 0

	var/DBQuery/delete_query = dbcon.NewQuery("DELETE FROM ss13_characters WHERE id = :id")
	delete_query.Execute(list(":id" = current_character))

	var/DBQuery/select_query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey ORDER BY id ASC LIMIT 1")
	select_query.Execute(list(":ckey" = C.ckey))

	if (select_query.NextRow())
		load_character_sql(text2num(select_query.item[1]), C)
	else
		new_character_sql(C)

	C << "<span class='notice'>Your character has been deleted from the database.</span>"
	return 1
