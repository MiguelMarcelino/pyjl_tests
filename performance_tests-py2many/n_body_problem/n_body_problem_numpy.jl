using Printf


function combinations(l)
    result = []
    for x = 0:length(l)-2
        ls = l[x+2:end]
        for y in ls
            push!(result, [l[x+1], y])
        end
    end
    return Vector{Float64}(result)
end

PI = 3.141592653589793
SOLAR_MASS = 4 * PI * PI
DAYS_PER_YEAR = 365.24
SYSTEM = Vector{Float64}([
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS],
    [
        4.841431442464721,
        -1.1603200440274284,
        -0.10362204447112311,
        0.001660076642744037 * DAYS_PER_YEAR,
        0.007699011184197404 * DAYS_PER_YEAR,
        -6.90460016972063e-05 * DAYS_PER_YEAR,
        0.0009547919384243266 * SOLAR_MASS,
    ],
    [
        8.34336671824458,
        4.124798564124305,
        -0.4035234171143214,
        -0.002767425107268624 * DAYS_PER_YEAR,
        0.004998528012349172 * DAYS_PER_YEAR,
        2.3041729757376393e-05 * DAYS_PER_YEAR,
        0.0002858859806661308 * SOLAR_MASS,
    ],
    [
        12.894369562139131,
        -15.111151401698631,
        -0.22330757889265573,
        0.002964601375647616 * DAYS_PER_YEAR,
        0.0023784717395948095 * DAYS_PER_YEAR,
        -2.9658956854023756e-05 * DAYS_PER_YEAR,
        4.366244043351563e-05 * SOLAR_MASS,
    ],
    [
        15.379697114850917,
        -25.919314609987964,
        0.17925877295037118,
        0.0026806777249038932 * DAYS_PER_YEAR,
        0.001628241700382423 * DAYS_PER_YEAR,
        -9.515922545197159e-05 * DAYS_PER_YEAR,
        5.1513890204661145e-05 * SOLAR_MASS,
    ],
])
PAIRS = combinations(SYSTEM)
function advance(dt, n, bodies = SYSTEM, pairs = PAIRS)
    for i = 0:n-1
        for j = 0:length(pairs)-1
            (x1, y1, z1, v11, v12, v13, m1), (x2, y2, z2, v21, v22, v23, m2) = pairs[j+1]
            dx = x1 - x2
            dy = y1 - y2
            dz = z1 - z2
            mag = dt * ((dx * dx + dy * dy) + dz * dz)^-1.5
            b1m = m1 * mag
            b2m = m2 * mag
            pairs[(j, 0, 3)+1] -= dx * b2m
            pairs[(j, 0, 4)+1] -= dy * b2m
            pairs[(j, 0, 5)+1] -= dz * b2m
            pairs[(j, 1, 3)+1] += dx * b1m
            pairs[(j, 1, 4)+1] += dy * b1m
            pairs[(j, 1, 5)+1] += dz * b1m
        end
        for (r1, r2, r3, vx, vy, vz, m) in bodies
            r1 += dt * vx
            r2 += dt * vy
            r3 += dt * vz
        end
    end
end

function report_energy(bodies = SYSTEM, pairs = PAIRS, e = 0.0)
    for ((x1, y1, z1, v11, v12, v13, m1), (x2, y2, z2, v21, v22, v23, m2)) in pairs
        dx = x1 - x2
        dy = y1 - y2
        dz = z1 - z2
        e -= m1 * m2 / ((dx * dx + dy * dy) + dz * dz)^0.5
    end
    for (r1, r2, r3, vx, vy, vz, m) in bodies
        e += m * ((vx * vx + vy * vy) + vz * vz) / 2.0
    end
    @printf("%.9f\n", e)
end

function offset_momentum(ref, bodies = SYSTEM, px = 0.0, py = 0.0, pz = 0.0)
    for (r1, r2, r3, vx, vy, vz, m) in bodies
        px -= vx * m
        py -= vy * m
        pz -= vz * m
    end
    m = ref[end]
    ref[4] = px / m
    ref[5] = py / m
    ref[6] = pz / m
end

function main(n)
    vectorize(np, offset_momentum(SYSTEM[1]))
    vectorize(np, report_energy())
    advance(0.01, n)
    vectorize(np, report_energy())
end

if abspath(PROGRAM_FILE) == @__FILE__
    start = perf_counter()
    main(500000)
    end_ = perf_counter()
    println("")
end
