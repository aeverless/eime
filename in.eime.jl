### EIME Input File

## =============
## (1) Variables
## =============
## You may define additional variables, constants and functions on top of what's required
## -------------
## Example:
##   const α = 3π/2
##   const β = -a * 4
##   const ψ = 6e-5
##   const g = 9.8
##   d = (v, t) -> v * t

## ================
## (2) Main formula
## ================
## This function will be used in calculations of main values
## Default: () -> nothing
## ----------------
## Examples:
##   - v(t) = Δh/t, where Δh is constant:
##     x = (t) -> Δh/t
##   - F(m₁, m₂) = (m₁+m₂)g, where g = 9.8 as per defined in (1) Variables:
##     x = (m_1, m_2) -> (m_1 + m_2) * g
## ----------------
x = () -> nothing

## ==============
## (3) Value name
## ==============
## Escaped name of value that will be used in generated LaTeX document
## Default: "x"
## --------------
## Examples:
##   - Given v(t); `v` has no escape sequence as it is an ASCII character:
##     valname = "v"
##   - Given ϕ(χ); `ϕ` has an escape sequence of `\phi` and `\` has to be escaped with another `\`:
##     valname = "\\phi"
## --------------
valname = "x"

## =====================
## (4) Decimal precision
## =====================
## Number of digits that decimal values will be rounded to via `stdround`
## Default: 4
## ---------------------
digits_after_decimal_point = 4

## ====================
## (5) Measurement Data
## ====================
## (5.1) and (5.2) are both named tuples of float vectors, so you will have to input the data
## in the following way:
##   const vals =
##       (
##           a=[a₁, a₂, …, aₙ₋₁, aₙ],
##           b=[b₁, b₂, …, bₙ₋₁, bₙ],
##           c=[c₁, c₂, …, cₙ₋₁, cₙ],
##       )
## Default: ()
## ==================
## (5.1) Measurements
## ==================
## Measured values for each variable
## ------------------
const measurements =
	(

	)
## ==================
## (5.2) Errors
## ==================
## Systematic error values for each variable
## ------------------
const errors =
	(

	)
## ------------------
## Example:
##   const measurements =
##       (
##           A_x=[10, 25, 35, 50, 60],
##           A_y=[1, 5, 8, 12, 14],
##           b=[100, 124, 145, 147, 187],
##       )
##
##   const errors =
##       (
##           A_x=0.025,
##           A_y=0.05,
##           b=1.2e1,
##       )