# Playing with binary and Gray code

function bitprint(bits::BitArray)
    for i=1:length(bits)
        if bits[i]
            print(1)
        else
            print(0)
        end
    end
end

function bintoint(bits::BitArray)
    pows = length(bits)-1:-1:0
    sum(2.^pows[bits])
end

function graytobin(bits::BitArray)
    shift = nextpow2(length(bits))/2
    while shift >= 1
        bits = bits $ (bits >> convert(Int64,shift))
        shift /= 2
    end
    bits
end
