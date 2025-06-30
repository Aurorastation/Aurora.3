/singleton/scenario/ringstation
	name = "Ringstation"
	desc = "An medium-sized, independent waystation with a ring-shaped design. Set up between civilised systems to provide\
	services to vessels passing through this sector, the SCCV Horizon has been cleared to interact with the waystation\
	to resupply ahead of continuing further into mostly uninhabited space."

	scenario_site_id = "ringstation"

	min_player_amount = 0
	min_actor_amount = 0

	weight = 100

	scenario_announcements = /singleton/scenario_announcements/ringstation

	roles = list(
		/singleton/role/ringstation/staff/administrator,
		/singleton/role/ringstation/staff/maintenance_staff,
		/singleton/role/ringstation/staff/clinic_staff,
		/singleton/role/ringstation/staff/supply_staff,
		/singleton/role/ringstation/staff/service,
		/singleton/role/ringstation/visitor
	)
	default_outfit = /obj/outfit/admin/generic/ringstation
	actor_accesses = list(/datum/access/ringstation)
	radio_frequency_name = "Waystation"

	base_area = /area/ringstation

/singleton/scenario_announcements/ringstation
	horizon_announcement_title = "SCC Vessel Sensor Relay Network"
	horizon_unrestrict_landing_message = "An independent, civilian waystation has been detected in the vessel's current operating sector. \
	The waystation has been automatically vetted and approved for temporary business interactions with the SCCV Horizon and wider Stellar Corporate \
	Conglomerate. All departments are encouraged to identify equipment deficits for potential resupply at the waystation. The waystation \
	has been registered as a Port of Call for crew to disembark upon at their leisure; remember that your actions represent the company."
	offship_announcement_message = "An independent, civilian waystation has been located within the sector and identified as a promising \
	candidate for resupplying."

/singleton/role/ringstation/staff/administrator
	name = "Waystation Administative & Control Staff"
	desc = "You are one of the administrator or control room staff aboard the Waystation. Oversee both the station's needs and operations, as well as those of \
			visiting third-party vessels which your station has been designed to temporarily accomodate. Ensure customers are paying."
	outfit = /obj/outfit/admin/generic/ringstation/staff/administrator

/singleton/role/ringstation/staff/maintenance_staff
	name = "Waystation Maintenance Staff"
	desc = "You are one of the maintenance staff aboard the Waystation - be it an engineer or tradie. Ensure the waystation remains in tip-top shape. \
			You also handle the repairs of docked vessels - if they can pay."
	outfit = /obj/outfit/admin/generic/ringstation/staff/maintenance_staff

/singleton/role/ringstation/staff/clinic_staff
	name = "Waystation Clinic Staff"
	desc = "You are one of the clinicians in the Waystation's clinic - be it a doctor, nurse, or EMT. Look after the health of \
			your fellow waystation staff, as well as any paying visitors."
	outfit = /obj/outfit/admin/generic/ringstation/staff/clinic_staff

/singleton/role/ringstation/staff/supply_staff
	name = "Waystation Supply Staff"
	desc = "You are one of the Waystation's supply personnel - be it a package courier, a hangar technician, or a senior logistician.\
	Ensure the waystation's departments have the equipment they need, refuel docked vessels (that can pay!), and handle any incoming\
	and outgoing Orion Express mail packages."
	outfit = /obj/outfit/admin/generic/ringstation/staff/supply_staff

/singleton/role/ringstation/staff/service
	name = "Waystation Service Staff"
	desc = "You work in one of the Waystation's stores - be it the computer hardware store, motel, grocery store, or cafeteria.\
	Handle the shopping needs of both waystation and visiting crew."
	outfit = /obj/outfit/admin/generic/ringstation/staff/service

/singleton/role/ringstation/visitor
	name = "Visitor"
	desc = "You are just a visitor at the waystation and don't work here. You're resting at the waystation until a friend or ferry \
	arrives to pick you up and take your elsewhere."
	outfit = /obj/outfit/admin/generic/ringstation/visitor
