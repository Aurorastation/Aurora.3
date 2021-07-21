/datum/hud_data
	var/icon                 // If set, overrides ui_style.
	var/has_a_intent = TRUE  // Set to draw intent box.
	var/has_m_intent = TRUE  // Set to draw move intent box.
	var/has_warnings = TRUE  // Set to draw environment warnings.
	var/has_pressure = TRUE  // Draw the pressure indicator.
	var/has_nutrition = TRUE // Draw the nutrition indicator.
	var/has_hydration = TRUE // Draw the hydration indicator.
	var/has_bodytemp = TRUE  // Draw the bodytemp indicator.
	var/has_hands = TRUE     // Set to draw hands.
	var/has_drop = TRUE      // Set to draw drop button.
	var/has_throw = TRUE     // Set to draw throw button.
	var/has_resist = TRUE    // Set to draw resist button.
	var/has_internals = TRUE // Set to draw the internals toggle button.
	var/has_up_hint = TRUE   // Set to draw the "look-up" hint icon.
	var/has_cell = FALSE     //Set if the species has a cell.
	var/list/equip_slots = list() // Checked by mob_can_equip().

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_oclothing, "name" = "suit",         "slot" = slot_wear_suit, "state" = "suit",   "toggle" = 1),
		"mask" =         list("loc" = ui_mask,      "name" = "mask",         "slot" = slot_wear_mask, "state" = "mask",   "toggle" = 1),
		"gloves" =       list("loc" = ui_gloves,    "name" = "gloves",       "slot" = slot_gloves,    "state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "name" = "glasses",      "slot" = slot_glasses,   "state" = "glasses","toggle" = 1),
		"l_ear" =        list("loc" = ui_l_ear,     "name" = "left ear",     "slot" = slot_l_ear,     "state" = "l_ear",  "toggle" = 1),
		"r_ear" =        list("loc" = ui_r_ear,     "name" = "right ear",    "slot" = slot_r_ear,     "state" = "r_ear",  "toggle" = 1),
		"head" =         list("loc" = ui_head,      "name" = "hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_shoes,     "name" = "shoes",        "slot" = slot_shoes,     "state" = "shoes",  "toggle" = 1),
		"wrists" =       list("loc" = ui_wrists,    "name" = "wrists",       "slot" = slot_wrists,    "state" = "wrists", "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "suit storage", "slot" = slot_s_store,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "back",         "slot" = slot_back,      "state" = "back", "slot_type" = /obj/screen/inventory/back),
		"id" =           list("loc" = ui_id,        "name" = "id",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "left pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "right pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "belt",         "slot" = slot_belt,      "state" = "belt")
		)

/datum/hud_data/New()
	..()
	for(var/slot in gear)
		equip_slots |= gear[slot]["slot"]

	if(has_hands)
		equip_slots |= slot_l_hand
		equip_slots |= slot_r_hand
		equip_slots |= slot_handcuffed

	if(slot_back in equip_slots)
		equip_slots |= slot_in_backpack

	if(slot_w_uniform in equip_slots)
		equip_slots |= slot_tie

	if(slot_belt in equip_slots)
		equip_slots |= slot_in_belt

	equip_slots |= slot_legcuffed

/datum/hud_data/diona
	has_hydration = FALSE
	has_internals = FALSE
	has_m_intent = FALSE
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_shoes,     "name" = "suit",         "slot" = slot_wear_suit, "state" = "suit",   "toggle" = 1),
		"l_ear" =        list("loc" = ui_glasses,   "name" = "left ear",     "slot" = slot_l_ear,     "state" = "l_ear",   "toggle" = 1),
		"r_ear" =        list("loc" = ui_wrists,	"name" = "right ear",    "slot" = slot_r_ear,     "state" = "r_ear",   "toggle" = 1),
		"head" =         list("loc" = ui_mask, 		"name" = "hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "suit storage", "slot" = slot_s_store,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "back",         "slot" = slot_back,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "id",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "belt",         "slot" = slot_belt,      "state" = "belt"),
		"mask" =         list("loc" = ui_oclothing,	"name" = "mask",         "slot" = slot_wear_mask, "state" = "mask",   "toggle" = 1),
		"eyes" =         list("loc" = ui_gloves,   	"name" = "glasses",      "slot" = slot_glasses,   "state" = "glasses","toggle" = 1)
		)

/datum/hud_data/monkey
	gear = list(
		"head" =         list("loc" = ui_oclothing, "name" = "hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"mask" =         list("loc" = ui_shoes,     "name" = "mask",         "slot" = slot_wear_mask, "state" = "mask",   "toggle" = 1),
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"back" =         list("loc" = ui_back,      "name" = "back",         "slot" = slot_back,      "state" = "back"),
		"id" =           list("loc" = ui_belt,      "name" = "id",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "left pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "right pocket", "slot" = slot_r_store,   "state" = "pocket")
		)


/datum/hud_data/ipc
	has_hydration = FALSE
	has_nutrition = FALSE
	has_cell = TRUE

/datum/hud_data/construct
	has_hydration = FALSE
	has_nutrition = FALSE

/datum/hud_data/technomancer_golem
	has_hydration = FALSE
	has_nutrition = FALSE

	gear = list(
		"l_ear" =        list("loc" = ui_shoes,     "name" = "left ear",     "slot" = slot_l_ear,     "state" = "l_ear",  "toggle" = 1),
		"back" =         list("loc" = ui_back,      "name" = "back",         "slot" = slot_back,      "state" = "back", "slot_type" = /obj/screen/inventory/back),
		"id" =           list("loc" = ui_id,        "name" = "id",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "left pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "right pocket", "slot" = slot_r_store,   "state" = "pocket")
		)