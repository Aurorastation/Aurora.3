/obj/item/contract/wizard/xray
	name = "xray vision contract"
	desc = "This contract is almost see-through..."
	color = "#339900"

/obj/item/contract/wizard/xray/contract_effect(mob/user as mob)
	..()
	if (!(XRAY in user.mutations))
		user.mutations.Add(XRAY)
		user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
		user.see_in_dark = 8
		user.see_invisible = SEE_INVISIBLE_LEVEL_TWO
		to_chat(user, "<span class='notice'>The walls suddenly disappear.</span>")
		return 1
	return 0