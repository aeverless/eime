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
##     f = (t) -> Δh/t
##   - τ(v₁, v₂) = (v₁+v₂)/g, where g = 9.8 as defined in (1) Variables:
##     f = (v_1, v_2) -> (v_1 + v_2) / g
## ----------------
f = () -> nothing

## =========
## (3) Value
## =========
## ===========
## (3.1) Label
## ===========
## Escaped label of value that will be used in the generated LaTeX document
## Default: "f"
## -----------
## Examples:
##   - Given v(t); `v` has no escape sequence as it is an ASCII character:
##     label = "v"
##   - Given ϕ(χ); `ϕ` has an escape sequence of `\phi` and `\` has to be escaped with another `\`:
##     label = "\\phi"
## -----------
label = "f"

## ==========
## (3.2) Unit
## ==========
## String that will denote the unit of values calculated
## Default: ""
## ----------
## Examples:
##   - Given v(t); v is a speed function:
##     unit may be "m/s", "km/h", etc.
##   - Given a(t); a is an acceleration function:
##     unit may be "m/s^2", "km/h^2", etc.
## ----------
unit = ""

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
## ============
## (5.2) Errors
## ============
## Systematic error values for each variable
## ------------
const errors =
	(

	)
## ------------
## Example:
##   const measurements =
##       (
##           v_1=[1388, 1536, 1726, 1664, 1771],
##           v_2=[142, 155, 171, 162, 175],
##       )
##   const errors =
##      (
##          v_1=1,
##          v_2=0.5,
##      )