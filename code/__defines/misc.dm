#define DEBUG

// Flags
#define ALL (~0) //For convenience.
#define NONE 0

// Turf-only flags.
#define TURF_FLAG_NOJAUNT 		1
#define TURF_FLAG_BACKGROUND 	2 // Used by shuttle movement to determine if it should be ignored by turf translation.

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.
#define RUIN_MAP_EDGE_PAD 15

/// Occupation preferences.
#define BE_ASSISTANT 0
#define RETURN_TO_LOBBY 1

// Invisibility constants.
#define INVISIBILITY_LIGHTING		20
#define INVISIBILITY_LEVEL_ONE		35
#define INVISIBILITY_LEVEL_TWO		45
#define INVISIBILITY_OVERMAP     	50
#define INVISIBILITY_OBSERVER		60
#define INVISIBILITY_EYE			61
#define INVISIBILITY_SYSTEM			99

#define SEE_INVISIBLE_LIVING		25
#define SEE_INVISIBLE_NOLIGHTING	15
#define SEE_INVISIBLE_LEVEL_ONE		35
#define SEE_INVISIBLE_LEVEL_TWO		45
#define SEE_INVISIBLE_CULT			60
#define SEE_INVISIBLE_OBSERVER		61
#define SEE_INVISIBLE_SYSTEM		99

#define SEE_INVISIBLE_MINIMUM		5
#define INVISIBILITY_MAXIMUM		100
#define INVISIBILITY_ABSTRACT		101	// Special invis value that can never be seen by see_invisible.

// Some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26 // Used to trigger removal from a processing list.

// Preference toggles.
#define SOUND_ADMINHELP 0x1
#define SOUND_MIDI      0x2
// 0x4 is free.
#define SOUND_LOBBY				0x8
#define CHAT_OOC				0x10
#define CHAT_DEAD				0x20
#define CHAT_GHOSTEARS			0x40
#define CHAT_GHOSTSIGHT			0x80
#define CHAT_PRAYER				0x100
#define CHAT_RADIO				0x200
#define CHAT_ATTACKLOGS			0x400
#define CHAT_DEBUGLOGS			0x800
#define CHAT_LOOC				0x1000
#define CHAT_GHOSTRADIO			0x2000
#define HIDE_TYPING_INDICATOR	0x4000
#define CHAT_NOICONS			0x8000
#define CHAT_GHOSTLOOC			0x10000

// 0x1 is free.
// 0x2 is free.
#define PROGRESS_BARS				0x4
#define PARALLAX_IS_STATIC			0x8
#define FLOATING_MESSAGES			0x10
#define HOTKEY_DEFAULT				0x20
#define FULLSCREEN_MODE				0x40
#define ACCENT_TAG_TEXT				0x80

#define TOGGLES_DEFAULT (SOUND_ADMINHELP | SOUND_MIDI | SOUND_LOBBY | CHAT_OOC | CHAT_DEAD | CHAT_GHOSTEARS | CHAT_GHOSTSIGHT | CHAT_PRAYER | CHAT_RADIO | CHAT_ATTACKLOGS | CHAT_LOOC | CHAT_GHOSTLOOC)

// ASFX and SFX Toggles
// (ASFX = Ambient Sound Effects; SFX = Sound Effects)
#define ASFX_AMBIENCE			BITFLAG(0)
#define ASFX_FOOTSTEPS			BITFLAG(1)
#define ASFX_VOTE				BITFLAG(2)
#define ASFX_VOX				BITFLAG(3)
#define ASFX_DROPSOUND			BITFLAG(4)
#define ASFX_ARCADE				BITFLAG(5)
#define ASFX_RADIO				BITFLAG(6)
#define ASFX_INSTRUMENT			BITFLAG(7)
#define ASFX_HUM 				BITFLAG(8)
#define ASFX_MUSIC				BITFLAG(9)
#define ASFX_CONSOLE_AMBIENCE	BITFLAG(10)

#define ASFX_DEFAULT (ASFX_AMBIENCE | ASFX_FOOTSTEPS | ASFX_VOTE | ASFX_VOX | ASFX_DROPSOUND | ASFX_ARCADE | ASFX_RADIO | ASFX_INSTRUMENT | ASFX_HUM | ASFX_MUSIC | ASFX_CONSOLE_AMBIENCE)

