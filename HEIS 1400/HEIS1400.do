** Ali Bahrami Sani
** Contact: alibahramisani.github.io

** HEIS 1400
* Data Path: https://www.amar.org.ir/%D8%AF%D8%A7%D8%AF%D9%87%D9%87%D8%A7-%D9%88-%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D8%A2%D9%85%D8%A7%D8%B1%DB%8C/%D9%87%D8%B2%DB%8C%D9%86%D9%87-%D9%88-%D8%AF%D8%B1%D8%A7%D9%85%D8%AF-%D8%AE%D8%A7%D9%86%D9%88%D8%A7%D8%B1/%D9%87%D8%B2%DB%8C%D9%86%D9%87-%D9%88-%D8%AF%D8%B1%D8%A7%D9%85%D8%AF-%DA%A9%D9%84-%DA%A9%D8%B4%D9%88%D8%B1#103181018---
* /
clear
**  1400Data  **
odbc load, table("U1400Data") lowercase
destring _all, replace force
gen urban=1
save U1400Data.dta, replace
clear
odbc load, table("R1400Data") lowercase
destring _all, replace force
gen urban=0
save R1400Data.dta, replace
append using U1400Data
save 1400Data.dta, replace
clear

** 1400P1 **
odbc load, table("U1400P1") lowercase
destring _all, force replace
gen long ostan = floor( address /100000000)
gen province = ostan - 100
drop ostan
gen long shahrestan = floor( address /1000000)
gen county = shahrestan - 10000
drop shahrestan
rename dycol01 MemberNumber
rename dycol03 Rel2Head
* replace BeHead = 0 if BeHead != 1
rename dycol09 ActSt
* replace ActSt=0 if ActSt!=1 & ActSt!=.
rename dycol04 Gender
replace Gender=0 if Gender==2
rename dycol05 Age
rename dycol10 Mar
* replace Mar=0 if Mar!=1 & Mar!=.
rename dycol06 Literacy
replace Literacy=0 if Literacy!=1
rename dycol07 IsEducating
replace IsEducating=0 if IsEducating==2
rename dycol08 Educ
replace Educ=0 if Literacy==0
egen Size= count(address), by(address)
gen urban=1
/*
egen WorkingAge = count(address) if Age>=15 & Age <=65, by(address)
*/
label var province "Province of residency"
label var address "Household ID"
label var Rel2Head "Relationship to the household head"
label var ActSt "Activity status"
label var Educ "Education level"
label var Size "Family size"
label var Mar "Marital status"
label var urban "Urbanity"
label var Gender ""
label var Age ""
label var Literacy ""
label define Rel2Head 0 "Not head" 1 "Head"
label values Rel2Head Rel2Head
label define ActSt 0 "Not employed" 1 "Employed"
label values ActSt ActSt
label define Gender 0 "Female" 1 "Male"
label values Gender Gender
label define Literacy 0 "Illiterate" 1 "Literate"
label values Literacy Literacy
label define Educ 0 "Illiteracy" 1 "Primary school" 2 "Middle school" 3 "High school" 4 "Diploma & pre-university" 5 "Associate degree" 6 "‌Bachelor" 7 "Master/professional doctorate" 8 "PhD" 9 "Other & unofficial"
label values Educ Educ
label define YesNo 0 "NO" 1 "YES"
label values IsEducating YesNo
label define Mar 0 "Not married" 1 "Married"
label values Mar Mar
label define urban 0 "Rural" 1 "Urban"
label values urban urban
save U1400P1.dta, replace
clear

