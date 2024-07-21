package = "fibonacci-modulo"
version = "dev-1"
source = {
	url = "git+https://github.com/thenumbernine/fibonacci-modulo.git"
}
description = {
	summary = "Plots the Fibonacci sequence modulo some number on a circle.",
	detailed = "Plots the Fibonacci sequence modulo some number on a circle.",
	homepage = "https://github.com/thenumbernine/fibonacci-modulo",
	license = "MIT"
}
dependencies = {
	"lua >= 5.1"
}
build = {
	type = "builtin",
	modules = {
		["fibonacci-modulo.1-make-collage-individual"] = "1-make-collage-individual.lua",
		["fibonacci-modulo.2-combine-collage"] = "2-combine-collage.lua",
		["fibonacci-modulo.fibonacci"] = "fibonacci.lua",
		["fibonacci-modulo.plot-density"] = "plot-density.lua",
		["fibonacci-modulo.run"] = "run.lua",
		["fibonacci-modulo.which-are-dense"] = "which-are-dense.lua"
	}
}
