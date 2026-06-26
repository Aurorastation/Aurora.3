//These threat levels work in a switch. So 0-199 is good, 200-399 is medium, etc.
/// You're a good guy. You don't get any penalties. Offships spawn in knowing of your good standing in the region.
#define ANABASIS_THREAT_LEVEL_GOOD 0
/// You're alright. You've done some bad things but so has everyone. As THREAT_LEVEL_GOOD but with a light increase in dangerous offship chance.
#define ANABASIS_THREAT_LEVEL_FAIRLY_GOOD 200
/// You've done some bad things. Offships no longer innately know that you're a good person. You are seen like the others. Medium increase in dangerous offship chance.
#define ANABASIS_THREAT_LEVEL_MEDIUM 400
/// You've done quite a few bad things and your name is known for the wrong reasons. Offships know that you are dangerous. Higher increase in dangerous offship chance.
#define ANABASIS_THREAT_LEVEL_NOTORIOUS 600
/// You are the bad guy. Offships know that not only you are dangerous, they know you are hostile to them. Everyone assumes you are out to kill and loot them. Even higher bad offship chance.
#define ANABASIS_THREAT_LEVEL_BAD 800
/// You are a threat to the region. All offships are told to cut you down to size. Unlikely alliances will form just to beat you the fuck up. Reach this level and you will have a bad time.
#define ANABASIS_THREAT_LEVEL_REGIONAL_THREAT 1000

// Contract difficulties have a threat level modifier that is then multiplied against the "evilness" of the contract in the region.
/// An easy contract is, as the tin says, easy. Not much difficulty or chance of people to die. Little or no threat level generation.
#define CONTRACT_DIFFICULTY_EASY		1
/// On a medium contract there's a chance things might go wrong. Somewhat challenging - like a traitor round on a secret scale, potentially. Generates an alright amount of threat level.
#define CONTRACT_DIFFICULTY_MEDIUM		2
/// A hard contract means that stuff will go wrong and crew will need to be careful. About a merc round on the secret scale. Generates quite a bit of threat level.
#define CONTRACT_DIFFICULTY_HARD		3
/// A very hard contract is predictably going to always end up with deaths. On the same scale as a crossfire round. Be very careful. Generates a lot of threat level... but think about the money...
#define CONTRACT_DIFFICULTY_VERY_HARD	4

// Evilness refers to how fucked up this action is in the region. Murder of civilians would have the highest evilness rating. Killing pirates may be seen as good in some regions (or badly if it's a pirate region!). Delivering a suspicious package would have very little.
// TODO: these are currently thought of as modifiers, maybe the modifier can be decoupled from the define and we can have evilness maps depending on region?
#define CONTRACT_EVILNESS_NONE 0
#define CONTRACT_EVILNESS_LOW 1.25
#define CONTRACT_EVILNESS_MEDIUM 1.5
#define CONTRACT_EVILNESS_HIGH 1.75
#define CONTRACT_EVILNESS_VERY_HIGH 2

/// Updates the current contract on SSanabasis and tells all objectives to re-check validity.
#define COMSIG_ANABASIS_UPDATE_CONTRACT "anabasis_update_contract"
/// Notifies SSanabasis of a completed objective.
#define COMSIG_OBJECTIVE_COMPLETED		"anabasis_objective_complete"

/// An objective where you have to bring a certain item on top of a turf.
#define OBJECTIVE_TYPE_RECEPTACLE		"receptacle"
