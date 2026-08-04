#define MAX_NTNET_ADDRESS_LEN 19
#define COMMUNICATOR_MAX_TEXT_LENGTH 512

/// Matches the "High" option in the client's Set View Zoom verb.
#define COMMUNICATOR_VIDEO_ZOOM 10

/// Voice calls and text messages only.
#define COMMUNICATOR_TIER_BASIC 1
/// Adds a short-range camera feed of the other end of a call.
#define COMMUNICATOR_TIER_VIDEO 2
/// Adds two-way holographic projection to video calls.
#define COMMUNICATOR_TIER_HOLOGRAPHIC 3

/// Preferred and maximum total horizontal spread for holograms sharing one tile.
#define COMMUNICATOR_HOLOGRAM_SLOT_SPACING 10
#define COMMUNICATOR_HOLOGRAM_MAX_SPREAD 24

#define INCOMING_REQUESTS "incoming"
#define OUTGOING_REQUESTS "outgoing"

#define CALL_REQUESTS "call"
#define FRIEND_REQUESTS "friend"

// Mirror of the `CommunicatorTab` enum in '../Communicator/types.ts'.
#define COMM_HOME_TAB 0
#define COMM_PHONE_TAB 1
#define COMM_CONTACTS_TAB 2
#define COMM_MESSAGING_TAB 3
#define COMM_SETTINGS_TAB 4
#define COMM_CALL_TAB 5
