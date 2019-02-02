*Load the extracted ACS datafile from by the Center for Economic and Policy Research*

*CLEAN THE ORIGINAL DATASET, DROP UNNESCESSARY VARIABLES*

drop wgtp1 wgtp2 wgtp3 wgtp4 wgtp5 wgtp6 wgtp7 wgtp8 wgtp9 wgtp10 wgtp11 wgtp12 wgtp13 wgtp14 wgtp15 wgtp16 wgtp17 wgtp18 wgtp19 wgtp20 wgtp21 wgtp22 wgtp23 wgtp24 wgtp25 wgtp26 wgtp27 wgtp28 wgtp29 wgtp30 wgtp31 wgtp32 wgtp33 wgtp34 wgtp35 wgtp36 wgtp37 wgtp38 wgtp40 wgtp39 wgtp41 wgtp42 wgtp43 wgtp44 wgtp45 wgtp46 wgtp47 wgtp48 wgtp49 wgtp50 wgtp51 wgtp52 wgtp53 wgtp54 wgtp55 wgtp56 wgtp57 wgtp58 wgtp59 wgtp60 wgtp61 wgtp62 wgtp63 wgtp64 wgtp65 wgtp66 wgtp67 wgtp68 wgtp69 wgtp70 wgtp71 wgtp72 wgtp73 wgtp74 wgtp75 wgtp76 wgtp77 wgtp78 wgtp79 wgtp80 perwgt pwgtp1 pwgtp2 pwgtp3 pwgtp4 pwgtp5 pwgtp6 pwgtp7 pwgtp8 pwgtp9 pwgtp10 pwgtp11 pwgtp12 pwgtp13 pwgtp14 pwgtp15 pwgtp16 pwgtp17 pwgtp18 pwgtp19 pwgtp20 pwgtp21 pwgtp22 pwgtp23 pwgtp24 pwgtp25 pwgtp26 pwgtp27 pwgtp28 pwgtp29 pwgtp30 pwgtp31 pwgtp32 pwgtp33 pwgtp34 pwgtp35 pwgtp36 pwgtp37 pwgtp38 pwgtp39 pwgtp40 pwgtp41 pwgtp42 pwgtp43 pwgtp44 pwgtp45 pwgtp46 pwgtp47 pwgtp48 pwgtp49 pwgtp50 pwgtp51 pwgtp52 pwgtp53 pwgtp54 pwgtp55 pwgtp56 pwgtp57 pwgtp58 pwgtp59 pwgtp60 pwgtp61 pwgtp62 pwgtp63 pwgtp64 pwgtp65 pwgtp66 pwgtp67 pwgtp68 pwgtp69 pwgtp70 pwgtp71 pwgtp72 pwgtp73 pwgtp74 pwgtp75 pwgtp76 pwgtp77 pwgtp78 pwgtp79 pwgtp80 anc1p05 anc2p05 anc1p08 yoep citwp nop ddrs05 deye05 dout05 dphy05 drem05 dwrk05 eng year serialno sporder division lngi mig dvis dhear dself dis drat lanx
drop jwrip jwmnp jwtr jwap jwdp ags refr rntm toilet ybl08 ybl05 ybl_all
drop vacs fmigsp fmigp migpuma migsp migsp2012 mover lanp16 hhlanp
drop adj_h puma hsgwgt resmode type vacant bus conp_adj handheld fiberop dsl dialup compothx broadbnd access laptop modem hispeed smartphone tablet othsvcex satellite
drop aapisub2_2005 aapisub2_2012 aapisub pi_d2012 pi_d2005 asian_d2005 asian_d2012 rac3p2005 rac2p2005
drop educ05 occp10 socp05 socp06 socp10 hh60 aapi asian mil_ly milstat state
drop fod1p09 fod2p09 fod1p10 fod2p10 anc2p08 mhp_adj mrgi mrgp_adj mrgt ind3d_05 ind3d_08 ind3d_09 ind3d_12
drop acr bath bld hfl mrgx sink smp_adj stove tel ten mv dcog damb dind hrearn05_adj hrwage05_adj fod1p09 fod2p09 fod1p10 fod2p10
drop incp_paw_adj  incp_ss_adj incp_ssi_adj incp_ret_adj incp_int_adj incp_oth_adj rinch_fs_adj inch_fs_adj rhrearn05_adj rhrwage05_adj rincp_paw_adj rincp_ss_adj rincp_ssi_adj rincp_ret_adj rincp_int_adj rincp_oth_adj
drop pobp05 pobp09 forbornm forbornf vps veteran
drop if sciengp = .
drop if civnonmil <1
*Restrict to only working age population
drop if age > 67
*Drop income that are less than 0 which is invalid
drop if incp_all_adj < 0
*only want noninstitutional population*
drop if mi(sciengp)


