
local noImage = {
	filename = "__integratedCircuitry__/graphics/empty.png",
	priority = "low",
	width = 1,
	height = 1,
}

-- invisible combinators

entity = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"])
local REMOVE_KEY = "-remove-"
overwriteContent(entity, {
	name = "invisible-decider-combinator",
	order = "zzzz",
	selection_box = REMOVE_KEY,
	collision_box = REMOVE_KEY,
	collision_mask = {"water-tile", "item-layer", "object-layer"},
	draw_circuit_wires = false,
	energy_source = {
		type = "void",
	},
	flags = {
		"placeable-neutral", 
		"player-creation",
		"not-on-map",
		"not-blueprintable",
		"hide-alt-info",
		"not-deconstructable",
		"not-upgradable"
	},
	sprites = noImage,
	equal_symbol_sprites = noImage,
	greater_or_equal_symbol_sprites = noImage,
	greater_symbol_sprites = noImage,
	less_or_equal_symbol_sprites = noImage,
	less_symbol_sprites = noImage,
	not_equal_symbol_sprites = noImage,
	activity_led_sprites = noImage,

}, REMOVE_KEY)

data:extend({	entity })




entity = table.deepcopy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
local REMOVE_KEY = "-remove-"
overwriteContent(entity, {
	name = "invisible-arithmetic-combinator",
	order = "zzzz",
	selection_box = REMOVE_KEY,
	collision_box = REMOVE_KEY,
	collision_mask = {"water-tile", "item-layer", "object-layer"},
	draw_circuit_wires = false,
	energy_source = {
		type = "void",
	},
	flags = {
		"placeable-neutral", 
		"player-creation",
		"not-on-map",
		"not-blueprintable",
		"hide-alt-info",
		"not-deconstructable",
		"not-upgradable"
	},
	sprites = noImage,
	and_symbol_sprites = noImage,
	divide_symbol_sprites = noImage,
	left_shift_symbol_sprites = noImage,
	minus_symbol_sprites = noImage,
	modulo_symbol_sprites = noImage,
	multiply_symbol_sprites = noImage,
	or_symbol_sprites = noImage,
	plus_symbol_sprites = noImage,
	power_symbol_sprites = noImage,
	right_shift_symbol_sprites = noImage,
	xor_symbol_sprites = noImage,
	activity_led_sprites = noImage,

}, REMOVE_KEY)

data:extend({	entity })




entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
local REMOVE_KEY = "-remove-"
overwriteContent(entity, {
	name = "invisible-constant-combinator",
	order = "zzzz",
	selection_box = REMOVE_KEY,
	collision_box = REMOVE_KEY,
	collision_mask = {"water-tile", "item-layer", "object-layer"},
	draw_circuit_wires = false,
	flags = {
		"placeable-neutral", 
		"player-creation",
		"not-on-map",
		"not-blueprintable",
		"hide-alt-info",
		"not-deconstructable",
		"not-upgradable"
	},
	sprites = noImage,
	activity_led_sprites = noImage,

}, REMOVE_KEY)

data:extend({	entity })