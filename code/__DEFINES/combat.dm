//Damage flag defines //

/// Involves corrosive substances.
#define ACID "acid"
/// Involved in checking whether a disease can infect or spread. Also involved in xeno neurotoxin.
#define BIO "bio"
/// Involves a shockwave, usually from an explosion.
#define BOMB "bomb"
/// Involves a solid projectile.
#define BULLET "bullet"
/// Involves being eaten
#define CONSUME "consume"
/// Involves an EMP or energy-based projectile.
#define ENERGY "energy"
/// Involves fire or temperature extremes.
#define FIRE "fire"
/// Involves a laser.
#define LASER "laser"
/// Involves a melee attack or a thrown object.
#define MELEE "melee"
/// Involved in checking the likelihood of applying a wound to a mob.
#define WOUND "wound"
/// Aurora snowflake, radiations
#define RAD "rad"

#define ARMOR_ALL "all_damage_types"


//bullet_act() return values
#define BULLET_ACT_HIT "HIT" //It's a successful hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_BLOCK "BLOCK" //It's a blocked hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_FORCE_PIERCE "PIERCE" //It pierces through the object regardless of the bullet being piercing by default.

#define NICE_SHOT_RICOCHET_BONUS 10 //if the shooter has the NICE_SHOT trait and they fire a ricocheting projectile, add this to the ricochet chance and auto aim angle
