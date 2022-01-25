/datum/design/circuit/electronics
	p_category = "Electronics Designs"

/datum/design/circuit/electronics/secure_airlock
	name = "Secure Hatch Electronics"
	desc = "Allows for the construction of a tamper-resistant hatch electronics."
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure