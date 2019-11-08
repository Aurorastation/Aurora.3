#define M_UNDER "Male underwear"
#define F_UNDER "Female underwear"
#define M_SOCKS "Male socks"
#define F_SOCKS "Female socks"
#define U_SHIRT "Undershirt"

/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	density = 1

/obj/structure/undies_wardrobe/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = user
	if(!ishuman(user) || (H.species && !(H.species.appearance_flags & HAS_UNDERWEAR)) && !(H.species.appearance_flags & HAS_SOCKS))
		to_chat(user, "<span class='warning'>Sadly there's nothing in here for you to wear.</span>")
		return 0


	var/list/selection_types = list()
	if (H.species.appearance_flags & HAS_UNDERWEAR)
		selection_types += list(M_UNDER, F_UNDER, U_SHIRT)
	if (H.species.appearance_flags & HAS_SOCKS)
		selection_types += list(M_SOCKS, F_SOCKS)

	var/utype = input("Which section do you want to pick from?") as null|anything in selection_types
	var/list/selection
	switch(utype)
		if(M_UNDER)
			selection = underwear_m
		if(F_UNDER)
			selection = underwear_f
		if(U_SHIRT)
			selection = undershirt_t
		if(M_SOCKS)
			selection = socks_m
		if(F_SOCKS)
			selection = socks_f
	var/pick = input("Select the style") as null|anything in selection
	if(pick)
		if(get_dist(src,user) > 1)
			return
		switch (utype)
			if(U_SHIRT)
				H.undershirt = undershirt_t[pick]
			if(F_SOCKS)
				H.socks = selection[pick]
			if(M_SOCKS)
				H.socks = selection[pick]
			if(M_UNDER)
				H.underwear = selection[pick]
			if(F_UNDER)
				H.underwear = selection[pick]

		H.update_underwear(TRUE)

	return 1

#undef M_UNDER
#undef F_UNDER
#undef M_SOCKS
#undef F_SOCKS
#undef U_SHIRT
