### EIME Input File Example

## =============
## (1) Variables
## =============
const g = 9.8

## ================
## (2) Main formula
## ================
## Given τ(v₁, v₂) = (v₁+v₂)/g, where g = 9.8 as defined in (1) Variables:
## ----------------
f = (v_1, v_2) -> (v_1 + v_2) / g

## =========
## (3) Value
## =========
## ===========
## (3.1) Label
## ===========
## Given τ(v₁, v₂), `τ` has a escape sequence of `\tau`
## -----------
label = "\\tau"
## ==========
## (3.2) Unit
## ==========
unit = "s"

## =====================
## (4) Decimal precision
## =====================
digits_after_decimal_point = 2

## ====================
## (5) Measurement Data
## ====================
## ==================
## (5.1) Measurements
## ==================
const measurements =
	(
		v_1=[1388, 1536, 1726, 1664, 1771],
		v_2=[142, 155, 171, 162, 175],
	)
## ==================
## (5.2) Errors
## ==================
const errors =
	(
		v_1=1,
		v_2=0.5,
	)
