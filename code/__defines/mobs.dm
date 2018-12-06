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
#define PASSEMOTES  0x32    // Mob has a cortical borer or holders inside of it that need to see emotes.
#define GODMODE     0x1000
#define FAKEDEATH   0x2000  // Replaces stuff like changeling.changeling_fakedeath.
#define DISFIGURED  0x4000  // Set but never checked. Remove this sometime and replace occurences with the appropriate organ code
#define XENO_HOST   0x8000  // Tracks whether we're gonna be a baby alien's mummy.

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

#define LEFT  1
#define RIGHT 2

// Pulse levels, very simplified.
#define PULSE_NONE    0 // So !M.pulse checks would be possible.
#define PULSE_SLOW    1 // <60     bpm
#define PULSE_NORM    2 //  60-90  bpm
#define PULSE_FAST    3 //  90-120 bpm
#define PULSE_2FAST   4 // >120    bpm
#define PULSE_THREADY 5 // Occurs during hypovolemic shock
#define GETPULSE_HAND 0 // Less accurate. (hand)
#define GETPULSE_TOOL 1 // More accurate. (med scanner, sleeper, etc.)

//intent flags, why wasn't this done the first time?
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HURT		"harm"

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
#define APPEARANCE_UPDATE_DNA  0x1
#define APPEARANCE_RACE       (0x2|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_GENDER     (0x4|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_SKIN        0x8
#define APPEARANCE_HAIR        0x10
#define APPEARANCE_HAIR_COLOR  0x20
#define APPEARANCE_FACIAL_HAIR 0x40
#define APPEARANCE_FACIAL_HAIR_COLOR 0x80
#define APPEARANCE_EYE_COLOR 0x100
#define APPEARANCE_ALL_HAIR (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_ALL       0xFFFF
#define APPEARANCE_PLASTICSURGERY (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR|APPEARANCE_GENDER) & ~APPEARANCE_RACE

// Click cooldown
#define DEFAULT_ATTACK_COOLDOWN 8 //Default timeout for aggressive actions
#define DEFAULT_QUICK_COOLDOWN  4


#define MIN_SUPPLIED_LAW_NUMBER 15
#define MAX_SUPPLIED_LAW_NUMBER 50

//default item on-mob icons
#define INV_HEAD_DEF_ICON 'icons/mob/head.dmi'
#define INV_BACK_DEF_ICON 'icons/mob/back.dmi'
#define INV_L_HAND_DEF_ICON 'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON 'icons/mob/items/righthand.dmi'
#define INV_W_UNIFORM_DEF_ICON 'icons/mob/uniform.dmi'
#define INV_ACCESSORIES_DEF_ICON 'icons/mob/ties.dmi'
#define INV_SUIT_DEF_ICON 'icons/mob/suit.dmi'

// NT's alignment towards the character
#define COMPANY_LOYAL 			"Loyal"
#define COMPANY_SUPPORTATIVE	"Supportive"
#define COMPANY_NEUTRAL 		"Neutral"
#define COMPANY_SKEPTICAL		"Skeptical"
#define COMPANY_OPPOSED			"Opposed"

#define COMPANY_ALIGNMENTS		list(COMPANY_LOYAL,COMPANY_SUPPORTATIVE,COMPANY_NEUTRAL,COMPANY_SKEPTICAL,COMPANY_OPPOSED)

// Defines the argument used for get_mobs_and_objs_in_view_fast
#define GHOSTS_ALL_HEAR 1
#define ONLY_GHOSTS_IN_VIEW 0

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

#define CREW_MINIMUM_HYDRATION CREW_HYDRATION_SLIGHTLYTHIRSTY	// The minimum amount of nutrition a crewmember will spawn with, represented as a percentage
#define CREW_MAXIMUM_HYDRATION CREW_HYDRATION_HYDRATED	// Same as above, but maximum.

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

#define ANIMAL_SPAWN_DELAY round(config.respawn_delay / 6)
#define DRONE_SPAWN_DELAY  round(config.respawn_delay / 3)

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
#define ANIMAL "animal" //Used for mice and any other simple animals
#define MINISYNTH "minisynth"//Used for drones and pAIs

#define RESPAWN_ANIMAL 3000
#define RESPAWN_MINISYNTH 6000

// Flags for the eat_types variable, a bitfield of what can or can't be eaten
// Note that any given mob can be more than one type
#define TYPE_ORGANIC      1	// Almost any creature under /mob/living/carbon and most simple animals
#define TYPE_SYNTHETIC    2	// Everything under /mob/living/silicon, plus IPCs, viscerators
#define TYPE_HUMANOID     4	// Humans, skrell, unathi, tajara, vaurca, diona, IPC, vox
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

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 10
#define BRAIN_DAMAGE_SEVERE 40

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special

#define CURE_CRYSTAL "crystal"
#define CURE_SOLITUDE "solitude"
#define CURE_HYPNOSIS "hypnosis"
#define CURE_SURGERY "surgery"
#define CURE_ADMIN "all"
