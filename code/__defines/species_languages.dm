// Species flags.
#define NO_BLOOD          0x1    // Vessel var is not filled with blood, cannot bleed out.
#define NO_BREATHE        0x2    // Cannot suffocate or take oxygen loss.
#define NO_SCAN           0x4    // Cannot be scanned in a DNA machine/genome-stolen.
#define NO_PAIN           0x8    // Cannot suffer halloss/recieves deceptive health indicator.
#define NO_SLIP           0x10   // Cannot fall over.
#define NO_POISON         0x20   // Cannot not suffer toxloss.
#define IS_PLANT          0x40   // Is a treeperson.
#define NO_EMBED          0x80   // Can not have shrapnel or any object embedded into its body
// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define IS_WHITELISTED    0x1    // Must be whitelisted to play.
#define CAN_JOIN          0x2    // Species is selectable in chargen.
#define IS_RESTRICTED     0x4    // Is not a core/normally playable species. (castes, mutantraces)

// Species appearance flags
#define HAS_SKIN_TONE     0x1    // Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_COLOR    0x2    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          0x4    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     0x8    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR     0x10   // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR    0x20   // Hair colour selectable in chargen. (RGB)
#define HAS_SOCKS         0x40   // If this species can wear socks
#define HAS_FBP           0x80   // If for whatever ungodly reason we decide to ever have non-Shell FBPs.

// Tau-Ceti basic, language common to all crew.
#define LANGUAGE_TCB "Ceti Basic"

// Species languages
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_SIIK_MAAS "Siik'maas"
#define LANGUAGE_SIIK_TAJR "Siik'tajr"
#define LANGUAGE_SIGN_TAJARA "Nal'rasan"
#define LANGUAGE_YA_SSA "Ya'ssa"
#define LANGUAGE_SKRELLIAN "Nral'Malic"
#define LANGUAGE_RESOMI "Resomi"
#define LANGUAGE_ROOTSONG "Rootsong"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Freespeak"
#define LANGUAGE_VAURCA "Hivenet"
#define LANGUAGE_AZAZIBA "Sinta'azaziba"
#define LANGUAGE_SIGN "Sign Language"

// Antag Languages
#define LANGUAGE_XENOMORPH "Xenomorph"
#define LANGUAGE_HIVEMIND "Hivemind"	// xeno hivemind
#define LANGUAGE_VOX "Vox-pidgin"
#define LANGUAGE_CHANGELING "Changeling"
#define LANGUAGE_BORER "Cortical Link"
#define LANGUAGE_CULT "Cult"		// NOT CULTISTS!
#define LANGUAGE_OCCULT "Occult"
#define LANGUAGE_TERMINATOR "Hephaestus Darkcomms"	// HKs.

// Lesser-form Languages
#define LANGUAGE_CHIMPANZEE "Chimpanzee"	// human
#define LANGUAGE_NEAERA "Neaera"			// skrell
#define LANGUAGE_STOK "Stok"				// unathi
#define LANGUAGE_FARWA "Farwa"				// tajara
#define LANGUAGE_BUG "V'krexi"				// vaurca

// Synth Languages
#define LANGUAGE_ROBOT "Robot Talk"
#define LANGUAGE_DRONE "Drone Talk"
#define LANGUAGE_EAL "Encoded Audio Language"

// Language flags.
#define WHITELISTED  1   // Language is available if the speaker is whitelisted.
#define RESTRICTED   2   // Language can only be acquired by spawning or an admin.
#define NONVERBAL    4   // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG     8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     16  // Broadcast to all mobs with this language.
#define NONGLOBAL    32  // Do not add to general languages list.
#define INNATE       64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   256 // No stuttering, slurring, or other speech problems
