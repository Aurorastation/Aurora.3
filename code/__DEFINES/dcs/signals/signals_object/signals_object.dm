// Object signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument


// /obj/item signals

///from base of obj/item/equipped(): (mob/equipper, slot)
#define COMSIG_ITEM_EQUIPPED "item_equip"
///From base of obj/item/on_equipped() (mob/equipped, slot)
#define COMSIG_ITEM_POST_EQUIPPED "item_post_equipped"
	/// This will make the on_equipped proc return FALSE.
	#define COMPONENT_EQUIPPED_FAILED (1<<0)
/// A mob has just equipped an item. Called on [/mob] from base of [/obj/item/equipped()]: (/obj/item/equipped_item, slot)
#define COMSIG_MOB_EQUIPPED_ITEM "mob_equipped_item"
///from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
///from base of obj/item/pickup(): (mob/user)
#define COMSIG_ITEM_PICKUP "item_pickup"

///from base of /obj/item/attack(): (mob/living, mob/living, params)
#define COMSIG_ITEM_ATTACK "item_attack"
///from base of obj/item/attack_self(): (/mob)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"
//from base of obj/item/attack_self_secondary(): (/mob)
#define COMSIG_ITEM_ATTACK_SELF_SECONDARY "item_attack_self_secondary"

///from base of [obj/item/attack()]: (atom/target, mob/user, proximity_flag, click_parameters)
#define COMSIG_ITEM_AFTERATTACK "item_afterattack"

// /obj/projectile signals (sent to the firer)

///from base of /obj/projectile/proc/on_hit(), like COMSIG_PROJECTILE_ON_HIT but on the projectile itself and with the hit limb (if any): (atom/movable/firer, atom/target, angle, hit_limb, blocked)
#define COMSIG_PROJECTILE_SELF_ON_HIT "projectile_self_on_hit"
///from base of /obj/projectile/proc/on_hit(): (atom/movable/firer, atom/target, angle, hit_limb, blocked)
#define COMSIG_PROJECTILE_ON_HIT "projectile_on_hit"
///from base of /obj/projectile/proc/fire(): (obj/projectile, atom/original_target)
#define COMSIG_PROJECTILE_BEFORE_FIRE "projectile_before_fire"
///from base of /obj/projectile/proc/fire(): (obj/projectile, atom/firer, atom/original_target)
#define COMSIG_PROJECTILE_FIRER_BEFORE_FIRE "projectile_firer_before_fire"
///from the base of /obj/projectile/proc/fire(): ()
#define COMSIG_PROJECTILE_FIRE "projectile_fire"
///sent to targets during the process_hit proc of projectiles
#define COMSIG_PROJECTILE_PREHIT "com_proj_prehit"
	#define PROJECTILE_INTERRUPT_HIT (1<<0)
///from /obj/projectile/pixel_move(): ()
#define COMSIG_PROJECTILE_PIXEL_STEP "projectile_pixel_step"
///sent to self during the process_hit proc of projectiles
#define COMSIG_PROJECTILE_SELF_PREHIT "com_proj_prehit"
///from the base of /obj/projectile/Range(): ()
#define COMSIG_PROJECTILE_RANGE "projectile_range"
///from the base of /obj/projectile/on_range(): ()
#define COMSIG_PROJECTILE_RANGE_OUT "projectile_range_out"
///from the base of /obj/projectile/process(): ()
#define COMSIG_PROJECTILE_BEFORE_MOVE "projectile_before_move"
///from [/obj/item/proc/tryEmbed] sent when trying to force an embed (mainly for projectiles and eating glass)
#define COMSIG_EMBED_TRY_FORCE "item_try_embed"
	#define COMPONENT_EMBED_SUCCESS (1<<1)
// FROM [/obj/item/proc/updateEmbedding] sent when an item's embedding properties are changed : ()
#define COMSIG_ITEM_EMBEDDING_UPDATE "item_embedding_update"

///sent to targets during the process_hit proc of projectiles
// #define COMSIG_FIRE_CASING "fire_casing"

///from the base of /obj/item/ammo_casing/ready_proj() : (atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
#define COMSIG_CASING_READY_PROJECTILE "casing_ready_projectile"

///sent to the projectile after an item is spawned by the projectile_drop element: (new_item)
#define COMSIG_PROJECTILE_ON_SPAWN_DROP "projectile_on_spawn_drop"
///sent to the projectile when spawning the item (shrapnel) that may be embedded: (new_item)
#define COMSIG_PROJECTILE_ON_SPAWN_EMBEDDED "projectile_on_spawn_embedded"

/// from /obj/projectile/energy/fisher/on_hit() or /obj/item/gun/energy/recharge/fisher when striking a target
#define COMSIG_HIT_BY_SABOTEUR "hit_by_saboteur"
	#define COMSIG_SABOTEUR_SUCCESS (1<<0)
