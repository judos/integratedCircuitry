require "libs.prototypes.all"

-- Item
local indicator = deepcopy(data.raw["item"]["small-lamp"])
overwriteContent(indicator, {
	name = "lamp-panel",
	order = "z[small-lamp]",
	place_result = "lamp-panel",
	icon = "__integratedCircuitry__/graphics/icons/lamp-panel.png",
})
data:extend({	indicator })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "lamp-panel",
		enabled = false,
		ingredients = {
			{"small-lamp", 1},
			{"steel-plate", 1},
		},
		result = "lamp-panel"
	}
})


-- Entity
local indicator = deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(indicator, {
	name = "lamp-panel",
	energy_usage_per_tick = "15KW",
	light = {intensity = 0.2, size = 10, color = {r=1.0, g=1.0, b=1.0}},
	picture_off =
	{
		filename = "__integratedCircuitry__/graphics/entity/lamp-panel-off.png",
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
		filename = "__integratedCircuitry__/graphics/entity/lamp-panel-on-patch.png",
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

indicator.minable.result = "lamp-panel"
data:extend({	indicator })


addTechnologyUnlocksRecipe("optics","lamp-panel")
