### EIME Input File Example

## =============
## (1) Variables
## =============
const g = 9.8

## ================
## (2) Main formula
## ================
## Given Φ(m₁, m₂) = (m₁+m₂)g, where g = 9.8 as defined in (1) Variables:
## ----------------
x = (m_1, m_2) -> (m_1 + m_2) * g

## ==============
## (3) Value name
## ==============
## Given Φ(m₁, m₂), `Φ` has a escape sequence of `\Phi`
## --------------
valname = "\\Phi"

## =====================
## (4) Decimal precision
## =====================
digits_after_decimal_point = 2

## ====================
## (5) Measurement Data
## ====================
##
## ==================
## (5.1) Measurements
## ==================
const measurements =
	(
		m_1=[10, 15, 45, 70, 10],
		m_2=[1, 5, 8, 12, 14],
	)
## ==================
## (5.2) Errors
## ==================
const errors =
	(
		m_1=0.1,
		m_2=0.05,
	)
