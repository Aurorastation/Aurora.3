#define COLOR_GADPATHUR_BROWN "#734A24"
#define COLOR_GADPATHUR_RED "#C01207"
#define COLOR_GADPATHUR_GOLD "#EDBF0A"
#define COLOR_GADPATHUR_BLACK "#333333"

//Get the base stuff handled here
/turf/simulated/wall/shuttle/dark/cardinal/gadpathur
	color = COLOR_GADPATHUR_BLACK

/obj/structure/machinery/door/airlock/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BROWN

/obj/structure/machinery/door/airlock/glass/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BROWN

/obj/structure/machinery/door/airlock/highsecurity/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK

/obj/structure/machinery/door/airlock/external/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_RED

/obj/structure/machinery/door/airlock/hatch/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK

/obj/structure/machinery/door/airlock/multi_tile/glass/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BLACK

/obj/structure/machinery/door/airlock/multi_tile/flipped/glass/gadpathur
	door_frame_color = COLOR_GADPATHUR_BLACK
	door_color = COLOR_GADPATHUR_BLACK

//Special doors

/obj/structure/machinery/door/airlock/gadpathur/quarters
	door_color = COLOR_GADPATHUR_BLACK

/obj/structure/machinery/door/airlock/gadpathur/quarters/crew
	name = "General Quarters"
	stripe_color = COLOR_GADPATHUR_RED
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/structure/machinery/door/airlock/gadpathur/quarters/officer
	name = "Officer Quarters"
	stripe_color = COLOR_GADPATHUR_GOLD
	req_access = list(ACCESS_GADPATHUR_NAVY_OFFICER)

/obj/structure/machinery/door/airlock/highsecurity/gadpathur/cic
	name = "Command Information Center"
	door_color = COLOR_GADPATHUR_BROWN
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/structure/machinery/door/airlock/glass/gadpathur/situation
	name = "Situation Room"
	door_color = COLOR_GADPATHUR_BROWN
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/structure/machinery/door/airlock/highsecurity/gadpathur/armory
	name = "Armory"
	door_color = "#2b4b68"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER)

/obj/structure/machinery/door/airlock/freezer/gadpathur/morgue
	door_frame_color = COLOR_GADPATHUR_BLACK
	name = "Morgue"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/structure/machinery/door/airlock/gadpathur/medical
	name = "Medical Bay"
	door_color = "#A7A9A0"
	stripe_color = "#345731"

/obj/structure/machinery/door/airlock/glass/gadpathur/surgery
	name = "Surgical Ward"
	door_color = "#A7A9A0"
	stripe_color = "#345731"

/obj/structure/machinery/door/airlock/glass/gadpathur/cell
	name = "Cell"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)
	door_color = "#2b4b68"
	stripe_color = "#ff4343"

/obj/structure/machinery/door/airlock/gadpathur/atmos
	name = "Atmospherics"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#caa638"
	stripe_color = "#62ff43"

/obj/structure/machinery/door/airlock/gadpathur/engi
	name = "Engineering"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/structure/machinery/door/airlock/hatch/gadpathur/thrusters
	door_color = "#caa638"
	stripe_color = "#62ff43"

/obj/structure/machinery/door/airlock/hatch/gadpathur/thrusters/port
	name = "Port Thrusters"

/obj/structure/machinery/door/airlock/hatch/gadpathur/thrusters/starboard
	name = "Starboard Thrusters"

/obj/structure/machinery/door/airlock/hatch/gadpathur/engine
	name = "Fusion Engine"
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/structure/machinery/door/airlock/hatch/gadpathur/armanent
	door_color = COLOR_GADPATHUR_BLACK
	stripe_color = COLOR_GADPATHUR_RED
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY, ACCESS_COALITION_NAVY)

/obj/structure/machinery/door/airlock/hatch/gadpathur/armanent/light
	name = "Light Armanent"

/obj/structure/machinery/door/airlock/hatch/gadpathur/armanent/heavy
	name = "Main Armanent"

/obj/structure/machinery/door/airlock/glass/gadpathur/engi
	name = "Engineering"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/structure/machinery/door/airlock/gadpathur/atmos/fuel
	name = "Fuel Bunker"
	door_color = COLOR_GADPATHUR_BLACK

/obj/structure/machinery/door/airlock/gadpathur/interrogation
	name = "Interrogation"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#2b4b68"
	stripe_color = COLOR_GADPATHUR_BROWN

/obj/structure/machinery/door/airlock/gadpathur/crew_prep
	name = "Crew Preparation"
	req_one_access = list(ACCESS_GADPATHUR_NAVY_OFFICER, ACCESS_GADPATHUR_NAVY)
	door_color = "#2b4b68"
	stripe_color = COLOR_GADPATHUR_GOLD

/obj/structure/machinery/door/airlock/external/gadpathur/shuttle
	door_frame_color = "#ac8b78"
	door_color = COLOR_GADPATHUR_RED

#undef COLOR_GADPATHUR_BROWN
#undef COLOR_GADPATHUR_RED
#undef COLOR_GADPATHUR_GOLD
#undef COLOR_GADPATHUR_BLACK
