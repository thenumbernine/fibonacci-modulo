#!/usr/bin/env luajit
local fib = require 'fibonacci-modulo.fibonacci'
local n = ... or 100000
require 'ext'
-- [[ gnuplotting
local fracs = table()
for i=2,n do
	local d = fib.density(fib.makeSequence(i), i)
	local f = d/i
	fracs:insert(f)
	print(i, f)
end
require 'gnuplot'{
	--persist = true,
	terminal = 'png size 1600,900 background "#ffffff"',
	output = 'pics/modulo-density.png',
	style = 'data dots',
	--style = 'data linespoints',
	data = {fracs},
	xlabel = 'modulo',
	ylabel = 'density',
	log = 'xy',
	{using='0:1', notitle=true},
}
--]]
--[[ symmath ... to see reduced fraction form
local symmath = require 'symmath'
symmath.tostring = symmath.export.SingleLine 
for i=2,n do
	local d = fib.density(fib.makeSequence(i), i)
	print(i, symmath.frac(d,i)())
end
--]]
