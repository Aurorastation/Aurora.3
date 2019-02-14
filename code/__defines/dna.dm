// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

// Generic mutations:
#define TK              1
#define COLD_RESISTANCE 2
#define XRAY            3
#define HULK            4
#define CLUMSY          5
#define FAT             6
#define HUSK            7
#define NOCLONE         8
#define LASER           9  // Harm intent - click anywhere to shoot lasers from eyes.
#define HEAL            10 // Healing people with hands.

#define SKELETON      29
#define PLANT         30

// Other Mutations:
#define mNobreath      100 // No need to breathe.
#define mRemote        101 // Remote viewing.
#define mRegen         102 // Health regeneration.
#define mRun           103 // No slowdown.
#define mRemotetalk    104 // Remote talking.
#define mMorph         105 // Hanging appearance.
#define mBlend         106 // Nothing. (seriously nothing)
#define mHallucination 107 // Hallucinations.
#define mFingerprints  108 // No fingerprints.
#define mShock         109 // Insulated hands.
#define mSmallsize     110 // Table climbing.

// disabilities
#define NEARSIGHTED 1
#define EPILEPSY    2
#define COUGHING    4
#define TOURETTES   8
#define STUTTER     16
#define DUMB            32
#define MONKEYLIKE      64 //sets IsAdvancedToolUser to FALSE
#define PACIFIST        128
#define UNINTELLIGIBLE  256
#define GERTIE 512
#define ASTHMA 1024

// sdisabilities
#define BLIND 0x1
#define MUTE  0x2
#define DEAF  0x4

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


// Hair Lengths

var/list/hairnone = list("Short Hair", "Short Hair 2", "Cut Hair", "Skinhead", "Balding Hair", "The Family Man", "Flaired Hair", "Crewcut", "Combover", "Overeye Short", "Overeye Very Short, Alternate", "Hime Cut", "Hime Cut Alt", "Short Hime Cut", "CIA", "Mulder", "Scully", "Wheeler", "Bangs Short", "Short Bangs", "Low Fade", "Balding Fade", "No Fade", "Trimmed Flat Top", "Shaved", "Trimmed", "Undercut", "High and Tight", "Thinning", "Thinning Front", "Thinning Back", "Flat Top", "Buzzcut")

var/list/hairsemisafe = list("Half-Shaved", "Half-Shaved Emo", "Long Side Emo", "Sideswept Hair", "Shaved Mohawk", "Tight Shaved Mohawk", "Naomi Mohawk", "Left Sidecut", "Right Sidecut", "Gentle 2", "Gentle 2 (Long)", "Gentle 2, Alternative", "Gentle 2, Alternative (Long)", "Neat", "Neat (Long)", "Donut Bun", "Shoulder Bob", "Messy", "Mohawk", "Drills, Side", "Low Bun", "Unkept", "Modern", "Bun", "Casual Bun", "Double-Bun", "Bangs", "Sleeze", "Medium Fade", "High Fade", "Tight Bun", "Coffee House Cut", "Bowl2", "Manbun", "Manbun", "Shaved Bun", "Librarian Bun", "Fade", "Krewcut", "Choppy (Short)", "Floof (Short)", "Sideshave", "Waxed", "Jenjen", "Fade (Grown)", "Swept", "Spiked")

var/list/hairsortasafe = list("Shoulder-length Hair", "Long Hair", "Long Hair Alt", "Very Long Hair", "Long Fringe", "Longer Fringe", "Ponytail 1", "Ponytail 2", "Ponytail 3", "Ponytail 4", "Ponytail 5", "Ponytail 6", "Ponytail 7", "Side Ponytail", "Side Ponytail 2", "One Shoulder", "Tress Shoulder", "Pompadour", "Beehive", "Beehive 2", "Curls", "Long Emo", "Emo Fringe", "Flow Hair", "Overeye Long", "Feather", "Hitop","Adam Jensen Hair", "Gelled Back", "Gentle", "Spiky", "Kusanagi Hair", "Pigtails", "Odango", "Ombre", "Updo", "Drillruru", "Nitori", "Joestar", "Volaju", "80's", "Emo", "Devil Lock", "Reverse Mohawk", "Bowl", "Chin Length Bob", "Bob", "Bobcurl", "Bedhead", "Bedhead 2", "Quiff", "Parted", "Fringetail", "Dandy Pompadour", "Poofy", "Wavy Shoulder (Down)", "Wavy Shoulder (Ponytail)", "Rows", "Rows 2", "Grande Braid", "Medium Braid" ,)


var/list/hairunsafe = list("Dreadlocks", "Afro", "Afro 2", "Big Afro", "Topknot", "Ronin", "Floorlength Braid", "Long Braid", "Long Braid 2", "Chrono", "Vegeta", "Nia", "Pomp III", "Superbowl", "Cactus")


var/list/skrelltentacles = list("Skrell Average Tentacles", "Skrell Very Short Tentacles", "Skrell Very Long Tentacles")


var/list/cathair = list("Tajaran Ears", "Tajara Clean", "Tajara Bangs", "Tajara Shaggy", "Tajaran Mohawk", "Tajara Plait", "Tajara Straight", "Tajara Long", "Tajara Rat Tail", "Tajara Spiky", "Tajara Messy", "Tajara Curly", "Tajara Housewife", "Tajara Victory Curls", "Tajara Bob", "Tajara Finger Curls", "Tajara Greaser")
