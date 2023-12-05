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

//Caliber Defines

//Sol Bloc
///Sol Generic Pistol (Security, Civilian)
#define CALIBER_PISTOL_GENERIC_SOL "9mm Pistol"

///Sol Military Pistol
#define CALIBER_PISTOL_MILITARY_SOL "4.6mm Pistol"

///Sol Assault Rifle/Light Machine Gun
#define CALIBER_RIFLE_ASSAULT_SOL "5.5mm Rifle"

///Sol Battle Rifle/Medium Machine Gun
#define CALIBER_RIFLE_BATTLE_SOL "7.6mm Rifle"

///Sol Heavy Machine Gun/AT Rifle
#define CALIBER_RIFLE_AT_SOL "12mm Rifle"

// Coalition Bloc
///Coalition Generic Pistol (Security, Civilian)
#define CALIBER_PISTOL_GENERIC_COC "10mm Pistol"

///Coalition Military Pistol
#define CALIBER_PISTOL_MILITARY_COC "5mm Caseless Pistol"

///Coalition Assault Rifle/Light Machine Gun
#define CALIBER_RIFLE_ASSAULT_COC "6.5mm Caseless Rifle"

///Coalition Battle Rifle/Medium Machine Gun
#define CALIBER_RIFLE_BATTLE_COC "10mm Caseless Rifle"

///Coalition Heavy Machine Gun/AT Rifle
#define CALIBER_RIFLE_AT_COC "15mm Caseless Rifle"

//Bizarre/Vintage Bloc
///Caliber used by older revolvers
#define CALIBER_PISTOL_MAGNUM ".357 Magnum"

///Caliber used by the Derringer pocket revolver
#define CALIBER_PISTOL_SPECIAL ".38 Special"

///Caliber used by the lever action rifle
#define CALIBER_RIFLE_GOVT ".40-75 Govt."

///Caliber used by the Springfield
#define CALIBER_RIFLE_SPRINGFIELD ".30-06 Springfield"

///Caliber used by the Musket
#define CALIBER_MUSKET "ball"

//Other calibers
///Exclusively used by Science's Experimental SMG
#define CALIBER_PISTOL_FLECHETTE "4mm Pistol"

///Civilian Shotgun
#define CALIBER_SHOTGUN_CIVILIAN "15mm Shell"

///Military Shotgun
#define CALIBER_SHOTGUN_MILITARY "20mm Shell"
