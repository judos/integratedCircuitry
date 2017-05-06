require "libs.prototypes.all"

-- Item
local indicator = deepcopy(data.raw["item"]["small-lamp"])
overwriteContent(indicator, {
	name = "indicator-lamp",
	order = "z[small-lamp]",
	place_result = "indicator-lamp",
	icon = "__base__/graphics/icons/small-lamp.png",
})
data:extend({	indicator })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "indicator-lamp",
		enabled = false,
		ingredients = {
			{"small-lamp", 1},
			{"steel-plate", 1},
		},
		result = "indicator-lamp"
	}
})


-- Entity
local indicator = deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(indicator, {
	name = "indicator-lamp",
	energy_usage_per_tick = "15KW",
	light = {intensity = 0.2, size = 10, color = {r=1.0, g=1.0, b=1.0}},
	picture_off =
	{
		filename = "__integratedCircuitry__/graphics/entity/indicator-off.png",
		priority = "high",
		width = 32,
		height = 32,
		frame_count = 1,
		axially_symmetrical = false,
		direction_count = 1,
		shift = {0,0},
	},
	picture_on =
	{
		filename = "__integratedCircuitry__/graphics/entity/indicator-on-patch.png",
		priority = "high",
		width = 32,
		height = 32,
		frame_count = 1,
		axially_symmetrical = false,
		direction_count = 1,
		shift = {0,0},
	},
	circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0.40625, 0.44},
        green = {0.40625, 0.47},
      },
      wire =
      {
        red = {0.40625, 0.42},
        green = {0.40625, 0.45},
      }
    },
})
indicator.circuit_connector_sprites = nil

indicator.minable.result = "indicator-lamp"
data:extend({	indicator })


addTechnologyUnlocksRecipe("optics","indicator-lamp")
