# Utility functions for the map

static func get_distance(a, b):
    # Obtain the Manhatan distance between 2 hexagons
    var distance = (abs(a.x - b.x) 
                + abs(a.y - b.y) 
                + abs(a.z - b.z))/2
    return distance

static func general_lerp(a, b, t):
    return a + (b - a) * t

static func hex_lerp(a, b, t):
    return Vector3(general_lerp(a.x, b.x, t), 
        general_lerp(a.y, b.y, t), 
        general_lerp(a.z, b.z, t))

static func hex_round(hex):
    # Aproximation of floating coordinates to nearest hexagon
    var rx = round(hex.x)
    var ry = round(hex.y)
    var rz = round(hex.z)

    var x_diff = abs(rx - hex.x)
    var y_diff = abs(ry - hex.y)
    var z_diff = abs(rz - hex.z)

    if x_diff > y_diff and x_diff > z_diff:
        rx = -ry-rz
    elif y_diff > z_diff:
        ry = -rx-rz
    else:
        rz = -rx-ry

    return Vector3(rx, ry, rz)

static func get_neighbours(local_vector, positions, obstacles):
    # Obtain Neighbours of an hexagon, it omits the obstacles near it
    var neighbours = []
    var vectors = [Vector3(1, -1, 0), Vector3(0, -1, 1), Vector3(-1, 0, 1),
        Vector3(-1, 1, 0), Vector3(0, 1, -1), Vector3(1, 0, -1)
    ]
    for vector in vectors:
        var neighbour_vector = local_vector + vector
        if positions.values().has(neighbour_vector) && \
            !obstacles.has(neighbour_vector):
            neighbours.push_back(neighbour_vector)
                    
    return neighbours

static func get_coordinate_range(position, distance):
	var results = []
	for x in range(-distance, distance + 1):
		for y in range(-distance, distance + 1):
			for z in range(-distance, distance + 1):
				if x + y + z == 0:
					results.push_back(position + Vector3(x, y, z))
	return results

static func hex_linedraw(a, b):
	var N = get_distance(a, b)
	var results = []
	for i in range(0, N+1):
		results.push_back(hex_round(hex_lerp(a, b, 1.0/N * i)))
	return results