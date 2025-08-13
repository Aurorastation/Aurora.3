/*
	var/station_area = FALSE
	/// Only used for the Horizon, and mostly for mapping checks.
	var/horizon_deck = null
	/// Only used for the Horizon, and mostly for mapping checks.
	var/department = null
	/// Only used for the Horizon, and mostly for mapping checks.
	var/subdepartment = null
*/

/area/horizon/command
	department = LOC_COMMAND
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/// Head of Staff offices
/area/horizon/command/heads
	name = "Head of Staff's Office (PARENT AREA - DON'T USE)"
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/command/heads/captain
	name = "Captain's Office"
	icon_state = "captain"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "The most daunting office on the entire ship. Except for CCIA's. Theirs is still a little scarier."
	horizon_deck = 3

/area/horizon/command/heads/xo
	name = "Executive Officer's Office"
	area_blurb = "No one really knows what goes on in here, but Ian usually seems pretty happy so it's got that going for it.."
	horizon_deck = 3

/area/horizon/command/heads/hos
	name = "Head of Security's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	area_blurb = "This office is possessed of an austere, vaguely threatening atmosphere. Why does it smell like black powder? None of the guns use black powder?"
	horizon_deck = 2

/area/horizon/command/heads/rd
	name = "RD's Office"
	icon_state = "head_quarters"
	area_blurb = "There are nagging subtle scents of ink, chemicals, ozone, machine oil, alien blood, and a dozen more in the air here that the scrubbers seem simply incapable of finally purging."
	horizon_deck = 2

/area/horizon/command/heads/chief
	name = "CE's Office"
	icon_state = "head_quarters"
	area_blurb = "This office can't seem to decide if it smells like welding fumes or expensive cologne. Several bulkhead walls are covered in buttons and toggles that exude an air of dangerous importance."
	horizon_deck = 2

/area/horizon/command/heads/cmo
	name = "CMO's Office"
	icon_state = "head_quarters"
	area_blurb = "There's a peculiar serenity to this office completely at odds with the often frenetic atmosphere of the rest of Medical. Maybe it's the cat."
	horizon_deck = 3

/area/horizon/command/heads/om
	name = "OM's Office"
	icon_state = "head_quarters"
	area_blurb = "Just stepping through the threshold imparts the nagging feeling that there's someone  out there that owes you money."
	horizon_deck = 2

/// Bridge areas
/area/horizon/command/bridge
	name = "Bridge"
	icon_state = "bridge"
	no_light_control = 1
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
	name = "Bridge Atrium"
	icon_state = "bridge"

/area/horizon/command/bridge/minibar
	name = "Bridge Break Room"
	icon_state = "bridge"

/area/horizon/command/bridge/aibunker
	name = "Command Bunker"
	icon_state = "ai_foyer"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	area_blurb = "Heavily armored and internal, the Combat Information Center is the secondary nerve center of the ship; the responsibility of the place weighs heavily."

/area/horizon/command/bridge/meeting_room
	name = "Bridge Conference Room"
	icon_state = "bridge"
	ambience = list()
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "A place for behind-closed-doors meetings to get things done (or to argue for hours)."
	area_blurb_category = "command_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/command/bridge/cciaroom
	name = "Human Resources Meeting Room"
	icon_state = "hr"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "You might feel dread when you enter this meeting room."
	area_blurb_category = "hr_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/command/bridge/cciaroom/lounge
	name = "Human Resources Lounge"
	icon_state = "hrlounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	area_blurb = "A place that may worsen any anxiety surrounding meetings with your bosses' bosses."
	area_blurb_category = "hr_lounge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/command/bridge/selfdestruct
	name = "Authentication Terminal Safe"
	icon_state = "bridge"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	area_blurb = "The air veritably throbs with doom."

/area/horizon/command/bridge/controlroom
	name = "Bridge Control Room"
	area_blurb = "The full expanse of space lies beyond a thick pane of reinforced glass, all that protects you from a cold and painful death. The computers hum, showing various displays and holographic signs. The sight would be overwhelming to one unused to such an environment. Even at full power, the sensors fail to map even a fraction of the dots of light making up the cosmic filament."
	area_blurb_category = "bridge"
	area_flags = AREA_FLAG_RAD_SHIELDED

//Teleporter
/area/horizon/command/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	horizon_deck = 1
	area_blurb = "The air in here always feels charged with the subdued crackle of electricity, tasting faintly of ozone."
	area_blurb_category = "teleporter"