*CREATE NEW VARIABLES*
*1. STEM occupation*
gen STEM_occupation = 0
replace STEM_occupation = 1 if socp12 == 113021 | socp12 == 119041 | socp12 == 119111 | socp12 == 119121 | socp12 >= 151111 & socp12 <193093| socp12 >= 193094 & socp12 <=194099 | socp12 > 251011 & socp12 < 251081 | socp12 > 274099 & socp12 < 311011 | socp12 == 414011 | socp12 == 419031

*2. Labor force status*
gen Lfstat = string(lfstat)
drop if Lfstat == "3" 

*Restrict the sample to only the working population
gen Unemployed = 0
replace Unemployed = 1 if Lfstat == "2"
drop if Unemployed >0

*3. Year of Education*
egen yearOfEducation = group(educ08), nolabel
replace yearOfEducation = 16 if yearOfEducation == 1
replace yearOfEducation = 18 if yearOfEducation == 2 |yearOfEducation == 3
replace yearOfEducation = 22 if yearOfEducation == 4
drop if socp12 > 537199

*4. Regional dummies*
gen Northeast = 0 
egen nregion = group(region)
replace Northeast = 1 if nregion == 1
gen MidWest = 0
replace MidWest = 1 if nregion == 2
gen West = 0
replace West = 1 if nregion == 4

*5. Ln(Income)*
gen ln_Inc = ln(incp_all_adj)

*6. Squared Age*
gen Sq_Age = age^2

*7. Female in Science*
gen Female_Science = female*sciengp

*8. parttime variable*
gen parttime = 1 if Unemployed == 0
replace parttime = 0 if Unemployed == 0 & hrslyr >35

***************************************************CLEAN DATASET EXPORTED********************************************************************

gen Bachelor = 0
replace Bachelor = 1 if yearOfEducation == 16
gen Mast_Professional = 0
replace Mast_Professional = 1 if yearOfEducation == 18
gen Doctorate = 0
replace Doctorate = 1 if yearOfEducation == 22

gen Fem_Sci_STEM = female*sciengp*STEM_occupation
gen Female_STEM = female * STEM_occupation
gen Fem_PhD = female*Doctorate
gen Fem_Mast = female*Mast_Professional
gen Science_STEM = sciengp*STEM_occupation


*CREATE GRAPHS*
*1. Graph of Science vs Gender*
 graph bar, over(female, relabel(1 "Male" 2 "Female")) over(sciengp, relabel (1 "Non-Science" 2 "Science"))

 
*2. Graph of STEM vs. Gender*
 graph bar, over(female, relabel(1 "Male" 2 "Female")) over(STEM_occupation, relabel (1 "Non-STEM" 2 "STEM"))
 
 
*3. Graph of Ave Income by Races*
graph bar incp_all_adj, over(wbhao)


*4. Graph of Ave Income by Region*
graph bar incp_all_adj, over(region)


*RUN AN OLS*
reg incp_all_adj age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp selfinc



*FINAL MODEL*


*Command to create a table
esttab EquationA EquationB EquationC EquationE, star(* 0.10 ** 0.05 *** 0.01) staraux b(a3) se(3) stats (N r2_a rmse F rss, labels (N AdjR-squared MSE F-ratio SSR))


