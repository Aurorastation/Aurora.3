// /mob/var/stat things.
#define CONSCIOUS   0
#define UNCONSCIOUS 1
#define DEAD        2

// Bitflags defining which status effects could be or are inflicted on a mob.
#define CANSTUN     0x1
#define CANWEAKEN   0x2
#define CANPARALYSE 0x4
#define CANPUSH     0x8
#define LEAPING     0x10
#define PASSEMOTES  0x20    // Mob has a cortical borer or holders inside of it that need to see emotes.
#define NOFALL      0x800
#define GODMODE     0x1000
#define FAKEDEATH   0x2000  // Replaces stuff like changeling.changeling_fakedeath.
#define DISFIGURED  0x4000  // Set but never checked. Remove this sometime and replace occurences with the appropriate organ code
#define XENO_HOST   0x8000  // Tracks whether we're gonna be a baby alien's mummy.
#define NO_ANTAG    0x10000  // Players are restricted from gaining antag roles when occupying this mob

// Incorporeal movement
#define INCORPOREAL_DISABLE 0 // Disabled
#define INCORPOREAL_GHOST   1 // Pass through matter like a ghost
#define INCORPOREAL_NINJA   2 // Pass through matter with a cool effect
#define INCORPOREAL_BSTECH  3 // Like ninja, but also go across Z-levels and move in space freely
#define INCORPOREAL_SHADE   4 // Shady
#define INCORPOREAL_MECH    5 // stripped down bstech

#define MOB_GRAB_NORMAL 1
#define MOB_GRAB_FIREMAN 2

// Grab levels.
#define GRAB_PASSIVE    1
#define GRAB_AGGRESSIVE 2
#define GRAB_NECK       3
#define GRAB_UPGRADING  4
#define GRAB_KILL       5

#define BORGMESON 0x1
#define BORGTHERM 0x2
#define BORGXRAY  0x4
#define BORGMATERIAL  8

#define HOSTILE_STANCE_IDLE      1
#define HOSTILE_STANCE_ALERT     2
#define HOSTILE_STANCE_ATTACK    3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED     5

#define ON_ATTACK_COOLDOWN(hostile_mob) world.time < hostile_mob.hostile_time_between_attacks + hostile_mob.hostile_last_attack

#define LEFT  1
#define RIGHT 2

#define FIST_ATTACK_ANIMATION -1

// Pulse levels, very simplified.
#define PULSE_NONE    0 // So !M.pulse checks would be possible.
#define PULSE_SLOW    1 // <60     bpm
#define PULSE_NORM    2 //  60-90  bpm
#define PULSE_FAST    3 //  90-120 bpm
#define PULSE_2FAST   4 // >120    bpm
#define PULSE_THREADY 5 // Occurs during hypovolemic shock
#define GETPULSE_HAND 0 // Less accurate. (hand)
#define GETPULSE_TOOL 1 // More accurate. (med scanner, sleeper, etc.)
#define PULSE_MAX_BPM 250 // Highest, readable BPM by machines and humans.

// Blood pressure levels, simplified
#define HIGH_BP_MOD 20
#define PRE_HIGH_BP_MOD 5
#define BP_SYS_IDEAL_MOD 40
#define BP_DIS_IDEAL_MOD 20

#define BLOOD_PRESSURE_HIGH     4
#define BLOOD_PRESSURE_PRE_HIGH 3
#define BLOOD_PRESSURE_IDEAL    2
#define BLOOD_PRESSURE_LOW      1

// total_radiation levels (Note that total_radiation can be above RADS_MAX until handle_mutations_and_radiation() runs)
#define RADS_NONE 0
#define RADS_LOW 1
#define RADS_MED 50
#define RADS_HIGH 75
#define RADS_MAX 100

//intent flags, why wasn't this done the first time?
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HURT		"harm"

//movement intents
#define M_WALK "walk"
#define M_RUN  "run"

// Limbs and robotic stuff.
#define BP_L_FOOT "l_foot"
#define BP_R_FOOT "r_foot"
#define BP_L_LEG  "l_leg"
#define BP_R_LEG  "r_leg"
#define BP_L_HAND "l_hand"
#define BP_R_HAND "r_hand"
#define BP_L_ARM  "l_arm"
#define BP_R_ARM  "r_arm"
#define BP_HEAD   "head"
#define BP_CHEST  "chest"
#define BP_GROIN  "groin"
#define BP_ALL_LIMBS list(BP_CHEST, BP_GROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
#define BP_IS_ROBOTIC(org)  (org.status & ORGAN_ROBOT)

