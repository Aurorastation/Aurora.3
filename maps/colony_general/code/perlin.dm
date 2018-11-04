/proc/pointToCell(var/x, var/y)
	return list(Floor(x), Floor(y))

/proc/dotProduct(var/list/v1, var/list/v2)

	return v1[1] * v2[1] + v1[2] * v2[2]

/proc/lerp(var/value1, var/value2, var/t) //linear interpolation
	return (1 - t) * value1 + t * value2

/proc/perlinFade(var/t)
	return t * t * t * (t * (t * 6 - 15) + 10)

/proc/perlin(var/x, var/y)
	var/list/cellCoord = pointToCell(x, y)

	var/Xoffset = x - cellCoord[1]
	var/Yoffset = y - cellCoord[2]

	var/list/noiseVectors = list(list(0,1),list(1,1),list(1,0),list(1,-1),list(0,-1),list(-1,-1),list(-1,0),list(-1,1))

	var/NEvector = pick(noiseVectors)
	var/SEvector = pick(noiseVectors)
	var/SWvector = pick(noiseVectors)
	var/NWvector = pick(noiseVectors)

	var/list/vectors = list(NEvector, SEvector, SWvector, NWvector)

	var/list/NEoffset = list(Xoffset, Yoffset)
	var/NEdotProduct = dotProduct(NEoffset, vectors[1])

	var/SEoffset = list(Xoffset, Yoffset + 1)
	var/SEdotProduct = dotProduct(SEoffset, vectors[2])

	var/SWoffset = list(Xoffset + 1, Yoffset + 1)
	var/SWdotProduct = dotProduct(SWoffset, vectors[3])

	var/NWoffset = list(Xoffset + 1, Yoffset)
	var/NWdotProduct = dotProduct(NWoffset, vectors[4])

	var/Nlerp = lerp(NWdotProduct, NEdotProduct, perlinFade(Xoffset))

	var/Slerp = lerp(SWdotProduct, SEdotProduct, perlinFade(Xoffset))

	//log_ss(" v1: [Nlerp] | v2: [Slerp] | t: [perlinFade(Yoffset)] | O: [lerp(Slerp, Nlerp, perlinFade(Yoffset))]")
	return lerp(Slerp, Nlerp, perlinFade(Yoffset))

/*var/list/hash() = list(208,34,231,213,32,248,233,56,161,78,24,140,71,48,140,254,245,255,247,247,40,
					185,248,251,245,28,124,204,204,76,36,1,107,28,234,163,202,224,245,128,167,204,
					9,92,217,54,239,174,173,102,193,189,190,121,100,108,167,44,43,77,180,204,8,81,
					70,223,11,38,24,254,210,210,177,32,81,195,243,125,8,169,112,32,97,53,195,13,
					203,9,47,104,125,117,114,124,165,203,181,235,193,206,70,180,174,0,167,181,41,
					164,30,116,127,198,245,146,87,224,149,206,57,4,192,210,65,210,129,240,178,105,
					228,108,245,148,140,40,35,195,38,58,65,207,215,253,65,85,208,76,62,3,237,55,89,
					232,50,217,64,244,157,199,121,252,90,17,212,203,149,152,140,187,234,177,73,174,
					193,100,192,143,97,53,145,135,19,103,13,90,135,151,199,91,239,247,33,39,145,
					101,120,99,3,186,86,99,41,237,203,111,79,220,135,158,42,30,154,120,67,87,167,
					135,176,183,191,253,115,184,21,233,58,129,233,142,39,128,211,118,137,139,255,
					114,20,218,113,154,27,127,246,250,1,8,198,250,209,92,222,173,21,88,102,219)

/proc/noise2(var/x, var/y, var/seed)
	var/t = hash[(y + seed) % 256]
	return hash[(t + x) % 256]

/proc/lin_inter(var/x, var/y, var/s)
	return x + s * (y-x)

/proc/smooth_inter(var/x, var/y, var/s)
	return lin_inter(x, y, s * s * (3-2*s))

/proc/noise2d(var/x, var/y, var/seed)
	var/x_int = x
	var/y_int = y
	var/x_frac = x - x_int
	var/y_frac = y - y_int
	var/s = noise2(x_int, y_int, seed)
	var/t = noise2(x_int+1, y_int, seed)
	var/u = noise2(x_int, y_int+1, seed)
	var/v = noise2(x_int+1, y_int+1, seed)
	var/low = smooth_inter(s, t, x_frac)
	var/high = smooth_inter(u, v, x_frac)

	return smooth_inter(low, high, y_frac)

/proc/perlin2d(var/x, var/y, var/freq, var/depth, var/seed)
	var/xa = x*freq
	var/ya = y*freq
	var/amp = 1.0
	var/fin = 0
	var/div = 0.0

	for(var/i=0, i<depth, i++)
		div += 256 * amp
		fin += noise2d(xa, ya, seed) * amp
		amp /= 2
		xa *= 2
		ya *= 2

	return fin/div*/