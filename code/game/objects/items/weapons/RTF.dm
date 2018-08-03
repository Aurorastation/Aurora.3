// Malf AI RTF.
var/malftransformermade = 0
/obj/item/weapon/rtf
	name = "\improper Rapid-Transformer-Fabricator"
	desc = "A device used to deploy a transformer. It can only be used once and there can not be more than one made."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	w_class = 3.0

/obj/item/weapon/rtf/afterattack(atom/A, mob/user as mob, proximity)

	if(!proximity) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return

	if(!istype(A, /turf/simulated/floor))
		return

	if(malftransformermade)
		user << "There is already a transformer machine made!"
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 100
	user << "Fabricating machine..."
	if(do_after(user, 30 SECONDS, act_target = src))
		var/obj/product = new /obj/machinery/transformer
		malftransformermade = 1
		product.forceMove(get_turf(A))

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
