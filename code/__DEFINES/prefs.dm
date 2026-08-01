// Character Preview Bitflags

/// Will show loadout items
#define EQUIP_PREVIEW_LOADOUT BITFLAG(0)

/// Will show job items, specific item bitflags will determine if those ones are shown or not
#define EQUIP_PREVIEW_JOB BITFLAG(1)

/// Will show job hat if true, will hide if this is false or EQUIP_PREVIEW_JOB is false
#define EQUIP_PREVIEW_JOB_HAT BITFLAG(2)

/// Will show job uniform if true, will hide if this is false or EQUIP_PREVIEW_JOB is false
#define EQUIP_PREVIEW_JOB_UNIFORM BITFLAG(3)

/// Will show job suit if true, will hide if this is false or EQUIP_PREVIEW_JOB is false
#define EQUIP_PREVIEW_JOB_SUIT BITFLAG(4)

/// Will show custom items if set, not set by default, to prevent overloading SQL requests
#define EQUIP_PREVIEW_CUSTOM_ITEMS BITFLAG(5)

/// The default EQUIP_PREVIEW bitflag, with this, all character creation items are shown
#define EQUIP_PREVIEW_ALL (EQUIP_PREVIEW_LOADOUT|EQUIP_PREVIEW_JOB|EQUIP_PREVIEW_JOB_HAT|EQUIP_PREVIEW_JOB_UNIFORM|EQUIP_PREVIEW_JOB_SUIT)

/// External organ. Is a prosthesis with a robo-limb manufacturer.
#define ORGAN_PREF_CYBORG "cyborg"
/// External organ. Amputated.
#define ORGAN_PREF_AMPUTATED "amputated"
/// External organ. Nymph-limb.
#define ORGAN_PREF_NYMPH "nymph"

/// Internal organ. Assisted, so halfway through mechanical.
#define ORGAN_PREF_ASSISTED "assisted"
/// Internal organ. Mechanical, so has a robo-limb manufacturer.
#define ORGAN_PREF_MECHANICAL "mechanical"
/// Internal organ. Removed, used for appendixes.
#define ORGAN_PREF_REMOVED "removed"
/// Note that a "normal" limb or organ has no pref, so there's no define for it.

/// Air cooling. Technically not used, but we need this for the linked lists in cooling_unit.dm.
#define ORGAN_PREF_AIRCOOLED "air"
/// Liquid cooling. For IPC cooling units. Default is air cooling.
#define ORGAN_PREF_LIQUIDCOOLED "liquid"
/// Passive cooling. For IPC cooling units. Default is air cooling.
#define ORGAN_PREF_PASSIVECOOLED "passive"

/// Externally powered only. Technically not used, but we need this for the linked lists in reactor.dm.
#define ORGAN_PREF_ELECTRICPOWER "electric"
/// Biological power reactor. Nutrients, food, etc.
#define ORGAN_PREF_BIOPOWER "biological"
/// Kinetic power reactor. Walking, running.
#define ORGAN_PREF_KINETICPOWER "kinetic"
/// Solar powered. Stand in the sun. Or LED lights. It's the future, fuck you.
#define ORGAN_PREF_SOLARPOWER "solar"
