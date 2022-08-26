#!/usr/bin/env luajit
local fib = require 'fibonacci-modulo.fibonacci'
local n = ... or 10000
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
	terminal = 'svg size 1024,768',
	output = 'pics/modulo-density.svg',
	data = {fracs},
	xlabel = 'modulo',
	ylabel = 'density',
	{using='0:1', notitle=true},
}
--]]
--[[ symmath
local symmath = require 'symmath'
symmath.tostring = symmath.export.SingleLine 
for i=2,n do
	local d = fib.density(fib.makeSequence(i), i)
	print(i, symmath.frac(d,i)())
end
--]]
