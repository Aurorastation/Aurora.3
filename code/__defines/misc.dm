#define DEBUG

// Turf-only flags.
#define NOJAUNT 1          // This is used in literally one place, turf.dm, to block ethereal jaunt.
#define MIMIC_BELOW 2      // If this turf should mimic the turf on the Z below.
#define MIMIC_OVERWRITE 4  // If this turf is Z-mimicing, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have an icon.
#define MIMIC_QUEUED 8     // If the turf is currently queued for Z-mimic update.
#define MIMIC_NO_AO 16     // If the turf shouldn't apply regular turf AO and only do Z-mimic AO.

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.

// Invisibility constants.
#define INVISIBILITY_LIGHTING             20
#define INVISIBILITY_LEVEL_ONE            35
#define INVISIBILITY_LEVEL_TWO            45
#define INVISIBILITY_OBSERVER             60
#define INVISIBILITY_EYE		          61

#define SEE_INVISIBLE_LIVING              25
#define SEE_INVISIBLE_NOLIGHTING 15
#define SEE_INVISIBLE_LEVEL_ONE           35
#define SEE_INVISIBLE_LEVEL_TWO           45
#define SEE_INVISIBLE_CULT		          60
#define SEE_INVISIBLE_OBSERVER            61

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100
#define INVISIBILITY_ABSTRACT 101	// Special invis value that can never be seen by see_invisible.

// Some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26 // Used to trigger removal from a processing list.

// Age limits on a character.
#define AGE_MIN 17
#define AGE_MAX 85

#define MAX_GEAR_COST 15 // Used in chargen for accessory loadout limit.

// Preference toggles.
#define SOUND_ADMINHELP 0x1
#define SOUND_MIDI      0x2
#define SOUND_AMBIENCE  0x4
#define SOUND_LOBBY     0x8
#define CHAT_OOC        0x10
#define CHAT_DEAD       0x20
#define CHAT_GHOSTEARS  0x40
#define CHAT_GHOSTSIGHT 0x80
#define CHAT_PRAYER     0x100
#define CHAT_RADIO      0x200
#define CHAT_ATTACKLOGS 0x400
#define CHAT_DEBUGLOGS  0x800
#define CHAT_LOOC       0x1000
#define CHAT_GHOSTRADIO 0x2000
#define SHOW_TYPING     0x4000
#define CHAT_NOICONS    0x8000

#define PARALLAX_SPACE 0x1
#define PARALLAX_DUST  0x2
#define PROGRESS_BARS  0x4
#define PARALLAX_IS_STATIC 0x8

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_ATTACKLOGS|CHAT_LOOC)

//Sound effects toggles
#define ASFX_AMBIENCE	1
#define ASFX_FOOTSTEPS	2
#define ASFX_VOTE		4
#define ASFX_VOX		8
#define ASFX_DROPSOUND	16
#define ASFX_ARCADE		32

#define ASFX_DEFAULT (ASFX_AMBIENCE|ASFX_FOOTSTEPS|ASFX_VOTE|ASFX_VOX|ASFX_DROPSOUND|ASFX_ARCADE)

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
#define RAD_SHIELDED 1 //shielded from radiation, clearly
#define SPAWN_ROOF   2 // if we should attempt to spawn a roof above us.
#define HIDE_FROM_HOLOMAP 4 // if we shouldn't be drawn on station holomaps
#define FIRING_RANGE	8

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

#define BOMBCAP_DVSTN_RADIUS (max_explosion_range/4)
#define BOMBCAP_HEAVY_RADIUS (max_explosion_range/2)
#define BOMBCAP_LIGHT_RADIUS max_explosion_range
#define BOMBCAP_FLASH_RADIUS (max_explosion_range*1.5)
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
#define PROGRAM_SILICON 16
#define PROGRAM_WRISTBOUND 32

#define PROGRAM_ALL (PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_WRISTBOUND | PROGRAM_TELESCREEN | PROGRAM_SILICON)
#define PROGRAM_ALL_REGULAR (PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_WRISTBOUND | PROGRAM_TELESCREEN)

#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2

// Caps for NTNet logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NTNET_LOGS 500
#define MIN_NTNET_LOGS 10

#define PROGRAM_ACCESS_ONE 1
#define PROGRAM_ACCESS_LIST_ONE 2
#define PROGRAM_ACCESS_LIST_ALL 3

// Special return values from bullet_act(). Positive return values are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flying after calling bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a miss (suppresses attack and admin logs) - only applies to mobs.

//Camera capture modes
#define CAPTURE_MODE_REGULAR 0 //Regular polaroid camera mode
#define CAPTURE_MODE_ALL 1 //Admin camera mode
#define CAPTURE_MODE_PARTIAL 3 //Simular to regular mode, but does not do dummy check

//Cargo random stock vars
//These are used in randomstock.dm
//And also for generating random loot crates in crates.dm
#define TOTAL_STOCK 	100//The total number of items we'll spawn in cargo stock

#define STOCK_UNCOMMON_PROB	23
//The probability, as a percentage for each item, that we'll choose from the uncommon spawns list

