/datum/psi_complexus

	var/announced = FALSE             // Whether or not we have been announced to our holder yet.
	var/suppressed = TRUE             // Whether or not we are suppressing our psi powers.
	var/use_psi_armor = TRUE         // Whether or not we should automatically deflect/block incoming damage.

	var/cost_modifier = 1             // Multiplier for power use stamina costs.
	var/stun = 0                      // Number of process ticks we are stunned for.
	var/next_power_use = 0            // world.time minimum before next power use.
	var/stamina = 50                  // Current psi pool.
	var/max_stamina = 50              // Max psi pool.
	var/psi_points = 0				  // Points spendable in the psi pointshop.
	var/spent_psi_points = 0		  // Need to keep track of if someone has spent psi-points before for things like updating psi-rank.

	var/psionic_rank
	var/last_psionic_rank
	var/list/manifested_items         // List of atoms manifested/maintained by psychic power.
	var/list/psionic_powers = list()  // List of singleton abilities.
	var/last_armor_check              // world.time of last armor check.
	var/last_aura_size
	var/last_aura_alpha
	var/last_aura_color
	var/aura_color = "#ff0022"

	var/datum/component/armor/psionic/armor_component
	var/obj/screen/psi/hub/ui	      // Reference to the master psi UI object.
	var/mob/living/owner              // Reference to our owner.
	var/image/_aura_image             // Client image

/datum/psi_complexus/proc/get_aura_image()
	if(_aura_image && !istype(_aura_image))
		var/atom/A = _aura_image
		log_debug("Non-image found in psi complexus: \ref[A] - \the [A] - [istype(A) ? A.type : "non-atom"]")
		destroy_aura_image(_aura_image)
		_aura_image = null
	if(!_aura_image)
		_aura_image = create_aura_image(owner)
	return _aura_image

/proc/create_aura_image(var/newloc)
	var/image/aura_image = image(loc = newloc, icon = 'icons/effects/psi_aura_small.dmi', icon_state = "aura")
	aura_image.blend_mode = BLEND_MULTIPLY
	aura_image.appearance_flags = NO_CLIENT_COLOR | RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	aura_image.layer = TURF_LAYER + 0.5
	aura_image.alpha = 0
	aura_image.pixel_x = -64
	aura_image.pixel_y = -64
	aura_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	aura_image.appearance_flags = 0
	for(var/thing in SSpsi.processing)
		var/datum/psi_complexus/psychic = thing
		if(psychic.owner.client && !psychic.suppressed)
			psychic.owner.client.images += aura_image
	SSpsi.all_aura_images[aura_image] = TRUE
	return aura_image

/proc/destroy_aura_image(var/image/aura_image)
	for(var/thing in SSpsi.processing)
		var/datum/psi_complexus/psychic = thing
		if(psychic.owner.client)
			psychic.owner.client.images -= aura_image
	SSpsi.all_aura_images -= aura_image

/datum/psi_complexus/New(var/mob/_owner)
	owner = _owner
	SSpsi.all_psi_complexes |= src
	START_PROCESSING(SSpsi, src)

/datum/psi_complexus/Destroy()
	destroy_aura_image(_aura_image)
	SSpsi.all_psi_complexes -= src
	QDEL_NULL(armor_component)
	STOP_PROCESSING(SSpsi, src)
	if(owner)
		if(owner.ability_master)
			owner.ability_master.remove_all_psionic_abilities()
		if(owner.client)
			owner.client.screen -= ui
			for(var/thing in SSpsi.all_aura_images)
				owner.client.images -= thing
		QDEL_NULL(ui)
		owner.psi = null
		owner = null

	if(manifested_items)
		for(var/thing in manifested_items)
			qdel(thing)
		manifested_items.Cut()

	. = ..()
