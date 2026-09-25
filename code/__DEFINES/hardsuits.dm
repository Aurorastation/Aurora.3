/** MODULE TYPES */
/**
 * Note that these types describe the primary functionality of a given module; additional configuration data provided by modules can
 * give them behavior modes that might seem to fall into multiple types below.
 *
 * For example, the Leg Actuators is type MODULETYPE_USABLE_ACTIVE, because it has a middle-click use functionality as its primary. However,
 * it provides a configuration option to toggle fall damping on and off.
 */
/// Passive module, just acts when put in naturally.
#define MODULETYPE_PASSIVE 0
/// Toggle module: you turn it on/off and it does stuff.
#define MODULETYPE_TOGGLE 1
/// Usable module: you can use these for a one-time effect; they are things that just Happen w/o a click action.
#define MODULETYPE_USABLE 2
/// Actively usable module: you may only have one selected at a time, and give you a special click action.
#define MODULETYPE_USABLE_ACTIVE 3

/*
 * Hardsuit power usage drains this much energy per tick from the cell. We don't accurately model this with CELLRATE and etc. because
 * in testing, it just didn't feel as good; static values felt better because they were more consistent/predictable w different configs.
 * There are 3600 machine ticks in a 2hr round, and a default cell has 30000 power.
 *
 * Note that every additional 1 power usage per tick (due to modules) will DECREASE cell lifetime by ~8m
 */

/// By itself, cell drains fully in 2hr5m
#define CHARGE_DRAIN_LOW 8
/// By itself, cell drains fully in 1hr40m
#define CHARGE_DRAIN_DEFAULT 10
/// By itself, cell drains fully in 1hr23m
#define CHARGE_DRAIN_HIGH 12

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
