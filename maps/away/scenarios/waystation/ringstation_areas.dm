
/area/ringstation
	name = "Waystation"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = "#494949"

//// Z1 - Maintenance Z-Level ////
/area/ringstation/z1
	name = "Waystation - Maintenance Tunnels - "
	icon_state = "maintenance"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ringstation/z1/maintenance_north
	name = "Waystation - Maintenance Tunnels - North"
	area_blurb_category = "ringstation_maintenance_level"
	area_blurb = "The varied sounds of the station above you cease. It is quieter down here, but so incredibly cramped and dark..."

/area/ringstation/z1/maintenance_east
	name = "Waystation - Maintenance Tunnels - East"
	area_blurb_category = "ringstation_maintenance_level"
	area_blurb = "The varied sounds of the station above you cease. It is quieter down here, but so incredibly cramped and dark..."

/area/ringstation/z1/maintenance_south
	name = "Waystation - Maintenance Tunnels - South"
	area_blurb_category = "ringstation_maintenance_level"
	area_blurb = "The varied sounds of the station above you cease. It is quieter down here, but so incredibly cramped and dark..."

/area/ringstation/z1/maintenance_west
	name = "Waystation - Maintenance Tunnels - West"
	area_blurb_category = "ringstation_maintenance_level"
	area_blurb = "The varied sounds of the station above you cease. It is quieter down here, but so incredibly cramped and dark..."

// Z1 Non-tunnels
/area/ringstation/z1/cafeteria_hydroponics
	name = "Waystation - Cafeteria - Hydroponics"
	icon_state = "hydro"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/ringstation/z1/engineering_lower_equipment_room
	name = "Waystation - Engineering - Equipment Room - Lower"
	icon_state = "engineering_storage"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ringstation/z1/reactor_waste
	name = "Waystation - Engineering - Reactor Waste"
	icon_state = "engineering_storage"
	holomap_color = "#d35f00"

/area/ringstation/z1/cryogenics
	name = "Waystation - Staff Pod - Cryogenics"
	icon_state = "cryo"
	holomap_color = "#7c85ff"

//// Z2 - Main Z-Level ////
/area/ringstation/z2

// Z2 Hallways
/area/ringstation/z2/hall
	name = "Waystation - Hallway"
	icon_state = "hallC"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/ringstation/z2/hall/north
	name = "Waystation - North Hallway"

/area/ringstation/z2/hall/north/stairwell
	name = "Waystation - VIP Dock Stairwell"

/area/ringstation/z2/hall/south
	name = "Waystation - South Hallway"
	color = "#adff61"

/area/ringstation/z2/hall/south/stairwell
	name = "Waystation - Emergency Dock Stairwell"

/area/ringstation/z2/hall/west
	name = "Waystation - West Hallway"
	color = "#ff9f82"

/area/ringstation/z2/hall/west/stairwell
	name = "Waystation - Public Docks Stairwell"

/area/ringstation/z2/hall/central_ring
	name = "Waystation - Central Ring"
	color = "#ff4646"
	area_blurb = "A long, curved hallway that offers almost no deviation; someone could get lost walking this same hallway over and over."

// Z2 Civilian Facilities
/area/ringstation/z2/computer_hardware_store
	name = "Waystation - Computer Hardware Store"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	icon = "green"

/area/ringstation/z2/computer_hardware_store/storage
	name = "Waystation - Computer Hardware Store - Storage"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/ringstation/z2/grocery_store
	name = "Waystation - Grocery Store"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	icon = "green"

/area/ringstation/z2/grocery_store/storage
	name = "Waystation - Grocery Store - Storage"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/ringstation/z2/survival_store
	name = "Waystation - Void Survival Store"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	icon = "green"

/area/ringstation/z2/cafeteria
	name = "Waystation - Cafeteria"
	icon_state = "courtroom"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	area_blurb = "A large cafeteria with the fragrant, sticky-sweet odor of cheap and quick cooking. The sterile tiling doesn't help, but at least there's a view into space..."

