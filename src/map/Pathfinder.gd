# Pathfinder class
extends Node

const MapUtils = preload("res://src/map/MapUtils.gd")
var positions

func _init(_positions):
	positions = _positions

func get_positions():
	return positions

func set_positions(_positions):
	positions = _positions

func possible_hex(start, distance):
	pass 

func priorityComparisson(a, b):
	# [Vector3, priority]
	return a[1] > b[1]

func find(start, goal, obstacles):
	# Using A-Star Algorithm from redblobgames.com
	var frontier = []
	frontier.push_back([start, 0])
	var came_from = {}
	var cost_so_far = {}
	came_from[start] = null
	cost_so_far[start] = 0
	while !frontier.empty():
		var current = frontier.back()[0]
		frontier.pop_back()
		if current == goal:
			break

		for next in MapUtils.get_neighbours(current, positions, obstacles):
			var new_cost = cost_so_far[current] + 1 # Change to graph.cost(current, next)
			if !cost_so_far.has(next) || new_cost < cost_so_far[next]:
				cost_so_far[next] = new_cost
				var priority = new_cost + MapUtils.get_distance(goal, next)
				frontier.push_front([next, priority])
				frontier.sort_custom(self, "priorityComparisson")
				came_from[next] = current
	var path = []
	recursive_path(goal, came_from, path)
	path.invert()
	return path
	
func recursive_path(hex, came_from, path):
	if came_from.has(hex):
		path.push_back(hex)
		if came_from[hex] != null:
			var new_hex = came_from[hex]
			recursive_path(new_hex, came_from, path)
		else:
			return path