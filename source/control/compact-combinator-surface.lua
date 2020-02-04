-- @module Surface for compact-combinator
-- @usage local Surface = require('compact-combinator-surface')

-- global data used:
-- integratedCircuitry.surface = {
--		next_chunk = {x,y},			ChunkPosition
--		empty_chunks = {
--			{x,y}, ...						ChunkPosition
--		},
--		width = width						number specifying how far it goes
--	}



local Surface = {}

-- returns the coordinates of a new chunk to be used for a compact-combinator
function Surface.newSpot()
	local data = global.integratedCircuitry
	if not data then err("Data not available"); return nil end
	if not data.surface then 
		data.surface = {
			next_chunk = {0,0},
			empty_chunks = {},
			width = 50
		}
	end
	data = data.surface
	
	-- If a spot got free use this instead of allocating new spot
	if #data.empty_chunks > 0 then
		return table.remove(data.empty_chunks)
	end
	
	local result = data.next_chunk
	local nextChunk = { result[1] + 1, result[2] }
	if nextChunk[1] >= data.width then
		nextChunk = { 0, nextChunk[2] + 1 }
	end
	data.next_chunk = nextChunk
	
	Surface.get().request_to_generate_chunks({result[1],result[2]}, 0)
	info("requested chunk-gen of "..serpent.block(result))
	return result
end

function Surface.placeTiles(chunkPosition)
	local tiles = {}
	for dx=0,31 do for dy=0,31 do
		local x = chunkPosition[1] * 32 + dx
		local y = chunkPosition[2] * 32 + dy
		table.insert(tiles,{name="sand-1",position={x,y}})
	end end
	Surface.get().set_tiles(tiles)
end


function Surface.freeSpot(chunkPosition)
	Surface.removeEntities(chunkPosition)
	local data = global.integratedCircuitry.surface
	table.insert(data.empty_chunks,chunkPosition)
end

function Surface.removeEntities(chunkPosition)
	local pos = {chunkPosition[1]*32, chunkPosition[2]*32}
	local entities = Surface.get().find_entities({{pos[1],pos[2]},{pos[1]+32,pos[2]+32}})
	for _,x in pairs(entities) do
		x.destroy()
	end
end

function Surface.get()
	local surfaceName = "compact-circuits"
	local surface = game.surfaces[surfaceName]
	if surface~=nil then return surface end
	game.create_surface(surfaceName,{width=1,height=1,peaceful_mode=true})
	surface = game.surfaces[surfaceName]
	surface.always_day = true
	surface.request_to_generate_chunks({0,0}, 0)
	return game.surfaces[surfaceName]
end





return Surface