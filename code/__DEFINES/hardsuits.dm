/** MODULE TYPES */
/**
 * Note that these types describe the primary functionality of a given module; additional configuration data provided by modules can
 * give them behavior modes that might seem to fall into multiple types below.
 *
 * For example, the Leg Actuators is type MODULE_USABLE_ACTIVE, because it has a middle-click use functionality as its primary. However,
 * it provides a configuration option to toggle fall damping on and off.
 */
/// Passive module, just acts when put in naturally.
#define MODULE_PASSIVE 0
/// Toggle module: you turn it on/off and it does stuff.
#define MODULE_TOGGLE 1
/// Usable module: you can use these for a one-time effect; they are things that just Happen w/o a click action.
#define MODULE_USABLE 2
/// Actively usable module: you may only have one selected at a time, and give you a special click action.
#define MODULE_USABLE_ACTIVE 3

/// The default cell drain of a hardsuit. The standard hardsuit active power usage drains this much energy per second.
/// 30000 is the value chosen because by default, rigs are created with High Capacity Power Cells, which have that capacity.
/// Installing a better cell should increase the power duration of a rig, so we don't adjust draw (CELLRATE) based on cap.
#define CHARGE_DRAIN_DEFAULT ((CELLRATE * 30000) / 6)
#define CHARGE_DRAIN_LOW ((CELLRATE * 30000) / 8)
#define CHARGE_DRAIN_HIGH ((CELLRATE * 30000) / 4)

#define MODULE_GENERAL 		1
#define MODULE_LIGHT_COMBAT 2
#define MODULE_HEAVY_COMBAT 4
#define MODULE_UTILITY 		8
#define MODULE_MEDICAL 		16
#define MODULE_SPECIAL 		32
#define MODULE_VAURCA 		64

#define ONLY_DEPLOY 1
#define ONLY_RETRACT 2
#define SEAL_DELAY 30
