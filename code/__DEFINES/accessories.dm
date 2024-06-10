// Accesssory Slots
#define ACCESSORY_GENERIC			BITFLAG(1)
#define ACCESSORY_UTILITY			BITFLAG(2)
#define ACCESSORY_ARMOR_PLATE		BITFLAG(3)
#define ACCESSORY_LEG_GUARDS		BITFLAG(4)
#define ACCESSORY_ARM_GUARDS		BITFLAG(5)

#define ACCESSORY_SLOT_UNIFORM		BITFLAG(1)
#define ACCESSORY_SLOT_SUIT			BITFLAG(2)
#define ACCESSORY_SLOT_ARMOR		BITFLAG(3)
#define ACCESSORY_SLOT_HEAD         BITFLAG(4)
#define ACCESSORY_SLOT_HELMET		BITFLAG(5)

// Accessory Weight Classes

/// Doesn't increase size
#define ACCESSORY_WEIGHT_NONE 0

/// Two accessories can be attached but will only increase size by one
#define ACCESSORY_WEIGHT_HALF_UNIT 0.5

// This accessory will increase the size by one
#define ACCESSORY_WEIGHT_ONE_UNIT 1