odbc load, table("R1400P1") lowercase
destring _all, force replace
gen long ostan = floor( address /100000000)
gen province = ostan - 200
drop ostan
gen long shahrestan = floor( address /1000000)
gen county = shahrestan - 20000
drop shahrestan
rename dycol01 MemberNumber
rename dycol03 Rel2Head
* replace BeHead = 0 if BeHead != 1
rename dycol09 ActSt
* replace ActSt=0 if ActSt!=1 & ActSt!=.
rename dycol04 Gender
replace Gender=0 if Gender==2
rename dycol05 Age
rename dycol10 Mar
* replace Mar=0 if Mar!=1 & Mar!=.
rename dycol06 Literacy
replace Literacy=0 if Literacy!=1
rename dycol07 IsEducating
replace IsEducating=0 if IsEducating==2
rename dycol08 Educ
replace Educ=0 if Literacy==0
egen Size= count(address), by(address)
gen urban=0
/*
egen WorkingAge = count(address) if Age>=15 & Age <=65, by(address)
*/
label var province "Province of residency"
label var address "Household ID"
label var Rel2Head "Relationship to the household head"
label var ActSt "Activity status"
label var Educ "Education level"
label var Size "Family size"
label var Mar "Marital status"
label var urban "Urbanity"
label var Gender ""
label var Age ""
label var Literacy ""
label define Rel2Head 0 "Not head" 1 "Head"
label values Rel2Head Rel2Head
label define ActSt 0 "Not employed" 1 "Employed"
label values ActSt ActSt
label define Gender 0 "Female" 1 "Male"
label values Gender Gender
label define Literacy 0 "Illiterate" 1 "Literate"
label values Literacy Literacy
label define Educ 0 "Illiteracy" 1 "Primary school" 2 "Middle school" 3 "High school" 4 "Diploma & pre-university" 5 "Associate degree" 6 "‌Bachelor" 7 "Master/professional doctorate" 8 "PhD" 9 "Other & unofficial"
label values Educ Educ
label define YesNo 0 "NO" 1 "YES"
label values IsEducating YesNo
label define Mar 0 "Not married" 1 "Married"
label values Mar Mar
label define urban 0 "Rural" 1 "Urban"
label values urban urban
save R1400P1.dta, replace
append using U1400P1
save 1400P1.dta, replace

** 1400P1 and 1400Data -> 1400Demographics **
merge m:m address using 1400Data, nogen
drop takmil noekhn takmildesca takmildescb takmildescc jaygozin jaygozindesca jaygozindescb jaygozindescc blkabdjaygozin radifjaygozin 
gen WA=1 if Age >= 15 & Age <= 65
replace WA=0 if WA==.
egen WorkingAge = sum(WA), by(address)
drop WA
save 1400Demographics.dta, replace

** P3S01 **
clear
odbc load address = "Address" Expenditure01 = "DYCOL06", table("U1400P3S01") lowercase
destring _all, replace force
collapse (sum) expenditure01, by(address)
save U1400P3S01.dta, replace
clear
odbc load address = "Address" Expenditure01 = "DYCOL06", table("R1400P3S01") lowercase
destring _all, replace force
collapse (sum) expenditure01, by(address)
save R1400P3S01.dta, replace
append using U1400P3S01
save 1400P3S01.dta, replace

** P3S02 **
clear
odbc load address = "Address" Expenditure02 = "DYCOL06", table("U1400P3S02") lowercase
destring _all, replace force
collapse (sum) expenditure02, by(address)
save U1400P3S02.dta, replace
clear
odbc load address = "Address" Expenditure02 = "DYCOL06", table("R1400P3S02") lowercase
destring _all, replace force
collapse (sum) expenditure02, by(address)
save R1400P3S02.dta, replace
append using U1400P3S02
save 1400P3S02.dta, replace

** P3S03 **
clear 
odbc load address = "Address" Expenditure03 = "DYCOL03", table("U1400P3S03") lowercase
destring _all, replace force
collapse (sum) expenditure03, by(address)
save U1400P3S03.dta, replace
clear
odbc load address = "Address" Expenditure03 = "DYCOL03", table("R1400P3S03") lowercase
destring _all, replace force
collapse (sum) expenditure03, by(address)
save R1400P3S03.dta, replace
append using U1400P3S03
save 1400P3S03.dta, replace

** P3S04 **
clear 
odbc load address = "Address" Expenditure04 = "DYCOL04", table("U1400P3S04") lowercase
destring _all, replace force
collapse (sum) expenditure04, by(address)
save U1400P3S04.dta, replace
clear
odbc load address = "Address" Expenditure04 = "DYCOL04", table("R1400P3S04") lowercase
destring _all, replace force
collapse (sum) expenditure04, by(address)
save R1400P3S04.dta, replace
append using U1400P3S04
save 1400P3S04.dta, replace

** P3S05 P3S06 P3S07 P3S08 P3S09 **
forvalues i = 5/9{
	** PS0`i' **
	clear 
	odbc load address = "Address" Expenditure0`i' = "DYCOL03", table(	"U1400P3S0`i'") lowercase
	destring _all, replace force
	collapse (sum) expenditure0`i', by(address)
	save U1400P3S0`i'.dta, replace
	clear
	odbc load address = "Address" Expenditure0`i' = "DYCOL03", table("R1400P3S0`i'") lowercase
	destring _all, replace force
	collapse (sum) expenditure0`i', by(address)
	save R1400P3S0`i'.dta, replace
	append using U1400P3S0`i'
	save 1400P3S0`i'.dta, replace
}

