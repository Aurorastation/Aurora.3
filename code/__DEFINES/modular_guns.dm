#define CHASSIS_SMALL 2
#define CHASSIS_MEDIUM 3
#define CHASSIS_LARGE 4

#define MOD_SILENCE 1
#define MOD_NUCLEAR_CHARGE 2

#define islasercapacitor(A) istype(A, /obj/item/laser_components/capacitor)
#define ismodifier(A) istype(A, /obj/item/laser_components/modifier)
#define ismodulator(A) istype(A, /obj/item/laser_components/modulator)
#define isfocusinglens(A) istype(A, /obj/item/laser_components/focusing_lens)
