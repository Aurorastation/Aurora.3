// check_pierce() return values
/// Default behavior: hit and delete self
#define PROJECTILE_PIERCE_NONE 0
/// Hit the thing but go through without deleting. Causes on_hit to be called with pierced = TRUE
#define PROJECTILE_PIERCE_HIT 1
/// Entirely phase through the thing without ever hitting.
#define PROJECTILE_PIERCE_PHASE 2
// Delete self without hitting
#define PROJECTILE_DELETE_WITHOUT_HITTING 3

// IFF values
#define IFF_DEFAULT "station"
#define IFF_TCFL "tcfl"
#define IFF_SYNDICATE "syndicate"
#define IFF_MERCENARY "mercenary"
#define IFF_RAIDER "raider"
#define IFF_LONER "loner"
#define IFF_BURGLAR "burglar"
#define IFF_JOCKEY "jockey"
#define IFF_CULTIST "cultist"
#define IFF_BLUESPACE "bluespace"
#define IFF_DEATHSQUAD "deathsquad"
#define IFF_ERIDANI "eridani"
#define IFF_HEPH "hephaestus"
#define IFF_ZENGHU "zenghu"
#define IFF_ZAVOD "zavodskoi"
#define IFF_EE "einstein"
#define IFF_FSF "freesolarianfleets"
#define IFF_IAC "interstellaraidcorps"
#define IFF_KATAPHRACT "kataphract"
#define IFF_FREELANCER "freelancer"
#define IFF_LANCER "lancer"
#define IFF_SOL "solarian"
#define IFF_HIGHLANDER "highlander"

#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define EJECT_CASINGS	1 //drop spent casings on the ground after firing
#define CYCLE_CASINGS 	2 //experimental: cycle casings, like a revolver. Also works for multibarrelled guns
#define DELETE_CASINGS	3 //deletes the casing, used in caseless ammunition guns or something
#define ROF_SMG 2 //ROF stands for "RATE OF FIRE"
#define ROF_PISTOL 3
#define ROF_INTERMEDIATE 4
#define ROF_RIFLE 5
#define ROF_HEAVY 8
#define ROF_SUPERHEAVY 12
#define ROF_UNWIELDY 16
#define ROF_SPECIAL 40

//Designed for things that need precision trajectories like projectiles.
//Don't use this for anything that you don't absolutely have to use this with (like projectiles!) because it isn't worth using a datum unless you need accuracy down to decimal places in pixels.

//You might see places where it does - 16 - 1. This is intentionally 17 instead of 16, because of how byond's tiles work and how not doing it will result in rounding errors like things getting put on the wrong turf.

#define RETURN_PRECISE_POSITION(A) new /datum/position(A)
#define RETURN_PRECISE_POINT(A) new /datum/point(A)

#define RETURN_POINT_VECTOR(ATOM, ANGLE, SPEED) (new /datum/point/vector(ATOM, null, null, null, null, ANGLE, SPEED))
#define RETURN_POINT_VECTOR_INCREMENT(ATOM, ANGLE, SPEED, AMT) (new /datum/point/vector(ATOM, null, null, null, null, ANGLE, SPEED, AMT))
