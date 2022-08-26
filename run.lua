#!/usr/bin/env luajit
local table = require 'ext.table'
local glCallOrDraw = require 'gl.call'

local App = require 'imguiapp.withorbit'()

local cmdline = require 'ext.cmdline'(...)
--print(require 'ext.tolua'(cmdline))

local n = ... or 10

-- do we want to take a pic and leave?
local doScreenshotAndExit = cmdline.screenshot

if cmdline.width then App.width = cmdline.width end
if cmdline.height then App.height = cmdline.height end

local gl
local sequence
function App:init(...)
	self.title = 'Fibonacci Sequence Modulo '..n
	return App.super.init(self, ...)
end

function App:initGL(...) 
	App.super.initGL(self, ...)
	gl = self.gl
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

	gl.glClear(gl.GL_COLOR_BUFFER_BIT)

	self.callList = self.callList or {}
	glCallOrDraw(self.callList, function()
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
	end)

	if doScreenshotAndExit then
		self:screenshotToFile(doScreenshotAndExit)
		self:requestExit()
	end

	App.super.super.update(self, ...)	-- ImGuiApp's update
end

return App():run()
