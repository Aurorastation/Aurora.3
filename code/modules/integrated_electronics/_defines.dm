/*
 * _defines.dm
 * Shared constants, spawn flags, pin format identifiers, capacity limits, and helper defines used by integrated electronics.
 */

#define IC_INPUT     "input"
#define IC_OUTPUT    "output"
#define IC_ACTIVATOR "activator"

// Pin functionality.
#define DATA_CHANNEL  "data channel"
#define PULSE_CHANNEL "pulse channel"

// Methods of obtaining a circuit. These are also defined in SSelectronics.
#define IC_SPAWN_DEFAULT  1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 2 // If the circuit design will be available in the IC printer after upgrading it.

// Displayed along with the pin name to show what type of pin it is.
#define IC_FORMAT_ANY     "\<ANY\>"
#define IC_FORMAT_STRING  "\<TEXT\>"
#define IC_FORMAT_CHAR    "\<CHAR\>"
#define IC_FORMAT_COLOR   "\<COLOR\>"
#define IC_FORMAT_NUMBER  "\<NUM\>"
#define IC_FORMAT_DIR     "\<DIR\>"
#define IC_FORMAT_BOOLEAN "\<BOOL\>"
#define IC_FORMAT_REF     "\<REF\>"
#define IC_FORMAT_LIST    "\<LIST\>"

#define IC_FORMAT_PULSE   "\<PULSE\>"

// Used inside input/output list to tell the constructor what pin to make.
#define IC_PINTYPE_ANY     /datum/integrated_io
#define IC_PINTYPE_STRING  /datum/integrated_io/string
#define IC_PINTYPE_CHAR    /datum/integrated_io/char
#define IC_PINTYPE_COLOR   /datum/integrated_io/color
#define IC_PINTYPE_NUMBER  /datum/integrated_io/number
#define IC_PINTYPE_DIR     /datum/integrated_io/dir
#define IC_PINTYPE_BOOLEAN /datum/integrated_io/boolean
#define IC_PINTYPE_REF     /datum/integrated_io/ref
#define IC_PINTYPE_LIST    /datum/integrated_io/list

#define IC_PINTYPE_PULSE_IN  /datum/integrated_io/activate
#define IC_PINTYPE_PULSE_OUT /datum/integrated_io/activate/out

// Data limits.
#define IC_MAX_LIST_LENGTH 200

/// integrated circuit: Base integrated circuit component.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "A base integrated circuit component."
	icon = 'icons/obj/assemblies/electronic_components.dmi'
	icon_state = "template"
	w_class = WEIGHT_CLASS_TINY
	// Assembly that currently owns this circuit.
	var/obj/item/electronic_assembly/assembly // Reference to the assembly holding this circuit, if any.
	// Long-form description shown in detailed UI or examine contexts.
	var/extended_desc
	// Input pin definitions exposed by this circuit.
	var/list/inputs = list()
	// Stores `inputs_default` state used by this integrated electronics object.
	var/list/inputs_default = list()  // Assoc list which will fill a pin with data upon creation.  e.g. "2" = 0 will set input pin 2 to equal 0 instead of null.
	// Output pin definitions exposed by this circuit.
	var/list/outputs = list()
	// Stores `outputs_default` state used by this integrated electronics object.
	var/list/outputs_default = list() // Ditto, for output.
	// Activator pin definitions used to trigger or signal work.
	var/list/activators = list()
	// Stores `next_use` state used by this integrated electronics object.
	var/next_use = 0                //Uses world.time
	// Circuit complexity cost used by assemblies and printer limits.
	var/complexity = 1              //This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	// Stores `size` state used by this integrated electronics object.
	var/size                        //This acts as a limitation on building machines, bigger components cost more 'space'. -1 for size 0
	// Stores `cooldown_per_use` state used by this integrated electronics object.
	var/cooldown_per_use = 1 SECOND // Circuits are limited in how many times they can be work()'d by this variable.
	// Power consumed when this circuit performs work.
	var/power_draw_per_use = 0      // How much power is drawn when work()'d.
	// Stores `power_draw_idle` state used by this integrated electronics object.
	var/power_draw_idle = 0         // How much power is drawn when doing nothing.
	// Controls where this circuit appears, such as default printer stock or research-only stock.
	var/spawn_flags                 // Used for world initializing, see the #defines above.
	// Human-readable printer/category grouping for this circuit.
	var/category_text = "General" // To show up on circuit printer, and perhaps other places.
	// Stores `phoron_cost` state used by this integrated electronics object.
	var/phoron_cost = 0.005        // 1/200th of one phoron sheet per circuit.
	// Stores `removable` state used by this integrated electronics object.
	var/removable = TRUE            // Determines if a circuit is removable from the assembly.
	// Stores `displayed_name` state used by this integrated electronics object.
	var/displayed_name = ""
	// Stores `allow_multitool` state used by this integrated electronics object.
	var/allow_multitool = TRUE      // Allows additional multitool functionality
									// Used as a global var, (Do not set manually in children).
