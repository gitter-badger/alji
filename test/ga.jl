println("   * Create a chromosome")
chrom1 = Chromosome(5)
@assert(length(chrom1.genes)==5)
@assert(length(chrom1.markers)==2)
@assert(chrom1.fitness==0)

println("   * Create a chromosome")
chrom2 = Chromosome([3,2,4,1])
@assert(length(chrom2.genes)==10)
@assert(chrom2.markers==[0,3,5,9,10])
@assert(chrom2.fitness==0)

println("   * Crossover similar chromosomes")
chrom1 = Chromosome([3,2,4,1])
while (chrom1 == chrom2)
  chrom1 = Chromosome([3,2,4,1])
end
(c1, c2)=cross(chrom1, chrom2)
@assert(length(c1.genes)==length(chrom1.genes))
@assert(length(c2.genes)==length(chrom2.genes))
@assert(intersect(c1.markers,c2.markers)==intersect(chrom1.markers,chrom2.markers))
@assert(union(c1.markers,c2.markers)==union(chrom1.markers,chrom2.markers))
@assert(c1 != chrom1)
@assert(c2 != chrom2)
@assert(c1.markers[1] == 0)
@assert(c2.markers[1] == 0)
@assert(c1.markers[end] == length(c1.genes))
@assert(c2.markers[end] == length(c2.genes))

println("   * Crossover dissimilar chromosomes")
chrom1 = Chromosome(5)
(c1, c2)=cross(chrom1, chrom2)
@assert(length(c1.genes)==length(chrom1.genes))
@assert(length(c2.genes)==length(chrom2.genes))
@assert(sort(intersect(c1.markers,c2.markers)) ==
        sort(intersect(chrom1.markers,chrom2.markers)))
@assert(sort(union(c1.markers,c2.markers)) ==
        sort(union(chrom1.markers,chrom2.markers)))
@assert(c1 != chrom1)
@assert(c2 != chrom2)
@assert(c1.markers[1] == 0)
@assert(c2.markers[1] == 0)
@assert(c1.markers[end] == length(c1.genes))
@assert(c2.markers[end] == length(c2.genes))

println("   * Stochastic universal sampling")
genome = [Chromosome(i) for i in rand(10:20,6)]
[chrom.fitness = rand() for chrom in genome]
selection = select(genome, 4)
@assert(length(selection) == 4)
[@assert(chrom in genome) for chrom in selection]

println("   * Tournament selection")
genome = [Chromosome(i) for i in rand(10:20,10)]
[chrom.fitness = rand() for chrom in genome]
selection = select(genome, 3, 3)
@assert(length(selection) == 3)
[@assert(chrom in genome) for chrom in selection]