#define ROBOTIC_NONE       0
#define ROBOTIC_ASSISTED   1
#define ROBOTIC_MECHANICAL 2

//Generic organs
#define BP_MOUTH    "mouth"
#define BP_EYES     "eyes"
#define BP_HEART    "heart"
#define BP_LUNGS    "lungs"
#define BP_BRAIN    "brain"
#define BP_LIVER    "liver"
#define BP_KIDNEYS  "kidneys"
#define BP_STOMACH  "stomach"
#define BP_APPENDIX "appendix"

//Vaurca organs
#define BP_NEURAL_SOCKET "neural socket"
#define BP_PHORON_RESERVE "phoron reserve tank"
#define BP_FILTRATION_BIT "filtration bit"
#define BP_PHORON_RESERVOIR "phoron reservoir"
#define BP_VAURCA_LIVER "mechanical liver"
#define BP_VAURCA_KIDNEYS "mechanical kidneys"

//Aut'akh organs
#define BP_ANCHOR   "anchor"
#define BP_HAEMO    "haemodynamic"
#define BP_ADRENAL  "adrenal"

//IPC organs
#define BP_CELL     "cell"
#define BP_OPTICS   "optics"
#define BP_IPCTAG   "ipc tag"

// Parasite organs
#define BP_ZOMBIE_PARASITE "black tumour"
#define BP_WORM_HEART "heart fluke"
#define BP_WORM_NERVE "nerve fluke"

//Augment organs
#define BP_AUG_TIMEPIECE    "integrated timepiece"
#define BP_AUG_TOOL         "retractable combitool"
#define BP_AUG_PEN          "retractable combipen"
#define BP_AUG_CRAYON         "retractable crayon"
#define BP_AUG_CYBORG_ANALYZER    "retractable cyborg analyzer"
#define BP_AUG_LIGHTER      "retractable lighter"
#define BP_AUG_HEALTHSCAN   "integrated health scanner"
#define BP_AUG_DRILL        "integrated mining drill"
#define BP_AUG_GUSTATORIAL   "integrated gustatorial centre"
#define BP_AUG_TESLA        "tesla spine"
#define BP_AUG_EYE_SENSORS  "integrated eyes sensors"
#define BP_AUG_HAIR         "synthetic hair extensions"
#define BP_AUG_CORDS           "synthetic vocal cords"
#define BP_AUG_COCHLEAR        "cochlear implant"
#define BP_AUG_SUSPENSION      "calf suspension"
#define BP_AUG_TASTE_BOOSTER   "taste booster"
#define BP_AUG_RADIO           "integrated radio"
#define BP_AUG_FUEL_CELL       "integrated fuel cell"
#define BP_AUG_AIR_ANALYZER    "integrated air analyzer"
#define BP_AUG_LANGUAGE        "integrated language processor"
#define BP_AUG_PSI             "psionic receiver"
#define BP_AUG_CALF_OVERRIDE   "calf overdrive"
#define BP_AUG_MEMORY          "memory inhibitor"
#define BP_AUG_EMOTION         "emotional manipulator"
#define BP_AUG_ENCHANED_VISION "vision enhanced retinas"
#define BP_AUG_SIGHTLIGHTS     "ocular installed sightlights"
#define BP_AUG_CORRECTIVE_LENS "corrective lenses"
#define BP_AUG_GLARE_DAMPENER "glare dampeners"
#define BP_AUG_ACC_CORDS       "modified synthetic vocal cords"

//Organ defines
#define PROCESS_ACCURACY 10
#define DEFAULT_BLOOD_AMOUNT 560 //Default blood amount in units

//These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
#define HUMAN 1
#define MONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

//Types of diona, returned by is_diona
#define DIONA_NYMPH		1
#define DIONA_WORKER	2

// Robot AI notifications
#define ROBOT_NOTIFICATION_NEW_UNIT 1
#define ROBOT_NOTIFICATION_NEW_NAME 2
#define ROBOT_NOTIFICATION_NEW_MODULE 3
#define ROBOT_NOTIFICATION_MODULE_RESET 4

// Appearance change flags
#define APPEARANCE_UPDATE_DNA				1
#define APPEARANCE_RACE						(2|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_GENDER					(4|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_SKIN						8
#define APPEARANCE_HAIR						16
#define APPEARANCE_HAIR_COLOR				32
#define APPEARANCE_FACIAL_HAIR 				64
#define APPEARANCE_FACIAL_HAIR_COLOR 		128
#define APPEARANCE_EYE_COLOR 				256
#define APPEARANCE_CULTURE					512
#define APPEARANCE_LANGUAGE					1024
#define APPEARANCE_ALL						65535
#define APPEARANCE_ALL_HAIR					(APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_PLASTICSURGERY 			(APPEARANCE_ALL & ~APPEARANCE_RACE)

