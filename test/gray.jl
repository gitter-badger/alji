println("   * Gray to binary")
g = trues(4)
b = graytobin(g)
print("    "); bitprint(g); print("->"); bitprint(b); println();
@assert(b[1])
@assert(~b[2])
@assert(b[3])
@assert(~b[4])

println("   * binary to int")
n_bits = rand(1:8)
b = trues(n_bits)
sol = (2^n_bits)-1
print("    "); bitprint(b); print("->"); println(sol);
@assert(bintoint(b) == sol)

println("   * Gray to binary to int")
g = trues(3)
b = graytobin(g)
print("    "); bitprint(b); print("->"); bitprint(g); println("->5");
@assert(bintoint(b) == 5)
