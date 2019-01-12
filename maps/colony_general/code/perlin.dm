/proc/perlin(var/x, var/y, var/seed, var/scale, var/octaves, var/persistence)
	var/total = 0
	var/amplitude = 1
	var/frequency = 1
	var/maxValue = 0			// Used for normalizing result to 0.0 - 1.0
	for(var/i = 0; i < octaves; i++)
		total += _perlin((x/scale) * frequency, (y/scale) * frequency, (seed/scale) * frequency) * amplitude

		maxValue += amplitude

		amplitude *= persistence
		frequency *= 2

	return total/maxValue

var/list/perlin_permutation = list(151,160,137,91,90,15,
	131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180)

var/perlin_p[512]

/proc/PerlinPermutate()
	for(var/x = 1; x <= 512; x++)
		perlin_p[x] = perlin_permutation[x % 256]

/proc/_perlin(var/x, var/y, var/seed)
	// Find the unit cube that contains the point
	var/x0 = Floor(x) & 255
	var/y0 = Floor(y) & 255
	var/z0 = Floor(seed) & 255

	// Find relative x, y,z of point in cube
	x -= Floor(x)
	y -= Floor(y)
	seed -= Floor(seed)

	// Compute fade curves for each of x, y, z
	var/u = fade(x)
	var/v = fade(y)
	var/w = fade(seed)

	// Hash coordinates of the 8 cube corners
	var/A =  perlin_p[max(1,x0)] + y0
	var/AA = perlin_p[max(1,A)] + z0
	var/AB = perlin_p[max(1,A + 1)] + z0
	var/B =  perlin_p[max(1,x0 + 1)] + y0
	var/BA = perlin_p[max(1,B)] + z0
	var/BB = perlin_p[max(1,B + 1)] + z0

	// Add blended results from 8 corners of cube
	var/res = lerp(w, lerp(v, lerp(u, grad(perlin_p[AA], x, y, seed), grad(perlin_p[BA], x-1, y, seed)), lerp(u, grad(perlin_p[AB], x, y-1, seed), grad(perlin_p[BB], x-1, y-1, seed))), lerp(v, lerp(u, grad(perlin_p[AA+1], x, y, seed-1), grad(perlin_p[BA+1], x-1, y, seed-1)), lerp(u, grad(perlin_p[AB+1], x, y-1, seed-1), grad(perlin_p[BB+1], x-1, y-1, seed-1))))
	return (res)

/proc/fade(var/t)
	return t * t * t * (t * (t * 6 - 15) + 10)

/proc/lerp(var/t, var/a, var/b)
	return a + t * (b - a)

/proc/grad(var/hash, var/x, var/y, var/z)
	var/h = hash & 15;
	// Convert lower 4 bits of hash into 12 gradient directions
	var/u = h < 8 ? x : y
	var/v = h < 4 ? y : h == 12 || h == 14 ? x : z
	return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)