// Click cooldown
#define DEFAULT_ATTACK_COOLDOWN 8 //Default timeout for aggressive actions
#define DEFAULT_QUICK_COOLDOWN  4


#define MIN_SUPPLIED_LAW_NUMBER 15
#define MAX_SUPPLIED_LAW_NUMBER 50

//default item on-mob icons
#define INV_HEAD_DEF_ICON			'icons/mob/head.dmi'
#define INV_BACK_DEF_ICON			'icons/mob/back.dmi'
#define INV_L_HAND_DEF_ICON			'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON			'icons/mob/items/righthand.dmi'
#define INV_W_UNIFORM_DEF_ICON		'icons/mob/uniform.dmi'
#define INV_ACCESSORIES_DEF_ICON	'icons/mob/ties.dmi'
#define INV_BELT_DEF_ICON 'icons/mob/belt.dmi'
#define INV_SUIT_DEF_ICON			'icons/mob/suit.dmi'
#define INV_L_EAR_DEF_ICON			'icons/mob/l_ear.dmi'
#define INV_R_EAR_DEF_ICON			'icons/mob/r_ear.dmi'
#define INV_SHOES_DEF_ICON			'icons/mob/feet.dmi'
#define INV_WRISTS_DEF_ICON			'icons/mob/wrist.dmi'

// IPC tags
#define IPC_OWNERSHIP_SELF	  "Self Owned"
#define IPC_OWNERSHIP_COMPANY "Company Owned"
#define IPC_OWNERSHIP_PRIVATE "Privately Owned"

// How wealthy/poor a character is
#define ECONOMICALLY_WEALTHY	"Wealthy"
#define ECONOMICALLY_WELLOFF	"Well-off"
#define ECONOMICALLY_AVERAGE	"Average"
#define ECONOMICALLY_UNDERPAID	"Underpaid"
#define ECONOMICALLY_POOR		"Poor"
#define ECONOMICALLY_DESTITUTE  "Impoverished"

#define ECONOMIC_POSITIONS		list(ECONOMICALLY_WEALTHY, ECONOMICALLY_WELLOFF, ECONOMICALLY_AVERAGE, ECONOMICALLY_UNDERPAID, ECONOMICALLY_POOR, ECONOMICALLY_DESTITUTE)

// Defines the argument used for get_mobs_or_objs_in_view
#define GHOSTS_ALL_HEAR 1
#define ONLY_GHOSTS_IN_VIEW 0

// Handle speech problems defines
#define HSP_MSG 		"message"
#define HSP_VERB 		"verb"
#define HSP_MSGMODE 	"message mode"
#define HSP_MSGRANGE 	"message range"

// Defines mob sizes, used by lockers and to determine what is considered a small sized mob, etc.
#define MOB_LARGE  		16
#define MOB_MEDIUM 		9
#define MOB_SMALL 		6
#define MOB_TINY 		4
#define MOB_MINISCULE	1

#define BASE_MAX_NUTRITION	600
#define HUNGER_FACTOR		0.04 // Factor of how fast mob nutrition decreases over time.

#define BASE_MAX_HYDRATION  800
#define THIRST_FACTOR       0.02 // Factor of how fast mob hydration decreases over time.

#define CREW_MINIMUM_HYDRATION CREW_HYDRATION_HYDRATED	// The minimum amount of nutrition a crewmember will spawn with, represented as a percentage
#define CREW_MAXIMUM_HYDRATION CREW_HYDRATION_OVERHYDRATED	// Same as above, but maximum.

#define CREW_MINIMUM_NUTRITION CREW_NUTRITION_FULL	// The minimum amount of nutrition a crewmember will spawn with, represented as a percentage.
#define CREW_MAXIMUM_NUTRITION CREW_NUTRITION_OVEREATEN	// Same as above, but maximum.

//Note that all of this is relative to nutrition/max nutrition
#define CREW_NUTRITION_OVEREATEN 0.8
#define CREW_NUTRITION_FULL 0.4
#define CREW_NUTRITION_SLIGHTLYHUNGRY 0.3
#define CREW_NUTRITION_HUNGRY 0.2
#define CREW_NUTRITION_VERYHUNGRY 0.1
#define CREW_NUTRITION_STARVING 0