#define STOCK_RARE_PROB	2.8
//The probability, as a percentage for each item, that we'll choose from the rare spawns list

//If an item is not rare or uncommon, it will be chosen from the common spawns list.
//So the probability of a common item is 100 - (uncommon + rare)

#define STOCK_LARGE_PROB	75
//Large items are spawned on predetermined locations.
//For each large spawn marker, this is the chance that we will spawn there


// Law settings
#define PERMABRIG_SENTENCE 90 // Measured in minutes

#define LAYER_TABLE	2.8
#define LAYER_UNDER_TABLE	2.79
#define LAYER_ABOVE_TABLE	2.81

// Stoplag.
#define TICK_CHECK (world.tick_usage > CURRENT_TICKLIMIT)
#define CHECK_TICK if (TICK_CHECK) stoplag()

// Performance bullshit.

//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
#define RANGE_TURFS(RADIUS, CENTER) \
  block( \
    locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
    locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
  )

#define get_turf(A) (get_step(A, 0))

#define UNTIL(X) while(!(X)) stoplag()

#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day

#define DEBUG_REF(D) (D ? "\ref[D]|[D] ([D.type])" : "NULL")

//Recipe type defines. Used to determine what machine makes them
#define MICROWAVE			0x1
#define FRYER				0x2
#define OVEN				0x4
#define CANDYMAKER			0x8
#define CEREALMAKER			0x10

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
// as text so you don't necessarily fuck with an object's ability to be garbage collected.
#if DM_VERSION < 513

#define SOFTREF(A) "\ref[A]"

#else

#define SOFTREF(A) ref(A)

#endif

// This only works on 511 because it relies on 511's `var/something = foo = bar` syntax.
#define WEAKREF(D) (istype(D, /datum) && !D:gcDestroyed ? (D:weakref || (D:weakref = new/datum/weakref(D))) : null)

#define ADD_VERB_IN(the_atom,time,verb) addtimer(CALLBACK(the_atom, /atom/.proc/add_verb, verb), time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)
#define ADD_VERB_IN_IF(the_atom,time,verb,callback) addtimer(CALLBACK(the_atom, /atom/.proc/add_verb, verb, callback), time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

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

#define USE_SUCCESS 0
#define USE_FAIL_NON_ADJACENT 1
#define USE_FAIL_NONLIVING 2
#define USE_FAIL_NON_ADV_TOOL_USR 3
#define USE_FAIL_DEAD 4
#define USE_FAIL_INCAPACITATED 5
#define USE_FAIL_NOT_IN_USER 6
#define USE_FAIL_IS_SILICON 7

#define DEFAULT_SIGHT (SEE_SELF)

#define isStationLevel(Z) ((Z) in current_map.station_levels)
#define isNotStationLevel(Z) !isStationLevel(Z)

#define isPlayerLevel(Z) ((Z) in current_map.player_levels)
#define isNotPlayerLevel(Z) !isPlayerLevel(Z)

#define isAdminLevel(Z) ((Z) in current_map.admin_levels)
#define isNotAdminLevel(Z) !isAdminLevel(Z)

#define isContactLevel(Z) ((Z) in current_map.contact_levels)
#define isNotContactLevel(Z) !isContactLevel(Z)

//Affects the chance that armour will block an attack. Should be between 0 and 1.
//If set to 0, then armor will always prevent the same amount of damage, always, with no randomness whatsoever.
//Of course, this will affect code that checks for blocked < 100, as blocked will be less likely to actually be 100.
#define ARMOR_BLOCK_CHANCE_MULT 1.0

//Cargo Container Types
#define CARGO_CONTAINER_CRATE "crate"
#define CARGO_CONTAINER_FREEZER "freezer"
#define CARGO_CONTAINER_BOX "box"

// We should start using these.
#define ITEMSIZE_TINY   1
#define ITEMSIZE_SMALL  2
#define ITEMSIZE_NORMAL 3
#define ITEMSIZE_LARGE  4
#define ITEMSIZE_HUGE   5

// getFlatIcon function altering defines
#define GFI_ROTATION_DEFAULT 0 //Don't do anything special
#define GFI_ROTATION_DEFDIR 1 //Layers will have default direction of there object
#define GFI_ROTATION_OVERDIR 2 //Layers will have overidden direction

// The pixel_(x|y) offset that will be used by default by wall items, such as APCs or Fire Alarms.
#define DEFAULT_WALL_OFFSET 28

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
	for (var/_tdir in cardinal) {                    \
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

#define HAS_ABOVE(z) (IS_VALID_ZINDEX(z) && SSatlas.z_levels & (1 << (z - 1)))
#define HAS_BELOW(z) (IS_VALID_ZINDEX(z) && (z) != 1 && SSatlas.z_levels & (1 << (z - 2)))

#define GET_ABOVE(A) (HAS_ABOVE(A:z) ? get_step(A, UP) : null)
#define GET_BELOW(A) (HAS_BELOW(A:z) ? get_step(A, DOWN) : null)

#define NULL_OR_EQUAL(self,other) (!(self) || (self) == (other))

//Lying animation
#define ANIM_LYING_TIME 2
