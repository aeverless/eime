### Estimator of Indirect Measurement Errors (EIME)

import Statistics
using ForwardDiff

include(ARGS[1])

const vars = keys(measurements)

macro args()
	Meta.parse("""
		(i) -> [$(join(["measurements.$var[i]" for var in vars], ','))]
	""")
end

args = @args()

const n = length(measurements[1])

## Student's Distribution
## p = 0.95, 3 ≤ n ≤ 10

const distribution_factors =
	(
		t=[3.18, 2.78, 2.57, 2.45, 2.36, 2.31, 2.26, 2.23],
		β=[1.30, 0.72, 0.51, 0.40, 0.33, 0.29, 0.25, 0.23],
		u=[0.94, 0.76, 0.64, 0.58, 0.52, 0.47, 0.42, 0.41],
		v=[1.15, 1.46, 1.67, 1.82, 1.94, 2.03, 2.11, 2.18]
	)

macro tests()
	return Meta.parse("""
		(n) -> ($(join(["$k = distribution_factors.$k[n-2]" for k in keys(distribution_factors)], ',')))
	""")
end

tests = @tests()(n)

## Calculations

const xs = [x(args(i)...) for i = 1:n]
println("Xs: ", join(xs, ", "))

const mean = Statistics.mean(xs)
println("Mean of x: ", mean)

const sd = Statistics.stdm(xs[1:n], mean, corrected=true)
println("Standard deviation: ", sd)

if !(abs(minimum(xs) - mean) / sd ≤ tests.v && abs(maximum(xs) - mean) / sd ≤ tests.v)
	println("Gross errors found!")
end

const sd_mean = sd / sqrt(n)
println("Standard deviation of the mean: ", sd_mean)

const Δmean = tests.t * sd_mean
println("Δ of the mean: ", Δmean)

const gradients = [ForwardDiff.gradient((args) -> x(args...), args(i)) for i = 1:n]
println("Gradients: ", join(gradients, ", "))

const θₓ = n \ sum(abs(gradients[i][j]) * errors[j] for j = 1:length(vars), i = 1:n)
println("θₓ: ", θₓ)

const Δx = sqrt(Δmean^2 + θₓ^2)
println("Δx: ", Δx)

println("x = ", mean, " ± ", Δx)
