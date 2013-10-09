using Alji

tests = ["test/gray.jl",
         "test/pso.jl",]

println("Running tests:")

for test in tests
    println(" * $(test)")
    include(test)
end