// For secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define      HEALTH_HUD 1 // A simple line reading the pulse.
#define      STATUS_HUD 2 // Alive, dead, diseased, etc.
#define          ID_HUD 3 // The job asigned to your ID.
#define      WANTED_HUD 4 // Wanted, released, paroled, security status.
#define    IMPLOYAL_HUD 5 // Loyality implant.
#define     IMPCHEM_HUD 6 // Chemical implant.
#define    IMPTRACK_HUD 7 // Tracking implant.
#define SPECIALROLE_HUD 8 // AntagHUD image.
#define  STATUS_HUD_OOC 9 // STATUS_HUD without virus DB check for someone being ill.
#define 	  LIFE_HUD 10 // STATUS_HUD that only reports dead or alive
#define     TRIAGE_HUD 11 // a HUD that creates a bar above the user showing their medical status

//	Shuttles.

// These define the time taken for the shuttle to get to the space station, and the time before it leaves again.
#define SHUTTLE_PREPTIME                300 // 5 minutes = 300 seconds - after this time, the shuttle departs centcom and cannot be recalled.
#define SHUTTLE_LEAVETIME               180 // 3 minutes = 180 seconds - the duration for which the shuttle will wait at the station after arriving.
#define SHUTTLE_FORCETIME               300 // 5 minutes = 300 seconds - time after which the shuttle is automatically forced
#define SHUTTLE_TRANSIT_DURATION        300 // 5 minutes = 300 seconds - how long it takes for the shuttle to get to the station.
#define SHUTTLE_TRANSIT_DURATION_RETURN 120 // 2 minutes = 120 seconds - for some reason it takes less time to come back, go figure.

// Shuttle moving status.
#define SHUTTLE_IDLE      0
#define SHUTTLE_WARMUP    1
#define SHUTTLE_INTRANSIT 2
#define SHUTTLE_HALT      3 // State of no recovery

// Ferry shuttle processing status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

// Setting this much higher than 1024 could allow spammers to DOS the server easily.
#define MAX_MESSAGE_LEN       1024
#define MAX_PAPER_MESSAGE_LEN 3072
#define MAX_BOOK_MESSAGE_LEN  9216
#define MAX_LNAME_LEN         64
#define MAX_NAME_LEN          63

// Event defines.
#define EVENT_LEVEL_MUNDANE  1
#define EVENT_LEVEL_MODERATE 2
#define EVENT_LEVEL_MAJOR    3

//General-purpose life speed define for plants.
#define HYDRO_SPEED_MULTIPLIER 1

#define DEFAULT_JOB_TYPE /datum/job/assistant

//Area flags, possibly more to come
#define AREA_FLAG_RAD_SHIELDED        	 BITFLAG(1) //shielded from radiation, clearly
#define AREA_FLAG_SPAWN_ROOF          	 BITFLAG(2) // if we should attempt to spawn a roof above us.
#define AREA_FLAG_HIDE_FROM_HOLOMAP   	 BITFLAG(3) // if we shouldn't be drawn on station holomaps
#define AREA_FLAG_FIRING_RANGE        	 BITFLAG(4)
#define AREA_FLAG_NO_CREW_EXPECTED    	 BITFLAG(5) // Areas where crew is not expected to ever be. Used to tell antag bases and such from crew-accessible areas on centcom level.
#define AREA_FLAG_PRISON              	 BITFLAG(6) // Marks prison area for purposes of checking if brigged/imprisoned
#define AREA_FLAG_NO_GHOST_TELEPORT_ACCESS BITFLAG(7) // Marks whether ghosts should not have teleport access to this area

// Convoluted setup so defines can be supplied by Bay12 main server compile script.
// Should still work fine for people jamming the icons into their repo.
#ifndef CUSTOM_ITEM_OBJ
#define CUSTOM_ITEM_OBJ 'icons/obj/custom_items_obj.dmi'
#endif
#ifndef CUSTOM_ITEM_MOB
#define CUSTOM_ITEM_MOB 'icons/mob/custom_items_mob.dmi'
#endif
#ifndef CUSTOM_ITEM_SYNTH
#define CUSTOM_ITEM_SYNTH 'icons/mob/custom_synthetic.dmi'
#endif

#define WALL_CAN_OPEN 1
#define WALL_OPENING 2

#define MIN_DAMAGE_TO_HIT 15 //Minimum damage needed to dent walls and girders by hitting them with a weapon.

