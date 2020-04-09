#define Clamp(x, low, high) 	max(low, min(high, x))
#define CLAMP01(x) 		(Clamp(x, 0, 1))

#define span(class, text) "<span class='[class]'>[text]</span>"
#define SPAN_NOTICE(X) "<span class='notice'>[X]</span>"
#define SPAN_WARNING(X) "<span class='warning'>[X]</span>"
#define SPAN_DANGER(X) "<span class='danger'>[X]</span>"
#define SPAN_CULT(X) "<span class='cult'>[X]</span>"
#define SPAN_GOOD(X) "<span class='good'>[X]</span>"
#define SPAN_BAD(X) "<span class='bad'>[X]</span>"
#define SPAN_ALIEN(X) "<span class='alium'>[X]</span>"
#define SPAN_ALERT(X) "<span class='alert'>[X]</span>"
#define SPAN_ITALIC(X) "<span class='italic'>[X]</span>"
#define SPAN_BOLD(X) "<span class='bold'>[X]</span>"
#define SPAN_SUBTLE(X) "<span class='subtle'>[X]</span>"

#define FONT_SMALL(X) "<font size='1'>[X]</font>"
#define FONT_NORMAL(X) "<font size='2'>[X]</font>"
#define FONT_LARGE(X) "<font size='3'>[X]</font>"
#define FONT_HUGE(X) "<font size='4'>[X]</font>"
#define FONT_GIANT(X) "<font size='5'>[X]</font>"

#define isAI(A) istype(A, /mob/living/silicon/ai)
#define isDrone(A) istype(A, /mob/living/silicon/robot/drone)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define isEye(A) istype(A, /mob/abstract/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define ismech(A) istype(A, /mob/living/heavy_vehicle)

#define isliving(A) istype(A, /mob/living)

#define israt(A) istype(A, /mob/living/simple_animal/rat)

#define isnewplayer(A) istype(A, /mob/abstract/new_player)

#define isobj(A) istype(A, /obj)

#define isobserver(A) istype(A, /mob/abstract/observer)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define iscapacitor(A) istype(A, /obj/item/stock_parts/capacitor)

#define ismicrolaser(A) istype(A, /obj/item/stock_parts/micro_laser)

#define ismatterbin(A) istype(A, /obj/item/stock_parts/matter_bin)

#define isscanner(A) istype(A, /obj/item/stock_parts/scanning_module)

#define ismanipulator(A) istype(A, /obj/item/stock_parts/manipulator)

#define isclient(A) istype(A, /client)

#define isprojectile(A) istype(A, /obj/item/projectile)

#define to_chat(target, message)                            target << message
#define to_world(message)                                   world << message
#define sound_to(target, sound)                             target << sound
#define to_file(file_entry, file_content)                   file_entry << file_content
#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)
#define send_rsc(target, rsc_content, rsc_name)             target << browse_rsc(rsc_content, rsc_name)
#define send_output(target, msg, control)                   target << output(msg, control)
#define send_link(target, url)                              target << link(url)

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define isopenturf(target) istype(target, /turf/simulated/open)
#define isweakref(target) istype(target, /datum/weakref)
#define isdatum(target) istype(target, /datum)
