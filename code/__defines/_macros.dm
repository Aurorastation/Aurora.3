#define Clamp(x, low, high) 	max(low, min(high, x))
#define CLAMP01(x) 		(Clamp(x, 0, 1))
#define JOINTEXT(X) jointext(X, null)
#define list_find(L, needle, LIMITS...) L.Find(needle, LIMITS)
#define hex2num(hex) text2num(hex, 16)
#define num2hex(num, pad) num2text(num, pad, 16)

#define span(class, text) ("<span class='[class]'>" + text + "</span>")
#define SPAN_NOTICE(X) ("<span class='notice'>" + X + "</span>")
#define SPAN_WARNING(X) ("<span class='warning'>" + X + "</span>")
#define SPAN_DANGER(X) ("<span class='danger'>" + X + "</span>")
#define SPAN_CULT(X) ("<span class='cult'>" + X + "</span>")
#define SPAN_GOOD(X) ("<span class='good'>" + X + "</span>")
#define SPAN_BAD(X) ("<span class='bad'>" + X + "</span>")
#define SPAN_ALIEN(X) ("<span class='alium'>" + X + "</span>")
#define SPAN_ALERT(X) ("<span class='alert'>" + X + "</span>")
#define SPAN_INFO(X) ("<span class='info'>" + X + "</span>")
#define SPAN_ITALIC(X) ("<span class='italic'>" + X + "</span>")
#define SPAN_BOLD(X) ("<span class='bold'>" + X + "</span>")
#define SPAN_SUBTLE(X) ("<span class='subtle'>" + X + "</span>")
#define SPAN_SOGHUN(X) ("<span class='soghun'>" + X + "</span>")
#define SPAN_VOTE(X) ("<span class='vote'>" + X + "</span>")

#define SPAN_HIGHDANGER(X) (FONT_LARGE(SPAN_DANGER(X)))

#define FONT_SIZE_SMALL 1
#define FONT_SIZE_NORMAL 2
#define FONT_SIZE_LARGE 3
#define FONT_SIZE_HUGE 4
#define FONT_SIZE_GIANT 5

#define FONT_SMALL(X) ("<font size='1'>" + X + "</font>")
#define FONT_NORMAL(X) ("<font size='2'>" + X + "</font>")
#define FONT_LARGE(X) ("<font size='3'>" + X + "</font>")
#define FONT_HUGE(X) ("<font size='4'>" + X + "</font>")
#define FONT_GIANT(X) ("<font size='5'>" + X + "</font>")

#define MATRIX_DANGER(X) (FONT_LARGE(SPAN_DANGER(X)))
#define MATRIX_NOTICE(X) (FONT_LARGE(SPAN_NOTICE(X)))

#define UNDERSCORE_OR_NULL(target) "[target ? "[target]_" : ""]"

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

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

#define isprojectile(A) istype(A, /obj/item/projectile)

#define isclothing(A) istype(A, /obj/item/clothing)

/// General I/O helpers
#define to_target(target, payload)                          target << (payload)
#define from_target(target, receiver)                       target >> (receiver)
#define to_file(file_entry, file_content)                   file_entry << file_content

#define legacy_chat(target, message)                        to_target(target, message)
#define to_world(message)                                   to_chat(world, message)
#define sound_to(target, sound)                             to_target(target, sound)
#define to_save(handle, value)                              to_target(handle, value) //semantics postport: what did they mean by this
#define show_browser(target, browser_content, browser_name) to_target(target, browse(browser_content, browser_name))
#define send_rsc(target, content, title)                    to_target(target, browse_rsc(content, title))
#define send_output(target, msg, control)                   to_target(target, output(msg, control))
#define send_link(target, url)                              to_target(target, link(url))

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define isopenturf(target) istype(target, /turf/simulated/open)
#define isweakref(target) istype(target, /datum/weakref)
#define isopenspace(A) istype(A, /turf/simulated/open)
#define isatom(D) istype(D, /atom)
#define isdatum(target) istype(target, /datum)
#define isitem(D) istype(D, /obj/item)
#define islist(D) istype(D, /list)
