/obj/item/contract/apprentice
	name = "apprentice wizarding contract"
	desc = "a wizarding school contract for those who want to sign their soul for a piece of the magic pie."
	color = "#993300"

/obj/item/contract/apprentice/contract_effect(mob/user as mob)
	if(user.mind.assigned_role == "Apprentice")
		to_chat(user, "<span class='warning'>You are already a wizarding apprentice!</span>")
		return 0
	if(wizards.add_antagonist_mind(user.mind,1,"Apprentice","<b>You are an apprentice! Your job is to learn the wizarding arts!</b>"))
		user.mind.assigned_role = "Apprentice"
		to_chat(user, "<span class='notice'>With the signing of this paper you agree to become \the [contract_master]'s apprentice in the art of wizardry.</span>")
		user.faction = "Space Wizard"
		wizards.add_antagonist_mind(user.mind,1)
		var/obj/item/I = new /obj/item/spellbook/student(get_turf(user))
		user.put_in_hands(I)
		new /obj/item/clothing/shoes/sandal(get_turf(user))
		new /obj/item/clothing/suit/wizrobe(get_turf(user))
		new /obj/item/clothing/head/wizard(get_turf(user))
		return 1
	return 0