** PS11 P3S12 **
forvalues i = 11/12{
	** PS0`i' **
	clear 
	odbc load address = "Address" Expenditure`i' = "DYCOL03", table(	"U1400P3S`i'") lowercase
	destring _all, replace force
	collapse (sum) expenditure`i', by(address)
	save U1400P3S`i'.dta, replace
	clear
	odbc load address = "Address" Expenditure`i' = "DYCOL03", table("R1400P3S`i'") lowercase
	destring _all, replace force
	collapse (sum) expenditure`i', by(address)
	save R1400P3S`i'.dta, replace
	append using U1400P3S`i'
	save 1400P3S`i'.dta, replace
}

** P3S13 **
clear
odbc load address = "Address" LoanAmount_InsuranceNumber = "DYCOL02" LoanSource = "DYCOL03" expenditure13 = "DYCOL05", table(U1400P3S13)
encode LoanSource, gen(LoanSource1)
drop LoanSource
ren LoanSource1 LoanSource
destring address LoanAmount_InsuranceNumber expenditure13, replace force
gen LoanAmount = LoanAmount_InsuranceNumber if LoanAmount_InsuranceNumber>14
replace LoanAmount=0 if LoanAmount==.
drop LoanAmount_InsuranceNumber
*preserve
collapse (sum) expenditure13 LoanAmount, by(address)
*save tempLoanU.dta, replace
*restore
*keep address LoanSource
*merge m:m address using tempLoanU, nogen
save U1400P3S13.dta, replace
clear
odbc load address = "Address" LoanAmount_InsuranceNumber = "DYCOL02" LoanSource = "DYCOL03" expenditure13 = "DYCOL05", table(R1400P3S13)
encode LoanSource, gen(LoanSource1)
drop LoanSource
ren LoanSource1 LoanSource
destring address LoanAmount_InsuranceNumber expenditure13, replace force
gen LoanAmount = LoanAmount_InsuranceNumber if LoanAmount_InsuranceNumber>14
replace LoanAmount=0 if LoanAmount==.
drop LoanAmount_InsuranceNumber
*preserve
collapse (sum) expenditure13 LoanAmount, by(address)
*save tempLoanU.dta, replace
*restore
*keep address LoanSource
*merge m:m address using tempLoanU, nogen
save R1400P3S13.dta, replace
append using U1400P3S13
save 1400P3S13.dta, replace

** P3S14 **
clear
odbc load address = "Address" Expenditure14 = "DYCOL03", table("U1400P3S14") lowercase
destring _all, replace force
collapse (sum) expenditure14, by(address)
save U1400P3S14.dta, replace
clear
odbc load address = "Address" Expenditure14 = "DYCOL03", table("R1400P3S14") lowercase
destring _all, replace force
collapse (sum) expenditure14, by(address)
save R1400P3S14.dta, replace
append using U1400P3S14
save 1400P3S14.dta, replace
*************************************
****   Building Final Dataset    ****
*************************************
/*
   Individual Level
*/
clear
use 1400Demographics
forvalues i = 1/9{
	merge m:m address using 1400P3S0`i', nogen
}
forvalues i = 11/14{
	merge m:m address using 1400P3S`i', nogen
}
forvalues i = 1/9{
	replace expenditure0`i'=0 if expenditure0`i'==.
}
forvalues i = 11/14{
	replace expenditure`i'=0 if expenditure`i'==.
}
gen TotalExpenditure = expenditure01 + expenditure02 + expenditure03 + expenditure04 + expenditure05 + expenditure06 + expenditure07 + expenditure08 + expenditure09 + expenditure11 + expenditure12 + expenditure13 + expenditure14
gen FoodExpenses = expenditure01 + expenditure02
ren expenditure03 ClothesExpenses
ren expenditure04 HousingExpenses
ren expenditure05 HomeApplianceExpenses
ren expenditure06 MedicalExpenses
ren expenditure07 TransportationExpenses
ren expenditure08 CommunicationExpenses
ren expenditure09 RecreationExpenses
ren expenditure11 HotelingRestExpenses
ren expenditure12 ServicesOtherExpenses
ren expenditure13 DurableLoanExpenses
ren expenditure14 InvestmentExpenses
save IndividualExpenditure1400.dta, replace
/*
   Household Level
*/
clear
use 1400Demographics
keep if Rel2Head==1
forvalues i = 1/9{
	merge m:m address using 1400P3S0`i', nogen
}
forvalues i = 11/14{
	merge m:m address using 1400P3S`i', nogen
}
forvalues i = 1/9{
	replace expenditure0`i'=0 if expenditure0`i'==.
}
forvalues i = 11/14{
	replace expenditure`i'=0 if expenditure`i'==.
}

