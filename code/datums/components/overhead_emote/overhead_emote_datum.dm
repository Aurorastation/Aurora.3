/datum/component/overhead_emote
	/// the mob with the emote
	var/mob/emote_mob

	/// path of relevant overhead emote singleton
	var/emote_type

	/// the image added above the mob during the emote
	var/image/emote_image

/datum/component/overhead_emote/Initialize(var/set_emote_type, var/mob/victim)
	emote_mob = parent
	emote_type = set_emote_type

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(remove_from_mob))

	var/singleton/overhead_emote/emote = GET_SINGLETON(emote_type)

	emote_image = emote.get_image(emote_mob)
	emote_mob.AddOverlays(emote_image)

	emote.start_emote(parent, victim)

/datum/component/overhead_emote/proc/remove_from_mob()
	emote_mob.CutOverlays(emote_image)
	emote_mob.RemoveComponentSource(src)
