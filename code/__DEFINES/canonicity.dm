/// Nothing in the round is canon; such as in a non-canon event. Things are forgotten the next round.
#define ROUND_NON_CANON	 				0
/// Actions taken during this round are canon. Antagonist actions are not considered here; see below.
#define ROUND_FULL_CANON				1

/// Antagonist actions are not expected during this round.
#define ANTAGONIST_ACTIONS_NOT_EXPECTED 0
/// Antagonist actions are NOT canon during this round.
#define ANTAGONIST_ACTIONS_NOT_CANON	1
/// Antagonist actions are canon during this round.
#define ANTAGONIST_ACTIONS_CANON		2


/// Character deaths are automatically not-canon. Usually the case in non-canon events.
#define NO_CHARACTER_DEATH				0
/// If character deaths are limited, and thus can be retconned if all player parties agree.
#define LIMITED_CHARACTER_DEATH			1
/// If players are FORCED to keep character deaths canon. In this case, ALL CHARACTER DEATHS MUST GO THROUGH HEADMINS AND LOREMASTERS TO BE RETCONNED. THERE ARE NO EXCEPTIONS!
#define FORCED_CHARACTER_DEATH			2

/// Away sites are NOT canon in this round.
#define AWAY_SITE_NOT_CANON				0
/// It's canon that you went to an away site, but the exact details are not (to prevent everyone from knowing the exact layout of the propellant station or whatever)
#define AWAY_SITE_CANON_LIMITED			1
/// The away site in its entirety is canon.
#define AWAY_SITE_CANON_FULL			2

/// Offships are not canon at all.
#define OFFSHIP_NOT_CANON 				0
/// Offship actions are canon, barring extreme actions like bombing the main ship or whatever.
#define OFFSHIP_CANON_LIMITED 			1
/// Offship actions are fully canon.
#define OFFSHIP_CANON_FULL 				2
