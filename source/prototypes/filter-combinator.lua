require "libs.prototypes.all"

-- Item, Recipe
data:extend({
	{
    type = "item",
    name = "filter-combinator",
    icon = "__integratedCircuitry__/graphics/icons/filter-combinator.png",
		icon_size = 32,
    flags = { "goes-to-quickbar" },
    subgroup = "circuit-network",
    place_result="filter-combinator",
    order = "c[combinators]-e[filter-combinator]",
    stack_size= 50,
  },
	{
    type = "recipe",
    name = "filter-combinator",
    enabled = false,
		hidden = true,
    ingredients =
    {
      {"copper-cable", 5},
      {"electronic-circuit", 5},
    },
    result = "filter-combinator"
  },
})

addTechnologyUnlocksRecipe("circuit-network","filter-combinator")


-- Entity
data:extend({
	{
    type = "constant-combinator",
    name = "filter-combinator",
    icon = "__base__/graphics/icons/constant-combinator.png",
		icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "filter-combinator"},
    max_health = 120,
    corpse = "small-remnants",

    collision_box = {{-0.35, -0.65}, {0.35, 0.65}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    item_slot_count = 18,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		sprites = {
      north = {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        x = 158,
        y = 63,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      },
      east = {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        y = 63,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      },
      south = {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        x = 237,
        y = 63,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      },
      west = {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        x = 79,
        y = 63,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      }
    },

    activity_led_sprites = {
      north =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-decider-north.png",
        width = 11,
        height = 12,
        frame_count = 1,
        shift = {0.265625, -0.53125},
      },
      east =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-decider-east.png",
        width = 11,
        height = 11,
        frame_count = 1,
        shift = {0.515625, -0.078125},
      },
      south =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-decider-south.png",
        width = 12,
        height = 12,
        frame_count = 1,
        shift = {-0.25, 0.03125},
      },
      west =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-decider-west.png",
        width = 12,
        height = 12,
        frame_count = 1,
        shift = {-0.46875, -0.5},
      }
    },

    activity_led_light = {
      intensity = 0.8,
      size = 1,
      color = {r = 1.0, g = 1.0, b = 1.0}
    },

    activity_led_light_offsets = {
      {0.265625, -0.53125},
      {0.515625, -0.078125},
      {-0.25, 0.03125},
      {-0.46875, -0.5}
    },

    circuit_wire_connection_points = {
      {
        shadow = {
          red = {0.15625, -0.28125},
          green = {0.65625, -0.25},
        },
        wire = {
          red = {-0.28125, -0.5625},
          green = {0.21875, -0.5625},
        }
      },
      {
        shadow = {
          red = {0.75, -0.15625},
          green = {0.75, 0.25},
        },
        wire = {
          red = {0.46875, -0.5},
          green = {0.46875, -0.09375},
        }
      },
      {
        shadow = {
          red = {0.75, 0.5625},
          green = {0.21875, 0.5625},
        },
        wire = {
          red = {0.28125, 0.15625},
          green = {-0.21875, 0.15625},
        }
      },
      {
        shadow = {
          red = {-0.03125, 0.28125},
          green = {-0.03125, -0.125},
        },
        wire = {
          red = {-0.46875, 0},
          green = {-0.46875, -0.40625},
        }
      }
    },
    circuit_wire_max_distance = 9
  },
})