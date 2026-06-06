// ##### List of custom type definitions using the macros above

// Singleton list of generic persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_GENERIC(basic, "Title", "A persistent generic with no special properties.", FALSE)
// => creates /singleton/persistent_type/generic/basic

CREATE_PERSISTENT_TYPE_GENERIC(horizon_overmap_position, "SCCV Horizon sector position", "Position of the SCCV Horizon on the overmap.", FALSE)

// Singleton list of history persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_HISTORY(basic, "Title", "A persistent record type with no special properties.", FALSE, /singleton/persistent_type_history_expiration_rule/row_count/hundred)
// => creates /singleton/persistent_type/history/basic with an expiration rule of 100 rows

// Singleton list of history persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(basic, "Title", "A persistent record type with no special properties.", /singleton/persistent_type_history_expiration_rule/age/year)
// => creates /singleton/persistent_type/history/character/basic with an expiration age rule of 365 days and mandatory attribute (character ID)

CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(mining_points, "Mining yield history", "History of mining points yield of individual miners.", /singleton/persistent_type_history_expiration_rule/age/week)
