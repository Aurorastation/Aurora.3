

#define BULLET_IMPACT_NONE  "none"
#define BULLET_IMPACT_METAL "metal"
#define BULLET_IMPACT_MEAT  "meat"

#define SOUNDS_BULLET_MEAT  list('sound/effects/projectile_impact/bullet_meat1.ogg', 'sound/effects/projectile_impact/bullet_meat2.ogg', 'sound/effects/projectile_impact/bullet_meat3.ogg', 'sound/effects/projectile_impact/bullet_meat4.ogg')
#define SOUNDS_BULLET_METAL  list('sound/effects/projectile_impact/bullet_metal1.ogg', 'sound/effects/projectile_impact/bullet_metal2.ogg', 'sound/effects/projectile_impact/bullet_metal3.ogg')
#define SOUNDS_LASER_MEAT  list('sound/effects/projectile_impact/energy_meat1.ogg','sound/effects/projectile_impact/energy_meat2.ogg')
#define SOUNDS_LASER_METAL  list('sound/effects/projectile_impact/energy_metal1.ogg','sound/effects/projectile_impact/energy_metal2.ogg')
#define SOUNDS_ION_ANY      list('sound/effects/projectile_impact/ion_any.ogg')

//Used in determining the currently permissable firemodes of wireless-control firing pins.
#define WIRELESS_PIN_DISABLED  1
#define WIRELESS_PIN_AUTOMATIC 2
#define WIRELESS_PIN_STUN      3
#define WIRELESS_PIN_LETHAL    4

//RCD Modes (TODO: Have the other RCD types have defines and set them here.)
#define RFD_FLOORS_AND_WALL 1
#define RFD_WINDOW_AND_FRAME 2
#define RFD_AIRLOCK 3
#define RFD_DECONSTRUCT 4

/*
 * Caliber Defines
 */

//Pistol Calibers
///Generic Solarian Pistol
#define CALIBER_PISTOL_SOL "9mm"
///Generic Coalition Pistol
#define CALIBER_PISTOL_COC "10mm"
///Service Solarian Pistol
#define CALIBER_SERVICE_PISTOL_SOL "5.7mm"
///Service Coalition Pistol
#define CALIBER_SERVICE_PISTOL_COC "4.6mm"
///Service Coalition Pistol (Caseless)
#define CALIBER_SERVICE_PISTOL_CASELESS_COC "4.6mm Caseless"

//Rifle Calibers
///Solarian Assault Rifles
#define CALIBER_ASSAULT_RIFLE_SOL "5.6mm"
///Coalition Assault Rifles
#define CALIBER_ASSAULT_RIFLE_COC "6.5mm"
///Solarian Battle Rifles
#define CALIBER_BATTLE_RIFLE_SOL "7.7mm"
///Coalition Battle Rifles
#define CALIBER_BATTLE_RIFLE_COC "10mm"

//Shotgun Calibers
///12 Gauge equivalent
#define CALIBER_SHOTGUN_MILITARY "18mm Shell"
///20 Gauge equivalent
#define CALIBER_SHOTGUN_CIVILIAN "14mm Shell"

//Vintage Calibers
///Musket
#define CALIBER_MUSKET "ball"
///Frontier Rifle
#define CALIBER_FRONTIER_RIFLE ".40-70 Govt."
///Antique Rifle
#define CALIBER_ANTIQUE_RIFLE ".30-40 Springfield"
///Frontier Revolver 1
#define CALIBER_FRONTIER_REVOLVER ".357 Magnum"
///Deagle
#define CALIBER_FRONTIER_DEAGLE ".50AE"

//Bizarre Calibers
///Hegemonic Pistol
#define CALIBER_HEGEMONY_PISTOL "11.6mm"
///Hegemonic Rifle
#define CALIBER_HEGEMONY_RIFLE "5.8mm"

//Special Calibers
///Prototype SMG
#define CALIBER_PISTOL_FLECHETTE "4mm"
