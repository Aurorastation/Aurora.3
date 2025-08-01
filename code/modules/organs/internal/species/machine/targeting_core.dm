/obj/item/organ/internal/machine/targeting_core
	name = "targeting core"
	desc = "A modification illegal in most nations. It allows the transformation of any IPC into a deadly fighter capable of performing incredible feats with firearms, providing increased accuracy, \
			advanced targeting systems, automatic reloading subroutines, and explicit knowledge of any weapons programmed into the core."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_targeting_core"
	organ_tag = BP_TARGETING_CORE
	parent_organ = BP_HEAD

/obj/item/organ/internal/machine/targeting_core/Initialize()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_EMPTIED_MAGAZINE, PROC_REF(automatic_reload))

/obj/item/organ/internal/machine/targeting_core/replaced()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_EMPTIED_MAGAZINE, PROC_REF(automatic_reload))

/obj/item/organ/internal/machine/targeting_core/removed()
	. = ..()
	if(owner)
		UnregisterSignal(owner, COMSIG_EMPTIED_MAGAZINE)

/**
* Signal handler.
* First of all, we need to find a magazine to reload with - which is what this proc does.
*/
/obj/item/organ/internal/machine/targeting_core/proc/automatic_reload(mob/user, obj/item/gun/gun)
	SIGNAL_HANDLER
	var/obj/item/ammo_magazine/magazine
	if(istype(gun, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/dakka = gun
		if(owner.belt)
			magazine = check_contents_for_magazine(owner.belt, dakka.magazine_type)

		if(!magazine)
			if(owner.l_store)
				if(owner.l_store.type == dakka.magazine_type)
					magazine = owner.l_store

		if(!magazine)
			if(owner.r_store)
				if(owner.r_store.type == dakka.magazine_type)
					magazine = owner.r_store

		if(!magazine)
			if(owner.w_uniform && istype(owner.w_uniform, /obj/item/clothing/under))
				var/obj/item/clothing/under/under = owner.w_uniform
				if(length(under.accessories))
					for(var/obj/item/storage/storage in under.accessories)
						magazine = check_contents_for_magazine(storage, dakka.magazine_type)

		if(!magazine)
			if(owner.wear_suit && istype(owner.wear_suit, /obj/item/clothing/suit))
				var/obj/item/clothing/suit/suit = owner.wear_suit
				if(length(suit.accessories))
					for(var/obj/item/storage/storage in suit.accessories)
						magazine = check_contents_for_magazine(storage, dakka.magazine_type)
				else if(!magazine && istype(suit, /obj/item/clothing/suit/storage))
					magazine = check_contents_for_magazine(suit, dakka.magazine_type)

		if(magazine)
			do_reload(user, gun, magazine)
		else
			to_chat(owner, SPAN_DANGER("Your targeting core can't locate any applicable magazines!"))

/**
* Reloads the gun itself.
*/
/obj/item/organ/internal/machine/targeting_core/proc/do_reload(mob/user, obj/item/gun/projectile/gun, obj/item/ammo_magazine/ammo)
	user.visible_message(SPAN_DANGER(FONT_LARGE("With supernatural accuracy and swiftness, [owner] replaces the magazine in [owner.get_pronoun("his")] [gun] in a fraction of a second!")))
	if(gun.ammo_magazine)
		gun.unload_ammo(user, drop_mag = TRUE)
	gun.load_ammo(ammo, user)
	playsound(user.loc, 'sound/effects/reload_woosh.ogg', 100)

/obj/item/organ/internal/machine/targeting_core/proc/check_contents_for_magazine(obj/item/storage/storage, magazine_type)
	if(istype(storage))
		for(var/obj/item/item in storage.contents)
			if(item.type == magazine_type)
				return item
