#define HUMAN_STRIP_DELAY        40   // Takes 40ds = 4s to strip someone.

#define CANDLE_LUM 3 // For how bright candles are.

// Item inventory slot bitmasks.
#define SLOT_OCLOTHING  BITFLAG(0)
#define SLOT_ICLOTHING  BITFLAG(1)
#define SLOT_GLOVES     BITFLAG(2)
#define SLOT_EYES       BITFLAG(3)
#define SLOT_EARS       BITFLAG(4)
#define SLOT_MASK       BITFLAG(5)
#define SLOT_HEAD       BITFLAG(6)
#define SLOT_FEET       BITFLAG(7)
#define SLOT_ID         BITFLAG(8)
#define SLOT_BELT       BITFLAG(9)
#define SLOT_BACK       BITFLAG(10)
#define SLOT_POCKET     BITFLAG(11) // This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_TWOEARS    BITFLAG(12)
#define SLOT_TIE        BITFLAG(13)
#define SLOT_HOLSTER    BITFLAG(14)
#define SLOT_WRISTS     BITFLAG(15)
#define SLOT_S_STORE    BITFLAG(16)
#define SLOT_PANTS      BITFLAG(17)

// Bitmasks for the flags_inv variable. These determine when a piece of clothing hides another, i.e. a helmet hiding glasses.
#define HIDEGLOVES      0x1
#define HIDESUITSTORAGE 0x2
#define HIDEJUMPSUIT    0x4
#define HIDESHOES       0x8
#define HIDETAIL        0x10
#define HIDEMASK        0x20
#define HIDEEARS		0x40 // Headsets and such.
#define HIDEEYES		0x80 // Glasses.
#define HIDEFACE		0x100// Dictates whether we appear as "Unknown".
#define HIDEWRISTS		0x200
#define HIDEPANTS		0x400
#define BLOCKHEADHAIR   0x800// Hides the user's hair overlay. Leaves facial hair.
#define BLOCKHAIR       0x1000/// Hides the user's hair, facial and otherwise.
#define ALWAYSDRAW		0x2000//If set, this item is always rendered even if its slot is hidden by other clothing
//Note that the item may still not be visible if its sprite is actually covered up.

// Inventory slot strings.
// since numbers cannot be used as associative list keys.
//icon_back, icon_l_hand, etc would be much better names for these...
#define slot_back_str		"slot_back"
#define slot_wear_id_str	"slot_wear_id"
#define slot_w_uniform_str	"slot_w_uniform"
#define slot_s_store_str	"slot_s_store"
#define slot_head_str		"slot_head"
#define slot_glasses_str 	"slot_glasses"
#define slot_wear_mask_str	"slot_mask"
#define slot_belt_str		"slot_belt"
#define slot_wear_suit_str	"slot_suit"
#define slot_l_ear_str		"slot_l_ear"
#define slot_r_ear_str		"slot_r_ear"
#define slot_pants_str		"slot_pants"
#define slot_shoes_str 		"slot_shoes"
#define slot_wrists_str 	"slot_wrists"
#define slot_gloves_str 	"slot_gloves"
#define slot_tail_str		"slot_tail"
#define slot_handcuffed_str	"slot_handcuffed"
#define slot_l_store_str	"slot_l_store"
#define slot_r_store_str	"slot_r_store"
#define slot_legcuffed_str	"slot_legcuffed"
#define slot_tie_str		"slot_tie"

// fake slots
#define slot_in_backpack_str "slot_in_backpack"
#define slot_in_belt_str	"slot_in_belt"

