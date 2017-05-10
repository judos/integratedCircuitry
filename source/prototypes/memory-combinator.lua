require "libs.prototypes.all"

-- Item
local memory = deepcopy(data.raw["item"]["constant-combinator"])
overwriteContent(memory, {
	name = "memory-combinator",
	order = "z[small-lamp]0",
	place_result = "memory-combinator",
	icon = "__integratedCircuitry__/graphics/icons/lamp-panel.png",
})
data:extend({	memory })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "memory-combinator",
		enabled = false,
		ingredients = {
			{"constant-combinator", 1},
			{"decider-combinator", 2},
			{"arithmetic-combinator", 1},
		},
		result = "memory-combinator"
	}
})


-- Entity
local memory = deepcopy(data.raw["combinator"]["constant-combinator"])
overwriteContent(memory, {
	name = "memory-combinator",
	energy_usage_per_tick = "150KW",
	
})

memory.minable.result = "memory-combinator"
data:extend({	memory })


addTechnologyUnlocksRecipe("optics","memory-combinator")
