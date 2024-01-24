/datum/map/sccv_horizon
	name = "SCCV Horizon"
	full_name = "SCCV Horizon"
	path = "sccv_horizon"

	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi', 'icons/misc/titlescreens/aurora/vaurca.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(1, 2, 3)
	admin_levels = list(4)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3, 5)
	restricted_levels = list()
	accessible_z_levels = list("1" = 5, "2" = 5, "3" = 5, "5" = 75)
	empty_levels = list(5)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/space,
		"4" = /turf/space,
		"5" = /turf/space,
		"6" = /turf/space
	)

	station_name = "SCCV Горизонт"
	station_short = "Горизонт"
	dock_name = "Корпоративный связной порт"
	dock_short = "Связной порт"
	boss_name = "Звёздный Корпоративный Конгломерат"
	boss_short = "ЗКК"
	company_name = "Звёздный Корпоративный Конгломерат"
	company_short = "ЗКК"
	station_type = "судно"

	command_spawn_enabled = TRUE
	command_spawn_message = "Добро пожаловать на SCCV Горизонт!"

	use_overmap = TRUE
	num_exoplanets = 2
	overmap_size = 35
	overmap_event_areas = 34
	planet_size = list(255,255)

	away_site_budget = 2
	away_ship_budget = 2
	away_variance = 1

	station_networks = list(
		NETWORK_COMMAND,
		NETWORK_REACTOR,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY,
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_INTREPID,
		NETWORK_NEWS
	)

	shuttle_docked_message = "Внимание экипажу: закончены приготовления к ротации экипажа. Начало через %ETA% минуты."
	shuttle_leaving_dock = "Внимание экипажу: начата процедура ротации персонала, конец через %ETA% минуты."
	shuttle_called_message = "Внимание экипажу: запланирован конец смены. Ротация экипажа начнётся через %ETA% минут."
	shuttle_recall_message = "Внимание экипажу: конец смены отменён, возвращайтесь к работе."
	bluespace_docked_message = "Внимание экипажу: Закончены приготовления к блюспейс прыжку. Начался разгорев двигателя. До прыжка осталось примерно %ETA%."
	bluespace_leaving_dock = "Внимание экипажу: Инициирован блюспейс прыжок. До выхода %ETA%."
	bluespace_called_message = "Внимание экипажу: Начата процедура блюспейс прыжка. До завершения приготовлений %ETA%."
	bluespace_recall_message = "Внимание экипажу: Блюспейс прыжок был отменён, возвращайтесь к работе."
	emergency_shuttle_docked_message = "Внимание экипажу: спасательные капсулы взведены. У вас есть %ETA% минут чтобы сесть на спасательные капсулы."
	emergency_shuttle_leaving_dock = "Внимание экипажу: эвакуация была завершена."
	emergency_shuttle_recall_message = "Внимание экипажу: эвакуация была отменена."
	emergency_shuttle_called_message = "Внимание экипажу: объявлена эвакуация. До взведения спасательных капсул %ETA%."

	meteors_detected_message = "Внимание экипажу: Крупное скопление метеоров находится на траектории столкновения с судном. У вас есть три минуты чтобы активировать щиты и укрываться в центральных отсеках корабля."
	meteor_contact_message = "Внимание экипажу: Метеоры достигли судна. Приготовьтесь к столкновению."
	meteor_end_message = "Внимание экипажу: Метеоры миновали судно, возвращайтесь на места."

	ship_meteor_contact_message = "Внимание экипажу: Обломки от местных руин находятся на траектории столкновения с судном."
	ship_detected_end_message = "Внимание экипажу: Обломки достигли судна. Приготовьтесь к столкновению."
	ship_meteor_end_message = "Внимание экипажу: Обломки миновали судно. Разрешено приступать к ремонту."

	dust_detected_message = "Внимание экипажу: Приближается космическая пыль."
	dust_contact_message = "Внимание экипажу: Космическая пыль достигла судна."
	dust_end_message = "Внимание экипажу: Космическая пыль миновала судно."

	radiation_detected_message = "Внимание экипажу: Радиационный шторм вскоре накроет судно. Эвакуируйтесь в один из экранированных технических тоннелей."
	radiation_contact_message = "Внимание экипажу: Судно вошло в радиационный шторм. Оставайтесь в безопасной зоне до тех пор, пока шторм не прошёл и машинный отсек не дал разрешение на выход."
	radiation_end_message = "Внимание экипажу: Судно покинуло радиационный шторм. Оставайтесь в безопасной зоне до тех пор, пока не будет получено разрешение на выход от машинного отсека. Доступ в технические тоннели будет вскоре восстановлен."

	rogue_drone_detected_messages = list("Внимание экипажу: Неопознанные боевые дроны были замечены в непосредственной близости с судном. Соблюдайте осторожность.",
													"Внимание экипажу: Сбойные боевые дроны были замечены вблизи судна. Соблюдайте осторожность.")
	rogue_drone_end_message = "Внимание экипажу: Боевые дроны покинули судно."
	rogue_drone_destroyed_message = "Внимание экипажу: Потерян визуальный контакт с дронами."


	map_shuttles = list(
		/datum/shuttle/autodock/ferry/lift/scc_ship/morgue,
		/datum/shuttle/autodock/multi/lift/operations,
		/datum/shuttle/autodock/multi/lift/robotics,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod4,
		/datum/shuttle/autodock/ferry/supply/horizon,
		/datum/shuttle/autodock/ferry/specops/ert_aurora,
		/datum/shuttle/autodock/multi/antag/skipjack_ship,
		/datum/shuttle/autodock/multi/antag/burglar_ship,
		/datum/shuttle/autodock/multi/antag/merc_ship,
		/datum/shuttle/autodock/multi/legion,
		/datum/shuttle/autodock/multi/distress,
		/datum/shuttle/autodock/overmap/intrepid,
		/datum/shuttle/autodock/overmap/mining,
		/datum/shuttle/autodock/overmap/canary,
		/datum/shuttle/autodock/ferry/merchant_aurora,
		/datum/shuttle/autodock/ferry/autoreturn/ccia,
		/datum/shuttle/autodock/overmap/orion_express_shuttle,
		/datum/shuttle/autodock/overmap/sfa_shuttle,
		/datum/shuttle/autodock/overmap/tcfl_shuttle,
		/datum/shuttle/autodock/overmap/ee_shuttle,
		/datum/shuttle/autodock/overmap/fsf_shuttle,
		/datum/shuttle/autodock/overmap/freighter_shuttle,
		/datum/shuttle/autodock/overmap/kataphract_transport,
		/datum/shuttle/autodock/overmap/iac_shuttle
	)

	evac_controller_type = /datum/evacuation_controller/starship

	allowed_spawns = list("Living Quarters Lift", "Cryogenic Storage")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift, /datum/spawnpoint/cryo)
	default_spawn = "Living Quarters Lift"

	allow_borgs_to_leave = TRUE

	warehouse_basearea = /area/operations/storage

