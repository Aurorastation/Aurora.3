/obj/structure/monolith
	name = "monolith"
	desc = "An eldritch structure of unknown origin."
	icon = 'icons/adhomai/monolith.dmi'
	icon_state = "jaggy1"
	layer = ABOVE_MOB_LAYER
	density = 1
	anchored = 1
	var/active = 0

/obj/structure/monolith/Initialize()
	. = ..()
	icon_state = "jaggy[rand(1,4)]"
	var/color_choice = pick(LIGHT_COLOR_SCARLET, COLOR_LUMINOL, COLOR_BLUE_LIGHT, COLOR_CYAN, COLOR_SUN)
	color = color_choice

/obj/structure/monolith/update_icon()
	overlays.Cut()
	if(active)
		var/image/I = image(icon,"[icon_state]decor")
		I.appearance_flags = RESET_COLOR
		I.color = get_random_colour(0, 150, 255)
		I.layer = LIGHTING_LAYER + 0.001
		add_overlay(I)
		set_light(0.3, 0.1, 2, l_color = I.color)

/obj/structure/monolith/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	visible_message("[user] touches \the [src].")
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(!H.isSynthetic())
			active = 1
			update_icon()
			if(prob(70))

				var/engravings = ""
				engravings = "[pick("an image of","a frieze of","a depiction of")] \
				[pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")] \
				[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
				[pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")]"
				if(prob(50))
					engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
				engravings += "."

				to_chat(H, "<span class='notice'>As you touch \the [src], you suddenly get a vivid image - [engravings]</span>")

			else
				to_chat(H, "<span class='warning'>An overwhelming stream of information invades your mind!</span>")
				var/list/candidates = list()
				for(var/mob/living/carbon/human/L in human_mob_list)
					candidates += L
				var/vision = ""
				vision = "[pick(candidates)] \
				[pick("killing","dying","gored","expiring","exploding","mauled","burning","flayed","in agony")]"
				vision += "."
				to_chat(H, "<span class='danger'><font size=2>[uppertext(vision)]</font></span>")
				H.Paralyse(2)
				H.adjustBrainLoss(10)
			return
	to_chat(user, "<span class='notice'>\The [src] is still.</span>")
	return ..()