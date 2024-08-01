#define is_multi_tile_object(atom) (atom.bound_width > world.icon_size || atom.bound_height > world.icon_size)


#define isAI(A) istype(A, /mob/living/silicon/ai)
#define isDrone(A) istype(A, /mob/living/silicon/robot/drone)
#define isMatriarchDrone(A) istype(A, /mob/living/silicon/robot/drone/construction/matriarch)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define isvirtualmob(A) istype(A, /mob/abstract/observer/virtual)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define isEye(A) istype(A, /mob/abstract/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define ismech(A) istype(A, /mob/living/heavy_vehicle)

#define isliving(A) istype(A, /mob/living)

#define israt(A) istype(A, /mob/living/simple_animal/rat)

#define isnewplayer(A) istype(A, /mob/abstract/new_player)

#define isobj(A) istype(A, /obj)

#define isspace(A) istype(A, /area/space)

#define isspaceturf(A) istype(A, /turf/space)

#define isobserver(A) istype(A, /mob/abstract/observer)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isbot(A) istype(A, /mob/living/bot)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define iscapacitor(A) istype(A, /obj/item/stock_parts/capacitor)

#define ismicrolaser(A) istype(A, /obj/item/stock_parts/micro_laser)

#define ismatterbin(A) istype(A, /obj/item/stock_parts/matter_bin)

#define isscanner(A) istype(A, /obj/item/stock_parts/scanning_module)

#define ismanipulator(A) istype(A, /obj/item/stock_parts/manipulator)

#define isclient(A) istype(A, /client)

#define isclothing(A) istype(A, /obj/item/clothing)
#define isaccessory(A) istype(A, /obj/item/clothing/accessory)

/// Projectile helpers
#define isprojectile(A) istype(A, /obj/projectile)
#define isbeam(A) istype(A, /obj/projectile/beam)
#define isenergy(A) istype(A, /obj/projectile/energy)
