/datum/map_template/ruin/away_site/swamptown
    name = "Remote Settlement"
    description = "An outpost located in a marshy valley."
    prefix = "scenarios/swamptown/"
    suffix = "swamptown.dmm"

    traits = list(
        // Bunker Level
        list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
        // Surface Level
        list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
    )

    sectors = list(ALL_POSSIBLE_SECTORS)
    spawn_weight = 0
    spawn_cost = 1
    id = "swamptown"

/singleton/submap_archetype/swamptown
    map = "Marshland Village"
    descriptor = "An outpost in the middle of a marsh."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/swamptown
    name = "Humid Exoplanet"
    desc = "\
        A small, habitable exoplanet with high humidity levels and tropical to subtropical temperatures for most of its regions. \
        Most of the planet's landmasses are covered in dense rainforest, jungle, swamps, or marshlands. \
        Scans reveal a cluster of artificial buildings located in a dryer part of the planet, where the ground is solid enough to allow for construction. \
        "
    icon_state = "globe2"
    color = "#f7e3e3"
    comms_support = TRUE
    initial_generic_waypoints = list(
        "nav_swamptown_landing",
	)
