using Alji

tests = ["test/pso.jl",]

println("Running tests:")

for test in tests
    println(" * $(test)")
    include(test)
end
