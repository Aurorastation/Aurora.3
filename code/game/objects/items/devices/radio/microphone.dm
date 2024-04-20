/obj/item/device/radio/microphone
	name = "handheld microphone"
	desc = "A handheld microphone, used for on-the-fly interviewing. Pose for the fans!"
	icon_state = "microphone"
	item_state = "microphone"

/obj/item/device/radio/microphone/Initialize()
	. = ..()
	set_frequency(ENT_FREQ)
	internal_channels = list(num2text(ENT_FREQ) = list())
