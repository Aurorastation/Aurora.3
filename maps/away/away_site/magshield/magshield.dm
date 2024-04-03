/datum/map_template/ruin/away_site/magshield
	name = "Magshield"
	id = "magshield"
	description = "It's an orbital shield station."
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA, ALL_COALITION_SECTORS)
	suffixes = list("away_site/magshield/magshield.dmm")
	spawn_weight = 1
	spawn_cost = 1

	unit_test_groups = list(1)

/singleton/submap_archetype/magshield
	map = "magshield"
	descriptor = "It's an orbital shield station."

/obj/effect/overmap/visitable/sector/magshield
	name = "orbital station"
	desc = "Sensors detect an orbital station above an exoplanet. Signs of past magentic impulses are registred from it. Planet landing is impossible due to lower orbits being cluttered with chaotically moving metal chunks."
	icon_state = "object"

	initial_generic_waypoints = list(
		"nav_magshield_1",
		"nav_magshield_2",
		"nav_magshield_3",
		"nav_magshield_4",
		"nav_magshield_5",
		"nav_magshield_6"
	)

/obj/effect/shuttle_landmark/nav_magshield/nav1
	name = "Orbital Station Navpoint #1"
	landmark_tag = "nav_magshield_1"

/obj/effect/shuttle_landmark/nav_magshield/nav2
	name = "Orbital Station Navpoint #2"
	landmark_tag = "nav_magshield_2"

/obj/effect/shuttle_landmark/nav_magshield/nav3
	name = "Orbital Station Navpoint #3"
	landmark_tag = "nav_magshield_3"

/obj/effect/shuttle_landmark/nav_magshield/nav4
	name = "Orbital Station Navpoint #4"
	landmark_tag = "nav_magshield_4"

/obj/effect/shuttle_landmark/nav_magshield/nav5
	name = "Orbital Station Navpoint #5"
	landmark_tag = "nav_magshield_5"

/obj/effect/shuttle_landmark/nav_magshield/nav6
	name = "Orbital Station Navpoint #6"
	landmark_tag = "nav_magshield_6"

//mainly props now, the gimmick of an infrequent emp pulse was kind of interesting but hard to port and might punish synths too hard for exploring
/obj/structure/magshield/maggen
	name = "magnetic field generator"
	desc = "A large three-handed generator with rotating top. It is used to create high-power magnetic fields in hard vacuum. It's spinning and that seems to be all it's good for at the moment."
	icon = 'maps/away/away_site/magshield/magshield_sprites.dmi'
	icon_state = "maggen"
	anchored = TRUE
	density = TRUE
	light_color = "#ffea61"

/obj/structure/magshield/maggen/attack_hand(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("You don't see how you could fix \the [src]. It would need some serious work."))

/obj/structure/magshield/rad_sensor
	name = "radiation sensor"
	desc = "Very sensitive vacuum radiation sensor. On top of the metal stand two modified Wilson cloud chambers filled with deuterium and tritium water."
	icon = 'maps/away/away_site/magshield/magshield_sprites.dmi'
	icon_state = "rad_sensor"
	anchored = TRUE

/obj/structure/magshield/nav_light
	name = "navigation light"
	desc = "Large and bright light regularly emitting green flashes."
	icon = 'maps/away/away_site/magshield/magshield_sprites.dmi'
	icon_state = "nav_light_green"
	anchored = TRUE
	density = TRUE

/obj/structure/magshield/nav_light/New() //Would be cool if these could flash, but I couldn't figure out how to carry that over.
	..()
	set_light(1.2, 3, LIGHT_COLOR_GREEN)

/obj/structure/magshield/nav_light/red
	desc = "Large and bright light regularly emitting red flashes."
	light_color = "#ee0000"
	icon_state = "nav_light_red"

/obj/structure/magshield/nav_light/red/New()
	..()
	set_light(1.2, 3, LIGHT_COLOR_RED)

/obj/item/book/manual/magshield_manual
	name = "SOP for Planetary Shield Orbital Stations"
	icon = 'maps/away/away_site/magshield/magshield_sprites.dmi'
	icon_state = "mg_guide"
	author = "Unknown"
	title = "Standard operating procedures for Planetary Shield Orbital Stations"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Introduction</h1>
				...is happy to see you as our customer! Please read this guide before using and operating with your custom PSOS - Planetary Shield Orbital Statiion.
				<h2>Best uses for PSOS</h2>
				PSOS is intended for protecting exoplanets from high energy space radiation rays and particles in the interest of furthering research on this phenomena. Best used for planets lacking active geomagnetic field so PSOS would compensate its absence and provide more data.<br>
				<h2>Applied Technologies</h2>
				...is delivering you your new PSOS with set of four (4) high-strength magnetic field generators. Those devices use rotating supeconducter hands to create magnetic field with strength up to 5 tesla effectively deflecting up to 99% of space radiation spectrum.<br>
				<br>
				Special modified vacuum radiation sensors will help you evaluate radiation level and adjust power input of PSOS magnetic generators for best efficiency and power saving.
				<br><br><br>
				<i>*The rest of the manual's pages are gone or otherwise faded out...*</i>
				</body>
			</html>
			"}

/obj/item/paper/magshield/tornpage
	name = "torn book page"
	info = "...you must carefully control radiation sensor automatics during solar flares. Sudden burst of high-energy plasma may cause positive feedback loop and increase magnetic genretors output in order of magnitude. This situation would lead to general damage of unprotected electronic devices as well as trajectory changes in nearby nickel-ferrum asteroids."

/obj/item/paper/magshield/log
	name = "printed page"
	info = "\[07:31\] ATTENTION: Solar flare detected! Automatic countermeasures activated.<br>\[07:33\] WARNING: ERROR: NULL input at FARADAY_CAGE#12.TFI - line 2067: No command found. System will be rebooted.<br>\[07:39\] WARNING: Radiation countermeasures ineffective. Please initiate emergency protocol.<br>\[07:40\] WARNING: Radiation countermeasures ineffective. Please initiate emergency protocol.<br>\[07:41\] WARNING: Radiation countermeasures ineffective. Please initiate emergency protocol.<br>\[07:45\] CRITICAL SYSTEM ALERT: Multiple systems failure. Please initiate emergency protocol immediately!<br>\[07:52\] WARNING: LIDAR-ASTRA system detected multiple meteors approaching. Estimate impact time: 12 seconds. <br>\[07:52\] CRITICAL SYSTEM ALERT: Multiple hull breaches dete%!(''c¤%#!"
