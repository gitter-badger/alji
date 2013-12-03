include("../src/gray.jl")

println("  * Create an individual")
genome = [Chromosome(i) for i in rand(10:20,6)]
ind1 = Individual(genome)
@assert(ind1.genome != genome)
[@assert(ind1.genome[i].markers == genome[i].markers) for i=1:length(genome)]
@assert(ind1.fitness == -Inf)

println("   * Mutate an individual")
ind2 = deepcopy(ind1)
mutate(ind2)
@assert(ind2 != ind1)

println("   * Crossover individuals")
(c1, c2)=cross(ind1, ind2)
@assert(c1 != ind1)
@assert(c2 != ind2)
@assert(c1 != c2)

println("   * Stochastic universal sampling")
genome = [Chromosome(i) for i in rand(10:20,6)]
pop = [Individual(genome) for i=1:10]
[ind.fitness = rand() for ind in pop]
selection = select(pop, 4)
@assert(length(selection) == 4)
[@assert(ind in pop) for ind in selection]

println("   * Tournament selection")
genome = [Chromosome(i) for i in rand(10:20,10)]
pop = [Individual(genome) for i=1:10]
[ind.fitness = rand() for ind in pop]
selection = select(pop, 3, 3)
@assert(length(selection) == 3)
[@assert(ind in pop) for ind in selection]

println("   * Run the GA")
function rosenbrock(genome::Vector{Chromosome})
    x = [bintoint(genome[1].genes),
         bintoint(genome[2].genes)]
    return -((1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2)
end

# two 8 bit ints
genome = [Chromosome(8), Chromosome(8)]
(bestgenome, bestfit) = ga(genome, rosenbrock)
println(bestfit)
