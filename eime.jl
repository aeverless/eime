### Estimator of Indirect Measurement Errors (EIME)

import Pkg
Pkg.activate(".")
Pkg.instantiate()

import Statistics
using ForwardDiff

valname = "\\phi"
digits_after_decimal_point = 4

function stdround(x)
	return round(x, digits=digits_after_decimal_point)
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

const vals = [stdround(x(args(i)...)) for i = 1:n]
const mean = Statistics.mean(vals) |> stdround
const sd = Statistics.stdm(vals[1:n], mean, corrected=true) |> stdround

const gross_errors_present = !(abs(minimum(vals) - mean) / sd ≤ tests.v && abs(maximum(vals) - mean) / sd ≤ tests.v)
if gross_errors_present
	@warn "gross errors present, please exclude erroneous values for calculations to be more reliable"
end

const sdm = sd / sqrt(n) |> stdround
const randerr = tests.t * sdm |> stdround
const gradients = [ForwardDiff.gradient((args) -> x(args...), args(i)) for i = 1:n]
const syserr = n \ sum(abs(gradients[i][j]) * errors[j] for j = 1:length(vars), i = 1:n) |> stdround
const abserr = sqrt(randerr^2 + syserr^2) |> stdround

const linebreak = "\\\\"
function labeled(label, str)
	join(["\\text{$label}", str], linebreak * ' ')
end

println(
	join(
		[
			labeled("Initial values:", "$(enclose_subscript("$(valname)_i")) = \\{$(join(vals, ", "))\\}"),
			labeled("Mean value:", "\\bar{$(valname)} = \\frac{1}{n}\\sum_{i = 1}^{n}$(valname)_i = $(mean)"),
			labeled("Standard deviation:", "S_{$(valname)} = \\sqrt{\\frac{1}{n-1}\\sum_{i=1}^{n}($(valname)_i-\\bar{$(valname)})^2} = $(sd)"),
			labeled("Check for gross errors:", "\\left\\{\\begin{array}{lr} \\frac{|$(valname)_{min} - \\bar{$(valname)}|}{S_{$(valname)}} \\le v_{p,n} \\\\ \\frac{|$(valname)_{max} - \\bar{$(valname)}|}{S_{$(valname)}} \\le v_{p,n} \\end{array}\\right." * (gross_errors_present ? "\\\\ \\text{Gross errors present!}" : "")),
			labeled("Standard deviation of the mean:", "S_{\\bar{$(valname)}} = \\frac{S_{$(valname)}}{\\sqrt{n}} = $(sdm)"),
			labeled("Random error:", "\\Delta{\\bar{$(valname)}} = t_{p,n} \\cdot S_{\\bar{$(valname)}} = $(randerr)"),
			labeled("Mean systematic error:", "\\theta_{$(valname)} = \\frac{1}{n} \\sum_{\\chi \\in \\{$(join(vars, ','))\\}} \\theta_\\chi ( \\sum_{i = 1}^{n} |\\frac{\\partial{$(valname)}}{\\partial{\\chi}}($(join(["{$var}_i" for var in vars], ',')))| ) = $(syserr)"),
			labeled("Absolute error:", "\\Delta{$(valname)} = \\sqrt{{\\Delta{\\bar{$(valname)}}^2 + \\theta_{$(valname)}^2}} = $(abserr)"),
			labeled("Final value:", "$(valname) = \\bar{$(valname)} \\pm \\Delta{$(valname)} = $(mean) \\pm $(abserr),\\,\\, p = $(p),\\,\\, n = $(n)"),
		],
		repeat(linebreak, 2) * '\n'
	)
)