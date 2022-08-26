#!/usr/bin/env luajit
local math = require 'ext.math'
local table = require 'ext.table'
local fib = require 'fibonacci-modulo.fibonacci'
local n = ... or 100000
local w = math.ceil(math.sqrt(n))
local Image = require 'image'
local img = Image(w,w,1,'unsigned char')
local dense = table()
for i=2,n do
	local d = fib.density(fib.makeSequence(i), i)
	local x = i % w
	local y = (i - x) / w
	if d == i then
		print(i, d==i, ' : '..math.primeFactorization(i):concat', ')
		dense:insert(i)
		img.buffer[x + w * y] = 255
	end
end
img:save'pics/which-are-dense-binary.png'
require 'gnuplot'{
	terminal = 'png size 1600,900 background "#ffffff"',
	output = 'pics/which-are-dense.png',
	data = {dense},
	log = 'xy',
	{using='0:1', notitle=true},
}
