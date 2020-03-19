/obj/item/contract/boon
	name = "boon contract"
	desc = "this contract grants you a boon for signing it."
	var/path

/obj/item/contract/boon/New(var/newloc, var/new_path)
	..(newloc)
	if(new_path)
		path = new_path
	var/item_name = ""
	if(ispath(path,/obj))
		var/obj/O = path
		item_name = initial(O.name)
	else if(ispath(path,/spell))
		var/spell/S = path
		item_name = initial(S.name)
	name = "[item_name] contract"

/obj/item/contract/boon/contract_effect(mob/user as mob)
	..()
	if(ispath(path,/spell))
		user.add_spell(new path)
		return 1
	else if(ispath(path,/obj))
		new path(get_turf(user.loc))
		playsound(get_turf(usr),'sound/effects/phasein.ogg',50,1)
		return 1

/obj/item/contract/boon/wizard
	contract_master = "\improper Wizard Academy"