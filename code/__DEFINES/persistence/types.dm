/*###################################################
	Type definitions
###################################################*/

// Type definitions using macros - This file contains all types getting made accessible in code and later in database during first subsystem run
// See macros for detailed information on parameters and the underlaying types
// Generally, after being released (as in, run against the database once), these should NOT be modified if possible, explicit warnings:

//		+------------------------------------------------------------------------------------------------------------------+
//		| MODIFYING THE TYPE NAME OF EXISTING DEFINES WILL CREATE A NEW TYPE DEFINITION IN THE DATABASE                    |
//		+------------------------------------------------------------------------------------------------------------------+
//		| MODIFYING THE ATTRIBUTE FLAG OF EXISTING DEFINES CAN HAVE BREAKING CONSEQUENCES, TESTING REQUIRED BEFORE RELEASE |
//		+------------------------------------------------------------------------------------------------------------------+

// Below are the defines for generics, history and history with character validation

// ##### Persistent generics

CREATE_PERSISTENT_TYPE_GENERIC(horizon_overmap_position, "SCCV Horizon sector position", "Position of the SCCV Horizon on the overmap.", FALSE)

// ##### Persistent history



// ##### Persistent history with character validation

CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(mining_points, "Mining yield history", "History of mining points yield of individual miners.", /singleton/persistent_type_history_expiration_rule/age/week)
