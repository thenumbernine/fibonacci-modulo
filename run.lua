#!/usr/bin/env luajit
local table = require 'ext.table'

local App = require 'imguiapp.withorbit'()

local cmdline = require 'ext.cmdline'(...)
--print(require 'ext.tolua'(cmdline))

local n = ... or 10

-- do we want to take a pic and leave?
local doScreenshotAndExit = cmdline.screenshot

local sequence

local gl

if cmdline.width then App.width = cmdline.width end
if cmdline.height then App.height = cmdline.height end

function App:init(...)
	self.title = 'Fibonacci Sequence Modulo '..n
	return App.super.init(self, ...)
end

function App:initGL(gl_, ...) 
	App.super.initGL(self, gl_, ...)
	gl = gl_
	self.view.ortho = true
	self.view.orthoSize = 1.1


	-- [=[ TOOD I use this often enough, put it in one place
	gradTex = require 'gl.gradienttex'(256, 
--[[ rainbow or heatmap or whatever
		{
			{0,0,0,0},
			{1,0,0,1/6},
			{1,1,0,2/6},
			{0,1,1,3/6},
			{0,0,1,4/6},
			{1,0,1,5/6},
			{0,0,0,6/6},
		},
--]]
-- [[ sunset pic from https://blog.graphiq.com/finding-the-right-color-palettes-for-data-visualizations-fcd4e707a283#.inyxk2q43
		{
			{22/255,31/255,86/255,1},
			{34/255,54/255,152/255,1},
			{87/255,49/255,108/255,1},
			{156/255,48/255,72/255,1},
			{220/255,60/255,57/255,1},
			{254/255,96/255,50/255,1},
			{255/255,188/255,46/255,1},
			{255/255,255/255,55/255,1},
		},
--]]
		false
	)
	--]=]

	-- fibonacci modulo
	local f1 = 1
	local f2 = 1
	sequence = table{f1, f2}
	while true do
		local f3 = (f1 + f2) % n
		f1,f2 = f2,f3
		if f1 == 1 and f2 == 1 then break end
		sequence:insert(f3)
	end
end

local function getPt(i)
	local th = (i/n + .25)*2*math.pi
	return math.cos(th), math.sin(th)
end

function App:update(...)
	self.view:setup(self.width / self.height)	-- GLApp.View.apply update

	gl.glClearColor(0,0,0,1)			-- yes, on my linux, destination alpha does matter for the screenshots
	gl.glClear(gl.GL_COLOR_BUFFER_BIT)

	gradTex:enable()
	gradTex:bind()

	gl.glPointSize(3)
	gl.glBegin(gl.GL_POINTS)
	for i=0,n-1 do
		gl.glTexCoord1f(i/n)
		gl.glVertex2f(getPt(i))
	end
	gl.glEnd()
	gl.glPointSize(1)

	gl.glBegin(gl.GL_LINE_LOOP)
	for _,i in ipairs(sequence) do
		gl.glTexCoord1f(i/n)
		gl.glVertex2f(getPt(i))
	end
	gl.glEnd()
	
	gradTex:unbind()
	gradTex:disable()

	if doScreenshotAndExit then
		self:screenshotToFile(doScreenshotAndExit)
		self:requestExit()
	end

	App.super.super.update(self, ...)	-- ImGuiApp's update
end

--[[
TODO put this in a superclass?
but I'm only consolidating it with hydro-cl
and hydro-cl caches its image buffers for performance
so I want the ability to cache images here
but cache what? the image and its flipped target?
and retain the ability to handle resizes?
how about a screenshot-context / screenshot-temp object then?
--]]
function App:screenshotToFile(filename)
	local Image = require 'image'
	local w, h = self.width, self.height
	local ssimg = Image(w, h, 4, 'unsigned char')
	gl.glReadPixels(0, 0, w, h, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, ssimg.buffer)
	ssimg:flip():save(filename)
end

return App():run()
