/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = BP_EYES
	parent_organ = BP_HEAD
	robotic_name = "optical sensors"
	robotic_sprite = "eyes-prosthetic"
	max_damage = 45
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
	..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		to_chat(owner, "<span class='danger'>You go blind!</span>")

/obj/item/organ/internal/eyes/proc/flash_act()
	return

/obj/item/organ/internal/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20

/obj/item/organ/internal/eyes/robotize()
	..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color
