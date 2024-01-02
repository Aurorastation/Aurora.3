//#define TESTING
#if DM_VERSION < 513
#error Your version of BYOND is too old to compile the code. At least BYOND 513 is required.
#endif


// Items that ask to be called every cycle.
GLOBAL_LIST_EMPTY(processing_power_items)
GLOBAL_LIST_EMPTY(med_hud_users) // List of all entities using a medical HUD.
GLOBAL_LIST_EMPTY(sec_hud_users) // List of all entities using a security HUD.
GLOBAL_LIST_EMPTY(hud_icon_reference)
GLOBAL_LIST_EMPTY(janitorial_supplies)	// List of all the janitorial supplies on the map that the PDA cart may be tracking.
GLOBAL_LIST_EMPTY(world_phylactery) 	//List of all phylactery in the world, used by liches

GLOBAL_LIST_EMPTY(listening_objects) // List of objects that need to be able to hear, used to avoid recursive searching through contents.

GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)

GLOBAL_LIST(global_map)
GLOBAL_PROTECT(global_map)

GLOBAL_LIST_EMPTY(cable_list)

GLOBAL_VAR(diary)
GLOBAL_PROTECT(diary)

GLOBAL_VAR(diary_runtime)
GLOBAL_PROTECT(diary_runtime)

GLOBAL_VAR(diary_date_string)
GLOBAL_PROTECT(diary_date_string)

GLOBAL_VAR(href_logfile)
GLOBAL_PROTECT(href_logfile)

GLOBAL_VAR_INIT(game_version, "Aurorastation")
GLOBAL_PROTECT(game_version)

GLOBAL_VAR_INIT(changelog_hash, "")
GLOBAL_PROTECT(changelog_hash)

GLOBAL_VAR_INIT(game_year, (text2num(time2text(world.realtime, "YYYY")) + 442))

GLOBAL_VAR_INIT(round_progressing, 1)
GLOBAL_VAR_INIT(master_mode, "extended")
/// If this is anything but "secret", the secret rotation will forcibly choose this mode.
GLOBAL_VAR_INIT(secret_force_mode, "secret")

GLOBAL_LIST_EMPTY(bombers)
GLOBAL_PROTECT(bombers)

GLOBAL_LIST_EMPTY(admin_log)
GLOBAL_PROTECT(admin_log)

GLOBAL_LIST_EMPTY(signal_log)
GLOBAL_PROTECT(signal_log)

GLOBAL_LIST_EMPTY(lastsignalers) // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
GLOBAL_PROTECT(lastsignalers)

GLOBAL_LIST_EMPTY(lawchanges) // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
GLOBAL_PROTECT(lawchanges)

GLOBAL_LIST_EMPTY(reg_dna)

GLOBAL_DATUM(newplayer_start, /turf)

//Spawnpoints.
GLOBAL_LIST_EMPTY(latejoin)
GLOBAL_LIST_EMPTY(latejoin_gateway)
GLOBAL_LIST_EMPTY(latejoin_cryo)
GLOBAL_LIST_EMPTY(latejoin_cryo_command)
GLOBAL_LIST_EMPTY(latejoin_cyborg)
GLOBAL_LIST_EMPTY(latejoin_merchant)
GLOBAL_LIST_EMPTY(latejoin_living_quarters_lift)
GLOBAL_LIST_EMPTY(kickoffsloc)
GLOBAL_LIST_EMPTY(virtual_reality_spawn)

GLOBAL_LIST_EMPTY(asteroid_spawn) // Asteroid "Dungeons" spawn at these.
GLOBAL_LIST_EMPTY(tdome1)
GLOBAL_LIST_EMPTY(tdome2)
GLOBAL_LIST_EMPTY(tdomeobserve)
GLOBAL_LIST_EMPTY(tdomeadmin)
GLOBAL_LIST_EMPTY(ninjastart)

GLOBAL_LIST_INIT(cardinal, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(cornerdirs, list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(reverse_dir, list( // reverse_dir[dir] = reverse of dir
	2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
))

GLOBAL_LIST_EMPTY(combatlog)
GLOBAL_PROTECT(lawchanges)

GLOBAL_LIST_EMPTY(IClog)
GLOBAL_PROTECT(IClog)

GLOBAL_LIST_EMPTY(OOClog)
GLOBAL_PROTECT(OOClog)

GLOBAL_LIST_EMPTY(adminlog)
GLOBAL_PROTECT(adminlog)

GLOBAL_VAR_INIT(Debug2, 0)
GLOBAL_DATUM(debugobj, /datum/debug)

GLOBAL_DATUM_INIT(mods, /datum/moduletypes, new())

GLOBAL_VAR_INIT(gravity_is_on, 1)

GLOBAL_LIST_EMPTY(awaydestinations) // Away missions. A list of landmarks that the warpgate can take you to.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)
GLOBAL_VAR(custom_event_msg)

// Database connections. A connection is established along with /hook/startup/proc/load_databases().
// Ideally, the connection dies when the server restarts (After feedback logging.).
GLOBAL_DATUM(dbcon, /DBConnection)
GLOBAL_PROTECT(dbcon)

// Added for Xenoarchaeology, might be useful for other stuff.
GLOBAL_LIST_INIT(alphabet_uppercase, list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"))

// Used by robots and robot preferences.
GLOBAL_LIST_INIT(robot_module_types, list(
	"Engineering",
	"Construction",
	"Medical",
	"Rescue",
	"Mining",
	"Custodial",
	"Service",
	"Clerical",
	"Research"
))

// Some scary sounds.
GLOBAL_LIST_INIT(scarySounds, list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/glass_break1.ogg',
	'sound/effects/glass_break2.ogg',
	'sound/effects/glass_break3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/welder_pry.ogg',
	'sound/machines/airlock.ogg',

))

// Bomb cap!
GLOBAL_VAR_INIT(max_explosion_range, 14)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/device/radio/all_channels, new)

// the number next to it denotes how much money the department receives when its account is generated
GLOBAL_LIST_INIT(department_funds, list(
	"Command" = 10000,
	"Medical" = 10000,
	"Engineering" = 10000,
	"Science" = 10000,
	"Security" = 10000,
	"Operations" = 5000,
	"Service" = 10000,
	"Vendor" = 0
))

//List of exosuit tracking beacons, to save performance
GLOBAL_LIST_EMPTY(exo_beacons)
