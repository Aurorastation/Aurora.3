// Consider these images/atoms as part of the UI/HUD (apart of the appearance_flags)
/// Used for progress bars and chat messages
#define APPEARANCE_UI_IGNORE_ALPHA (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA|PIXEL_SCALE)
/// Used for HUD objects
#define APPEARANCE_UI (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE)

// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list
// note: if you add more HUDs, even for non-human atoms, make sure to use unique numbers for the defines!
// /datum/atom_hud expects these to be unique
// these need to be strings in order to make them associative lists

/// A simple line reading the pulse.
#define HEALTH_HUD "1"
/// Alive, dead, diseased, etc.
#define STATUS_HUD "2"
/// The job asigned to your ID.
#define ID_HUD "3"
/// Wanted, released, paroled, security status.
#define WANTED_HUD "4"
/// Loyality implant.
#define IMPLOYAL_HUD "5"
/// Chemical implant.
#define IMPCHEM_HUD "6"
/// Tracking implant.
#define IMPTRACK_HUD "7"
//for antag huds. these are used at the /mob level
#define ANTAG_HUD "8" // used to be SPECIALROLE_HUD

#define STATUS_HUD_OOC		"9" // STATUS_HUD without virus DB check for someone being ill.

#define TRIAGE_HUD	"10" //a HUD that creates a bar above the user showing their medical status

//by default everything in the hud_list of an atom is an image
//a value in hud_list with one of these will change that behavior
#define HUD_LIST_LIST 1

//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_SECURITY_BASIC 1
#define DATA_HUD_SECURITY_ADVANCED 2
#define DATA_HUD_MEDICAL_BASIC 3
#define DATA_HUD_MEDICAL_ADVANCED 4
#define DATA_HUD_ANTAG 5

/// cooldown for being shown the images for any particular data hud
#define ADD_HUD_TO_COOLDOWN 20
