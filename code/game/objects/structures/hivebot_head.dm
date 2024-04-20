/obj/structure/hivebot_head
	name = "\improper Secondary Transmitter Drone core"
	desc = "The central core of the Hivebot Secondary Transmitter Drone - all that remains after the machine's destruction. Perhaps some data as to the threat can be gleaned from this?"
	icon = 'icons/obj/structure/hivebot_head.dmi'
	icon_state = "hivebot_head"
	w_class = ITEMSIZE_LARGE
	breakable = FALSE
	climbable = FALSE
	density = FALSE

/obj/structure/hivebot_head/ex_act(severity) //dont want it getting blown up
	return

/obj/structure/hivebot_head/attack_hand(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("\The [user] touches \the [src]."), SPAN_NOTICE("You touch \the [src]."))
	if(prob(10))
		var/T = get_turf(src)
		icon_state = "hivebot_head_active"
		playsound(src.loc, 'sound/effects/creatures/hivebot/hivebot-bark-005.ogg', 60)
		to_chat(user, SPAN_WARNING("\The [src] suddenly sparks and lights up, emitting some unintelligible noise!"))
		spark(T, 3, GLOB.alldirs)
		addtimer(CALLBACK(src, PROC_REF(deactivate)), 3 SECONDS)

/obj/structure/hivebot_head/proc/deactivate()
	icon_state = "hivebot_head"
	visible_message(SPAN_WARNING("\The [src] shudders and goes silent..."))