#define DEFAULT_TABLE_MATERIAL "plastic"
#define DEFAULT_TABLE_REINF_MATERIAL "plasteel"
#define DEFAULT_TABLE_FLIP_WEIGHT 22
#define DEFAULT_WALL_MATERIAL "steel"

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define MATERIAL_UNMELTABLE 0x1
#define MATERIAL_BRITTLE    0x2
#define MATERIAL_PADDING    0x4

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

#define BOMBCAP_DVSTN_RADIUS (GLOB.max_explosion_range/4)
#define BOMBCAP_HEAVY_RADIUS (GLOB.max_explosion_range/2)
#define BOMBCAP_LIGHT_RADIUS GLOB.max_explosion_range
#define BOMBCAP_FLASH_RADIUS (GLOB.max_explosion_range*1.5)
									// NTNet module-configuration values. Do not change these. If you need to add another use larger number (5..6..7 etc)
#define NTNET_SOFTWAREDOWNLOAD 1 	// Downloads of software from NTNet
#define NTNET_PEERTOPEER 2			// P2P transfers of files between devices
#define NTNET_COMMUNICATION 3		// Communication (messaging)
#define NTNET_SYSTEMCONTROL 4		// Control of various systems, RCon, air alarm control, etc.

// NTNet transfer speeds, used when downloading/uploading a file/program.
#define NTNETSPEED_LOWSIGNAL 0.05	// GQ/s transfer speed when the device is wirelessly connected and on Low signal
#define NTNETSPEED_HIGHSIGNAL 0.25	// GQ/s transfer speed when the device is wirelessly connected and on High signal
#define NTNETSPEED_ETHERNET 1	  // GQ/s transfer speed when the device is using wired connection
#define NTNETSPEED_DOS_AMPLIFICATION 20	// Multiplier for Denial of Service program. Resulting load on NTNet relay is this multiplied by NTNETSPEED of the device

// Program bitflags
#define PROGRAM_CONSOLE 1
#define PROGRAM_LAPTOP 2
#define PROGRAM_TABLET 4
#define PROGRAM_TELESCREEN 8
#define PROGRAM_SILICON_AI 16
#define PROGRAM_WRISTBOUND 32
#define PROGRAM_SILICON_ROBOT 64
#define PROGRAM_SILICON_PAI 128

#define PROGRAM_ALL (PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_WRISTBOUND | PROGRAM_TELESCREEN | PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT | PROGRAM_SILICON_PAI)
#define PROGRAM_SILICON (PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT | PROGRAM_SILICON_PAI)
#define PROGRAM_STATIONBOUND (PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT)
#define PROGRAM_ALL_REGULAR (PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_WRISTBOUND | PROGRAM_TELESCREEN)
#define PROGRAM_ALL_HANDHELD (PROGRAM_TABLET | PROGRAM_WRISTBOUND)

#define PROGRAM_STATE_DISABLED -1
#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2

// Caps for NTNet logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NTNET_LOGS 500
#define MIN_NTNET_LOGS 10

#define PROGRAM_ACCESS_ONE 1
#define PROGRAM_ACCESS_LIST_ONE 2
#define PROGRAM_ACCESS_LIST_ALL 3

#define PROGRAM_NORMAL 1
#define PROGRAM_SERVICE 2
#define PROGRAM_TYPE_ALL (PROGRAM_NORMAL | PROGRAM_SERVICE)

#define DEVICE_UNSET 0
#define DEVICE_COMPANY BITFLAG(0)
#define DEVICE_PRIVATE BITFLAG(1)
#define ALL_DEVICE_ENROLLMENTS DEVICE_COMPANY|DEVICE_PRIVATE

#define SCANNER_MEDICAL BITFLAG(0)
#define SCANNER_REAGENT BITFLAG(1)
#define SCANNER_GAS BITFLAG(2)

// Special return values from bullet_act(). Positive return values are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flying after calling bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a miss (suppresses attack and admin logs) - only applies to mobs.
#define PROJECTILE_DODGED     -3 //this is similar to the above, but the check and message is run on the mob, instead of on the projectile code. basically just has a unique message
#define PROJECTILE_STOPPED    -4 //stops the projectile completely, as if a shield absorbed it

//Camera capture modes
#define CAPTURE_MODE_REGULAR 0 //Regular polaroid camera mode
#define CAPTURE_MODE_ALL 1 //Admin camera mode
#define CAPTURE_MODE_PARTIAL 3 //Simular to regular mode, but does not do dummy check

