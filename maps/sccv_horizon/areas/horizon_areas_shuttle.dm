/// SHUTTLE_AREAS
/area/horizon/shuttle
	name = "Shuttle"
	icon_state = "shuttle"
	requires_power = 0
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED
	horizon_deck = 1
	department = LOC_SHUTTLE
	area_blurb = "A shuttle compartment: compact and rigidly functional."

/area/horizon/shuttle/intrepid
	name = "Intrepid"
	icon_state = "intrepid"
	requires_power = TRUE

/area/horizon/shuttle/intrepid/main_compartment
	name = "Intrepid Main Compartment"

/area/horizon/shuttle/intrepid/port_compartment
	name = "Intrepid Port Compartment"

/area/horizon/shuttle/intrepid/starboard_compartment
	name = "Intrepid Starboard Compartment"

/area/horizon/shuttle/intrepid/junction_compartment
	name = "Intrepid Junction Compartment"

/area/horizon/shuttle/intrepid/buffet
	name = "Intrepid Buffet"

/area/horizon/shuttle/intrepid/medical
	name = "Intrepid Medical Compartment"

/area/horizon/shuttle/intrepid/engineering
	name = "Intrepid Engineering Compartment"

/area/horizon/shuttle/intrepid/port_storage
	name = "Intrepid Port Nacelle"

/area/horizon/shuttle/intrepid/flight_deck
	name = "Intrepid Flight Deck"

/area/horizon/shuttle/escape_pod
	name = "Escape Pod"
	area_blurb = "If you're in here, you've probably had a bad day."

/area/horizon/shuttle/escape_pod/pod1
	name = "Escape Pod - 1"

/area/horizon/shuttle/escape_pod/pod2
	name = "Escape Pod - 2"

/area/horizon/shuttle/escape_pod/pod3
	name = "Escape Pod - 3"

/area/horizon/shuttle/escape_pod/pod4
	name = "Escape Pod - 4"

/area/horizon/shuttle/mining
	name = "Spark"
	requires_power = TRUE

/area/horizon/shuttle/canary
	name = "Canary"
	requires_power = TRUE

/area/horizon/shuttle/quark/cockpit
	name = "Quark Cockpit"
	requires_power = TRUE

/area/horizon/shuttle/quark/cargo_hold
	name = "Quark Cargo Hold"
	requires_power = TRUE
