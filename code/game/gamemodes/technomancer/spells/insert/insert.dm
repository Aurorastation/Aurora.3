//Template for spells which put something inside someone else, good for buffs/debuffs, damage over times and heals over time.

/obj/item/spell/insert
	name = "insert template"
	desc = "Tell a coder if you can read this in-game."
	icon_state = "purify"
	cast_methods = CAST_MELEE
	var/spell_color = "#03A728"
	var/spell_light_intensity = 2
	var/spell_light_range = 3
	var/obj/item/inserted_spell/inserting = null
	var/allow_stacking = 0

/obj/item/spell/insert/New()
	..()
	set_light(spell_light_range, spell_light_intensity, l_color = light_color)

/obj/item/inserted_spell
	var/mob/living/carbon/human/origin = null
	var/mob/living/host = null
	var/spell_power_at_creation = 1.0 // This is here because the spell object that made this object probably won't exist.

/obj/item/inserted_spell/New(var/newloc, var/user, var/obj/item/spell/insert/inserter)
	..(newloc)
	host = newloc
	origin = user
	if(light_color)
		spawn(1)
			set_light(inserter.spell_light_range, inserter.spell_light_intensity, inserter.spell_color)
	on_insert()

/obj/item/inserted_spell/proc/on_insert()
	return

/obj/item/inserted_spell/proc/on_expire(var/dispelled = 0)
	qdel(src)
	return

/obj/item/spell/insert/proc/insert(var/mob/living/L, mob/user)
	if(inserting)
		if(!allow_stacking)
			for(var/obj/item/inserted_spell/IS in L.contents)
				if(IS.type == inserting)
					to_chat(user, "<span class='warning'>\The [L] is already affected by \the [src].</span>")
					return
		var/obj/item/inserted_spell/inserted = new inserting(L,user,src)
		inserted.spell_power_at_creation = calculate_spell_power(1.0)
		log_and_message_admins("has casted [src] on [L].")
		qdel(src)

/obj/item/spell/insert/on_melee_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living))
		var/mob/living/L = hit_atom
		insert(L,user)

/obj/item/spell/insert/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living))
		var/mob/living/L = hit_atom
		insert(L,user)