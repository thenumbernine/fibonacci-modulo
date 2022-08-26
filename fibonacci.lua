local table = require 'ext.table'

local fib = {}

function fib.makeSequence(n)
	-- fibonacci modulo
	local f1 = 1
	local f2 = 1
	local sequence = table{f1, f2}
	while true do
		local f3 = (f1 + f2) % n
		f1,f2 = f2,f3
		-- stop once we loop
		if f1 == 1 and f2 == 1 then break end
		sequence:insert(f3)
	end
	return sequence 	
end

function fib.density(sequence, n)
	local dests = table()
	for _,f in ipairs(sequence) do dests[f] = true end
	return #dests:keys()	-- if this equals n then it is dense
end

function fib.isDense(sequence, n)
	return fib.density(sequence, n) == n
end

return fib
