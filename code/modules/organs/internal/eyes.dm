/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = BP_EYES
	parent_organ = BP_HEAD
	robotic_name = "optical sensors"
	max_damage = 45
	min_broken_damage = 25
	relative_size = 5
	var/list/eye_colour = list(0,0,0)
	var/singular_name = "eye"

/obj/item/organ/internal/eyes/proc/update_colour()
	if(!owner)
		return
	eye_colour = list(
		owner.r_eyes ? owner.r_eyes : 0,
		owner.g_eyes ? owner.g_eyes : 0,
		owner.b_eyes ? owner.b_eyes : 0
		)

/obj/item/organ/internal/eyes/proc/change_eye_color()
	set name = "Change Eye Color"
	set desc = "Changes your robotic eye color."
	set category = "IC"
	set src in usr
	if (owner.incapacitated())
		return
	var/new_eyes = input("Please select eye color.", "Eye Color", rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)) as color|null
	if(new_eyes)
		var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
		var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
		var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
		if(do_after(owner, 5) && owner.change_eye_color(r_eyes, g_eyes, b_eyes))
			owner.update_eyes()
			owner.visible_message("<span class='notice'>[owner] shifts, their eye color changing.</span>", "<span class='notice'>You shift, your eye color changing.</span>")

/obj/item/organ/internal/eyes/take_damage(amount, var/silent=0)
	var/oldbroken = is_broken()
	. = ..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		to_chat(owner, "<span class='danger'>You go blind!</span>")

/obj/item/organ/internal/eyes/flash_act(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, ignore_inherent = FALSE, type = /obj/screen/fullscreen/flash, length = 2.5 SECONDS)
	var/burnthrough = intensity - owner.get_flash_protection(ignore_inherent)
	if(burnthrough <= 0)
		return

	if(burnthrough == 1)
		to_chat(owner, SPAN_WARNING("Your eyes sting a little."))
		take_damage(rand(1, 3), TRUE)
	else if(burnthrough == 2)
		to_chat(owner, SPAN_WARNING("Your eyes burn!"))
		take_damage(rand(3, 5), TRUE)
	else if(burnthrough >= 3)
		to_chat(owner, SPAN_DANGER("[FONT_HUGE("Your eyes burn from the intense light of the flash!")]"))
		take_damage(rand(5, 9), TRUE)
		owner.eye_blurry += rand(12, 20)

	if(is_bruised() && !is_broken() && !(owner.disabilities & NEARSIGHTED))
		to_chat(owner, SPAN_DANGER("The intense light is making it harder to see..."))
		owner.disabilities |= NEARSIGHTED
		addtimer(CALLBACK(owner, /mob/proc/remove_nearsighted), 10 SECONDS)

	return TRUE

/obj/item/organ/internal/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20

/obj/item/organ/internal/eyes/do_surge_effects()
	if(owner)
		owner.overlay_fullscreen("noise", /obj/screen/fullscreen/flash/noise)

/obj/item/organ/internal/eyes/clear_surge_effects()
	if(owner)
		owner.clear_fullscreen("noise")

/obj/item/organ/internal/eyes/robotize()
	..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color
