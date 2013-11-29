tests = ["chromosome.jl",
         "ga.jl",
         "gray.jl",
         "pso.jl",]

println("Running tests:")

for test in tests
    println(" * $(test)")
    include("src/$test")
    include("test/$test")
end
