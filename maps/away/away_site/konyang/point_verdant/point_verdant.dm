/datum/map_template/ruin/away_site/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	id = "point_verdant"
	description = "A landing zone designated by local authorities within an SCC-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("away_site/konyang/point_verdant/point_verdant-1.dmm","away_site/konyang/point_verdant/point_verdant-2.dmm","away_site/konyang/point_verdant/point_verdant-3.dmm")
	spawn_weight = 1
	spawn_cost = 1
	unit_test_groups = list(2)


/singleton/submap_archetype/point_verdant
	map = "point_verdant"
	descriptor = "A landing zone within Point Verdant city limits."

/obj/effect/overmap/visitable/sector/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	desc = "A landing zone designated by local authorities within an SCC-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	icon_state = "poi"
	scanimage = "konyang_point_verdant.png"
	place_near_main = list(0,0)
	landing_site = TRUE
	alignment = "Coalition of Colonies"
	requires_contact = FALSE
	instant_contact = TRUE

	comms_support = TRUE
	comms_name = "National Police" //these comms should only be used by Konyang Police ghostroles
	freq_name = "Corporate District Patrol"

	initial_generic_waypoints = list(
		"nav_point_verdant_waterdock_01",
		"nav_point_verdant_waterdock_02",
		"nav_point_verdant_waterdock_03",
		"nav_point_verdant_waterdock_04",
		"nav_point_verdant_waterdock_05",
		"nav_point_verdant_waterdock_06",
		"nav_point_verdant_waterdock_07",
		"nav_point_verdant_waterdock_08",
		"nav_point_verdant_waterdock_09",
		"nav_point_verdant_waterdock_10",
		"nav_point_verdant_waterdock_11",
		"nav_point_verdant_waterdock_12",
		"nav_point_verdant_waterdock_13",
		"nav_point_verdant_waterdock_14",
	)
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_point_verdant_spaceport_intrepid"),
		"Spark" = list("nav_point_verdant_spaceport_spark"),
		"Canary" = list("nav_point_verdant_spaceport_canary", "nav_point_verdant_corporate_canary"),
	)

// Lore items

/obj/item/paper/fluff/umbrella_report_1
	name = "progress report"
	desc = "A progress report marked with an EE stamp."
	info = "(This report goes into a lengthy semi-rant by a disgruntled employee about the Facility Director having seen the potential of the IPC signal. They demanded that several \
			infected IPCs be brought to testing cells at any cost. They would embark on a certain 'Project Hylemnomil'.)"

/obj/item/paper/fluff/umbrella_report_2
	name = "progress report"
	desc = "A progress report marked with an EE stamp."
	info = "(This report describes the steps taken for the abduction of a test subject. They specifically researched many profiles, and ended up settling for \
			a girl with no family and no friends, who was coming that day for an interview for an Einstein desk job. The abduction was going to be easy, painless, and invisible.)"

/obj/item/paper/fluff/umbrella_report_3
	name = "medical progress report"
	desc = "A single-page progress report marked with an EE stamp."
	info = "(This report is a complex medical report that you simply cannot read as a non-doctor. If you are a doctor, adminhelp and let Matt know that you found Report 3.)"

/obj/item/paper/fluff/umbrella_report_4
	name = "medical paper stack"
	desc = "A medical paper stack marked with an EE stamp. It's made up of many papers taped together."
	info = "(This stack of papers is a complex bundle of body scans that you simply cannot read as a non-doctor. If you are a doctor, adminhelp and let Matt know that you found Report 4.)"

/obj/item/paper/fluff/umbrella_report_5
	name = "antiviral test results"
	desc = "A neat stack of antiviral test results."
	info = "(These antiviral test results simply cannot be read as a non-doctor. If you are a doctor, adminhelp and let Matt know that you found Report 5.)"

/obj/item/paper/fluff/wanted_poster
	name = "police wanted poster"
	desc = "A haphazardly crafted wanted poster."
	info = "<center><b><font size=4>HELP WANTED</font></b></center><br> Ito Suzuki has been missing for ten days. If you have seen them, please contact the Police Department and  Hikari on Chirper at sugimoto.hikari."
