require "libs.prototypes.all"

-- Item
local statusPanel = deepcopy(data.raw["item"]["small-lamp"])
overwriteContent(statusPanel, {
	name = "status-panel",
	order = "z[statusPanel]",
	place_result = "status-panel",
	icon = "__base__/graphics/icons/small-lamp.png",
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
local statusPanel = deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(statusPanel, {
	name = "status-panel",
	energy_usage_per_tick = "45KW",
	collision_box = {{-0.45, -1.45}, {0.45, 1.45}},
  selection_box = {{-0.5, -1.5}, {0.5, 1.5}},
	light = {intensity = 0.1, size = 5, color = {r=1.0, g=1.0, b=1.0}},
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

-- Car entity to show content of status panel:
local statusPanelCar = {}
-- = deepcopy(data.raw["car"]["car"]) -- <-- that didn't work because the machine gun is always shown??
overwriteContent(statusPanelCar, {
	name = "status-panel-sprite",
	type = "car",
	
	icon = "__base__/graphics/icons/car.png",
	flags = {"placeable-neutral", "placeable-off-grid", "player-creation"},    
	minable = {mining_time = 0.5, result = "status-panel-sprite"},
	max_health = 200,
	order="z[zebra]",
	corpse = "small-remnants",
	energy_per_hit_point = 1,
	crash_trigger = crash_trigger(),
	resistances = { },
	collision_box = {{-0.1, -.1}, {.1,.1}},
	collision_mask = { "item-layer", "object-layer", "player-layer", "water-tile"},
	selection_box = {{0,0}, {0,0}},
	effectivity = 0.5,
	braking_power = "200kW",
	burner = {
		effectivity = 0.6,
		fuel_inventory_size = 1,
		smoke = {}
	},
	consumption = "150kW",
	friction = 2e-3,
	sound_minimum_speed = 1;
	rotation_speed = 0.015,
	weight = 700,
	guns = { },
	inventory_size = 0,
	animation = {
		layers = {
			{
				width = 32,
				height = 96,
				frame_count = 1,
				direction_count = 11,
				apply_runtime_tint = false,
				max_advance = 0.2,
				shift = {0,-1},
				stripes = {
					{
					 filename = "__integratedCircuitry__/graphics/entity/status-panel-patch.png",
					 width_in_frames = 11,
					 height_in_frames = 1,
					},
				}
			}
		}
	}
})
data:extend({	statusPanelCar })

-- TEMPORARY FOR TESTING
local statusPanelCarItem = deepcopy(data.raw["item-with-entity-data"]["car"])
overwriteContent(statusPanelCarItem, {
	name = "status-panel-sprite",
  place_result = "status-panel-sprite",
})
data:extend({	statusPanelCarItem })