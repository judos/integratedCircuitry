-- @module Surface for compact-combinator
-- @usage local Surface = require('compact-combinator-surface')

-- global data used:
-- integratedCircuitry.surface = {
--		chunks = {
--			[x][y] = bool            -- true if chunk is used
--		},
--		templates = $entity        -- Chest for storing blueprint items
--	}


local Surface = {} -- exported interface
local private = {} -- private methods


-- returns the coordinates of a new chunk to be used for a compact-combinator
function Surface.newSpot(pos_x, pos_y)
	local data = private.data()
	
	-- spiral search
	local x = math.floor(pos_x / 32)
	local y = math.floor(pos_y / 32)
	local radius = 1
	local direction = 1

	while true do
		-- move Y up/down
		for dy = 1,radius do
			local chunk = {x, y}
			if not private.isChunkUsed(chunk) then
				private.markChunk(chunk, true)
				return chunk
			end
			y = y + direction
		end
		-- move X right/left
		for dx = 1,radius  do
			local chunk = {x, y}
			if not private.isChunkUsed(chunk) then
				private.markChunk(chunk, true)
				return chunk
			end
			x = x + direction
		end
		direction = -direction
		radius = radius + 1

		-- limit to a search square of approx. 50 x 50 (=2500) chunks
		if radius > 50 then
			return nil
		end

	end

end


function Surface.placeTiles(chunkPos, size)
	local tiles = {}
	local area = Surface.chunkArea(chunkPos, size)
	for x=area[1][1],area[2][1]-1 do for y=area[1][2],area[2][2]-1 do
		table.insert(tiles,{name="refined-concrete",position={x,y}})
	end end
	Surface.get().set_tiles(tiles)
end


function Surface.chunkMiddle(chunkPos)
	return {chunkPos[1] * 32 + 16, chunkPos[2] * 32 + 16}
end


function Surface.chunkArea(chunkPos, size)
	local start = - math.ceil((size-1)/2)
	local to = start + size
	local middle = Surface.chunkMiddle(chunkPos)
	return {{middle[1]+start, middle[2]+start}, {middle[1]+to, middle[2]+to}}
end


function Surface.freeSpot(chunkPos)
	local itemsDropped = Surface.removeEntities(chunkPos)
	local tiles = {}
	local area = Surface.chunkArea(chunkPos, 31)
	for x=area[1][1],area[2][1]-1 do for y=area[1][2],area[2][2]-1 do
		table.insert(tiles, {name="out-of-map",position={x,y}})
	end end
	Surface.get().set_tiles(tiles)
	private.markChunk(chunkPos, false)
	return itemsDropped
end


function Surface.removeEntities(chunkPos)
	local c = {chunkPos[1]*32, chunkPos[2]*32}
	local entities = Surface.get().find_entities({c,{c[1]+32,c[2]+32}})
	local itemsDropped = {}
	for _,x in pairs(entities) do
		if x.name ~= "compact-combinator-connection" and x.name ~= "character" and x.name ~= "compact-combinator-template-chest" then
			if x.name ~= "compact-combinator-port" and x.name ~= "compact-combinator-substation" and x.name ~= "electric-energy-interface" and x.name ~= "entity-ghost" then
				itemsDropped[x.name] = (itemsDropped[x.name] or 0)+1
			end
			x.destroy()
		end
	end
	return itemsDropped
end


Surface.name = "compact-circuits"


function Surface.get()
	private.init()
	return game.surfaces[Surface.name]
end


function Surface.templateInventory()
	return private.data().templates.get_inventory(defines.inventory.chest)
end


---------------------------------------------------
-- Private methods
---------------------------------------------------


function private.init()
	local d = global.integratedCircuitry
	if d.surface then return end
	d.surface = {
		chunks = {},
		-- templates = $entity       -- See at the end where chest is created
	}
	local surface = game.surfaces[Surface.name]
	game.create_surface(Surface.name,{width=1,height=1,peaceful_mode=true})
	surface = game.surfaces[Surface.name]
	surface.always_day = true
	surface.wind_speed = 0
	surface.request_to_generate_chunks({0,0}, 1)
	surface.force_generate_chunk_requests()
	-- remove 1 tile which was generated by mapgen
	local tiles = {}
	table.insert(tiles, {name="out-of-map",position={0,0}})
	surface.set_tiles(tiles)
	d.surface.templates = surface.create_entity{
		name="compact-combinator-template-chest",position={0,0},force=game.forces.player
	}
end


function private.data()
	private.init()
	return global.integratedCircuitry.surface
end


function private.isChunkUsed(chunk)
	local x = chunk[1]
	local y = chunk[2]
	local data = private.data().chunks
	--info("check chunk used: "..tostring(x)..", "..tostring(y))
	return data[x] and data[x][y]
end


function private.markChunk(chunk, used)
	local x = chunk[1]
	local y = chunk[2]
	local data = private.data().chunks
	--info("mark chunk used: "..tostring(x)..", "..tostring(y)..", "..tostring(used))
	if not data[x] then data[x] = {} end
	data[x][y] = used
end


return Surface