*Command to run the Breusch-Pagan F-test for Heteroskedasticity
estat hettest, fstat rhs


*Command to have a mean table
estpost tabstat age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime pubsect nonprof selfemp Fem_Sci_STEM Female_STEM Female_Science, by (STEM_occupation) statistics (mean sd median max min count) columns(statistics)


*Potential Best Model
reg ln_Inc age female racwht married nhhchild povpip sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp Fem_Sci_STEM Female_STEM Female_Science Doctorate Mast_Professional 



*MWD Test for functional Form of the dependent variable*
reg ln_Inc age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp
predict pre_LnEI, xb
gen m=exp(pre_LnEI)
reg incp_all_adj m,noconstant
 predict Pred_meqn, xb
corr incp_all_adj Pred_meqn
display 0.5464^2



*RANDOM TEST* --------------------------------------------------------------------------------------------------------------------------------------------
display 0.5494*0.5494
reg ln_Inc age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp
test STEM_occupation sciengp
predict r, resid
kdensity r, normal
pnorm r
reg ln_Inc age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp,robust
predict r_robust, resid
swilk r_robust
kwallis ln_Inc, by(STEM_occupation)
kdensity r_robust, normal
collin
reg ln_Inc age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp,robust
wls0 ln_Inc age female racwht married nhhchild povpip yearOfEducation sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp, wvar (age Sq_Age) type(abse) noconstant graph
*--------------------------------------------------------------------------------------------------------------------------------------------

gen Bachelor = 0
replace Bachelor = 1 if yearOfEducation == 16
gen Mast_Professional = 0
replace Mast_Professional = 1 if yearOfEducation == 18
gen Doctorate = 0
replace Doctorate = 1 if yearOfEducation == 22
gen Fem_Sci_STEM = female*sciengp*STEM_occupation
gen Female_STEM = female * STEM_occupation
gen Fem_PhD = female*Doctorate
gen Fem_Mast = female*Mast_Professional
gen Science_STEM = sciengp*STEM_occupation
reg incp_all_adj
reg incp_all_adj Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_Sci_STEM
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_Sci_STEM
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_Sci_STEM Fem_PhD Fem_Mast
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM
reg incp_all_adj Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_Sci_STEM
eststo EquationA

*MWD TEST*--------------------------------------------------------------------------------------------------------------------------------------------
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_Sci_STEM
predict pre_LnEI, xb
gen m=exp(pre_LnEI)
reg incp_all_adj m,noconstant
predict Pred_meqn, xb
corr incp_all_adj Pred_meqn
display 0.5566^2

*CREATE A TABLE *--------------------------------------------------------------------------------------------------------------------------------------------
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_Sci_STEM
eststo EquationB
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM
estat hettest, fstat rhs
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM
eststo EquationC
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM, robust
eststo EquationD
esttab EquationA EquationB EquationC EquationD, star(* 0.10 ** 0.05 *** 0.01) staraux b(a3) se(3) stats (N r2_a rmse F rss, labels (N AdjR-squared MSE F-ratio SSR))
reg ln_Inc Sq_Age age female racwht married nhhchild povpip sciengp STEM_occupation Northeast MidWest West parttime pubsect nonprof selfemp Doctorate Mast_Professional Female_Science Female_STEM Fem_PhD Fem_Mast
esttab EquationA EquationB EquationD, star(* 0.10 ** 0.05 *** 0.01) staraux b(a3) se(3) stats (N r2_a rmse F rss, labels (N AdjR-squared MSE F-ratio SSR))


*FINAL BEST MODEL*--------------------------------------------------------------------------------------------------------------------------------------------
reg ln_Inc age female racwht married nhhchild povpip sciengp Sq_Age Northeast MidWest West parttime STEM_occupation pubsect nonprof selfemp Female_STEM Female_Science Doctorate Mast_Professional, robust
vif
estat hettest, fstat rhs
