#!/usr/bin/env luajit
local fib = require 'fibonacci-modulo.fibonacci'
local n = ... or 100
for i=2,n do
	print(i, fib.density(fib.makeSequence(i), i)/i)
end
