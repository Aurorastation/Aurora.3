//Remember, +1 accuracy means that accuracy is calculated 1 tile closer. -1 is the opposite.

//accuracy = PISTOL_ACCURACY_UNWIELDED
//accuracy_wielded = PISTOL_ACCURACY_WIELDED

//For lightweight pistols and whatnot
#define PISTOL_ACCURACY_WIELDED 1
#define PISTOL_ACCURACY_UNWIELDED -8

//For heavy, special pistols that would cause the balance gods to shed a tear if dual wielded.
#define HEAVY_PISTOL_ACCURACY_WIELDED 1
#define HEAVY_PISTOL_ACCURACY_UNWIELDED -12

//For SMGs meant to be held with two hands, but can be held with one hand for a small penalty
#define SMG_ACCURACY_WIELDED 2
#define SMG_ACCURACY_UNWIELDED -12

//For rifles that are meant to be held with two hands.
#define RIFLE_ACCURACY_WIELDED 3
#define RIFLE_ACCURACY_UNWIELDED -12

//For heavy weapons that are difficult to fire with one hand
#define HEAVY_ACCURACY_WIELDED 2
#define HEAVY_ACCURACY_UNWIELDED -16

//For weapons that rely on scopes to be accurate
#define SNIPER_ACCURACY_WIELDED -6
#define SNIPER_ACCURACY_UNWIELDED -20

//For shotgun-like weapons.
#define SHOTGUN_ACCURACY_WIELDED 1
#define SHOTGUN_ACCURACY_UNWIELDED -10

//For magic wands and staves
#define STAFF_ACCURACY_WIELDED 3
#define STAFF_ACCURACY_UNWIELDED -8