//Note that all of this is relative to hydration/max hydration
#define CREW_HYDRATION_OVERHYDRATED 1.01 //Overhydration can't occur.
#define CREW_HYDRATION_HYDRATED 0.4
#define CREW_HYDRATION_SLIGHTLYTHIRSTY 0.3
#define CREW_HYDRATION_THIRSTY 0.2
#define CREW_HYDRATION_VERYTHIRSTY 0.1
#define CREW_HYDRATION_DEHYDRATED 0

#define TINT_NONE 0
#define TINT_MODERATE 1
#define TINT_HEAVY 2
#define TINT_BLIND 3

#define FLASH_PROTECTION_REDUCED -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_MODERATE 1
#define FLASH_PROTECTION_MAJOR 2

#define EAR_PROTECTION_REDUCED -1
#define EAR_PROTECTION_NONE		0
#define EAR_PROTECTION_MODERATE 1
#define EAR_PROTECTION_MAJOR	2

#define ANIMAL_SPAWN_DELAY round(config.respawn_delay / 6)
#define DRONE_SPAWN_DELAY  round(config.respawn_delay / 3)

// Gluttony levels.
#define GLUT_TINY 1       // Eat anything tiny and smaller
#define GLUT_SMALLER 2    // Eat anything smaller than we are
#define GLUT_ANYTHING 4   // Eat anything, ever
#define GLUT_MESSY 8      // Only eat mobs, and eat them in chunks.

#define GLUT_ITEM_TINY 16         // Eat items with a w_class of small or smaller
#define GLUT_ITEM_NORMAL 32      // Eat items with a w_class of normal or smaller
#define GLUT_ITEM_ANYTHING 64    // Eat any item
#define GLUT_PROJECTILE_VOMIT 128 // When vomitting, does it fly out?


// Devour speeds, returned by can_devour()
#define DEVOUR_SLOW 1
#define DEVOUR_FAST 2

// Incapacitation flags, used by the mob/proc/incapacitated() proc
#define INCAPACITATION_NONE 0
#define INCAPACITATION_RESTRAINED 1
#define INCAPACITATION_BUCKLED_PARTIALLY 2
#define INCAPACITATION_BUCKLED_FULLY 4
#define INCAPACITATION_STUNNED 8
#define INCAPACITATION_FORCELYING 16
#define INCAPACITATION_KNOCKOUT 32

#define INCAPACITATION_KNOCKDOWN (INCAPACITATION_KNOCKOUT|INCAPACITATION_FORCELYING)
#define INCAPACITATION_DISABLED (INCAPACITATION_KNOCKDOWN|INCAPACITATION_STUNNED)
#define INCAPACITATION_DEFAULT (INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_DISABLED)
#define INCAPACITATION_ALL (~INCAPACITATION_NONE)

#define MOB_PULL_NONE 0
#define MOB_PULL_SMALLER 1
#define MOB_PULL_SAME 2
#define MOB_PULL_LARGER 3

//Time of Death constants
//Used with a list in preference datums to track times of death
#define CREW "crew" //Used for crewmembers, AI, cyborgs, nymphs, antags
#define ANIMAL "animal" //Used for rats and any other simple animals
#define MINISYNTH "minisynth"//Used for drones and pAIs

#define RESPAWN_ANIMAL 3000
#define RESPAWN_MINISYNTH 6000

// Flags for the eat_types variable, a bitfield of what can or can't be eaten
// Note that any given mob can be more than one type
#define TYPE_ORGANIC      1	// Almost any creature under /mob/living/carbon and most simple animals
#define TYPE_SYNTHETIC    2	// Everything under /mob/living/silicon, plus IPCs, viscerators
#define TYPE_HUMANOID     4	// Humans, skrell, unathi, tajara, vaurca, diona, IPC
#define TYPE_WEIRD        8	// Slimes, constructs, demons, and other creatures of a magical or bluespace nature.
#define TYPE_INCORPOREAL 16 // Mobs that don't really have any physical form to them.

// Maximum number of chickens allowed at once.
// If the number of chickens on the map exceeds this, laid eggs will not hatch.
#define MAX_CHICKENS 50

//carbon taste sensitivity defines, used in mob/living/carbon/proc/ingest
#define TASTE_HYPERSENSITIVE 3 //anything below 5%
#define TASTE_SENSITIVE 2 //anything below 7%
#define TASTE_NORMAL 1 //anything below 15%
#define TASTE_DULL 0.5 //anything below 30%
#define TASTE_NUMB 0.1 //anything below 150%

