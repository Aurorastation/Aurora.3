#define SHIP_CALIBER_NONE "none"
#define SHIP_CALIBER_406MM "406mm"
#define SHIP_CALIBER_40MM "40mm"
#define SHIP_CALIBER_90MM "90mm"
#define SHIP_CALIBER_ZTA "zero-point warp beam"
#define SHIP_CALIBER_178MM "178mm"
#define SHIP_CALIBER_COILGUN "tungsten rod"
#define SHIP_CALIBER_200MM "200mm"
#define SHIP_CALIBER_BLASTER "blaster charge"

#define SHIP_GUN_FIRING_SUCCESSFUL "firing sequence completed"
#define SHIP_GUN_ERROR_NO_AMMO "no ammunition loaded"

#define NO_PROJECTILE "no projectile"
#define SHIP_HAZARD_TARGET "Automatic Hazard Targeting"

#define SHIP_AMMO_CAN_HIT_HAZARDS    1
#define SHIP_AMMO_CAN_HIT_VISITABLES 2
#define SHIP_AMMO_CAN_HIT_PLANETS    4

#define SHIP_AMMO_IMPACT_HE "high explosive"
#define SHIP_AMMO_IMPACT_PROBE "sensor probe"
#define SHIP_AMMO_IMPACT_FMJ "full metal jacket"
#define SHIP_AMMO_IMPACT_AP "armour-piercing"
#define SHIP_AMMO_IMPACT_LASER "laser"
#define SHIP_AMMO_IMPACT_BUNKERBUSTER "bunker-buster"
#define SHIP_AMMO_IMPACT_PLASMA "plasma"
#define SHIP_AMMO_IMPACT_ZTA "zero-point warp beam"
#define SHIP_AMMO_IMPACT_BLASTER "blaster charge"

#define FIRING_EFFECT_FLAG_THROW_MOBS  1
#define FIRING_EFFECT_FLAG_EXTREMELY_LOUD 2 //Play the heavy firing sound to all mobs on connected zlevels.
#define FIRING_EFFECT_FLAG_SILENT 4 //Only play the heavy firing sound to nearby mobs, don't play the light sound.

#define SHIP_GUN_SCREENSHAKE_SCREEN 1
#define SHIP_GUN_SCREENSHAKE_ALL_MOBS 2

#define SHIP_AMMO_STATUS_RUPTURED 0
#define SHIP_AMMO_STATUS_GOOD     1

#define SHIP_AMMO_BEHAVIOUR_DUMBFIRE 1 //These are not flags! Dumbfire shells proceed along a straight path.
#define SHIP_AMMO_BEHAVIOUR_GUIDED 2  //Guided towards the target.

#define SHIP_AMMO_FLAG_INFLAMMABLE	 1 //Rupture when exposed to fire.
#define SHIP_AMMO_FLAG_VERY_HEAVY	 2 //Cannot be lifted by a normal person.
#define SHIP_AMMO_FLAG_VULNERABLE	 4 //Rupture from being shot at, attacked.
#define SHIP_AMMO_FLAG_VERY_FRAGILE  8 //Rupture from being thrown, dropped on harm intent.

//Overmap projectiles.
#define OVERMAP_PROJECTILE_RANGE_LOW 5
#define OVERMAP_PROJECTILE_RANGE_MEDIUM 10
#define OVERMAP_PROJECTILE_RANGE_MEDIUMHIGH 15
#define OVERMAP_PROJECTILE_RANGE_HIGH 25
#define OVERMAP_PROJECTILE_RANGE_ULTRAHIGH 30

//Targeting flags for overmap effects.
#define TARGETING_FLAG_GENERIC_WAYPOINTS 1
#define TARGETING_FLAG_ENTRYPOINTS       2