/datum/map/sccv_horizon/send_welcome()
	var/obj/effect/overmap/visitable/ship/horizon = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/sccv_horizon)

	var/welcome_text = "<center><img src = scclogo.png><br />[FONT_LARGE("<b>SCCV Горизонт</b> Данные считывания сенсоров сверх-дальнего действия:")]<br>"
	welcome_text += "Отчёт сгенерирован [worlddate2text()] в [worldtime2text()]</center><br /><br />"
	welcome_text += "<hr>Текущий сектор:<br /><b>[SSatlas.current_sector.name]</b><br /><br>"

	if (horizon) //If the overmap is disabled, it's possible for there to be no Horizon.
		var/list/space_things = list()
		welcome_text += "Текущие координаты:<br /><b>[horizon.x]:[horizon.y]</b><br /><br>"
		welcome_text += "Следующая система для прыжка:<br /><b>[SSatlas.current_sector.generate_system_name()]</b><br /><br>"
		var/last_visit
		var/current_day = time2text(world.realtime, "День")
		switch(current_day)
			if("Monday")
				last_visit = "1 день назад"
			if("Tuesday")
				last_visit = "2 дня назад"
			if("Wednesday")
				last_visit = "3 дня назад"
			if("Thursday")
				last_visit = "4 дня назад"
			if("Friday")
				last_visit = "5 дней назад"
			if("Saturday")
				last_visit = "6 дней назад"
			if("Sunday")
				last_visit = "Неделю назад"
		welcome_text += "Последний визит в порт: <br><b>[last_visit]</b><br><br>"
		welcome_text += "До ближайшего порта:<br /><b>[SSatlas.current_sector.get_port_travel_time()]</b><br /><br>"
		welcome_text += "Сканирование системы выявило следующие точки интереса:<br />"

		for(var/zlevel in GLOB.map_sectors)
			var/obj/effect/overmap/visitable/O = GLOB.map_sectors[zlevel]
			if(O.name == horizon.name)
				continue
			if(istype(O, /obj/effect/overmap/visitable/ship/landable)) //Don't show shuttles
				continue
			if (O.hide_from_reports)
				continue
			space_things |= O

		for(var/obj/effect/overmap/visitable/O in space_things)
			var/location_desc = " на следующих координатах."
			if(O.loc != horizon.loc)
				var/bearing = round(90 - Atan2(O.x - horizon.x, O.y - horizon.y),5) //fucking triangles how do they work
				if(bearing < 0)
					bearing += 360
				location_desc = ", азимут [bearing]."
			welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"

		welcome_text += "<hr>"

	post_comm_message("Данные считывания сенсоров SCCV Горизонт", welcome_text)
	priority_announcement.Announce(message = "Данные со считывания сенсоров сверх-дальнего действия были распечатаны на все консоли командования.")

/datum/map/sccv_horizon/load_holodeck_programs()
	// loads only if at least two engineers are present
	// so as to not drain power on deadpop
	// also only loads if no program is loaded already
	var/list/roles = number_active_with_role()
	if(roles && roles["Engineer"] && roles["Engineer"] >= 2)
		for(var/obj/machinery/computer/holodeck_control/holo in GLOB.holodeck_controls)
			if(!holo.active)
				holo.load_random_program()