gen TotalExpenditure = expenditure01 + expenditure02 + expenditure03 + expenditure04 + expenditure05 + expenditure06 + expenditure07 + expenditure08 + expenditure09 + expenditure11 + expenditure12 + expenditure13 + expenditure14
*replace Mar=0  if Mar!=1
gen AgeSq = Age^2
gen WorkingAgeSq = WorkingAge^2
gen FoodExpenses = expenditure01 + expenditure02
ren expenditure03 ClothesExpenses
ren expenditure04 HousingExpenses
ren expenditure05 HomeApplianceExpenses
ren expenditure06 MedicalExpenses
ren expenditure07 TransportationExpenses
ren expenditure08 CommunicationExpenses
ren expenditure09 RecreationExpenses
ren expenditure11 HotelingRestExpenses
ren expenditure12 ServicesOtherExpenses
ren expenditure13 DurableLoanExpenses
ren expenditure14 InvestmentExpenses
save HouseholdExpenditure.dta, replace
***************************************************************************
*****************Multi Dimentional Poverty Index***************************
***************************************************************************
clear
** 1400P2 **
odbc load,  table("U1400P2") lowercase
ren dycol01 HomeOwnership
ren dycol03 NoRooms
ren dycol04 HouseArea
ren dycol05 HouseStructure
ren dycol06 Material
ren dycol07 Car
ren dycol08 MotorBike
ren dycol09 Bike
ren dycol10 Radio
ren dycol11 Multiplayer
ren dycol12 OldTV
ren dycol13 ColorTV
ren dycol14 DVD
ren dycol15 Computer
ren dycol16 CellPhone
ren dycol17 Freezer
ren dycol18 Refrige
ren dycol19 Refreezer
ren dycol20 Stove
ren dycol21 VacCleaner
ren dycol22 WashMachine
ren dycol23 SewMachine
ren dycol24 Fan
ren dycol25 P_WaterCooler
ren dycol26 P_AC
ren dycol27 DishWasher
ren dycol28 Microwave
ren dycol29 NONE
ren dycol30 PipeWater
ren dycol31 Elec
ren dycol32 PipeGas
ren dycol33 Tel
ren dycol34 Internet
ren dycol35 Bath
ren dycol36 Kitchen
ren dycol37 F_WaterCooler
ren dycol38 CentralCooling
ren dycol39 CentralHeating
ren dycol40 Package
ren dycol41 F_AC_Cooler
ren dycol42 Sewage
ren dycol43 CookingFuel
ren dycol44 HeatingFuel
save U1400P2.dta, replace

clear

odbc load, table("R1400P2") lowercase 
ren dycol01 HomeOwnership
ren dycol03 NoRooms
ren dycol04 HouseArea
ren dycol05 HouseStructure
ren dycol06 Material
ren dycol07 Car
ren dycol08 MotorBike
ren dycol09 Bike
ren dycol10 Radio
ren dycol11 Multiplayer
ren dycol12 OldTV
ren dycol13 ColorTV
ren dycol14 DVD
ren dycol15 Computer
ren dycol16 CellPhone
ren dycol17 Freezer
ren dycol18 Refrige
ren dycol19 Refreezer
ren dycol20 Stove
ren dycol21 VacCleaner
ren dycol22 WashMachine
ren dycol23 SewMachine
ren dycol24 Fan
ren dycol25 P_WaterCooler
ren dycol26 P_AC
ren dycol27 DishWasher
ren dycol28 Microwave
ren dycol29 NONE
ren dycol30 PipeWater
ren dycol31 Elec
ren dycol32 PipeGas
ren dycol33 Tel
ren dycol34 Internet
ren dycol35 Bath
ren dycol36 Kitchen
ren dycol37 F_WaterCooler
ren dycol38 CentralCooling
ren dycol39 CentralHeating
ren dycol40 Package
ren dycol41 F_AC_Cooler
ren dycol42 Sewage
ren dycol43 CookingFuel
ren dycol44 HeatingFuel
save R1400P2.dta, replace
append using U1400P2 
destring _all ,replace force
foreach var of varlist HomeOwnership-HeatingFuel{
	replace `var' = 0 if `var'==.
}
save 1400P2.dta, replace

