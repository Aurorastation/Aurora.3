/obj/machinery/commsjammer
	name = "machinery amalgamation"
	desc = "SSome machinery jury-rigged from several different parts.."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "jammer"
	density = TRUE
	layer = TURF_LAYER + 0.1
	anchored = TRUE
	idle_power_usage = 300
	active_power_usage = 90 KILOWATTS

/obj/machinery/commsjammer/Initialize()
	. = ..()
	add_overlay("jammer-overlay")

/obj/machinery/commsjammer/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W))
		return
	if(user.a_intent == I_HURT)
		if (W.force >= 10)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			visible_message(span("notice", "[user] smashes \the [src]!"))
			var/T = get_turf(src)
			new /obj/effect/gibspawner/robot(T)
			spark(T, 3, alldirs)
			qdel(src)
		else
			visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")