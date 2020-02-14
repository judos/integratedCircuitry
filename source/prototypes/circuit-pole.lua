
-- Item

local circuitPole = table.deepcopy(data.raw["item"]["small-electric-pole"])
overwriteContent(circuitPole, {
	name = "circuit-pole",
	icon = "__integratedCircuitry__/graphics/icons/circuit-pole.png",
	subgroup = "circuit-network",
	order = "b[wires]-c[circuit-pole]",
  place_result = "circuit-pole"
})
data:extend({	circuitPole })

-- Recipe

data:extend({
	{
    type = "recipe",
    name = "circuit-pole",
    ingredients = {
      {"iron-plate", 1},
      {"copper-cable", 1}
    },
    result = "circuit-pole",
    result_count = 2,
    requester_paste_multiplier = 25
  }
})

-- Entity

local circuitPole = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
overwriteContent(circuitPole, {
	name = "circuit-pole",
	place_result = "circuit-pole",
	icon = "__integratedCircuitry__/graphics/icons/circuit-pole.png",
	minable = {
		hardness = circuitPole.minable.hardness, 
		mining_time = circuitPole.minable.mining_time, 
		result = "circuit-pole"
	},
	maximum_wire_distance = 15,
	supply_area_distance = 0,
	draw_copper_wires = false,
	pictures = {
		filename = "__integratedCircuitry__/graphics/entity/circuit-pole.png",
		priority = "extra-high",
		width = 60,
		height = 36,
		direction_count = 4,
		shift = util.by_pixel(16, 1)
	},
	track_coverage_during_build_by_moving = false,
	connection_points = {
		{
			shadow = {
				red = {0.6, 0.4},
				green = {0.9, 0.42}
			},
			wire = {
				red = {-0.375, -0.35},
				green = {0.00625, -0.35}
			}
		},
		{
			shadow = {
				red = {0.5, 0.1},
				green = {0.95, 0.4}
			},
			wire = {
				red = {-0.31, -0.5},
				green = {-0.1, -0.34}
			}
		},
		{
			shadow = {
				red = {0.85, 0.1},
				green = {0.85, 0.5}
			},
			wire = {
				red = {-0.09, -0.525},
				green = {-0.08, -0.275}
			}
		},
		{
			shadow = {
				red = {0.85, 0.2},
				green = {0.5, 0.48}
			},
			wire = {
				red = {0.1, -0.45},
				green = {-0.125, -0.3}
			}
		}
	},
})
circuitPole.radius_visualisation_picture.filename = "__integratedCircuitry__/graphics/entity/circuit-pole-radius-visualization.png",
data:extend({	circuitPole })