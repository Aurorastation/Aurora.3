//Watts, yes this is stupid but it's just for visual reference to the code reader, so deal with it
#define WATTS *1

/**
 * Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
 *
 * It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
 */
#define CELLRATE 0.002

// Doors!
#define DOOR_CRUSH_DAMAGE 20
#define ALIEN_SELECT_AFK_BUFFER  1    // How many minutes that a person can be AFK before not being allowed to be an alien.

// Channel numbers for power.
#define POWER_CHAN  -1  // Use default
#define AREA_USAGE_EQUIP   BITFLAG(1)
#define AREA_USAGE_LIGHT   BITFLAG(2)
#define AREA_USAGE_ENVIRON BITFLAG(3)
#define AREA_USAGE_TOTAL   (AREA_USAGE_EQUIP|AREA_USAGE_LIGHT|AREA_USAGE_ENVIRON) // For total power used only.

#define LIGHT_USAGE(area) (area.used_light + area.oneoff_light)
#define EQUIP_USAGE(area) (area.used_equip + area.oneoff_equip)
#define ENVIRON_USAGE(area) (area.used_environ + area.oneoff_environ)
#define CLEAR_USAGE(area) area.oneoff_equip = 0; area.oneoff_light = 0; area.oneoff_environ = 0;

/// Returns the surplus power available to the powernet (avail - load)
#define POWERNET_SURPLUS(powernet) powernet.avail - powernet.load
/// Clamps the passed-in amount between 0 and the powernet's available load capacity.
#define POWERNET_POWER_DRAW(powernet, amt) ((powernet) ? clamp(amt, 0, powernet.avail - powernet.load) : 0)
/// Draws power from the powernet directly, if it exists.
#define DRAW_FROM_POWERNET(powernet, amt) ((powernet) ? (powernet.load += amt) : 0)

/// Adds an amount from SMES to the powernet (powernet.smes_newavail)
#define SMES_ADD_TO_POWERNET(smes, amt) if(smes.powernet) { \
	smes.powernet.newavail += amt; \
	smes.powernet.smes_newavail += amt; \
}
/// Adds an amount to the available power in the powernet (powernet.newavail)
#define ADD_TO_POWERNET(machine, amt) ((machine.powernet) ? (machine.powernet.newavail += amt) : 0)
/// Returns the available power to the machine via the powernet (powernet.avail)
#define POWER_AVAIL(machine) (machine.powernet?.avail || 0)
/// Returns the load of the powernet attached to the machine (powernet.load)
#define POWER_LOAD(machine) (machine.powernet?.load || 0)
/// Returns the surplus power available to the machine via the powernet (avail - load)
#define POWER_SURPLUS(machine) ((machine.powernet) ? (POWERNET_SURPLUS(machine.powernet)) : 0)
/// Clamps the passed-in amount between 0 and the powernet's available load capacity.
#define POWER_DRAW(machine, amt) (POWERNET_POWER_DRAW(machine.powernet, amt))
/// Draws power from the machine's powernet, if it exists.
#define DRAW_POWER(machine, amt) (DRAW_FROM_POWERNET(machine.powernet, amt))
/// Clamps the passed-in amount between 0 and the terminal's powernet's available load capacity.
#define TERMINAL_POWER_DRAW(amt) (src.terminal ? POWER_DRAW(src.terminal, amt) : 0)
/// Draws power from src's terminal, if it exists.
#define TERMINAL_DRAW_POWER(amt) (src.terminal ? (DRAW_POWER(src.terminal, amt)) : 0)

#define POWER_USE_OFF       0
#define POWER_USE_IDLE      1
#define POWER_USE_ACTIVE    2

// Bitflags for machine stat variable.
// These definitions are copypasted in the dmdocs in 'code/game/machinery.dm' so they can be easily referenced by checking the 'stat' variable.
// SO THAT MEANS IF YOU UPDATE THEM HERE, UPDATE THEM THERE FOR VISIBILITY!
#define BROKEN   0x1
#define NOPOWER  0x2
#define POWEROFF 0x4  // TBD.
#define MAINT    0x8  // Under maintenance.
#define EMPED    0x10 // Temporary broken by EMP pulse.

#define FABRICATOR_EXTRA_COST_FACTOR 1.25
#define FAB_HACKED BITFLAG(1)
#define FAB_DISABLED BITFLAG(2)
#define FAB_SHOCKED BITFLAG(3)
#define FAB_BUSY     BITFLAG(4)

#define INOPERABLE(machine)  (machine.stat & (BROKEN|NOPOWER|MAINT|EMPED))
#define OPERABLE(machine)    !INOPERABLE(machine)

// Used by firelocks
#define FIREDOOR_OPEN 1
#define FIREDOOR_CLOSED 2

#define AI_CAMERA_LUMINOSITY 6

//Vending machines.
#define CAT_NORMAL 1
#define CAT_HIDDEN 2  // also used in corresponding wires/vending.dm
#define CAT_COIN   4

