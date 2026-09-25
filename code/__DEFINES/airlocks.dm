#define AIRLOCK_CRUSH_DIVISOR 8 // Damage caused by airlock crushing a mob is split into multiple smaller hits. Prevents things like cut off limbs, etc, while still having quite dangerous injury.
#define CYBORG_AIRLOCKCRUSH_RESISTANCE 4 // Damage caused to silicon mobs (usually cyborgs) from being crushed by airlocks is divided by this number. Unlike organics cyborgs don't have passive regeneration, so even one hit can be devastating for them.

#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

/// The main airlock body is paintable.
#define AIRLOCK_PAINTABLE_MAIN 1
/// The stripe decal is paintable.
#define AIRLOCK_PAINTABLE_STRIPE 2
/// Other detailing is paintable.
#define AIRLOCK_PAINTABLE_DETAIL 4
/// The window is paintable.
#define AIRLOCK_PAINTABLE_WINDOW 8
