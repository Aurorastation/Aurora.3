/obj/item/device/identityscanner
	name = "identity scanner"
	desc = "A hand-held scanner able to determine the identity of a individual."
	icon_state = "health"
	item_state = "healthanalyzer"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/last_scan = 0
	var/scan_number = 0
	var/person_name = "NO DATA"
	var/person_faction = "NO DATA"
	var/person_species = "NO DATA"
	var/person_economic_status = "NO DATA"
	var/person_religion = "NO DATA"
	var/person_sec_incident_count = "NO DATA"
	var/person_ccia_incident_count = "NO DATA"
	var/person_created_at = "NO DATA"
	var/person_jobs = list()


/obj/item/device/identityscanner/attack(mob/living/M, mob/living/user)
	// Check if the db is connected first
	if (!establish_db_connection(dbcon))
		to_chat(user,SPAN_WARNING("Database not available - Try again later"))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(src)
	flick("[icon_state]-scan", src)
	add_fingerprint(user)

	//Reset the data before the query
	scan_number += 1
	person_name = "NO DATA"
	person_faction = "NO DATA"
	person_species = "NO DATA"
	person_economic_status = "NO DATA"
	person_religion = "NO DATA"
	person_sec_incident_count = "NO DATA"
	person_ccia_incident_count = "NO DATA"
	person_created_at = "NO DATA"
	person_jobs = list()

	if(M && M.character_id)
		// Perform the person_query
		var/DBQuery/person_query = dbcon.NewQuery("SELECT id as chr_id, name, faction, species, economic_status, religion, (SELECT COUNT(*) FROM ss13_character_incidents WHERE char_id = chr_id) AS sec_incident_count, (SELECT COUNT(*) FROM ss13_ccia_action_char WHERE char_id = chr_id) AS ccia_incident_count, created_at FROM ss13_characters WHERE id = :char_id: ORDER BY id DESC")
		person_query.Execute(list("char_id"=M.character_id))
		while(person_query.NextRow())
			person_name = person_query.item[2]
			person_faction = person_query.item[3]
			person_species = person_query.item[4]
			person_economic_status = person_query.item[5]
			person_religion = person_query.item[6]
			person_sec_incident_count = person_query.item[7]
			person_ccia_incident_count = person_query.item[8]
			person_created_at = person_query.item[9]

		//Perform the jobs query
		//ToDo: Add antag status?
		var/DBQuery/job_query = dbcon.NewQuery("SELECT ss13_characters_log.id, ss13_characters_log.datetime, ss13_characters_log.job_name, ss13_characters_log.alt_title, ss13_antag_log.special_role_name FROM ss13_characters_log LEFT JOIN ss13_antag_log ON ss13_characters_log.game_id = ss13_antag_log.game_id AND ss13_characters_log.char_id = ss13_antag_log.char_id WHERE ss13_characters_log.char_id = :char_id: ORDER BY id DESC LIMIT 0,50")
		job_query.Execute(list("char_id"=M.character_id))
		while(job_query.NextRow())
			person_jobs += list(list("id"=job_query.item[1], "date"=job_query.item[2], "job_name"=job_query.item[3], "alt_title"=job_query.item[4], "special_role"=job_query.item[5]))

	else
		person_name = "NOT IN DATABASE"
		person_faction = "Event Character?"
		person_jobs = list()

	//Open the UI
	ui_interact(user)


/obj/item/device/identityscanner/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "IdentityScanner", "Identity Scanner", 750, 850)
    ui.open()

/obj/item/device/identityscanner/ui_data(mob/user)
  var/list/data = list()
  data["scan_number"] = scan_number
  data["name"] = person_name
  data["faction"] = person_faction
  data["species"] = person_species
  data["economic_status"] = person_economic_status
  data["religion"] = person_religion
  data["sec_incident_count"] = person_sec_incident_count
  data["ccia_incident_count"] = person_ccia_incident_count
  data["created_at"] = person_created_at
  data["last_jobs"] = person_jobs


  return data
