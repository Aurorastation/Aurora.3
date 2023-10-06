#define COLOR_GADPATHUR_BROWN "#734A24"
#define COLOR_GADPATHUR_RED "#C01207"
#define COLOR_GADPATHUR_GOLD "#EDBF0A"
#define COLOR_GADPATHUR_BLACK "#333333"

//Get the base stuff handled here
/turf/simulated/wall/shuttle/dark/cardinal/gadpathur
	color = COLOR_GADPATHUR_BLACK

/obj/machinery/door/airlock/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BROWN

/obj/machinery/door/airlock/glass/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BROWN

/obj/machinery/door/airlock/highsecurity/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK

//Special doors

/obj/machinery/door/airlock/gadpathur/quarters
	door_color = COLOR_GADPATHUR_BLACK

/obj/machinery/door/airlock/gadpathur/quarters/crew
	name = "general quarters"
	stripe_color = COLOR_GADPATHUR_RED
	req_one_access = list(access_gadpathur_navy, access_coalition_navy)

/obj/machinery/door/airlock/gadpathur/quarters/officer
	name = "officer quarters"
	stripe_color = COLOR_GADPATHUR_GOLD
	req_access = list(access_gadpathur_navy_officer)

/obj/machinery/door/airlock/highsecurity/gadpathur/cic
	name = "command information center"
	door_color = COLOR_GADPATHUR_BROWN
	req_one_access = list(access_gadpathur_navy_officer, access_gadpathur_navy, access_coalition_navy)

/obj/machinery/door/airlock/highsecurity/gadpathur/armory
	name = "armory"
	door_color = "#2b4b68"
	req_one_access = list(access_gadpathur_navy_officer)

/obj/machinery/door/airlock/glass/gadpathur/cell
	name = "cell"
	req_one_access = list(access_gadpathur_navy_officer, access_gadpathur_navy, access_coalition_navy)
	door_color = "#2b4b68"
	stripe_color = "#ff4343"

/obj/machinery/door/airlock/gadpathur/interrogation
	name = "interrogation"
	req_one_access = list(access_gadpathur_navy_officer, access_gadpathur_navy)
	door_color = "#2b4b68"
	stripe_color = COLOR_GADPATHUR_BROWN

/obj/machinery/door/airlock/gadpathur/crew_prep
	name = "crew_preparation"
	req_one_access = list(access_gadpathur_navy_officer, access_gadpathur_navy)
	door_color = "#2b4b68"
	stripe_color = COLOR_GADPATHUR_GOLD

#undef COLOR_GADPATHUR_BROWN
#undef COLOR_GADPATHUR_RED
#undef COLOR_GADPATHUR_GOLD
#undef COLOR_GADPATHUR_BLACK