/area/ringstation/z2/cafeteria/kitchen
	name = "Waystation - Cafeteria - Kitchen"
	icon_state = "kitchen"

/area/ringstation/z2/motel
	name = "Waystation - Motel"
	icon_state = "crew_quarters"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/ringstation/z2/motel/reception
	name = "Waystation - Motel - Reception"

/area/ringstation/z2/motel/hall
	name = "Waystation - Motel - Hallway"

/area/ringstation/z2/motel/utility
	name = "Waystation - Motel - Utility Room"

/area/ringstation/z2/motel/storage
	name = "Waystation - Motel - Storage"

/area/ringstation/z2/motel/room
	name = "Waystation - Motel - Room A"
	area_blurb_category = "ringstation_motel_room"
	area_blurb = "A neat, recently cleaned room that smells of air freshener. Plenty of space to store your belongings and get some rest..."

/area/ringstation/z2/motel/room/b
	name = "Waystation - Motel - Room B"
	area_blurb_category = "ringstation_motel_room"
	area_blurb = "A neat, recently cleaned room that smells of air freshener. Plenty of space to store your belongings and get some rest..."

/area/ringstation/z2/motel/room/c
	name = "Waystation - Motel - Room C"
	area_blurb_category = "ringstation_motel_room"
	area_blurb = "A neat, recently cleaned room that smells of air freshener. Plenty of space to store your belongings and get some rest..."

// Z2 Medical
/area/ringstation/z2/medical
	name = "Waystation - Clinic"
	icon_state = "medbay"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	area_blurb = "This place is even more sterile than the rest of this station..."

/area/ringstation/z2/medical/reception
	name = "Waystation - Clinic - Reception"

/area/ringstation/z2/medical/resus
	name = "Waystation - Clinic - Resus Ward"

/area/ringstation/z2/medical/imaging
	name = "Waystation - Clinic - Imaging Room"

/area/ringstation/z2/medical/surgery
	name = "Waystation - Clinic - Operating Theatre"
	icon_state = "surgery"

/area/ringstation/z2/medical/recovery
	name = "Waystation - Clinic - Inpatient Ward"
	icon_state = "patients"

/area/ringstation/z2/medical/storage
	name = "Waystation - Clinic - Equipment Room"

/area/ringstation/z2/medical/morgue
	name = "Waystation - Clinic - Morgue"
	icon_state = "morgue"

// Z2 Engineering
/area/ringstation/z2/engineering
	name = "Waystation - Engineering"
	icon_state = "engineering"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ringstation/z2/engineering/hall
	name = "Waystation - Engineering - Hallway"

/area/ringstation/z2/engineering/equipment_room
	name = "Waystation - Engineering - Equipment Storage"
	icon_state = "engineering_storage"

/area/ringstation/z2/engineering/atmospherics
	name = "Waystation - Engineering - Atmospherics Control Room"
	icon_state = "atmos"

/area/ringstation/z2/engineering/reactor
	name = "Waystation - Engineering - Reactor Room"
	icon_state = "engine"

/area/ringstation/z2/engineering/reactor_monitoring
	name = "Waystation - Engineering - Reactor Monitoring"
	icon_state = "engine_monitoring"

/area/ringstation/z2/engineering/reactor_decontamination
	name = "Waystation - Engineering - Reactor Decontamination"

// Z2 Supply
/area/ringstation/z2/supply
	name = "Waystation - Supply"
	icon_state = "quartstorage"
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/ringstation/z2/supply/packages
	name = "Waystation - Supply - OX Package Storage"

/area/ringstation/z2/supply/office
	name = "Waystation - Supply - Office"

/area/ringstation/z2/supply/warehouse
	name = "Waystation - Supply - Warehouse"
	icon_state = "quartloading"
	area_blurb = "A crowded warehouse with a dusty smell. Utterly disorganised and with crates haphazardly strewn wherever, it would be a miracle digging anything out of this."

