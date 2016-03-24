/spell/targeted/equip_item/remove_horsemask
	name = "Free the Horseman"
	desc = "This spell lifts the Curse of the Horseman from the target. This spell does not require robes."
	school = "transmutation"
	charge_type = Sp_RECHARGE
	charge_max = 150
	charge_counter = 0
	spell_flags = SELECTABLE
	invocation = "KN'A EUTH, PUCK 'BTHNK!"
	invocation_type = SpI_SHOUT
	range = 7
	max_targets = 1
	cooldown_min = 30 //30 deciseconds reduction per rank
	selection_type = "range"

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "wiz_horse" //need to make a new HUD for remove_horsemask

/spell/targeted/equip_item/remove_horsemask/New()
	..()
	var/obj/item/clothing/mask/horsehead/magichead = new /obj/item/clothing/mask/horsehead
	remove_equipped = list("[slot_wear_mask]" = magichead)

/spell/targeted/equip_item/remove_horsemask/cast(list/targets, mob/user = usr)
	..()
	for(var/mob/living/target in targets)
		if (istype(target.wear_mask, /obj/item/clothing/mask/horsehead))
			target.visible_message(	"<span class='danger'>The horse head on [target]'s face lights up and burns away, revealing \his face.</span>", \
									"<span class='danger'>Your face burns up once more, but you suddenly realize that you are no longer wearing a silly horsemask!</span>")
			flick("e_flash", target.flash)
