require "libs.all"

local inserter_offset_x = 0.01
local belt_offset_x = 0.02
local chest_offset_x = 0.04

function updateWireConnectionPoints(entity, offsetX)
	local connections = entity.circuit_wire_connection_point
	if connections ~= nil then
		if connections.shadow ~= nil and connections.shadow.red ~= nil then
			connections.shadow.red[1] = connections.shadow.red[1] + offsetX
		end
		if connections.wire ~= nil and connections.wire.red ~= nil then
			connections.wire.red[1] = connections.wire.red[1] + offsetX
		end
	end
end

for k,d in pairs(data.raw["transport-belt"]) do
	updateWireConnectionPoints(d, belt_offset_x)
end
for k,d in pairs(data.raw["inserter"]) do
	updateWireConnectionPoints(d, inserter_offset_x)
end
for k,d in pairs(data.raw["container"]) do
	updateWireConnectionPoints(d, chest_offset_x)
end