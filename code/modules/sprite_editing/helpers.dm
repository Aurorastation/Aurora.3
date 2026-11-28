/// Splits an HTML RGB/RGBA color into four numeric channels.
/proc/sprite_editor_split_color(color)
	var/list/channels = rgb2num(color)
	if(length(channels) == 3)
		channels += 255
	return channels

#define SPRITE_EDITOR_ALPHA_COMPOSE(src_a, comp_a, back_ch, src_ch) ((1 - src_a / comp_a) * back_ch + (src_a / comp_a) * src_ch)

/// Alpha-composites source over backdrop using the normal CSS blend mode.
/proc/sprite_editor_blend_color(backdrop = "#00000000", source)
	var/list/source_channels = sprite_editor_split_color(source)
	if(length(source_channels) != 4)
		return backdrop
	var/source_alpha = source_channels[4]
	if(source_alpha == 0)
		return backdrop
	if(source_alpha == 255)
		return source
	var/list/backdrop_channels = sprite_editor_split_color(backdrop)
	if(length(backdrop_channels) != 4)
		return source
	var/backdrop_alpha = backdrop_channels[4] / 255
	source_alpha /= 255
	var/output_alpha = source_alpha + backdrop_alpha - source_alpha * backdrop_alpha
	return rgb(
		SPRITE_EDITOR_ALPHA_COMPOSE(source_alpha, output_alpha, backdrop_channels[1], source_channels[1]),
		SPRITE_EDITOR_ALPHA_COMPOSE(source_alpha, output_alpha, backdrop_channels[2], source_channels[2]),
		SPRITE_EDITOR_ALPHA_COMPOSE(source_alpha, output_alpha, backdrop_channels[3], source_channels[3]),
		output_alpha * 255,
	)

#undef SPRITE_EDITOR_ALPHA_COMPOSE

/// Copies an icon's pixels into the editor's top-to-bottom row format.
/proc/sprite_editor_fill_grid_from_icon(list/grid, icon/source)
	var/width = source.Width()
	var/height = source.Height()
	for(var/x in 1 to width)
		for(var/y in 1 to height)
			var/pixel = source.GetPixel(x, height + 1 - y)
			if(length(pixel) == 7)
				pixel += "ff"
			grid[y][x] = pixel

