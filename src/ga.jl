# ga.jl - A genetic algorithm
#
# This julia implementation is part of alji:
#  https://github.com/d9w/alji
#
# Copyright Dennis Wilson 2013, under the GPL (see alji for version)

const p_mutation = 0.05;
const p_crossover = 0.75;

type Chromosome
  genes::BitArray
  markers::Vector{Float64}
  fitness::Float64
end

function Chromosome(n::Int64)
  # n is the bit length of the chromosome
  genes = randbool(n)
  markers = []
  Chromosome(genes, markers, 0.0)
end

function Chromosome(lengths::Vector{Int64})
  # lengths is a vector of gene bit lengths
  genes = randbool(sum(lengths));
  markers = zeros(Int64,length(lengths)+1);
  for i=1:length(lengths)
    markers[i+1]=markers[i]+lengths[i]
  end
  Chromosome(genes, markers, 0.0)
end

function mutate(chrom::Chromosome)
  # bit string manipulation
  mutate = rand(length(chrom))
  chrom.genes[chance .< p_mutation] = ~chrom.genes[chance .< p_mutation]
end

function cross(p1::Chromosome, p2::Chromosome)
  # single-point crossover of two arbitratry chromosomes
  if rand() < p_crossover
    c_markers = intersect(p1.markers, p2.markers)
    if (length(c_markers) > 0)
      cross_point = c_markers[rand(1:length(c_markers))]
    else
      cross_point = rand(1:min(length(p1),length(p2)))
    end
    c1_markers = [p1.markers[p1.markers .<= cross_point],
                   p2.markers[p2.markers .> cross_point]]
    c2_markers = [p2.markers[p2.markers .<= cross_point],
                   p1.markers[p1.markers .> cross_point]]
    c1_genes = [p1.genes[1:cross_point],
                 p2.genes[cross_point+1:length(p2.genes)]]
    c1_genes = [p2.genes[1:cross_point],
                 p1.genes[cross_point+1:length(p1.genes)]]
  else
    c1_markers = p1.markers
    c2_markers = p2.markers
    c1_genes = p1.genes
    c2_genes = p2.genes
  end
  [Chromosome(c1_genes, c1_markers, 0.0),
    Chromosome(c2_genes, c2_markers, 0.0)]
end

function evaluate(chrom::Chromosome, fitness::Function)
  chrom.fitness = fitness(chrom.genes)
end
