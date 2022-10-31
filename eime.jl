### Estimator of Indirect Measurement Errors (EIME)

import Pkg
Pkg.activate(".")
Pkg.instantiate()

import Statistics
using ForwardDiff

flabel = "f"
digits_after_decimal_point = 4

function stdround(val)
	return round(val, digits=digits_after_decimal_point)
end

function enclose_subscript(str::String)
	n_layers = 0
	res = ""
	for char in str
		res *= char
		if char == '_'
			res *= '{'
			n_layers += 1
		end
	end
	res *= repeat('}', n_layers)
	return res
end

if length(ARGS) == 0
	@error "path to an input file was not provided"
	exit()
end

include(ARGS[1])

const vars = [enclose_subscript(string(var)) for var in keys(measurements)]

macro args()
	Meta.parse("""
		(i) -> [$(join(["measurements.$var[i]" for var in keys(measurements)], ','))]
	""")
end

args = @args()

const p = 0.95
const n = length(measurements[1])

## Student's Distribution
## p = 0.95, 3 ≤ n ≤ 10

const distribution_factors =
	(
		t=[3.18, 2.78, 2.57, 2.45, 2.36, 2.31, 2.26, 2.23],
		β=[1.30, 0.72, 0.51, 0.40, 0.33, 0.29, 0.25, 0.23],
		u=[0.94, 0.76, 0.64, 0.58, 0.52, 0.47, 0.42, 0.41],
		v=[1.15, 1.46, 1.67, 1.82, 1.94, 2.03, 2.11, 2.18],
	)

macro tests()
	return Meta.parse("""
		(n) -> ($(join(["$k = distribution_factors.$k[n-2]" for k in keys(distribution_factors)], ',')))
	""")
end

tests = @tests()(n)

## Calculations

const vals = [stdround(f(args(i)...)) for i = 1:n]
const mean = Statistics.mean(vals) |> stdround
const sd = Statistics.stdm(vals[1:n], mean, corrected=true) |> stdround

const gross_errors_present = !(abs(minimum(vals) - mean) / sd ≤ tests.v && abs(maximum(vals) - mean) / sd ≤ tests.v)
if gross_errors_present
	@warn "gross errors present, please exclude erroneous values for calculations to be more reliable"
end

const sdm = sd / sqrt(n) |> stdround
const randerr = tests.t * sdm |> stdround
const gradients = [ForwardDiff.gradient((args) -> f(args...), args(i)) for i = 1:n]
const syserr = n \ sum(abs(gradients[i][j]) * errors[j] for j = 1:length(vars), i = 1:n) |> stdround
const abserr = sqrt(randerr^2 + syserr^2) |> stdround

const linebreak = "\\\\"
function labeled(label, str)
	join(["\\text{$label}", str], linebreak * ' ')
end

println(
	join(
		map(
			(pair) -> labeled(pair[1] * ':', pair[2]),
			[
				("Distribution Factors", "v_{p,n} = $(tests.v),\\,\\, t_{p,n} = $(tests.t)"),
				("Initial values", "$(enclose_subscript("$(flabel)_i")) = \\{$(join(vals, ", "))\\}"),
				("Mean value", "\\bar{$(flabel)} = \\frac{1}{n}\\sum_{i = 1}^{n}$(flabel)_i = $(mean)"),
				("Standard deviation", "S_{$(flabel)} = \\sqrt{\\frac{1}{n-1}\\sum_{i=1}^{n}($(flabel)_i-\\bar{$(flabel)})^2} = $(sd)"),
				("Check for gross errors", "\\left\\{\\begin{array}{lr} \\frac{|$(flabel)_{min} - \\bar{$(flabel)}|}{S_{$(flabel)}} \\le v_{p,n} \\\\ \\frac{|$(flabel)_{max} - \\bar{$(flabel)}|}{S_{$(flabel)}} \\le v_{p,n} \\end{array}\\right." * (gross_errors_present ? "\\\\ \\text{Gross errors present!}" : "")),
				("Standard deviation of the mean", "S_{\\bar{$(flabel)}} = \\frac{S_{$(flabel)}}{\\sqrt{n}} = $(sdm)"),
				("Random error", "\\Delta{\\bar{$(flabel)}} = t_{p,n} \\cdot S_{\\bar{$(flabel)}} = $(randerr)"),
				("Mean systematic error", "\\theta_{$(flabel)} = \\frac{1}{n} \\sum_{\\chi \\in \\{$(join(vars, ','))\\}} \\theta_\\chi ( \\sum_{i = 1}^{n} |\\frac{\\partial{$(flabel)}}{\\partial{\\chi}}($(join(["{$var}_i" for var in vars], ',')))| ) = $(syserr)"),
				("Absolute error", "\\Delta{$(flabel)} = \\sqrt{{\\Delta{\\bar{$(flabel)}}^2 + \\theta_{$(flabel)}^2}} = $(abserr)"),
				("Final value", "$(flabel) = \\bar{$(flabel)} \\pm \\Delta{$(flabel)} = $(mean) \\pm $(abserr),\\,\\, p = $(p),\\,\\, n = $(n)"),
			]),
		repeat(linebreak, 2) * '\n'
	)
)