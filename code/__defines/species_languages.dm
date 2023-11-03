// Species flags.
#define NO_BLOOD            BITFLAG(1)    // Vessel var is not filled with blood, cannot bleed out.
#define NO_BREATHE          BITFLAG(2)    // Cannot suffocate or take oxygen loss.
#define NO_SCAN             BITFLAG(3)    // Cannot be scanned in a DNA machine/genome-stolen.
#define NO_PAIN             BITFLAG(4)    // Cannot suffer halloss/receives deceptive health indicator.
#define NO_SLIP             BITFLAG(5)    // Cannot fall over.
#define NO_POISON           BITFLAG(6)    // Cannot not suffer toxloss.
#define IS_PLANT            BITFLAG(7)    // Is a treeperson.
#define NO_EMBED            BITFLAG(8)    // Can not have shrapnel or any object embedded into its body
#define IS_MECHANICAL       BITFLAG(9)    // Is a robot.
#define ACCEPTS_COOLER      BITFLAG(10)    // Can wear suit coolers and have them work without a suit.
#define NO_CHUBBY           BITFLAG(11)   // Cannot be visibly fat from nutrition type.
#define NO_ARTERIES         BITFLAG(12)   // This species does not have arteries.
#define PHORON_IMMUNE       BITFLAG(13)   // species doesn't suffer the negative effects of phoron contamination
#define CAN_SWEAT           BITFLAG(14)   // Forgive me.
#define NO_COLD_SLOWDOWN	BITFLAG(15)		//Doesn't slow down in the cold.
// unused: 0x8000(32768) - higher than this will overflow

// Base flags for IPCs.
#define IS_IPC (NO_BREATHE|NO_SCAN|NO_BLOOD|NO_PAIN|NO_POISON|IS_MECHANICAL|NO_CHUBBY|PHORON_IMMUNE|NO_COLD_SLOWDOWN)

// Species spawn flags
#define IS_WHITELISTED    0x1    // Must be whitelisted to play.
#define CAN_JOIN          0x2    // Species is selectable in chargen.
#define IS_RESTRICTED     0x4    // Is not a core/normally playable species. (castes, mutantraces)
#define NO_AGE_MINIMUM    0x8    // Doesn't respect minimum job age requirements.

// Species appearance flags
#define HAS_SKIN_TONE     0x1    // Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_COLOR    0x2    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          0x4    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     0x8    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR     0x10   // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR    0x20   // Hair colour selectable in chargen. (RGB)
#define HAS_SOCKS         0x40   // If this species can wear socks
#define HAS_FBP           0x80   // If for whatever ungodly reason we decide to ever have non-Shell FBPs.
#define HAS_SKIN_PRESET   0x100  // Skin color presets selectable in character generation.

// Innate Languages
#define LANGUAGE_NOISE "Noise" // Used for audible emotes.
#define LANGUAGE_TCB "Ceti Basic"

// Species Languages
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_ELYRAN_STANDARD "Elyran Standard"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_SIIK_MAAS "Siik'maas"
#define LANGUAGE_SIIK_TAJR "Siik'tajr"
#define LANGUAGE_SIGN_TAJARA "Nal'rasan"
#define LANGUAGE_YA_SSA "Ya'ssa"
#define LANGUAGE_DELVAHII "Delvahhi"
#define LANGUAGE_SKRELLIAN "Nral'Malic"
#define LANGUAGE_ROOTSONG "Rootsong"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Freespeak"
#define LANGUAGE_VAURCA "Hivenet"
#define LANGUAGE_AZAZIBA "Sinta'azaziba"
#define LANGUAGE_SIGN "Sign Language"

// Antag Languages
#define LANGUAGE_CHANGELING "Changeling"
#define LANGUAGE_BORER "Cortical Link"
#define LANGUAGE_BORER_HIVEMIND "Cortical Hivemind"
#define LANGUAGE_CULT "Cult"		// NOT CULTISTS!
#define LANGUAGE_OCCULT "Occult"
#define LANGUAGE_REVENANT "Revenant"
#define LANGUAGE_REVENANT_RIFTSPEAK "Riftspeak"
#define LANGUAGE_TERMINATOR "Hephaestus Darkcomms"	// HKs.
#define LANGUAGE_LIIDRA "Lii'draic Hivemind" //Lii'dra

// Lesser-form Languages
#define LANGUAGE_GIBBERING "Gibbering"			// alberyk
#define LANGUAGE_CHIMPANZEE "Chimpanzee"	// human
#define LANGUAGE_NEAERA "Neaera"			// skrell
#define LANGUAGE_STOK "Stok"				// unathi
#define LANGUAGE_FARWA "Farwa"				// tajara
#define LANGUAGE_BUG "V'krexi"				// vaurca

// Synth Languages
#define LANGUAGE_ROBOT "Robot Talk"
#define LANGUAGE_LOCAL_DRONE "Drone Transmission"
#define LANGUAGE_DRONE "Matrix Weave"
#define LANGUAGE_EAL "Encoded Audio Language"

// Language flags.
#define WHITELISTED   BITFLAG(0)  // Language is available if the speaker is whitelisted.
#define RESTRICTED    BITFLAG(1)  // Language can only be acquired by spawning or an admin.
#define NONVERBAL     BITFLAG(2)  // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG      BITFLAG(3)  // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND      BITFLAG(4)  // Broadcast to all mobs with this language.
#define NONGLOBAL     BITFLAG(5)  // Do not add to general languages list.
#define INNATE        BITFLAG(6)  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG   BITFLAG(7)  // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER    BITFLAG(8)  // No stuttering, slurring, or other speech problems
#define TCOMSSIM      BITFLAG(9)  // Can be synthesized in tcoms
#define KNOWONLYHEAR  BITFLAG(10) // Only people who know the language actually hears it
#define PRESSUREPROOF BITFLAG(11) // Pressure doesn't affect hearing
#define PASSLISTENOBJ BITFLAG(12) // Listening Objs can't hear this language

// Autohiss
#define AUTOHISS_OFF 0
#define AUTOHISS_BASIC 1
#define AUTOHISS_FULL 2

#define AUTOHISS_NUM 3

// Representative missions levels
#define REPRESENTATIVE_MISSION_LOW 1
#define REPRESENTATIVE_MISSION_MEDIUM 2
#define REPRESENTATIVE_MISSION_HIGH 3
