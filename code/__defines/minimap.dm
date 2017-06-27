//
// Constants and standard colors for the holomap
//

#define HOLOMAP_ICON 'icons/480x480.dmi' // Icon file to start with when drawing holomaps (to get a 480x480 canvas).
#define HOLOMAP_ICON_SIZE 480 // Pixel width & height of the holomap icon.  Used for auto-centering etc.
#define ui_holomap "CENTER-7, CENTER-7" // Screen location of the holomap "hud"

// Holomap colors
#define HOLOMAP_OBSTACLE "#FFFFFFDD"	// Color of walls and barriers
#define HOLOMAP_PATH     "#66666699"	// Color of floors
#define HOLOMAP_HOLOFIER "#79FF79"	// Whole map is multiplied by this to give it a green holoish look

#define HOLOMAP_AREACOLOR_COMMAND     "#386d8099"
#define HOLOMAP_AREACOLOR_SECURITY    "#AE121299"
#define HOLOMAP_AREACOLOR_MEDICAL     "#FFFFFFA5"
#define HOLOMAP_AREACOLOR_SCIENCE     "#A154A699"
#define HOLOMAP_AREACOLOR_ENGINEERING "#F1C23199"
#define HOLOMAP_AREACOLOR_CARGO       "#E06F0099"
#define HOLOMAP_AREACOLOR_HALLWAYS    "#FFFFFF66"
#define HOLOMAP_AREACOLOR_ARRIVALS    "#0000FFCC"
#define HOLOMAP_AREACOLOR_ESCAPE      "#FF0000CC"
#define HOLOMAP_AREACOLOR_DORMS       "#5bc1c199"
// If someone can come up with a non-conflicting color for the lifts, please update this.
#define HOLOMAP_AREACOLOR_LIFTS       null

// Handy defines to lookup the pixel offsets for this Z-level.  Cache these if you use them in a loop tho.
//	 	Commenting these out for now. Replace if we ever datumize our maps.
/*#define HOLOMAP_PIXEL_OFFSET_X(zLevel) ((using_map.holomap_offset_x.len >= zLevel) ? using_map.holomap_offset_x[zLevel] : 0)
#define HOLOMAP_PIXEL_OFFSET_Y(zLevel) ((using_map.holomap_offset_y.len >= zLevel) ? using_map.holomap_offset_y[zLevel] : 0)
#define HOLOMAP_LEGEND_X(zLevel) ((using_map.holomap_legend_x.len >= zLevel) ? using_map.holomap_legend_x[zLevel] : 96)
#define HOLOMAP_LEGEND_Y(zLevel) ((using_map.holomap_legend_y.len >= zLevel) ? using_map.holomap_legend_y[zLevel] : 96)*/

#define HOLOMAP_PIXEL_OFFSET_X(zlevel) ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
#define HOLOMAP_PIXEL_OFFSET_Y(zlevel) ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
#define HOLOMAP_LEGEND_X(zlevel) 96
#define HOLOMAP_LEGEND_Y(zlevel) 96

#define HOLOMAP_EXTRA_STATIONMAP      "stationmapformatted"
#define HOLOMAP_EXTRA_STATIONMAPAREAS "stationareas"
#define HOLOMAP_EXTRA_STATIONMAPSMALL "stationmapsmall"
