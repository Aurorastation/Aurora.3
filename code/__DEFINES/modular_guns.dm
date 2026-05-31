#define CHASSIS_SMALL 2
#define CHASSIS_MEDIUM 3
#define CHASSIS_LARGE 4

#define MOD_SILENCE 1
#define MOD_NUCLEAR_CHARGE 2

///The maximum improvement that can be applied to a weapon component.
#define IMPROVEMENT_CAP 100
///The maximum increase an individual variable can recieve over it's initial value.
#define INCREASE_CAP 2
///The maximum decrease an individual variable can recieve under it's initial value.
#define DECREASE_CAP 0.2
///All improvements are multiplied by this value, tweak down if they are too strong, up if they are too weak.
#define IMPROVEMENT_MULTIPLIER 1


#define islasercapacitor(A) istype(A, /obj/item/laser_components/capacitor)
#define ismodifier(A) istype(A, /obj/item/laser_components/modifier)
#define ismodulator(A) istype(A, /obj/item/laser_components/modulator)
#define isfocusinglens(A) istype(A, /obj/item/laser_components/focusing_lens)
