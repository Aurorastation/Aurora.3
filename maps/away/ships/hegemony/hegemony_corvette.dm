/datum/map_template/ruin/away_site/hegemony_corvette
	name = "Hegemony Corvette"
	description = "Ship with lizards."
	suffixes = list("ships/hegemony/hegemony_corvette.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_UUEOAESA)
	spawn_weight = 1
	ship_cost = 1
	id = "hegemony_corvette"

/singleton/submap_archetype/hegemony_corvette
	map = "Hegemony Corvette"
	descriptor = "Ship with lizards."

/obj/effect/overmap/visitable/ship/hegemony_corvette
	name = "Hegemony Corvette"
	class = "HMV" //Hegemony Military Vessel
	desc = "stuff goes here"
	icon_state = "foundation"
	moving_state = "foundation-moving"
	colors = list("#e38222", "#f0ba3e")
	scanimage = "unathi_corvette.png"
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	volume = "75 meters length, 35 meters beam/width, 21 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding medium-caliber ballistic armament, port obscured flight craft bay"
	sizeclass = "Foundation-class corvette"
	shiptype = "Military patrol and anti-pirate operation."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	//initial_restricted_waypoints = list()
	//initial_generic_waypoints = list()

/obj/effect/overmap/visitable/ship/hegemony_corvette/New()
	designation = "[pick("Three Heads' Chosen", "Revenge for Gakal'zaal", "Child of Chanterel", "Horns of the Hegemon", "Hide of Steel", "Battle-Talon", "Roaming Warrior", "Abiding Victory", "Scorched Scales", "Wildfire of Moghes", "Travakh Unending", "Blessed By The Spirits", "Blackened Tail", "Legend Foretold", "Molten Claws", "Unfading River", "Emberstorm")]"
	..()

