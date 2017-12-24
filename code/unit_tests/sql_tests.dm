var/DBConnection/dbcon_ut

/proc/check_ut_db()
	if (!dbcon_ut)
		dbcon_ut = new("127.0.0.1", 3306, "ss13_test", "root")

	return establish_db_connection(dbcon_ut)

/datum/unit_test/sql_preferences
	name = "SQL: Preferences Columns"

/datum/unit_test/sql_preferences/start_test()
	if (!check_ut_db())
		fail("Test DB setup failed.")
		return TRUE

	var/faults = 0
	var/valid_columns = list()

	var/list/table_names = list(
		"ss13_characters",
		"ss13_characters_flavour"
	)
	for (var/T in table_names)
		var/DBQuery/get_cs = dbcon_ut.NewQuery("SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_NAME` = :table:")
		get_cs.Execute(list("table" = T))

		if (get_cs.ErrorMsg())
			log_unit_test("[ascii_red]--------------- SQL error encountered: [get_cs.ErrorMsg()].[ascii_reset]")
			fail("SQL error encountered.")
			return TRUE

		valid_columns[T] = list()

		while (get_cs.NextRow())
			valid_columns[T][get_cs.item[1]] = TRUE

	var/datum/preferences/P = new(null)

	for (var/datum/category_group/player_setup_category/G in P.player_setup.categories)
		for (var/datum/category_item/player_setup_item/A in G.items)
			var/list/test_columns = list()
			var/list/temp


			temp = A.gather_load_query()
			for (var/B in temp)
				if (!test_columns[B])
					test_columns[B] = list()

				test_columns[B] |= temp[B]["vars"]
				test_columns[B] |= temp[B]["args"]
			temp.Cut()


			temp = A.gather_load_parameters()
			var/list/unfound = temp.Copy()
			for (var/C in temp)
				for (var/B in test_columns)
					if (C in test_columns[B])
						unfound -= C
						break

			if (unfound.len)
				for (var/C in unfound)
					log_unit_test("[ascii_red]--------------- load parameter '[C]' not found in any queries for '[A.name]'.[ascii_reset]")
					faults++
			temp.Cut()


			temp = A.gather_save_query()
			for (var/B in temp)
				if (!test_columns[B])
					test_columns[B] = list()

				test_columns[B] |= temp[B]
			temp.Cut()

			for (var/B in test_columns)
				var/list/valids = valid_columns[B]
				if (!valids || !valids.len)
					log_unit_test("[ascii_red]--------------- table '[B]' referenced but not found for '[A.name]'.[ascii_reset]")
					faults++
					continue

				for (var/C in test_columns[B])
					if (!(C in valids))
						log_unit_test("[ascii_red]--------------- column '[C]' referenced but not in table '[B]' '[A.name]'.[ascii_reset]")
						faults++

	if (faults)
		fail("\[[faults]\] faults found in the SQL preferences setup.")
	else
		pass("No faults found in the SQL preferences setup.")

	return TRUE
