// GENERIC MINING AREAS

/area/mine
	icon_state = "mining"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	sound_env = ASTEROID

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"
	flags = HIDE_FROM_HOLOMAP

//S

// Smalls
/area/outpost/mining_north
	name = "North Mining"
	icon_state = "outpost_mine_north"

/area/outpost/mining_west
	name = "West Mining"
	icon_state = "outpost_mine_west"

/area/outpost/abandoned
	name = "Abandoned"
	icon_state = "dark"

// Main mining
/area/outpost/mining_main
	icon_state = "outpost_mine_main"
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/outpost/mining_main/dorms
	name = "Mining Dormitory"

/area/outpost/mining_main/medbay
	name = "Mining Medical"

/area/outpost/mining_main/maintenance
	name = "Mining Maintenance"

/area/outpost/mining_main/west_hall
	name = "Mining West Hallway"

/area/outpost/mining_main/east_hall
	name = "Mining East Hallway"

/area/outpost/mining_main/eva
	name = "Mining EVA storage"

/area/outpost/mining_main/refinery
	name = "Mining Refinery"



// Engineering
/area/outpost/engineering
	icon_state = "outpost_engine"
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/outpost/engineering/hallway
	name = "Engineering - Sublevel Hallway"

/area/outpost/engineering/atmospherics
	name = "Engineering - Sublevel Atmospherics"

/area/outpost/engineering/power
	name = "Engineering - Tesla Bay"

/area/outpost/engineering/telecomms
	name = "Engineering - Sublevel Telecommunications"

/area/outpost/engineering/storage
	name = "Engineering - Sublevel Storage"

/area/outpost/engineering/meeting
	name = "Engineering - Break Room"



// Research
/area/outpost/research
	icon_state = "outpost_research"
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/outpost/research/hallway
	name = "Research - Sublevel Hallway"

/area/outpost/research/dock
	name = "Research Shuttle Dock"

/area/outpost/research/eva
	name = "Research - Xenoarcheology"

/area/outpost/research/analysis
	name = "Research - Sample Analysis"

/area/outpost/research/chemistry
	name = "Research - Chemistry"

/area/outpost/research/medical
	name = "Research Medical"

/area/outpost/research/power
	name = "Research Maintenance"

/area/outpost/research/isolation_a
	name = "Research - Isolation A"

/area/outpost/research/isolation_b
	name = "Research - Isolation B"

/area/outpost/research/isolation_c
	name = "Research - Isolation C"

/area/outpost/research/isolation_monitoring
	name = "Research - Isolation Monitoring"

/area/outpost/research/lab
	name = "Research - Sublevel Laboratory"

/area/outpost/research/emergency_storage
	name = "Research - Sublevel Emergency Storage"

/area/outpost/research/anomaly_storage
	name = "Research - Anomalous Storage"

/area/outpost/research/anomaly_analysis
	name = "Research - Anomaly Analysis"

/area/outpost/research/kitchen
	name = "Research - Kitchen"

/area/outpost/research/disposal
	name = "Research - Waste Disposal"
