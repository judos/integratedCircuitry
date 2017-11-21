require "libs.all"

local updated_belt_connection_points = {
  shadow = {
    red = {0.803125, -0.296875},
    green = {0.703125, -0.203125},
  },
  wire = {
    red = {0.5375, -0.59375},
    green = {0.4375, -0.46875},
  }
}


for k,d in pairs(data.raw["transport-belt"]) do
	d.circuit_wire_connection_point = updated_belt_connection_points
end