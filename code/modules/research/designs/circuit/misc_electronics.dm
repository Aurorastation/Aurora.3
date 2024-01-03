/datum/design/circuit/electronics
	p_category = "Electronics Designs"

/datum/design/circuit/electronics/secure_airlock
	name = "Secure Airlock Electronics"
	desc = "Allows for the construction of a tamper-resistant airlock electronics."
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure
