/// Constants for area management on the Horizon.

/// Locations
// LOC_AMIDSHIPS should only be assigned to var/location_ew
#define LOC_AMIDSHIPS		"Amidships"
// East
#define LOC_PORT			"Port"
#define LOC_PORT_FAR		"Far to Port"
#define LOC_PORT_NEAR		"Port Amidships"
// West
#define LOC_STARBOARD		"Starboard"
#define LOC_STARBOARD_FAR	"Far to Starboard"
#define LOC_STARBOARD_NEAR	"Starboard Amidships"
// North
#define LOC_AFT				"Aft"
#define LOC_AFT_FAR			"Far to Aft"
#define LOC_AFT_NEAR		"Aft Amidships"
// South
#define LOC_FORE			"Fore"
#define LOC_FORE_FAR		"Far to Fore"
#define LOC_FORE_NEAR		"Fore Amidships"

/// 'Departments' - formal and informal
// If we rename any of these, also change them in subsystems.dm define.
#define LOC_AI			"Artificial Intelligence"
#define LOC_COMMAND		"Command"
// LOC_PUBLIC and LOC_CREW are effectively the same thing, just separated for flavor.
// LOC_PUBLIC is pretty much going to be hallways/stairs etc.
#define LOC_PUBLIC		"Public"
#define LOC_CREW		"Crew Areas"
#define LOC_ENGINEERING	"Engineering"
#define LOC_HANGAR		"Hangar"
#define LOC_HOLODECK	"Holodeck"
#define LOC_MAINTENANCE	"Maintenance"
#define LOC_MEDICAL		"Medical"
#define LOC_OPERATIONS	"Operations"
#define LOC_SCIENCE		"Science"
#define LOC_SECURITY	"Security"
#define LOC_SERVICE		"Service"
#define LOC_SHUTTLE		"Shuttle"

/// Global Subdepartments - Used for every department with a Head of Staff
#define SUBLOC_COMMAND		"Command"

/// Command Subdepartments

/// Crew Subdepartments
#define SUBLOC_HALLS		"Corridor"
#define SUBLOC_STAIRS		"Stairwell"
#define SUBLOC_CRYO			"Cryogenics"
#define SUBLOC_RESDECK		"ResDeck"

/// Engineering Subdepartments
#define SUBLOC_ATMOS		"Atmospherics"
#define SUBLOC_TELECOMMS	"Telecomms"

/// Operations Subdepartments
#define SUBLOC_MINING		"Mining"
#define SUBLOC_MACHINING	"Machining"

/// Science Subdepartments
#define SUBLOC_XENOBIO		"Xenobiology"
#define SUBLOC_XENOBOT		"Xenobotany"
#define SUBLOC_XENOARCH		"Xenoarchaeology"

/// Service Subdepartments
#define SUBLOC_BAR			"Bar"
#define SUBLOC_CHAPEL		"Chapel"
#define SUBLOC_CUSTODIAL	"Custodial"
#define SUBLOC_HYDRO		"Hydroponics"
#define SUBLOC_KITCHEN		"Kitchen"
#define SUBLOC_LIBRARY		"Library"

