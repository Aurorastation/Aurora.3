/*
	var/station_area = FALSE
	/// Only used for the Horizon, and mostly for mapping checks.
	var/horizon_deck = null
	/// Only used for the Horizon, and mostly for mapping checks.
	var/department = null
	/// Only used for the Horizon, and mostly for mapping checks.
	var/subdepartment = null
*/

/// Head of Staff offices
/area/horizon/command/heads
	name = "Head of Staff's Office (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	department = LOC_COMMAND

/area/horizon/command/heads/captain
	name = "Command - Captain's Office"
	icon_state = "captain"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	horizon_deck = 3

/area/horizon/command/heads/xo
	name = "Command - Executive Officer's Office"
	horizon_deck = 3

/area/horizon/command/heads/hos
	name = "Security - Head of Security's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	horizon_deck = 2

/area/horizon/command/heads/rd
	name = "Research - RD's Office"
	icon_state = "head_quarters"
	horizon_deck = 2

/area/horizon/command/heads/chief
	name = "Engineering - CE's Office"
	icon_state = "head_quarters"
	horizon_deck = 2

/area/horizon/command/heads/cmo
	name = "Medbay - CMO's Office"
	icon_state = "head_quarters"
	horizon_deck = 3

/area/horizon/command/heads/om
	name = "Operations - OM's Office"
	icon_state = "head_quarters"
	horizon_deck = 2

/// Bridge areas
/area/horizon/command/bridge
	name = "Bridge"
	icon_state = "bridge"
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_blurb = "The sound here seems to carry more than others, every click of a shoe or clearing of a throat amplified. \
	The smell of ink, written and printed, wafts notably through the air."
	area_blurb_category = "command"
	horizon_deck = 3

/area/horizon/command/bridge/bridge_crew
	name = "Bridge Crew Preparation"
	icon_state = "bridge_crew"

/area/horizon/command/bridge/supply
	name = "Bridge Supply Closet"
	icon_state = "bridge_crew"

/area/horizon/command/bridge/upperdeck
	name = "Command Atrium Upper Deck"
	icon_state = "bridge"

/area/horizon/command/bridge/minibar
	name = "Command Break Room"
	icon_state = "bridge"

/area/horizon/command/bridge/aibunker
	name = "Command - Bunker"
	icon_state = "ai_foyer"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/command/bridge/centcom_meetingroom
	name = "Level A Meeting Room"
	icon_state = "bridge"

/area/horizon/command/bridge/meeting_room
	name = "Command - Conference Room"
	icon_state = "bridge"
	ambience = list()
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "A place for behind-closed-doors meetings to get things done, or to argue for hours in..."
	area_blurb_category = "command_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/command/bridge/cciaroom
	name = "Command - Human Resources Meeting Room"
	icon_state = "hr"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "You might feel dread when you enter this meeting room."
	area_blurb_category = "hr_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/command/bridge/cciaroom/lounge
	name = "Command - Human Resources Lounge"
	icon_state = "hrlounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	area_blurb = "A place that may worsen any anxiety surrounding meetings with your bosses' boss."
	area_blurb_category = "hr_lounge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/command/bridge/selfdestruct
	name = "Command - Station Authentication Terminal Safe"
	icon_state = "bridge"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/command/bridge/controlroom
	name = "Command - Control Room"
	area_blurb = "The full expanse of space lies beyond a thick pane of reinforced glass, all that protects you from a cold and painful death. The computers hum, showing various displays and holographic signs. The sight would be overwhelming if you are not used to such an environment. Even at full power, the sensors fail to map even a fraction of the dots of light making up the cosmic filament."
	area_blurb_category = "bridge"
	area_flags = AREA_FLAG_RAD_SHIELDED

//Teleporter
/area/teleporter
	name = "Command - Teleporter"
	icon_state = "teleporter"
	station_area = TRUE
