/datum/design/circuit/electronics
	design_order = 4

/datum/design/circuit/electronics/AssembleDesignName()
	..()
	name = "Electronics Design ([item_name])"

/datum/design/circuit/electronics/secure_airlock
	name = "Secure Airlock Electronics"
	desc = "Allows for the construction of a tamper-resistant airlock electronics."
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure