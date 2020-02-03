require "libs.prototypes.all"

-- Item
local statusPanel = table.deepcopy(data.raw["item"]["small-lamp"])
overwriteContent(statusPanel, {
	name = "status-panel",
	order = "z[statusPanel]",
	place_result = "status-panel",
	icon = "__integratedCircuitry__/graphics/icons/status-panel.png",
	icon_size = 32,
})
data:extend({	statusPanel })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "status-panel",
		enabled = false,
		ingredients = {
			{"lamp-panel", 3},
			{"electronic-circuit", 3},
		},
		result = "status-panel"
	}
})


-- Entity
local statusPanel = table.deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(statusPanel, {
	name = "status-panel",
	energy_usage_per_tick = "45KW",
	collision_box = {{-0.45, -1.45}, {0.45, 1.45}},
  selection_box = {{-0.5, -1.5}, {0.5, 1.5}},
	light = {intensity = 0.1, size = 5, color = {r=1.0, g=1.0, b=1.0}},
	icon = "__integratedCircuitry__/graphics/icons/status-panel.png",
	icon_size = 32,
	picture_off = {
		filename = "__integratedCircuitry__/graphics/entity/status-panel-base.png",
		priority = "low",
		width = 32,
		height = 96,
		frame_count = 1,
		axially_symmetrical = false,
		direction_count = 1,
		shift = {0,0},
	},
	picture_on = emptyImage(),
	circuit_wire_connection_point = {
		shadow =
		{
			red = {0.40625, 1.44},
			green = {0.40625, 1.47},
		},
		wire =
		{
			red = {0.40625, 1.42},
			green = {0.40625, 1.45},
		}
	},
	circuit_connector_sprites = nil,
	minable = {
		result = "status-panel",
		mining_time = 0.5
	}
})
data:extend({	statusPanel })

addTechnologyUnlocksRecipe("optics","status-panel")

-- Sprite to show status panel:
local statusPanelSprite = {
	type = "simple-entity-with-owner",
	name = "ic-status-panel-sprite",
	render_layer = "higher-object-above",
	icon = "__integratedCircuitry__/graphics/entity/status-panel-patch.png",
	icon_size = 32,
	flags = {"placeable-neutral", "placeable-off-grid", "player-creation"},
	order = "s-e-w-o",
	max_health = 100,
	--corpse = "small-remnants",
	collision_box = {{-0.1, -.1}, {.1,.1}},
	selection_box = {{0,0}, {0,0}},
	pictures = {
		sheet = {
			filename = "__integratedCircuitry__/graphics/entity/status-panel-patch.png",
			line_length = 11,
			width = 32,
			height = 96,
			variation_count = 11,
			apply_runtime_tint = false,
			axially_symmetrical = false,
			direction_count = 1,
			shift = {0,-1},
		},
	}
}

data:extend({	statusPanelSprite })
