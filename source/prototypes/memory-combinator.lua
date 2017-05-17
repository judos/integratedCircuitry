require "libs.prototypes.all"

-- Item
local memory = deepcopy(data.raw["item"]["constant-combinator"])
overwriteContent(memory, {
	name = "memory-combinator",
	order = "z[small-lamp]0",
	place_result = "memory-combinator",
	icon = "__integratedCircuitry__/graphics/icons/memory-combinator.png",
})
data:extend({	memory })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "memory-combinator",
		enabled = false,
		ingredients = {
			{"constant-combinator", 4},
			{"electronic-circuit", 20},
		},
		result = "memory-combinator"
	}
})


-- Entity
local remove = {}
local memory = deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(memory, {
	name = "memory-combinator",
	icon = "__integratedCircuitry__/graphics/icons/memory-combinator.png",
	max_health = 500,
	collision_box = {{-0.85, -0.85}, {0.85, 0.85}},
	selection_box = {{-1, -1}, {1, 1}},
	energy_usage_per_tick = "100KW",
	picture_off = {
		filename = "__integratedCircuitry__/graphics/entity/memory-combinator.png",
		x = 0,
		y = 0,
		width = 120,
		height = 120,
		frame_count = 1,
		shift = {0,0}, --{0.140625, 0.140625},
	},
	picture_on = {
		filename = "__integratedCircuitry__/graphics/empty.png",
		width = 1,
		height = 1,
	},
	light = remove,
	light_when_colored = remove,
	glow_size = 0,
	glow_color_intensity = 0,
	sprites = remove,
	activity_led_light_offsets = remove,
	activity_led_sprites = remove,
	input_connection_bounding_box = {{-1, -1}, {0, 0}},
	output_connection_bounding_box = {{0, 0}, {1,1}},
},remove)

memory.minable.result = "memory-combinator"
data:extend({	memory })


addTechnologyUnlocksRecipe("optics","memory-combinator")
