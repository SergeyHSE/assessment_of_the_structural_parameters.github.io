net search outreg2
net search ivreg2
ssc install ivreg2 

//Descriptive statistics and graphing
sum inv_real gdp_real

gen id = _n

line inv_real annual, name(inv_real)
line gdp_real annual, name(gdp_real)
scatter inv_real gdp_real, name(gdp_inv)
graph combine gdp_real inv_real gdp_inv

//Model evaluation
tsset annual
reg inv_real gdp_real L.inv_real L.gdp_real
est store ols

//Fit quality analysis
predict inv_real_hat, xb
predict e_hat, residual
twoway (line inv_real annual)(line inv_real_hat annual)||(line e_hat annual)

//Checking for heteroscedasticity
estat hettest e_hat

estat szroeter e_hat


//Chek specification
estat ovtest 

//Autocorrelation
estat dwatson

estat durbinalt

estat bgodfrey, lags(2)

archlm, lags(2)

ac e_hat, name(ac)
pac e_hat, name(pac)
graph combine ac pac

corrgram e_hat

dfuller e_hat

dfuller e_hat, trend

dfuller e_hat, drift

//ARIMA
arima e_hat, arima(1,0,0) 
estat ic 
arima e_hat, arima(1,0,1)
estat ic 

scalar mu = _b[gdp_real]/(1-_b[L.inv_real])
scalar lambda = 1-_b[L.inv_real]
scalar delta = 1+_b[L.gdp_real]/_b[gdp_real]
di mu
di delta
di lambda

nlcom _b[gdp_real]/(1-_b[L.inv_real])
nlcom 1+_b[L.gdp_real]/_b[gdp_real]
nlcom 1-_b[L.inv_real]

//2sls
ivreg2 inv_real gdp_real L.gdp_real (L.inv_real = L2.inventory L2.inv_real L2.gdp_real)
est store sls

estat ic

scalar mu = _b[gdp_real]/(1-_b[L.inv_real])
scalar lambda = 1-_b[L.inv_real]
scalar delta = 1+_b[L.gdp_real]/_b[gdp_real]
di mu
di delta
di lambda

nlcom _b[gdp_real]/(1-_b[L.inv_real])
nlcom 1+_b[L.gdp_real]/_b[gdp_real]
nlcom 1-_b[L.inv_real]

//gmm
ivreg2 inv_real gdp_real L.gdp_real (L.inv_real = L2.inventory L2.inv_real L2.gdp_real), gmm2s robust
est store sgmm

ivreg2 inv_real gdp_real L.gdp_real (L.inv_real = L2.inventory L2.inv_real L2.gdp_real), gmm2s
est store gmm2s

estat ic

scalar mu = _b[gdp_real]/(1-_b[L.inv_real])
scalar lambda = 1-_b[L.inv_real]
scalar delta = 1+_b[L.gdp_real]/_b[gdp_real]
di mu
di delta
di lambda

nlcom _b[gdp_real]/(1-_b[L.inv_real])
nlcom 1+_b[L.gdp_real]/_b[gdp_real]
nlcom 1-_b[L.inv_real]

hausman sls ols

hausman gmm2s ols 

//ARIMAX (1.0.0)
arima inv_real gdp_real L.inv_real L.gdp_real, arima(1,0,0)
est store arima1

estat ic

scalar mu = _b[gdp_real]/(1-_b[L.inv_real])
scalar lambda = 1-_b[L.inv_real]
scalar delta = 1+_b[L.gdp_real]/_b[gdp_real]
di mu
di delta
di lambda

nlcom _b[gdp_real]/(1-_b[L.inv_real])
nlcom 1+_b[L.gdp_real]/_b[gdp_real]
nlcom 1-_b[L.inv_real]

predict inv_real_arima1, xb
predict e_arima1, residual
ac e_arima1, name(ac1)
pac e_arima1, name(pac1)
graph combine ac1 pac1

corrgram e_arima1

estat hettest e_arima1

twoway (line inv_real annual) (line inv_real_arima1 annual)||(line e_arima1 annual)

//ARIMAX (1.0.1)
arima inv_real gdp_real L.inv_real L.gdp_real, arima(1,0,1)
est store arima2

estat ic

scalar mu = _b[gdp_real]/(1-_b[L.inv_real])
scalar lambda = 1-_b[L.inv_real]
scalar delta = 1+_b[L.gdp_real]/_b[gdp_real]
di mu
di delta
di lambda

nlcom _b[gdp_real]/(1-_b[L.inv_real])
nlcom 1+_b[L.gdp_real]/_b[gdp_real]
nlcom 1-_b[L.inv_real]

predict inv_real_arima2, xb
predict e_arima2, residual
ac e_arima2, name(ac2)
pac e_arima2, name(pac2)
graph combine ac2 pac2

corrgram e_arima2

estat hettest e_arima2

twoway (line inv_real annual) (line inv_real_arima2 annual)||(line e_arima2 annual)

outreg2 using accel, word replace



