### Input Example

const θ = 2.1
const ψ = θ * 6.8e-2

x = (a, b, c) -> π * ψ * a / 8 * (b^2 + c^2)
valname = "\\phi"
digits_after_decimal_point = 4

const measurements =
	(
		a=[20.5, 21.1, 19.8, 18.8, 20.3] * 1e-1,
		b=[60.5, 60.6, 60.8, 60.6, 60.3] * 1e-1,
		c=[2410, 2145, 2346, 2411, 2431] * 1e-3
	)

const errors =
	(
		a=5e-4,
		b=5e-4,
		c=5e-1
	)