//Cargo random stock vars
//These are used in randomstock.dm
//And also for generating random loot crates in crates.dm
#define TOTAL_STOCK 	180//The total number of items we'll spawn in cargo stock

#define STOCK_UNCOMMON_PROB	25
//The probability, as a percentage for each item, that we'll choose from the uncommon spawns list

#define STOCK_RARE_PROB	3
//The probability, as a percentage for each item, that we'll choose from the rare spawns list

//If an item is not rare or uncommon, it will be chosen from the common spawns list.
//So the probability of a common item is 100 - (uncommon + rare)

#define STOCK_LARGE_PROB	75
//Large items are spawned on predetermined locations.
//For each large spawn marker, this is the chance that we will spawn there

// Law settings
#define PERMABRIG_SENTENCE 90 // Measured in minutes

/// for general usage of tick_usage
#define TICK_USAGE world.tick_usage
/// to be used where the result isn't checked
#define TICK_USAGE_REAL world.tick_usage

// Stoplag.
#define TICK_CHECK (TICK_USAGE > CURRENT_TICKLIMIT)
/// runs stoplag if tick_usage is above the limit
#define CHECK_TICK ( TICK_CHECK ? stoplag() : 0 )

/// Returns true if tick usage is above 95, for high priority usage
#define TICK_CHECK_HIGH_PRIORITY ( TICK_USAGE > 95 )
/// runs stoplag if tick_usage is above 95, for high priority usage
#define CHECK_TICK_HIGH_PRIORITY ( TICK_CHECK_HIGH_PRIORITY ? stoplag() : 0 )


// Performance bullshit.

//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
#define RANGE_TURFS(RADIUS, CENTER) \
	block( \
		locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
		locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
	)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
	locate(max((CENTER).x-(H_RADIUS),1), max((CENTER).y-(V_RADIUS),1), (CENTER).z), \
	locate(min((CENTER).x+(H_RADIUS),world.maxx), min((CENTER).y+(V_RADIUS),world.maxy), (CENTER).z) \
	)

#define get_turf(A) (get_step(A, 0))
#define NORTH_OF_TURF(T)	locate(T.x, T.y + 1, T.z)
#define EAST_OF_TURF(T)		locate(T.x + 1, T.y, T.z)
#define SOUTH_OF_TURF(T)	locate(T.x, T.y - 1, T.z)
#define WEST_OF_TURF(T)		locate(T.x - 1, T.y, T.z)

#define UNTIL(X) while(!(X)) stoplag()

#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day

#define DEBUG_REF(D) (D ? "\ref[D]|[D] ([D.type])" : "NULL")

// MultiZAS directions.
#define NORTHUP (NORTH|UP)
#define EASTUP (EAST|UP)
#define SOUTHUP (SOUTH|UP)
#define WESTUP (WEST|UP)
#define NORTHDOWN (NORTH|DOWN)
#define EASTDOWN (EAST|DOWN)
#define SOUTHDOWN (SOUTH|DOWN)
#define WESTDOWN (WEST|DOWN)

#define NL_NOT_DISABLED      0
#define NL_TEMPORARY_DISABLE 1
#define NL_PERMANENT_DISABLE 2

// Used for creating soft references to objects. A manner of storing an item reference
#define SOFTREF(A) ref(A)

// This only works on 511 because it relies on 511's `var/something = foo = bar` syntax.
#define WEAKREF(D) (istype(D, /datum) && !D:gcDestroyed ? (D:weakref || (D:weakref = new/datum/weakref(D))) : null)

#define ADD_VERB_IN(the_atom,time,verb) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(add_verb), the_atom, verb), time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)
#define ADD_VERB_IN_IF(the_atom,time,verb,callback) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(add_verb), the_atom, verb, callback), time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

// Maploader bounds indices
#define MAP_MINX 1
#define MAP_MINY 2
#define MAP_MINZ 3
#define MAP_MAXX 4
#define MAP_MAXY 5
#define MAP_MAXZ 6

// /atom/proc/use_check flags.
#define USE_ALLOW_NONLIVING 1
#define USE_ALLOW_NON_ADV_TOOL_USR 2
#define USE_ALLOW_DEAD 4
#define USE_ALLOW_INCAPACITATED 8
#define USE_ALLOW_NON_ADJACENT 16
#define USE_FORCE_SRC_IN_USER 32
#define USE_DISALLOW_SILICONS 64
#define USE_DISALLOW_SPECIALS 128 // revenants, zombies, etc

