//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_blurb = "The sound here seems to carry more than others, every click of a shoe or clearing of a throat amplified. The smell of ink wafts notably through the air."
	area_blurb_category = "command"

/area/bridge/upperdeck
	name = "Command Atrium Upper Deck"
	icon_state = "bridge"

/area/bridge/minibar
	name = "Command Break Room"
	icon_state = "bridge"

/area/bridge/ailobby
	name = "AI Elevator Access"
	icon_state = "ai_foyer"

/area/bridge/aibunker
	name = "Command - Bunker"
	icon_state = "ai_foyer"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/bridge/centcom_meetingroom
	name = "Level A Meeting Room"
	icon_state = "bridge"

/area/bridge/levela
	name = "Surface - Bridge"
	icon_state = "bridge"

/area/bridge/levela/research_dock
	name = "Surface - Bridge Expeditionary Dock"
	icon_state = "research_dock"

/area/crew_quarters/heads/cryo
	name = "Command - Dormitory"
	icon_state = "head_quarters"

/area/bridge/meeting_room
	name = "Command - Conference Room"
	icon_state = "bridge"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR
	area_blurb = "A place for behind-closed-doors meetings to get things done, or argue for hours in..."
	area_blurb_category = "command_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/bridge/cciaroom
	name = "Command - Human Resources Meeting Room"
	icon_state = "hr"
	sound_env = MEDIUM_SOFTFLOOR
	area_blurb = "You feel severe existential dread when you enter this room.."
	area_blurb_category = "hr_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/bridge/cciaroom/lounge
	name = "Command - Human Resources Lounge"
	icon_state = "hrlounge"
	sound_env = SMALL_SOFTFLOOR
	area_blurb = "A place that worsens the slightest anxieties surrounding meetings with your bosses boss."
	area_blurb_category = "hr_lounge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/bridge/selfdestruct
	name = "Command - Station Authentication Terminal Safe"
	icon_state = "bridge"

/area/bridge/controlroom // Horizon.
	name = "Command - Control Room"
	area_blurb = "The full expanse of space lies beyond a thick pane of glass, all that protects you from a cold death. The computers all hum with various displays and holographic signs, overwhelming if you were not used to such an environment. Even at full power, the sensors fail to map even a fraction of the dots of light making up the cosmic filament."
	area_blurb_category = "bridge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/crew_quarters/captain
	name = "Command - Captain's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/crew_quarters/heads
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/crew_quarters/heads/hop
	name = "Command - HoP's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hor
	name = "Research - RD's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/chief
	name = "Engineering - CE's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hos
	name = "Security - HoS' Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/cmo
	name = "Medbay - CMO's Office"
	icon_state = "head_quarters"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"
	no_light_control = 1
	station_area = 1

/area/server
	name = "Research Server Room"
	icon_state = "server"
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE


//Teleporter
/area/teleporter
	name = "Command - Teleporter"
	icon_state = "teleporter"
	station_area = 1
