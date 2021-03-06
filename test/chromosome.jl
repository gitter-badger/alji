println("   * Create a chromosome")
chrom1 = Chromosome(5)
@assert(length(chrom1.genes)==5)
@assert(length(chrom1.markers)==2)

println("   * Create a chromosome")
chrom2 = Chromosome([0,3,5,9,10])
@assert(length(chrom2.genes)==10)
@assert(chrom2.markers==[0,3,5,9,10])

println("   * Mutate a chromosome")
chrom = Chromosome(10000)
genes1 = deepcopy(chrom.genes)
mutate(chrom)
@assert(genes1 != chrom.genes)

println("   * Crossover similar chromosomes")
chrom1 = Chromosome([0,3,5,9,10])
while (chrom1 == chrom2)
  chrom1 = Chromosome([0,3,5,9,10])
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