#define USE_SUCCESS 0
#define USE_FAIL_NON_ADJACENT 1
#define USE_FAIL_NONLIVING 2
#define USE_FAIL_NON_ADV_TOOL_USR 3
#define USE_FAIL_DEAD 4
#define USE_FAIL_INCAPACITATED 5
#define USE_FAIL_NOT_IN_USER 6
#define USE_FAIL_IS_SILICON 7
#define USE_FAIL_IS_MOB_SPECIAL 8

#define DEFAULT_SIGHT (SEE_SELF)

#define isStationLevel(Z) ((Z) in current_map.station_levels)
#define isNotStationLevel(Z) !isStationLevel(Z)

#define isPlayerLevel(Z) ((Z) in current_map.player_levels)
#define isNotPlayerLevel(Z) !isPlayerLevel(Z)

#define isAdminLevel(Z) ((Z) in current_map.admin_levels)
#define isNotAdminLevel(Z) !isAdminLevel(Z)

#define isContactLevel(Z) ((Z) in current_map.contact_levels)
#define isNotContactLevel(Z) !isContactLevel(Z)

//Cargo Container Types
#define CARGO_CONTAINER_CRATE "crate"
#define CARGO_CONTAINER_FREEZER "freezer"
#define CARGO_CONTAINER_BOX "box"
#define CARGO_CONTAINER_BODYBAG "bodybag"

// We should start using these.
#define ITEMSIZE_TINY   1
#define ITEMSIZE_SMALL  2
#define ITEMSIZE_NORMAL 3
#define ITEMSIZE_LARGE  4
#define ITEMSIZE_HUGE   5
#define ITEMSIZE_IMMENSE 6

// getFlatIcon function altering defines
#define GFI_ROTATION_DEFAULT 0 //Don't do anything special
#define GFI_ROTATION_DEFDIR 1 //Layers will have default direction of there object
#define GFI_ROTATION_OVERDIR 2 //Layers will have overidden direction

// The pixel_(x|y) offset that will be used by default by wall items, such as APCs or Fire Alarms.
#define DEFAULT_WALL_OFFSET 22 // Don't touch this unless you're going to work with walls in a major way.

// Defines for translating a dir into pixelshifts for wall items
#define DIR2PIXEL_X(dir) ((dir & (NORTH|SOUTH)) ? 0 : (dir == EAST ? DEFAULT_WALL_OFFSET : -(DEFAULT_WALL_OFFSET)))
#define DIR2PIXEL_Y(dir) ((dir & (NORTH|SOUTH)) ? (dir == NORTH ? DEFAULT_WALL_OFFSET : -(DEFAULT_WALL_OFFSET)) : 0)

/*
Define for getting a bitfield of adjacent turfs that meet a condition.
ORIGIN is the object to step from, VAR is the var to write the bitfield to
TVAR is the temporary turf variable to use, FUNC is the condition to check.
FUNC generally should reference TVAR.
example:
	var/turf/T
	var/result = 0
	CALCULATE_NEIGHBORS(src, result, T, isopenturf(T))
*/
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, TVAR, FUNC) \
	for (var/_tdir in GLOB.cardinal) {                    \
		TVAR = get_step(ORIGIN, _tdir);              \
		if ((TVAR) && (FUNC)) {                      \
			VAR |= 1 << _tdir;                       \
		}                                            \
	}                                                \
	if (VAR & N_NORTH) {                             \
		if (VAR & N_WEST) {                          \
			TVAR = get_step(ORIGIN, NORTHWEST);      \
			if (FUNC) {                              \
				VAR |= N_NORTHWEST;                  \
			}                                        \
		}                                            \
		if (VAR & N_EAST) {                          \
			TVAR = get_step(ORIGIN, NORTHEAST);      \
			if (FUNC) {                              \
				VAR |= N_NORTHEAST;                  \
			}                                        \
		}                                            \
	}                                                \
	if (VAR & N_SOUTH) {                             \
		if (VAR & N_WEST) {                          \
			TVAR = get_step(ORIGIN, SOUTHWEST);      \
			if (FUNC) {                              \
				VAR |= N_SOUTHWEST;                  \
			}                                        \
		}                                            \
		if (VAR & N_EAST) {                          \
			TVAR = get_step(ORIGIN, SOUTHEAST);      \
			if (FUNC) {                              \
				VAR |= N_SOUTHEAST;                  \
			}                                        \
		}                                            \
	}