merge m:m  address using 1400P1, nogen

merge m:m  address using 1400Data, nogen 
drop radifjaygozin blkabdjaygozin jaygozindescc jaygozindescb jaygozindesca jaygozin takmildescc takmildescb takmildesca takmil noekhn fasl istel fvam
save MDPI1400.dta, replace
clear
** OPHI MPI Variables **
use MDPI1400
* egen Yofu6 = total(Educ), by(address )
* gen Yofu6 = fYof /Size
gen y6 =1 if Educ<1
egen Yofu6 = total(y6), by(address )
replace Yofu6=3 if Yofu6>=1
replace Yofu6=1 if Yofu6==0
replace Yofu6=0 if Yofu6==3
gen SA8 = 1 if Age >=14 & Educ==2
replace SA8=0 if SA8==.
gen SolidFuel = 1 if CookingFuel!=1 | CookingFuel!=2 | CookingFuel!=3 | CookingFuel!=4| CookingFuel!=5
replace SolidFuel=0 if SolidFuel==.
gen AP = Radio+ ColorTV +Tel +Computer+ Bike+ MotorBike +Refreezer+ Freezer +Refrige 
gen AssetPoverty=1 if AP>1 & Car==0
replace AssetPoverty=0 if AssetPoverty==.
drop AP
** Hosehold Level **
** CountyMDPI1400 **
collapse (mean) HomeOwnership NoRooms HouseArea HouseStructure Material Car MotorBike Bike Radio Multiplayer OldTV ColorTV DVD Computer CellPhone Freezer Refrige Refreezer Stove VacCleaner WashMachine SewMachine Fan P_WaterCooler P_AC DishWasher NONE PipeWater Elec PipeGas Tel Internet Bath Kitchen F_WaterCooler CentralCooling CentralHeating Package F_AC_Cooler Sewage CookingFuel HeatingFuel Microwave urban Size county province weight AssetPoverty SolidFuel SA8 Yofu6, by(address) 
*YofSU6
replace SA8=1 if SA8>0
ren county countyname
ren province provincename
collapse (mean) HomeOwnership NoRooms HouseArea HouseStructure Material Car MotorBike Bike Radio Multiplayer OldTV ColorTV DVD Computer CellPhone Freezer Refrige Refreezer Stove VacCleaner WashMachine SewMachine Fan P_WaterCooler P_AC DishWasher NONE PipeWater Elec PipeGas Tel Internet Bath Kitchen F_WaterCooler CentralCooling CentralHeating Package F_AC_Cooler Sewage CookingFuel HeatingFuel Microwave urban Size provincename AssetPoverty SolidFuel SA8 Yofu6 [pweight = weight], by(countyname)
save CountyMDPI1400.dta, replace
clear
use HouseholdExpenditure
gen ClothingShare = ClothesExpenses/TotalExpenditure
gen HousingShare = HousingExpenses/TotalExpenditure
gen ApplianceShare = HomeApplianceExpenses/TotalExpenditure
gen MedicalShare = MedicalExpenses/TotalExpenditure
gen TransportationShare = TransportationExpenses/TotalExpenditure
gen CommunicationShare = CommunicationExpenses/TotalExpenditure
gen RecreationShare = RecreationExpenses/TotalExpenditure
gen HotelingResShare = HotelingRestExpenses/TotalExpenditure
gen ServicesOtherShare = ServicesOtherExpenses/TotalExpenditure
gen DurableLoanShare = DurableLoanExpenses/TotalExpenditure
gen InvestmentShare = InvestmentExpenses/TotalExpenditure
collapse (mean) HotelingResShare InvestmentShare DurableLoanShare ServicesOtherShare RecreationShare CommunicationShare TransportationShare MedicalShare ApplianceShare HousingShare ClothingShare [pweight = weight], by(county)
ren county countyname
merge 1:1 countyname using CountyMDPI1400, nogen
save CountyMDPI1400, replace