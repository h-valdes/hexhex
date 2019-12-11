# Utility functions for the map

static func get_distance(a, b):
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