#define DEVICE_NO_CELL "no_cell"

#define FALLOFF_SOUNDS 0.5
#define SOUND_Z_FACTOR 100
// Maximum number of Zs away you can be from a sound before it stops being audible.
#define MAX_SOUND_Z_TRAVERSAL 2

#define Z_ALL_TURFS(Z) block(locate(1, 1, Z), locate(world.maxx, world.maxy, Z))

// Z-controller stuff - see basic.dm to see why the fuck this is the way it is.
#define IS_VALID_ZINDEX(z) !((z) > world.maxz || (z) > 17)

#define GET_ABOVE(A) (HasAbove(A:z) ? get_step(A, UP) : null)
#define GET_BELOW(A) (HasBelow(A:z) ? get_step(A, DOWN) : null)

#define GET_Z(A) (get_step(A, 0)?.z || 0)

#define NULL_OR_EQUAL(self,other) (!(self) || (self) == (other))

//Lying animation
#define ANIM_LYING_TIME 2

// Cooking appliances.
#define MIX					1 << 0
#define FRYER				1 << 1
#define OVEN				1 << 2
#define SKILLET				1 << 3
#define SAUCEPAN			1 << 4
#define POT					1 << 5
#define GRILL				1 << 6

// Cooking misc.
// can_insert return values
#define CANNOT_INSERT		0
#define CAN_INSERT			1
#define INSERT_GRABBED		2
// check_contents return values
#define CONTAINER_EMPTY		0
#define CONTAINER_SINGLE	1
#define CONTAINER_MANY		2

#define CLIENT_FROM_VAR(I) (ismob(I) ? I:client : (isclient(I) ? I : (istype(I, /datum/mind) ? I:current?:client : null)))

// check_items/check_reagents/check_fruits return values
#define COOK_CHECK_FAIL		-1
#define COOK_CHECK_EXTRA	0
#define COOK_CHECK_EXACT	1

// Moved from tanks/tanks.dm
#define TANK_MAX_RELEASE_PRESSURE 		(3*ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE 	24 // kPa
#define TANK_IDEAL_PRESSURE 			1015 //Arbitrary.

#define STATION_TAG "Aurora"

//Planet habitability class
#define HABITABILITY_IDEAL  1
#define HABITABILITY_OKAY  2
#define HABITABILITY_BAD  3

//Map template flags
/// Lets multiple copies of the template to be spawned
#define TEMPLATE_FLAG_ALLOW_DUPLICATES 1
/// Makes it ignore away site budget and just spawn (works only for away sites)
/// A site needs to be set to spawn in current sector to be considered still
#define TEMPLATE_FLAG_SPAWN_GUARANTEED 2
/// if it should destroy objects it spawns on top of
#define TEMPLATE_FLAG_CLEAR_CONTENTS   4
/// if it should forbid ruins from spawning on top of it
#define TEMPLATE_FLAG_NO_RUINS         8

//Ruin map template flags
#define TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED 32  // Ruin is not available during spawning unless another ruin permits it, or whitelisted by the exoplanet

#define LANDING_ZONE_RADIUS 15 // Used for autoplacing landmarks on exoplanets

#define RAD_LEVEL_LOW 1 // Around the level at which radiation starts to become harmful
#define RAD_LEVEL_MODERATE 25
#define RAD_LEVEL_HIGH 40
#define RAD_LEVEL_VERY_HIGH 100

#define RADIATION_THRESHOLD_CUTOFF 0.1	// Radiation will not affect a tile when below this value.

// Defines for formatting cooldown actions for the stat panel.
/// The stat panel the action is displayed in.
#define PANEL_DISPLAY_PANEL "panel"
/// The status shown in the stat panel.
/// Can be stuff like "ready", "on cooldown", "active", "charges", "charge cost", etc.
#define PANEL_DISPLAY_STATUS "status"
/// The name shown in the stat panel.
#define PANEL_DISPLAY_NAME "name"

//Transfer Types
#define TRANSFER_EMERGENCY "emergency transfer"
#define TRANSFER_JUMP "bluespace jump"
#define TRANSFER_CREW "crew transfer"

/// Gyrotron power usage modifier.
#define GYRO_POWER 25000
