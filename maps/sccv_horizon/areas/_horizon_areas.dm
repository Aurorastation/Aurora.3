/**
 * Definitions for every area used on the SCCV Horizon map.
 *
 * This file is only to contain definitions for the master horizon and horizon exterior areas, and this documentation.
 * The other files in this subfolder ('maps/sccv_horizon/code/sccv_horizon_areas') are the remaining SCCV Horizon areas,
 * divided broadly by department with the exception of horizon_areas_crew.dm.
 *
 * While most should be self-explanatory by name, horizon_areas_crew is a catch-all file for all areas that are either 'public'
 * (like hallways, washrooms) but also areas which are difficult to slot into a given department, like Head of Staff offices,
 * non-dept storage, etc. If we add anything weird that doesn't fit neatly, add it there.
 *
 * Whenever areas are added or removed from the Horizon, it should be handled within this subfolder. Whenever NBT comes, the
 * definition names /area/horizon/. should just be replaced with /area/[whatever]/.
 *
 * GUIDELINES:
 * * The Horizon should not have any areas mapped to it which are defined outside this file.
 * * Any PR that removes all areas of a given definition should also remove or comment out that definition from here.
 * * No area should exist across multiple decks. Ex., an elevator vestibule on all three decks should have three child definitions, one for each deck. This is both for organization and for managing area objects like APCs etc.
 * * Update the groupings list if anything is added/removed.
 */

/// SCCV Horizon master areas
/area/horizon
	name = "Horizon (PARENT AREA - DON'T USE)"
	icon_state = "unknown"
	station_area = TRUE
	ambience = AMBIENCE_GENERIC
	// Remember to set this for new areas!!
	// horizon_deck = 1, 2, or 3
	// Remember to set this for new areas!!
	// department = constant in '\_DEFINES\departments.dm'
	// Remember to set this for new areas!!
	// subdepartment = constant in '\_DEFINES\departments.dm'
	area_blurb = "One of the compartments of the SCCV Horizon."

/area/horizon/exterior
	name = "Horizon - Exterior"
	icon_state = "exterior"
	base_turf = /turf/space
	dynamic_lighting = TRUE
	requires_power = FALSE
	has_gravity = FALSE
	no_light_control = TRUE
	allow_nightmode = FALSE
	ambience = AMBIENCE_SPACE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	area_blurb = "The sheer scale of the SCCV Horizon is never more apparent when crawling across its hull like an ant."