// Camera networks
#define NETWORK_CRESCENT "Crescent"
#define NETWORK_CIVILIAN_EAST "Civilian East"
#define NETWORK_CIVILIAN_WEST "Civilian West"
#define NETWORK_CIVILIAN_MAIN "Civilian Main"
#define NETWORK_CIVILIAN_SURFACE "Civilian Surface"
#define NETWORK_COMMAND "Command"
#define NETWORK_REACTOR "Reactor"
#define NETWORK_ENGINEERING "Engineering"
#define NETWORK_ENGINEERING_OUTPOST "Engineering Outpost"
#define NETWORK_ERT "ZeEmergencyResponseTeam"
#define NETWORK_STATION "Station"
#define NETWORK_MECHS "Mechs"
#define NETWORK_MEDICAL "Medical"
#define NETWORK_MERCENARY "MercurialNet"
#define NETWORK_TCFL "TCFL"
#define NETWORK_MINE "MINE"
#define NETWORK_RESEARCH "Research"
#define NETWORK_RESEARCH_OUTPOST "Research Outpost"
#define NETWORK_ROBOTS "Robots"
#define NETWORK_PRISON "Prison"
#define NETWORK_SECURITY "Security"
#define NETWORK_TELECOM "Tcomsat"
#define NETWORK_THUNDER "Thunderdome"
#define NETWORK_ALARM_ATMOS "Atmosphere Alarms"
#define NETWORK_ALARM_POWER "Power Alarms"
#define NETWORK_ALARM_FIRE "Fire Alarms"
#define NETWORK_SUPPLY "Operations"
#define NETWORK_SERVICE "Service"
#define NETWORK_EXPEDITION "Expedition"
#define NETWORK_CALYPSO "Calypso"
#define NETWORK_POD "General Utility Pod"
#define NETWORK_FIRST_DECK "First Deck"
#define NETWORK_SECOND_DECK "Second Deck"
#define NETWORK_THIRD_DECK "Third Deck"
#define NETWORK_INTREPID "Intrepid" // horizon shuttle, expedition/transport
#define NETWORK_CANARY "Canary" // horizon shuttle, scout/fighter
#define NETWORK_QUARK "Quark" // horizon shuttle, xenostudies
#define NETWORK_NEWS "News"
#define NETWORK_CRYO_OUTPOST "#187-D Outpost"


// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
GLOBAL_LIST_INIT(restricted_camera_networks, list(NETWORK_ERT,NETWORK_MERCENARY,"Secret"))


//singularity defines
#define STAGE_ONE 	1
#define STAGE_TWO 	3
#define STAGE_THREE	5
#define STAGE_FOUR	7
#define STAGE_FIVE	9
#define STAGE_SUPER	11

// Interaction flags
#define STATUS_INTERACTIVE 2 // GREEN Visability
#define STATUS_UPDATE 1 // ORANGE Visability
#define STATUS_DISABLED 0 // RED Visability
#define STATUS_CLOSE -1 // Close the interface

/**
 * Atmospherics Machinery.
 */

/// Maximum flowrate, in L/s, that the scrubbers use when siphoning. Anything higher than `CELL_VOLUME` has no effect.
#define MAX_SIPHON_FLOWRATE   5000

/// Maximum flowrate, in L/s, that the scrubbers use when scrubbing from a turf.
#define MAX_SCRUBBER_FLOWRATE 400

#define ATMOS_PUMP_MAX_PRESSURE 15000

// These balance how easy or hard it is to create huge pressure gradients with pumps and filters.
// Lower values means it takes longer to create large pressures differences.
// Has no effect on pumping gasses from high pressure to low, only from low to high.
#define ATMOS_PUMP_EFFICIENCY   2.5
#define ATMOS_FILTER_EFFICIENCY 2.5

// Will not bother pumping or filtering if the gas source as fewer than this amount of moles, to help with performance.
#define MINIMUM_MOLES_TO_PUMP   0.01
#define MINIMUM_MOLES_TO_FILTER 0.04

// The flow rate/effectiveness of various atmos devices is limited by their internal volume,
// so for many atmos devices these will control maximum flow rates in L/s.
#define ATMOS_DEFAULT_VOLUME_PUMP   200 // Liters.
#define ATMOS_DEFAULT_VOLUME_FILTER 500 // L.
#define ATMOS_DEFAULT_VOLUME_MIXER  500 // L.
#define ATMOS_DEFAULT_VOLUME_PIPE   70  // L.
#define ATMOS_DEFAULT_VOLUME_HE_PIPE 70 // L.

// Default maximum pressure for simple pipes
#define ATMOS_DEFAULT_MAX_PRESSURE     PRESSURE_ONE_THOUSAND * 20 // 20000 kPa.
#define ATMOS_DEFAULT_FATIGUE_PRESSURE PRESSURE_ONE_THOUSAND * 15 // 15000 kPa.
#define ATMOS_DEFAULT_ALERT_PRESSURE   ATMOS_DEFAULT_FATIGUE_PRESSURE // See above.

// Misc process flags.
#define M_PROCESSES 0x1
#define M_USES_POWER 0x2

// If this is returned from a machine's process() proc, the machine will stop processing but
// will continue to have power calculations done.
#define M_NO_PROCESS 27

// This controls how much power the AME generates per unit of fuel.
#define AM_POWER_FACTOR 1000000

// Machinery process flags, for use with START_PROCESSING_MACHINE
#define MACHINERY_PROCESS_SELF          (1<<0)
#define MACHINERY_PROCESS_COMPONENTS    (1<<1)
#define MACHINERY_PROCESS_ALL           (MACHINERY_PROCESS_SELF | MACHINERY_PROCESS_COMPONENTS)

// Machinery init flag masks
#define INIT_MACHINERY_PROCESS_SELF         0x1
#define INIT_MACHINERY_PROCESS_COMPONENTS   0x2
#define INIT_MACHINERY_PROCESS_ALL          0x3

// Status Display Modes
#define STATUS_DISPLAY_BLANK 0
#define STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME 1
#define STATUS_DISPLAY_MESSAGE 2
#define STATUS_DISPLAY_ALERT 3
#define STATUS_DISPLAY_TIME 4
#define STATUS_DISPLAY_CUSTOM 99
