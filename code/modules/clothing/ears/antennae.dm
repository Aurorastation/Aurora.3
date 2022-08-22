//ipc 'pins'

/obj/item/clothing/ears/antenna
	name = "antenna"
	slot_flags = SLOT_HEAD | SLOT_EARS
	body_parts_covered = 0
	matter = list(DEFAULT_WALL_MATERIAL = 10)
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/clothing/ears/antenna/verb/lock_antennae()
	set name = "Lock Antenna(e)"
	set desc = "Lock your antenna(e) in place."
	set category = "Object"

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if(use_check_and_message(user))
		return

	if(!user.isSynthetic())
		to_chat(user, SPAN_WARNING("The locking mechanism refuses to work!"))
		return

	if(user.r_ear != src && user.l_ear != src)
		to_chat(user, SPAN_WARNING("Your antennae must be on your head for the locking mechanism to work."))
		return

	to_chat(user, SPAN_NOTICE("You [canremove ? "enable" : "disable"] the locking mechanism on your antennae."))
	playsound(user, canremove ? 'sound/machines/hatch_close.ogg' : 'sound/machines/hatch_open.ogg', 25)
	canremove = !canremove

/obj/item/clothing/ears/antenna/curved
	name = "curved antennae"
	desc = "A set of decorative antennae. This particular pair is curved in the middle point, arcing upwards. Unfortunately, it doesn't get FM here."
	icon_state = "curvedantennae"
	item_state = "curvedantennae"

/obj/item/clothing/ears/antenna/straight
	name = "straight antennae"
	desc = "A set of decorative antennae. This particular pair is straight, jutting out to what is reasonably shoulder width. They don't seem to plug into anything."
	icon_state = "straightantennae"
	item_state = "straightantennae"

/obj/item/clothing/ears/antenna/circle
	name = "circle antennae"
	desc = "A set of decorative antennae. This particular pair is circular, mimicking a sattelite dish. Still better than cable, though."
	icon_state = "circleantennae"
	item_state = "circleantennae"

/obj/item/clothing/ears/antenna/tusk
	name = "tusk antennae"
	desc = "A set of decorative antennae. This particular pair is stylized like animal tusks, for combat down the runway, of course."
	icon_state = "tusk"
	item_state = "tusk"

/obj/item/clothing/ears/antenna/horncrown
	name = "horn crown antennae"
	desc = "A set of decorative antennae. This particular pair is in a spring shape, attached to a large chassis. Careful for doorways."
	icon_state = "horncrown"
	item_state = "horncrown"

/obj/item/clothing/ears/antenna/horn
	name = "horn antennae"
	desc = "A set of decorative antennae. This particular pair is in a spring shape, mimicking animal horns."
	icon_state = "dual_horn"
	item_state = "dual_horn"

/obj/item/clothing/ears/antenna/horn/single
	name = "horn antenna"
	desc = "A set of decorative antennae. This particular one is in a spring shape, mimicking an animal's horn."
	icon_state = "horn"
	item_state = "horn"

/obj/item/clothing/ears/antenna/dish
	name = "antenna dishes"
	desc = "A set of decorative antennae. This particular one is stylized as two tiny dishes, intended to hold excess wiring in a very specific manner. If only they picked up holodramas."
	icon_state = "dual_dish"
	item_state = "dual_dish"

/obj/item/clothing/ears/antenna/whip
	name = "whip antennae"
	desc = "A set of decorative antennae. Despite being commonly seen on Shells, nobody knows what these actually do."
	icon_state = "dual_whip"
	item_state = "dual_whip"

/obj/item/clothing/ears/antenna/whip/single
	name = "whip antenna"
	desc = "A decorative antenna. Despite being commonly seen on Shells, nobody knows what these actually do."
	icon_state = "whip"
	item_state = "whip"

/obj/item/clothing/ears/antenna/trinary_halo
	name = "trinary perfection antenna"
	desc = "A decorative antenna that is commonly worn by IPCs who serve the Trinary Perfection. It resembles a golden gear."
	icon_state = "trinary_halo"
	item_state = "trinary_halo"
