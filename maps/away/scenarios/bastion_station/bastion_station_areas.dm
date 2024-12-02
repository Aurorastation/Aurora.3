// --- base area

/area/bastion_station
	name = "Bastion Station (abstract)"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = "#494949"

// --- docks

/area/bastion_station/docks
	name = "Docks"
	icon_state = "arrivals_dock"
	holomap_color = "#162969"

// --- hallways

/area/bastion_station/hallways_center
	name = "Central Ring"
	icon_state = "hallC"
	holomap_color = "#4e6ac7"

/area/bastion_station/hallways_hangar
	name = "Hangar Hallway"
	icon_state = "hallC"
	holomap_color = "#4e6ac7"

/area/bastion_station/dock_stairwell
	name = "Docks Stairwell"
	icon_state = "hallC"
	holomap_color = "#4e6ac7"

// --- living and medical

/area/bastion_station/crew_quarters
	name = "Crew Quarters"
	icon_state = "crew_quarters"
	holomap_color = "#4e6ac7"

/area/bastion_station/kitchen
	name = "Kitchen"
	icon_state = "kitchen"
	holomap_color = "#4e6ac7"

/area/bastion_station/hydro
	name = "Hydroponics"
	icon_state = "garden"
	holomap_color = "#4ec762"

/area/bastion_station/kitchen_freezer
	name = "Kitchen Freezer"
	icon_state = "kitchen"
	holomap_color = "#4e6ac7"

/area/bastion_station/medbay
	name = "Medbay"
	icon_state = "medbay"
	holomap_color = "#4ec77c"

/area/bastion_station/operating
	name = "Operating Theater"
	icon_state = "medbay"
	holomap_color = "#3eb46c"

/area/bastion_station/medical_equipment
	name = "Medical Equipment"
	icon_state = "medbay"
	holomap_color = "#4cd681"

// --- Engineering

/area/bastion_station/engineering
	name = "Engineering"
	icon_state = "engineering"
	holomap_color = "#a87c29"

/area/bastion_station/reactor
	name = "Reactor Room"
	icon_state = "engineering"
	holomap_color = "#855e17"

/area/bastion_station/east_maintenance
	name = "Starboard Maintenance"
	icon_state = "maintenance"
	holomap_color = "#c28616"

/area/bastion_station/northwest_maintenance
	name = "Fore Port Maintenance"
	icon_state = "maintenance"
	holomap_color = "#c28616"

// --- Command and Hangar

/area/bastion_station/bridge
	name = "Combat Information Center"
	icon_state = "bridge"
	holomap_color = "#1f398f"

/area/bastion_station/captain
	name = "Captain's Quarters"
	icon_state = "bridge"
	holomap_color = "#4a68ca"

/area/bastion_station/hangar
	name = "Hangar"
	icon_state = "bluenew"
	holomap_color = "#0e2366"

/area/bastion_station/ai_core
	name = "AI Core"
	icon_state = "ai_chamber"
	holomap_color = "#0e2366"

// --- Security

/area/bastion_station/brig
	name = "Brig"
	icon_state = "security"
	holomap_color = "#ad2828"

/area/bastion_station/checkpoint
	name = "Security Checkpoint"
	icon_state = "security"
	holomap_color = "#681919"

// --- Weapons Bay

/area/bastion_station/weapons_bay
	name = "Weapons Bay"
	icon_state = "hallC"
	holomap_color = "#681919"

// --- Shrike Areas

/area/shuttle/bastion/red
	name = "Shrike Red"
	requires_power = TRUE

/area/shuttle/bastion/blue
	name = "Shrike Blue"
	requires_power = TRUE
