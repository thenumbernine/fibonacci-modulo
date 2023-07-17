#!/usr/bin/env luajit
require 'ext'
local collagedir = 'collage'
path(collagedir):mkdir()
local function printAndReturn(...)
	print(...)
	return ...
end
local function exec(s)
	print('>'..s)
	return printAndReturn(os.execute(s))
end
for i=2,101 do
	exec(table{
		'./run.lua',
		i,
		'width=256',
		'height=256',
		'screenshot='..collagedir..'/'..i..'.png'
	}:concat' ')
end
