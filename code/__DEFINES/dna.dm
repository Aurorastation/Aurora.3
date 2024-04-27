// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

// Generic mutations:
#define COLD_RESISTANCE BITFLAG(0)
#define XRAY            BITFLAG(1)
#define HULK            BITFLAG(2)
#define CLUMSY          BITFLAG(3)
#define FAT             BITFLAG(4)
#define HUSK            BITFLAG(5)
#define NOCLONE         BITFLAG(6)
#define LASER_EYES      BITFLAG(7)  // Harm intent - click anywhere to shoot lasers from eyes.
#define SKELETON        BITFLAG(8)

// Other Mutations:
#define mNobreath       BITFLAG(9) // No need to breathe.
#define mRemote         BITFLAG(10) // Remote viewing.
#define mRegen          BITFLAG(11) // Health regeneration.
#define mRun            BITFLAG(12) // No slowdown.
#define mRemotetalk     BITFLAG(13) // Remote talking.
#define mMorph          BITFLAG(14) // Hanging appearance.
#define mHallucination  BITFLAG(15) // Hallucinations.
#define mFingerprints   BITFLAG(16) // No fingerprints.
#define mShock          BITFLAG(17) // Insulated hands.
#define mSmallsize      BITFLAG(18) // Table climbing.

// disabilities
#define NEARSIGHTED 	1
#define EPILEPSY    	2
#define COUGHING    	4
#define STUTTERING  	8
#define DUMB            16
#define PACIFIST        32
#define ASTHMA 			64

// sdisabilities
#define BLIND 0x1
#define MUTE  0x2
#define DEAF  0x4

#define DNA_BLOCK_SIZE 3

// Buffer datatype flags.
#define DNA2_BUF_UI 1
#define DNA2_BUF_UE 2
#define DNA2_BUF_SE 4

// The way blocks are handled badly needs a rewrite, this is horrible.
// Too much of a project to handle at the moment, TODO for later.
var/BLINDBLOCK    = 0
var/DEAFBLOCK     = 0
var/HULKBLOCK     = 0
var/TELEBLOCK     = 0
var/FIREBLOCK     = 0
var/XRAYBLOCK     = 0
var/CLUMSYBLOCK   = 0
var/FAKEBLOCK     = 0
var/COUGHBLOCK    = 0
var/GLASSESBLOCK  = 0
var/EPILEPSYBLOCK = 0
var/TWITCHBLOCK   = 0
var/STUTTERBLOCK  = 0
var/MONKEYBLOCK   = STRUCDNASIZE

var/BLOCKADD = 0
var/DIFFMUT  = 0

var/HEADACHEBLOCK      = 0
var/NOBREATHBLOCK      = 0
var/REMOTEVIEWBLOCK    = 0
var/REGENERATEBLOCK    = 0
var/INCREASERUNBLOCK   = 0
var/REMOTETALKBLOCK    = 0
var/MORPHBLOCK         = 0
var/BLENDBLOCK         = 0
var/HALLUCINATIONBLOCK = 0
var/NOPRINTSBLOCK      = 0
var/SHOCKIMMUNITYBLOCK = 0
var/SMALLSIZEBLOCK     = 0