GLOBAL_LIST_INIT(all_inventory_slots, list(
	slot_back_str,
	BP_L_HAND,
	BP_R_HAND,
	slot_wear_id_str,
	slot_w_uniform_str,
	slot_s_store_str,
	slot_head_str,
	slot_glasses_str,
	slot_wear_mask_str,
	slot_belt_str,
	slot_wear_suit_str,
	slot_l_ear_str,
	slot_r_ear_str,
	slot_pants_str,
	slot_shoes_str,
	slot_wrists_str,
	slot_gloves_str,
	slot_tail_str,
	slot_handcuffed_str,
	slot_l_store_str,
	slot_r_store_str,
	slot_legcuffed_str,
	slot_tie_str,
))

//itemstate suffixes. Used for containedsprite worn items
#define WORN_LHAND	"_lh"
#define WORN_RHAND	"_rh"
#define WORN_LSTORE	"_ls"
#define WORN_RSTORE "_rs"
#define WORN_SSTORE "_ss"
#define WORN_LEAR 	"_le"
#define WORN_REAR 	"_re"
#define WORN_HEAD 	"_he"
#define WORN_UNDER 	"_un"
#define WORN_SUIT 	"_su"
#define WORN_GLOVES	"_gl"
#define WORN_SHOES	"_sh"
#define WORN_EYES	"_ey"
#define WORN_BELT	"_be"
#define WORN_BACK	"_ba"
#define WORN_ID		"_id"
#define WORN_MASK	"_ma"
#define WORN_WRISTS	"_wr"
#define WORN_PANTS	"_pa"
#define WORN_ACCESS	"_ac"

// Bitflags for clothing parts.
#define HEAD        BITFLAG(0)
#define FACE        BITFLAG(1)
#define EYES        BITFLAG(2)
#define UPPER_TORSO BITFLAG(3)
#define LOWER_TORSO BITFLAG(4)
#define LEG_LEFT    BITFLAG(5)
#define LEG_RIGHT   BITFLAG(6)
#define LEGS        (LEG_LEFT | LEG_RIGHT)
#define FOOT_LEFT   BITFLAG(7)
#define FOOT_RIGHT  BITFLAG(8)
#define FEET        (FOOT_LEFT | FOOT_RIGHT)
#define ARM_LEFT    BITFLAG(9)
#define ARM_RIGHT   BITFLAG(10)
#define ARMS        (ARM_LEFT | ARM_RIGHT)
#define HAND_LEFT   BITFLAG(11)
#define HAND_RIGHT  BITFLAG(12)
#define HANDS       (HAND_LEFT | HAND_RIGHT)
#define FULL_BODY   (HEAD | FACE | EYES | UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS)

GLOBAL_LIST_INIT(bp_to_coverage, list(
	BP_HEAD = HEAD,
	BP_EYES = EYES,
	BP_MOUTH = FACE,
	BP_CHEST = UPPER_TORSO,
	BP_GROIN = LOWER_TORSO,
	BP_L_ARM = ARM_LEFT,
	BP_R_ARM = ARM_RIGHT,
	BP_L_HAND = HAND_LEFT,
	BP_R_HAND = HAND_RIGHT,
	BP_L_LEG = LEG_LEFT,
	BP_R_LEG = LEG_RIGHT,
	BP_L_FOOT = FOOT_LEFT,
	BP_R_FOOT = FOOT_RIGHT
))

// Bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection().
// The values here should add up to 1, e.g., the head has 30% protection.
#define THERMAL_PROTECTION_HEAD        0.3
#define THERMAL_PROTECTION_UPPER_TORSO 0.15
#define THERMAL_PROTECTION_LOWER_TORSO 0.15
#define THERMAL_PROTECTION_LEG_LEFT    0.075
#define THERMAL_PROTECTION_LEG_RIGHT   0.075
#define THERMAL_PROTECTION_FOOT_LEFT   0.025
#define THERMAL_PROTECTION_FOOT_RIGHT  0.025
#define THERMAL_PROTECTION_ARM_LEFT    0.075
#define THERMAL_PROTECTION_ARM_RIGHT   0.075
#define THERMAL_PROTECTION_HAND_LEFT   0.025
#define THERMAL_PROTECTION_HAND_RIGHT  0.025

