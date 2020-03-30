/obj/item/contract
	name = "contract"
	desc = "written in the blood of some unfortunate fellow."
	icon = 'icons/mob/screen/spells.dmi'
	icon_state = "master_open"

	var/contract_master = null
	var/list/contract_spells = list(/spell/contract/reward,/spell/contract/punish,/spell/contract/return_master)

/obj/item/contract/attack_self(mob/user as mob)
	if(contract_master == null)
		to_chat(user, "<span class='notice'>You bind the contract to your soul, making you the recipient of whatever poor fool's soul that decides to contract with you.</span>")
		contract_master = user
		return

	if(contract_master == user)
		to_chat(user, "You can't contract with yourself!")
		return

	if(iscultist(user))
		to_chat(user, "Your soul already belongs to other powers!")
		return

	var/ans = alert(user,"The contract clearly states that signing this contract will bind your soul to \the [contract_master]. Are you sure you want to continue?","[src]","Yes","No")

	if(ans == "Yes")
		user.visible_message("\The [user] signs the contract, their body glowing a deep yellow.")
		if(!src.contract_effect(user))
			user.visible_message("\The [src] visibly rejects \the [user], erasing their signature from the line.")
			return
		user.visible_message("\The [src] disappears with a flash of light.")
		if(contract_spells.len && istype(contract_master,/mob/living)) //if it aint text its probably a mob or another user
			var/mob/living/M = contract_master
			for(var/spell_type in contract_spells)
				M.add_spell(new spell_type(user), "const_spell_ready")
		log_and_message_admins("signed their soul over to \the [contract_master] using \the [src].", user)
		qdel(src)

/obj/item/contract/proc/contract_effect(mob/user as mob)
	to_chat(user, "<span class='warning'>You've signed your soul over to \the [contract_master] and with that your unbreakable vow of servitude begins.</span>")
	return 1