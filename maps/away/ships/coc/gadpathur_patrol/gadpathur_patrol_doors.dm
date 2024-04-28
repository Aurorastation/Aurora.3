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

/obj/machinery/door/airlock/external/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_RED

/obj/machinery/door/airlock/hatch/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK

/obj/machinery/door/airlock/multi_tile/glass/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BLACK

/obj/machinery/door/airlock/multi_tile/flipped/glass/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BLACK

//Special doors

/obj/machinery/door/airlock/gadpathur/quarters
	door_color = COLOR_GADPATHUR_BLACK

/obj/machinery/door/airlock/gadpathur/quarters/crew
	name = "general quarters"
	stripe_color = COLOR_GADPATHUR_RED
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/machinery/door/airlock/gadpathur/quarters/officer
	name = "officer quarters"
	stripe_color = COLOR_GADPATHUR_GOLD
	req_access = list(ACCESS_GADPATHUR_NAVY_OFFICER)

/obj/machinery/door/airlock/highsecurity/gadpathur/cic
	name = "command information center"
	door_color = COLOR_GADPATHUR_BROWN
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/machinery/door/airlock/glass/gadpathur/situation
	name = "situation room"
	door_color = COLOR_GADPATHUR_BROWN
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/machinery/door/airlock/highsecurity/gadpathur/armory
	name = "armory"
	door_color = "#2b4b68"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER)

/obj/machinery/door/airlock/freezer/gadpathur/morgue
	door_frame_color = COLOR_GADPATHUR_BLACK
	name = "morgue"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/machinery/door/airlock/gadpathur/medical
	name = "medical bay"
	door_color = "#A7A9A0"
	stripe_color = "#345731"

/obj/machinery/door/airlock/glass/gadpathur/surgery
	name = "surgical ward"
	door_color = "#A7A9A0"
	stripe_color = "#345731"

/obj/machinery/door/airlock/glass/gadpathur/cell
	name = "cell"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)
	door_color = "#2b4b68"
	stripe_color = "#ff4343"

/obj/machinery/door/airlock/gadpathur/atmos
	name = "atmospherics"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#caa638"
	stripe_color = "#62ff43"

/obj/machinery/door/airlock/gadpathur/engi
	name = "engineering"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/machinery/door/airlock/hatch/gadpathur/thrusters
	door_color = "#caa638"
	stripe_color = "#62ff43"

/obj/machinery/door/airlock/hatch/gadpathur/thrusters/port
	name = "port thrusters"

/obj/machinery/door/airlock/hatch/gadpathur/thrusters/starboard
	name = "starboard thrusters"

/obj/machinery/door/airlock/hatch/gadpathur/engine
	name = "fusion engine"
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/machinery/door/airlock/hatch/gadpathur/armanent
	door_color = COLOR_GADPATHUR_BLACK
	stripe_color = COLOR_GADPATHUR_RED
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/machinery/door/airlock/hatch/gadpathur/armanent/light
	name = "light armanent"

/obj/machinery/door/airlock/hatch/gadpathur/armanent/heavy
	name = "main armanent"

/obj/machinery/door/airlock/glass/gadpathur/engi
	name = "engineering"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/machinery/door/airlock/gadpathur/atmos/fuel
	name = "fuel bunker"
	door_color = COLOR_GADPATHUR_BLACK

/obj/machinery/door/airlock/gadpathur/interrogation
	name = "interrogation"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#2b4b68"
	stripe_color = COLOR_GADPATHUR_BROWN

/obj/machinery/door/airlock/gadpathur/crew_prep
	name = "crew_preparation"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#2b4b68"
	stripe_color = COLOR_GADPATHUR_GOLD

/obj/machinery/door/airlock/external/gadpathur/shuttle
	door_frame_color = "#ac8b78"
	door_color = COLOR_GADPATHUR_RED

#undef COLOR_GADPATHUR_BROWN
#undef COLOR_GADPATHUR_RED
#undef COLOR_GADPATHUR_GOLD
#undef COLOR_GADPATHUR_BLACK
