#!/usr/bin/env luajit
require 'ext'
local collagedir = 'collage'
local fs = table()
for f in os.listdir(collagedir) do
	fs:insert(f)
end
fs:sort(function(a,b)
	-- prioritize number sorting
	local na = tonumber(a:match'(%d+)%.png')
	local nb = tonumber(b:match'(%d+)%.png')
	if na and nb then return na < nb end
	-- sort by string otherwise
	if na then return true end
	if nb then return false end
	return a < b
end)
local n = #fs
local w = math.ceil(math.sqrt(n))
local h = math.ceil(math.sqrt(n))
print(w, h)
local Image = require 'image'
local img0 = Image(collagedir..'/'..fs[1])
local targetImage = Image(w * img0.width, h * img0.height, 4, 'unsigned char')
for i,f in ipairs(fs) do
	local x = (i-1)%w
	local y = (i-1-x)/w
	targetImage:pasteInto{
		image = Image(collagedir..'/'..f),
		x = x * img0.width,
		y = y * img0.height,
	}
	print(f,x,y)
end
targetImage:save'collage.png'