/area/ringstation/z2/supply/hangar
	name = "Waystation - Supply - Hangar"
	icon_state = "quartloading"
	area_blurb = "An expansive hangar, still packed with yet-opened shipping containers. A large crane looms over a raised platform."

// Z2 Maintenance Tunnels
/area/ringstation/z2/maintenance
	name = "Waystation - Maintenance"
	icon_state = "maintenance"
	area_blurb = "Scarcely lit, cramped, and filled with stale, dusty air. Around you hisses compressed air through the pipes, a buzz of electrical charge through the wires, and muffled rumbles of the hull settling. This place may feel alien compared to the interior of the ship and is a place where one could get lost or badly hurt, but some may find the isolation comforting."

/area/ringstation/z2/maintenance/cafe2motel
	name = "Waystation - Maintenance - Cafeteria-Motel Median"

/area/ringstation/z2/maintenance/medical2stores
	name = "Waystation - Maintenance- Medical-Stores Median"

/area/ringstation/z2/maintenance/atmos2reactor
	name = "Waystation - Maintenance - Atmospherics-Reactor Median"

/area/ringstation/z2/maintenance/engineering2supply
	name = "Waystation - Maintenance - Engineering-Supply Median"

/area/ringstation/z2/maintenance/supply2hangar
	name = "Waystation - Maintenance - Supply-Hangar Median"

/area/ringstation/z2/maintenance/hangar2hall
	name = "Waystation - Maintenance - Hangar-North Hall Median"

/area/ringstation/z2/maintenance/cafe2hall
	name = "Waystation - Maintenance - Motel-North Hall Median"

// Z2 Staff Pod
/area/ringstation/z2/staffpod
	name = "Waystation - Staff Pod"
	icon_state = "bridge"
	holomap_color = "#7c85ff"

/area/ringstation/z2/staffpod/hydroponics
	name = "Waystation - Staff Pod - Hydroponics"

/area/ringstation/z2/staffpod/washing
	name = "Waystation - Staff Pod - Utility Room"

/area/ringstation/z2/staffpod/eva
	name = "Waystation - Staff Pod - Emergency EVA Storage"
	icon_state = "eva"

/area/ringstation/z2/staffpod/bathrooms
	name = "Waystation - Staff Pod - Bathrooms"

/area/ringstation/z2/staffpod/lounge
	name = "Waystation - Staff Pod - Lounge"

/area/ringstation/z2/staffpod/kitchen
	name = "Waystation - Staff Pod - Kitchen"

//// Z3 Control Room & Docks Z-Level ////
/area/ringstation/z3

/area/ringstation/z3/station_control_room
	name = "Waystation - Staff Pod - Station Control Room"
	icon_state = "bridge"
	holomap_color = "#7c85ff"
	area_blurb = "Up here, a half-dozen holocomputers hum and beep. Looking outside of the windows, the whole top surface of the waystation is visible, including the docking ports north, west and south."

/area/ringstation/z3/dock
	icon_state = "arrivals_dock"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/ringstation/z3/dock/public
	name = "Waystation - West Dock, Public Access"

/area/ringstation/z3/dock/premium
	name = "Waystation - North Dock, Staff/VIP Access"

/area/ringstation/z3/dock/emergency
	name = "Waystation - South Dock, Emergency Access"
	icon_state = "escape"
	holomap_color = "#ff0000"

//// Exterior Areas ////

/area/ringstation/exterior
	name = "Waystation - Exterior"
	color = "#6a5aa5"
	icon_state = "space"

/area/ringstation/exterior/atmos
	name = "Waystation - Exterior - Atmospherics Holding Tanks"
	color = "#a57c5a"

/area/ringstation/exterior/ring_median
	name = "Waystation - Exterior - Ring Median"

/area/ringstation/exterior/roof
	name = "Waystation - Exterior - Roof"

