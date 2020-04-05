/spell/targeted/lichdom
	name = "Lichdom"
	desc = "Trade your life and soul for immortality and power."
	feedback = "LID"
	range = 0
	school = "necromancy"
	charge_max = 10000
	spell_flags = Z2NOCAST | NEEDSCLOTHES | INCLUDEUSER
	invocation_type = SpI_EMOTE
	invocation = "entones an obscure chant..."
	max_targets = 1
	level_max = list(Sp_TOTAL = 0, Sp_SPEED = 0, Sp_POWER = 0)

	cast_sound = 'sound/magic/pope_entry.ogg'

	hud_state = "wiz_lich"

/spell/targeted/lichdom/cast(mob/target,var/mob/living/carbon/human/user as mob)
	..()
	if(isundead(user))
		to_chat(user, "You have no soul or life to offer.")
		return 0

	user.visible_message("<span class='cult'>\The [user]'s skin sloughs off bone, their blood boils and guts turn to dust!</span>")
	gibs(user.loc)
	user.add_spell(new /spell/targeted/dark_resurrection)
	user.set_species("Skeleton")
	user.unEquip(user.wear_suit)
	user.unEquip(user.head)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/black(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/black(user), slot_head)
	to_chat(user, "<span class='notice'>Your soul flee to the remains of your heart, turning it into your phylactery. Do not allow anyone to destroy it!</span>")
	var/obj/item/phylactery/G = new(get_turf(user))
	G.lich = user
	G.icon_state = "cursedheart-on"
	user.remove_spell(src)
	return 1