// Pressure limits.
#define  HAZARD_HIGH_PRESSURE 550 // This determines at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define WARNING_HIGH_PRESSURE 325 // This determines when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define  HAZARD_LOW_PRESSURE  20  // This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)
#define WARNING_LOW_PRESSURE  50  // This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)

#define FIRESUIT_MAX_PRESSURE       20 * ONE_ATMOSPHERE  // Firesuits and atmos voidsuits
#define RIG_MAX_PRESSURE            10 * ONE_ATMOSPHERE  // Rigs
#define LIGHT_RIG_MAX_PRESSURE       5 * ONE_ATMOSPHERE  // Rigs
#define ENG_VOIDSUIT_MAX_PRESSURE   10 * ONE_ATMOSPHERE
#define VOIDSUIT_MAX_PRESSURE        5 * ONE_ATMOSPHERE
#define SPACE_SUIT_MAX_PRESSURE      2 * ONE_ATMOSPHERE

#define FIRESUIT_MIN_PRESSURE        0.5 * ONE_ATMOSPHERE

#define TEMPERATURE_DAMAGE_COEFFICIENT  1.5 // This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR   12  // This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM   1   // Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_COLD_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_COOLING_MAX           -30  // The maximum number of degrees that your body can cool down in 1 tick, when in a cold area.
#define BODYTEMP_HEATING_MAX            30  // The maximum number of degrees that your body can heat up in 1 tick,   when in a hot  area.

#define BODYTEMP_HEAT_DAMAGE_LIMIT 360.15 // The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_COLD_DAMAGE_LIMIT 260.15 // The limit the human body can take before it starts taking damage from coldness.

#define SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define   SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define       HELMET_MIN_COLD_PROTECTION_TEMPERATURE 160 // For normal helmets.
#define        ARMOR_MIN_COLD_PROTECTION_TEMPERATURE 160 // For armor.
#define       GLOVES_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For some gloves.
#define         SHOE_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For shoes.

#define   SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE 5000  // These need better heat protect, but not as good heat protect as firesuits.
#define     FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // What max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define  FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // For fire-helmet quality items. (Red and white hardhats)
#define       HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For normal helmets.
#define        ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For armor.
#define       GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For some gloves.
#define         SHOE_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For shoes.

// Fire.
#define FIRE_MIN_STACKS          -20
#define FIRE_MAX_STACKS           25

#define THROWFORCE_SPEED_DIVISOR    5  // The throwing speed value at which the throwforce multiplier is exactly 1.
#define THROWNOBJ_KNOCKBACK_SPEED   15 // The minumum speed of a w_class 2 thrown object that will cause living mobs it hits to be knocked back. Heavier objects can cause knockback at lower speeds.
#define THROWNOBJ_KNOCKBACK_DIVISOR 2  // Affects how much speed the mob is knocked back with.

// Suit sensor levels
#define SUIT_SENSOR_OFF      0
#define SUIT_SENSOR_BINARY   1
#define SUIT_SENSOR_VITAL    2
#define SUIT_SENSOR_TRACKING 3

#define SUIT_SENSOR_MODES list("Off" = SUIT_SENSOR_OFF, "Binary sensors" = SUIT_SENSOR_BINARY, "Vitals tracker" = SUIT_SENSOR_VITAL, "Tracking beacon" = SUIT_SENSOR_TRACKING)

#define SUIT_NO_SENSORS EMPTY_BITFIELD
#define SUIT_HAS_SENSORS FLAG(0)
#define SUIT_LOCKED_SENSORS FLAG(1)

// Modifiers for injections, used for syringes, hyposprays, and overloaders.
#define INJECTION_FAIL     0
#define BASE_INJECTION_MOD 1 // x1 multiplier with no effects
#define SUIT_INJECTION_MOD 2 // x2 multiplier if target is wearing spacesuit
