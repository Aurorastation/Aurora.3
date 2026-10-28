// Polaris-style datum AI intelligence levels.
#define AI_INTELLIGENCE_DUMB 1
#define AI_INTELLIGENCE_NORMAL 2
#define AI_INTELLIGENCE_SMART 3

// Results returned by mob AI interfaces.
#define AI_MOVEMENT_ON_COOLDOWN -1
#define AI_MOVEMENT_FAILED 0
#define AI_MOVEMENT_SUCCESS 1

#define AI_ATTACK_ON_COOLDOWN -1
#define AI_ATTACK_FAILED 0
#define AI_ATTACK_SUCCESS 1

// Reasons a target stopped being usable. These let the holder distinguish
// "gone from sight" from "dead/ally/invulnerable" and react appropriately.
#define AI_TARGET_VALID 0
#define AI_TARGET_INVISIBLE 1
#define AI_TARGET_NO_SIGHT 2
#define AI_TARGET_ALLY 3
#define AI_TARGET_DEAD 4
#define AI_TARGET_INVINCIBLE 5

// Holder debug verbosity.
#define AI_LOG_OFF 0
#define AI_LOG_ERROR 1
#define AI_LOG_WARNING 2
#define AI_LOG_INFO 3
#define AI_LOG_DEBUG 4
#define AI_LOG_TRACE 5

// Datum AI stances. These deliberately do not reuse the legacy hostile mob
// stance defines; an AI holder is the authority for its own state.
#define AI_STANCE_SLEEP 0
#define AI_STANCE_IDLE 1
#define AI_STANCE_ALERT 2
#define AI_STANCE_APPROACH 3
#define AI_STANCE_FIGHT 4
#define AI_STANCE_BLINDFIGHT 5
#define AI_STANCE_REPOSITION 6
#define AI_STANCE_MOVE 7
#define AI_STANCE_FOLLOW 8
#define AI_STANCE_FLEE 9
#define AI_STANCE_DISABLED 10
#define AI_STANCE_SPECIAL 11

#define AI_STANCES_COMBAT list(AI_STANCE_ALERT, AI_STANCE_APPROACH, AI_STANCE_FIGHT, AI_STANCE_BLINDFIGHT, AI_STANCE_REPOSITION, AI_STANCE_FLEE)

#define AI_COMM_SAY "say"
#define AI_COMM_AUDIBLE_EMOTE "audible emote"
#define AI_COMM_VISUAL_EMOTE "visual emote"
