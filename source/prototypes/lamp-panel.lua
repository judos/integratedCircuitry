require "libs.prototypes.all"

-- Item
local indicator = table.deepcopy(data.raw["item"]["small-lamp"])
overwriteContent(indicator, {
	name = "lamp-panel",
	order = "z[small-lamp]",
	place_result = "lamp-panel",
	icon = "__integratedCircuitry__/graphics/icons/lamp-panel.png",
	icon_size = 32,
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
local indicator = table.deepcopy(data.raw["lamp"]["small-lamp"])
local REMOVE = "__REMOVE__"
overwriteContent(indicator, {
	name = "lamp-panel",
	fast_replaceable_group = "lamp",
	energy_usage_per_tick = "15KW",
	collision_box = {{-0.4,-0.4},{0.4,0.4}},
	collision_mask = {"water-tile", "item-layer", "object-layer"},
	light = {intensity = 0.2, size = 0.5, color = {r=0.5, g=0.5, b=0.5}},
	light_when_colored = {intensity = 0.2, size = 0.5, color = {r=0.5, g=0.5, b=0.5}},
	glow_size = 1,
	glow_color_intensity = 0.135,
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
      wire =
      {
        red = {0.5, 0.5},
        green = {0.5, 0.5},
      },
			shadow =
      {
        red = {0.5, 0.5},
        green = {0.5, 0.5},
      }
    },
}, REMOVE)
indicator.circuit_connector_sprites = nil
table.insert(indicator.signal_to_color_mapping,
	{type="virtual", name="signal-black", color={r=0.1,g=0.1,b=0.1}}
)
table.insert(indicator.signal_to_color_mapping,
	{type="virtual", name="signal-grey", color={r=0.5,g=0.5,b=0.5}}
)

indicator.minable.result = "lamp-panel"
data:extend({	indicator })


addTechnologyUnlocksRecipe("optics","lamp-panel")