//ear healing limit - past this ear_damage your ear will not recover its hearing over time
#define HEARING_DAMAGE_LIMIT 100
#define HEARING_DAMAGE_SLOW_HEAL 25

// Used by hearing sensitivity
#define HEARING_NORMAL 0
#define HEARING_SENSITIVE 1
#define HEARING_VERY_SENSITIVE 2

#define MACHINE_SOUND "You hear the sound of machinery"
#define BUTTON_FLICK "You hear a click"
#define THUNK_SOUND "You hear a THUNK"
#define PING_SOUND "You hear a ping"

//Used by emotes
#define VISIBLE_MESSAGE 1
#define AUDIBLE_MESSAGE 2

//helper for inverting armor blocked values into a multiplier
#define BLOCKED_MULT(blocked) max(1 - (blocked/100), 0)

// Prosthetic organ defines.
#define PROSTHETIC_IPC "Hephaestus Integrated Limb"
#define PROSTHETIC_HK "Hephaestus Vulcanite Limb"
#define PROSTHETIC_IND "Hephaestus Industrial Limb"
#define PROSTHETIC_SYNTHSKIN "Human Synthskin"
#define PROSTHETIC_BC "Bishop Cybernetics"
#define PROSTHETIC_ZH "Zeng-Hu Pharmaceuticals"
#define PROSTHETIC_HI "Hephaestus Industries"
#define PROSTHETIC_XMG "Xion Manufacturing Group"
#define PROSTHETIC_DIONA "Unknown Model"
#define PROSTHETIC_AUTAKH "Aut'akh Manufactured"
#define PROSTHETIC_TESLA "Tesla Powered Prosthetics"
#define PROSTHETIC_TESLA_BODY "Industrial Tesla Powered Prosthetics"
#define PROSTHETIC_VAURCA "Vaurca Robotic Limb"

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 10
#define BRAIN_DAMAGE_SEVERE 40

#define CURE_CRYSTAL "crystal"
#define CURE_SOLITUDE "solitude"
#define CURE_HYPNOSIS "hypnosis"
#define CURE_SURGERY "surgery"
#define CURE_ADMIN "all"

// triage tags
#define TRIAGE_NONE "None"
#define TRIAGE_GREEN "Green"
#define TRIAGE_YELLOW "Yellow"
#define TRIAGE_RED "Red"
#define TRIAGE_BLACK "Black"

// Surgery Stuff
#define SURGERY_SUCCESS 2 // Proceed with surgery
#define SURGERY_FAIL 1 // Autofail surgery
#define SURGERY_IGNORE 0 // Ignore surgery completely and just attack

#define STASIS_MISC     "misc"
#define STASIS_CRYOBAG  "cryobag"
#define STASIS_COLD     "cold"

#define AURA_CANCEL 1
#define AURA_FALSE  2
#define AURA_TYPE_BULLET "Bullet"
#define AURA_TYPE_WEAPON "Weapon"
#define AURA_TYPE_THROWN "Thrown"
#define AURA_TYPE_LIFE   "Life"

// Remote Control defines
#define REMOTE_GENERIC_MECH "remotemechs"
#define REMOTE_AI_MECH "aimechs"
#define REMOTE_PRISON_MECH "prisonmechs"

#define REMOTE_GENERIC_ROBOT "remoterobots"
#define REMOTE_BUNKER_ROBOT "bunkerrobots"
#define REMOTE_PRISON_ROBOT "prisonrobots"
#define REMOTE_WARDEN_ROBOT "wardenrobots"

#define REMOTE_AI_ROBOT "airobots"

// Robot Overlay Defines
#define ROBOT_PANEL_EXPOSED  "exposed"
#define ROBOT_PANEL_CELL     "cell"
#define ROBOT_PANEL_NO_CELL  "no cell"

#define ROBOT_ICON		"iconpath"
#define ROBOT_CHASSIS	"chassistype"
#define ROBOT_PANEL		"paneltype"
#define ROBOT_EYES		"eyetype"

#define BLOOD_REGEN_RATE 0.1

// Height Defines
#define HEIGHT_NOT_USED 0
#define HEIGHT_CLASS_TINY 130
#define HEIGHT_CLASS_SHORT 150
#define HEIGHT_CLASS_AVERAGE 170
#define HEIGHT_CLASS_TALL 190
#define HEIGHT_CLASS_HUGE 240
#define HEIGHT_CLASS_GIGANTIC 300
