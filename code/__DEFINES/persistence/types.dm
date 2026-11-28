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
CREATE_PERSISTENT_TYPE_GENERIC(photocopier_toner, "Photocopier toner levels", "Remaining toner in photocopiers mapped onto the SCCV Horizon.", TRUE)
CREATE_PERSISTENT_TYPE_GENERIC(papershredder_contents, "Paper shredder contents", "Shredded paper in paper shredders mapped onto the SCCV Horizon.", TRUE)
CREATE_PERSISTENT_TYPE_GENERIC(request_console_paperstock, "Request console paper stock", "Remaining paper in request consoles mapped onto the SCCV Horizon.", TRUE)
CREATE_PERSISTENT_TYPE_GENERIC(horizon_vending_stock, "SCCV Horizon vending stock", "Remaining normal stock in vending machines mapped onto the SCCV Horizon.", TRUE)
CREATE_PERSISTENT_TYPE_GENERIC(horizon_cleanliness, "SCCV Horizon cleanliness", "Accumulated per-area grime levels of the SCCV Horizon across rounds.", FALSE)

// ##### Persistent history



// ##### Persistent history with character validation

CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(mining_points, "Mining yield history", "History of mining points yield of individual miners.", /singleton/persistent_type_history_expiration_rule/age/week)
CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(mining_point_balance, "Mining point balance", "History of unspent mining point balances of individual miners.", /singleton/persistent_type_history_expiration_rule/row_count/one)
