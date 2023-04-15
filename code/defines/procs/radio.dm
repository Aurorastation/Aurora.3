/proc/register_radio(source, old_frequency, new_frequency, radio_filter)
	if(old_frequency)
		SSradio.remove_object(source, old_frequency)
	if(new_frequency)
		return SSradio.add_object(source, new_frequency, radio_filter)

/proc/unregister_radio(source, frequency)
	if(SSradio)
		SSradio.remove_object(source, frequency)

/proc/get_frequency_name(var/display_freq)
	var/freq_text

	if(display_freq == BLSP_FREQ)
		freq_text = "Bluespace"

	if(!freq_text)
		// the name of the channel
		if(display_freq in ANTAG_FREQS)
			freq_text = "#unkn"
		else
			for(var/channel in radiochannels)
				if(radiochannels[channel] == display_freq)
					freq_text = channel
					break

	// --- If the frequency has not been assigned a name, just use the frequency as the name ---
	if(!freq_text)
		freq_text = format_frequency(display_freq)

	return freq_text
