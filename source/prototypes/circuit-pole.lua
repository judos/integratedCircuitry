
-- Item

local circuitPole = deepcopy(data.raw["item"]["small-electric-pole"])
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

local circuitPole = deepcopy(data.raw["electric-pole"]["small-electric-pole"])
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
	pictures = {
		filename = "__integratedCircuitry__/graphics/entity/circuit-pole.png",
		priority = "extra-high",
		width = 60,
		height = 62,
		direction_count = 4,
		shift = {0.5, -0.4}
	},
	track_coverage_during_build_by_moving = false,
	connection_points = {
		{
			shadow = {
				--copper = {2.7, 0},
				red = {2.3, 0},
				green = {3.1, 0}
			},
			wire = {
				--copper = {0, -1.7},
				red = {-0.375, -1.15},
				green = {0.00625, -1.15}
			}
		},
		{
			shadow = {
				--copper = {2.7, -0.05},
				red = {2.2, -0.35},
				green = {3, 0.12}
			},
			wire = {
				--copper = {-0.04, -1.8},
				red = {-0.3, -1.4},
				green = {0.1, -1.1575}
			}
		},
		{
			shadow = {
				--copper = {2.5, -0.1},
				red = {2.55, -0.45},
				green = {2.5, 0.25}
			},
			wire = {
				--copper = {-0.15625, -1.6875},
				red = {-0.08, -1.325},
				green = {-0.065, -1.075}
			}
		},
		{
			shadow = {
				--copper = {2.30, -0.1},
				red = {2.65, -0.40},
				green = {1.75, 0.20}
			},
			wire = {
				--copper = {-0.03125, -1.71875},
				red = {0.1, -1.3},
				green = {-0.125, -1.15}
			}
		}
	},
})
circuitPole.radius_visualisation_picture.filename = "__integratedCircuitry__/graphics/entity/circuit-pole-radius-visualization.png",
data:extend({	circuitPole })