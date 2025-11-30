/*ALL DEFINES RELATED TO INVENTORY OBJECTS, MANAGEMENT, ETC, GO HERE*/

//ITEM INVENTORY WEIGHT, FOR w_class
/// Usually items smaller then a human hand, (e.g. playing cards, lighter, scalpel, coins/holochips)
#define WEIGHT_CLASS_TINY 1
/// Pockets can hold small and tiny items, (e.g. flashlight, multitool, grenades, GPS device)
#define WEIGHT_CLASS_SMALL 2
/// Standard backpacks can carry tiny, small & normal items, (e.g. fire extinguisher, stun baton, gas mask, metal sheets)
#define WEIGHT_CLASS_NORMAL 3
/// Items that can be wielded or equipped but not stored in an inventory, (e.g. defibrillator, backpack, space suits)
#define WEIGHT_CLASS_BULKY 4
/// Usually represents objects that require two hands to operate, (e.g. shotgun, two-handed melee weapons)
#define WEIGHT_CLASS_HUGE 5
/// Essentially means it cannot be picked up or placed in an inventory, (e.g. mech parts, safe)
#define WEIGHT_CLASS_GIGANTIC 6
// Use this to forbid item from being placed in a container.
#define WEIGHT_CLASS_NO_CONTAINER INFINITY

#define BASE_STORAGE_COST(w_class) (2**(w_class-1)) //1,2,4,8,16,...

//linear increase. Using many small storage containers is more space-efficient than using large ones,
//in exchange for being limited in the w_class of items that will fit
#define BASE_STORAGE_CAPACITY(w_class) (7*(w_class-1))

// "max_storage_space" Defines
/// max_storage_space = 56
#define DEFAULT_HOLDING_STORAGE   BASE_STORAGE_CAPACITY(9)
/// max_storage_space = 35
#define DEFAULT_DUFFELBAG_STORAGE BASE_STORAGE_CAPACITY(6)
/// max_storage_space = 28
#define DEFAULT_BACKPACK_STORAGE  BASE_STORAGE_CAPACITY(5)
/// max_storage_space = 21
#define DEFAULT_LARGEBOX_STORAGE  BASE_STORAGE_CAPACITY(4)
/// max_storage_space = 14
#define DEFAULT_BOX_STORAGE       BASE_STORAGE_CAPACITY(3)
