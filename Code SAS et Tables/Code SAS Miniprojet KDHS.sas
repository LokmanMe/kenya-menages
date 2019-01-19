/* QUEL LIEN Y A T IL ENTRE RICHESSE DU MENAGE ET EDUCATION DU CHEF DE MENAGE ? */

LIBNAME MP "C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA"; 

/* Visualisation du dictionnaire de la table initiale KDHS */
PROC CONTENTS DATA=MP.KDHS;
RUN;
/* On voit qu'il y a 9057 individus et 2191 variables. On va la tronquer pour se focaliser uniquement sur les variables qui nous intéressent */

/* Création de la table menage1 à partir de la table KDHS en ne gardant que les variables relatifs aux ménages */
data MP.menage1 (keep= HHID HV005 HV009 HV014 HV024--HV026 HV201--HV228);
set MP.kdhs;
run;

/* Création de la table menage2 à partir de la table KDHS en ajoutant des variables qui nous intéressent personnellement */
data MP.menage2 (keep= 	HHID HV005 HV009 HV014 HV024--HV026 HV201--HV228
						HV270 HV271 			/*Wealth index et Wealth factor score*/
						HV106_01 				/*Highest educational level pour LE CHEF DE FAMILLE SEULEMENT*/  );
set MP.kdhs;
run;


/* Création de la table menage3 à  partir de menage2 en assignant les bonnes caractéristiques aux variables qualitatives 
et ordinales (les variables quantitatives restent en format numérique bien évidemment).
+ Assignation des labels aux variables */
data mp.menage3;
set mp.menage2;
cHV024 = put(HV024,$1.);
cHV025 = put(HV025,$1.);
cHV026 = put(HV026,$1.);
cHV201 = put(HV201,$2.);
cHV202 = put(HV202,$2.);
cHV205 = put(HV205,$2.);
cHV206 = put(HV206,$1.);
cHV207 = put(HV207,$1.);
cHV208 = put(HV208,$1.);
cHV209 = put(HV209,$1.);
cHV210 = put(HV210,$1.);
cHV211 = put(HV211,$1.);
cHV212 = put(HV212,$1.);
cHV213 = put(HV213,$2.);
cHV214 = put(HV214,$2.);
cHV215 = put(HV215,$2.);
cHV217 = put(HV217,$1.);
cHV218 = put(HV218,$2.);
cHV219 = put(HV219,$1.);
cHV221 = put(HV221,$1.);
cHV225 = put(HV225,$1.);
cHV226 = put(HV226,$2.);
cHV227 = put(HV227,$1.);
cHV228 = put(HV228,$1.);

cHV270 = put(HV270,$1.);
cHV106_01 = put(HV106_01,$1.);

LABEL 
cHV024 = "Region"
cHV025 = "Type of place of residence"
cHV026 = "Place of residence"
cHV201 = "Source of drinking water"
cHV202 = "Source of non-drinking water"
cHV205 = "Type of toilet facility"
cHV206 = "Has electricity"
cHV207 = "Has radio"
cHV208 = "Has television"
cHV209 = "Has refrigerator"
cHV210 = "Has bicycle"
cHV211 = "Has motorcycle/scooter"
cHV212 = "Has car/truck"
cHV213 = "Main floor material" 
cHV214 = "Main wall material"
cHV215 = "Main roof material"
cHV217 = "Relationship structure"
cHV218 = "Line number of head of househ"
cHV219 = "Sex of head of household"
cHV221 = "Has telephone"
cHV225 = "Share toilet with other households"
cHV226 = "Type of cooking fuel"
cHV227 = "Have bednet for sleeping"
cHV228 = "Children under 5 slept under bednet last night"

cHV270 = "Wealth index"
cHV106_01 =  "Highest educational level of head of househ"
;
run;


/* Suppression des variables qualitatives aux caractéristiques numériques */
DATA mp.menage4; 
  SET MP.menage3; 
  DROP HV024 HV025 HV026 HV201 HV202 HV205 HV206 HV207 HV208 HV209 HV210 HV211 HV212 HV213 HV214 HV215 HV217 HV218 HV219 HV221 HV225 HV226 
HV227 HV228 HV270 HV106_01
; 
RUN; 


/* Création de la table menage :
On met la table menage4 dans menage (final) et on supprime toutes les tables intermédiaires (qui ont seulement servi à créer la table finale) */
DATA mp.menage;
SET mp.menage4;
RUN;
PROC DELETE DATA=mp.menage1 mp.menage2 mp.menage3 mp.menage4;
RUN;


/* Visualisation du dictionnaire de la table menage, notre table définitive.
On y apprend notamment qu'on a 34 variables et que les labels ont bien été pris en compte */
proc contents data=mp.menage;
run;


/* Création des formats dans la bibliothèque MP et on demande au programme (option fmt search) de chercher les formats dans MP */
PROC FORMAT LIB=MP;
VALUE $REGIONf
"1" = "Nairobi"
"2" = "Central"
"3" = "Coast"
"4" = "Eastern"
"5" = "Nyanza"
"6" = "Rift Valley"
"7" = "Western"
"8" = "Northeastern"
;
VALUE $TYPERESf
"1" = "Urban"
"2" = "Rural"
;
VALUE $PLACERESf
"0" = "Capital or large city"
"1" = "Small city"
"2" = "Town"
"3" = "Countryside"
"9" = "Missing"
"." = "Not applicable"
;
VALUE $SOURCEWATERf
"10" = "PIPED WATER"
"11" = "Piped into dwelling"
"12" = "Piped to yard/plot"
"13" = "Public tap/standpipe"
"20" = "TUBE WELL WATER"
"21" = "Tube well or borehole"
"30" = "DUG WELL OPEN or PROTECTED"
"31" = "Protected well"
"32" = "Unprotected well"
"40" = "SURFACE WATER"
"41" = "Protected spring"
"42" = "Unprotected spring"
"43" = "River/dam/lake/ponds/stream/canal/irirgation channel"
"51" = "Rainwater"
"61" = "Tanker truck"
"62" = "Cart with small tank"
"71" = "Bottled water"
"96" = "Other"
"99" = "Missing"
" ." = "Not applicable"
;
VALUE $SOURCENONWATERf
"10" = "PIPED WATER"
"11" = "Piped into dwelling"
"12" = "Piped to yard/plot"
"13" = "Public tap/standpipe"
"20" = "TUBE WELL WATER"
"21" = "Tube well or borehole"
"30" = "DUG WELL OPEN/PROTECTED"
"31" = "Protected well"
"32" = "Unprotected well"
"40" = "SURFACE WATER"
"41" = "Protected spring"
"42" = "Unprotected spring"
"43" = "River/dam/lake/ponds/stream/canal/irirgation channel"
"51" = "Rainwater"
"61" = "Tanker truck"
"62" = "Cart with small tank"
"71" = "Bottled water"
"96" = "Other"
"99" = "Missing"
" ." = "Not applicable"
;
VALUE $TYPETOILETf
"10" = "FLUSH TOILET"
"11" = "Flush   to piped sewer system"
"12" = "Flush   to septic tank"
"13" = "Flush   to pit latrine"
"14" = "Flush   to somewhere else"
"15" = "Flush   dont know where"
"20" = "PIT LATRINE TOILET"
"21" = "Pit latrine   ventilated improved pit VIP"
"22" = "Pit latrine   with slab"
"23" = "Pit latrine   without slab / open pit"
"30" = "NO FACILITY"
"31" = "No facility/bush/field"
"41" = "Composting toilet"
"42" = "Bucket toilet"
"43" = "Hanging toilet / hanging latrine"
"96" = "OTHER"
"99" = "Missing"
" ." = "Not applicable"
;
VALUE $NOYESMISSING
"0" = "No"
"1" = "Yes"
"9" = "Missing"
"." = "Not applicable"
;
VALUE $MAINFLOORf
"10" = "NATURAL"
"11" = "Earth, sand"
"12" = "Dung"
"20" = "RUDIMENTARY"
"21" = "Wood planks"
"22" = "Palm bamboo"
"30" = "FINISHED"
"31" = "Parquet polished wood"
"32" = "Vinyl asphalt strips"
"33" = "Ceramic tiles"
"34" = "Cement"
"35" = "Carpet"
"96" = "OTHER"
"99" = "Missing"
" ." = "Not applicable"
;
VALUE $MAINWALLf
"10" = "NATURAL"
"11" = "No walls"
"12" = "Cane / palm / trunks/ grass/ sticks"
"13" = "Dirt/ mud/ dung"
"20" = "RUDIMENTARY"
"21" = "Bamboo with mud"
"22" = "Stone with mud"
"23" = "Uncovered adobe"
"24" = "Plywood"
"25" = "Cardboard"
"26" = "Reused wood"
"27" = "Corrugated metal"
"30" = "FINISHED"
"31" = "Cement"
"32" = "Stone with lime / cement"
"33" = "Bricks"
"34" = "Cement blocks"
"35" = "Covered adobe"
"36" = "Wood planks / shingles"
"96" = "OTHER"
"99" = "Missing"
" ." = "Not applicable"
;
VALUE $MAINROOFf
"10" = "NATURAL"
"11" = "Thatch / palm leaf"
"12" = "Dung/ mud"
"20" = "RUDIMENTARY"
"21" = "Corregated iron (mabati)"
"22" = "Tin cans"
"30" = "FINISHED"
"31" = "Asbestos sheet"
"32" = "Concrete"
"33" = "Tiles"
"96" = "OTHER"
"99" = "Missing"
" ." = "Not applicable"
; 
VALUE $RELSHIPSTRUCTf
"0" = "No adults"
"1" = "One adult"
"2" = "Two adults, opp. sex"
"3" = "Two adults, same sex"
"4" = "Three+ related adult"
"5" = "Unrelated adults"
"." = "Not applicable"
;
VALUE $HEADHOUSEf
"1" = "Male"
"2" = "Female"
"9" = "Missing"
"." = "Not applicable"
;
VALUE $COOKINGFUELf
" 1" =  "Electricity"
" 2" =  "LPG/Natural gas"
" 4" =  "Biogas"
" 5" =  "Kerosene"
" 6" =  "Coal lignite"
" 7" =  "Charcoal"
" 8" =  "Wood"
" 9" =  "Straw / shrubs / grass"
"10" = "Agricultural crop"
"11" = "Animal dung"
"95" = "No food cooked in HH"
"96" = "Other"
"99" = "Missing"
" ." = "Not applicable"
;
VALUE $CHILDRENBEDNETf
"0" = "No"
"1" = "All children"
"2" = "Some children"
"3" = "No bednet in HH"
"9" = "Missing"
"." = "No children in household"
;
VALUE $WEALTHf
"1" = "Poorest"
"2" = "Poorer"
"3" = "Middle"
"4" = "Richer"
"5" = "Richest"
;
VALUE $HIGHESTEDUCf
"0" = "No education, preschool"
"1" = "Primary"
"2" = "Secondary"
"3" = "Higher"
"8" = "Don't know"
"9" = "Missing"
"." = "Not applicable"
;
RUN;

option fmtsearch=(MP);


/***************/
/* TRIS A PLAT */
/***************/

ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\ANNEXE 1 - TRIS A PLAT AVANT TRAITEMENT DES MODALITÉS.pdf" style=report_pdf;

PROC FREQ DATA=mp.menage ;
TABLE cHV024 cHV025 cHV026 cHV201 cHV202 cHV205 
cHV206 cHV207 cHV208 cHV209 cHV210 cHV211 cHV212 /*NOYESMISSING*/
cHV213 cHV214 cHV215 cHV217 cHV218 cHV219 cHV221		cHV225 cHV226 cHV227 cHV228 cHV270 cHV106_01;
FORMAT cHV024 $REGIONf. cHV025 $TYPERESf. cHV026 $PLACERESf. cHV201 $SOURCEWATERf. cHV202 $SOURCENONWATERf. cHV205 $TYPETOILETf.
cHV206 $NOYESMISSING. cHV207 $NOYESMISSING. cHV208 $NOYESMISSING. cHV209 $NOYESMISSING. cHV210 $NOYESMISSING. cHV211 $NOYESMISSING. cHV212 $NOYESMISSING. 
cHV213 $MAINFLOORf. cHV214 $MAINWALLf. cHV215 $MAINROOFf.
cHV217 $RELSHIPSTRUCTf.  cHV219 $HEADHOUSEf. cHV221 $NOYESMISSING.  cHV225 $NOYESMISSING. cHV226 $COOKINGFUELf. cHV227 $NOYESMISSING. cHV228 $CHILDRENBEDNETf. cHV270 $WEALTHf.
cHV106_01 $HIGHESTEDUCf.
;
TITLE "ANNEXE 1 : TRIS A PLAT DES VARIABLES QUALITATIVES AVANT TRAITEMENT DES MODALITÉS";
FOOTNOTE;
RUN;

ods pdf close;

/*On fait des tris à plat de toutes les variables qualitatives et ordinales avec la procédure FREQ
On n'oublie pas d'assigner les formats à  leurs variables correspondantes*/


/*ON REMARQUE QU'IL Y A TROP DE MODALITÉS POUR CERTAINES VARIABLES ON VA DONC CREER UNE TABLE MenageSimple QUI REGROUPERA DES MODALITÉS*/

DATA mp.menagesimple;
SET mp.menage;

/*cVH201 : SOURCE OF DRINKING WATER*/
if cHV201="10" or cHV201="11" or cHV201="20" or cHV201="21" or cHV201="31" or cHV201="41" or cHV201="71" 		then cHV201="1"; /*protected and good quality water*/
if cHV201="12" or cHV201="30" or cHV201="61" or cHV201="62"	or cHV201="96"										then cHV201="2"; /*medium quality and inconvienient source*/
if cHV201="13" or cHV201="32" or cHV201="40" or cHV201="42" or cHV201="43" or cHV201="51"						then cHV201="3"; /*unsafe water and very inconvienient source*/
if cHV201="99" or cHV201=" ."																					then delete;	 /*other, missing, not applicable*/


/*cHV202 : SOURCE OF NON-DRINKING WATER*/
if cHV202="10" or cHV202="11" or cHV202="20" or cHV202="21" or cHV202="31" or cHV202="41" or cHV202="71" 		then cHV202="1"; /*protected and good quality water*/
if cHV202="12" or cHV202="30" or cHV202="61" or cHV202="62"	or cHV202="96"										then cHV202="2"; /*medium quality and inconvienient source*/
if cHV202="13" or cHV202="32" or cHV202="40" or cHV202="42" or cHV202="43" or cHV202="51"						then cHV202="3"; /*unsafe water and very inconvienient source*/
if cHV202="99" or cHV202=" ."																					then delete;

/*cHV205 : TYPE OF TOILET FACILITY*/
if cHV205="10" or cHV205="11" or cHV205="12" or cHV205="13" or cHV205="14" or cHV205="15" 				 		then cHV205="1"; /*flush toilet (convenient)*/
if cHV205="20" or cHV205="21" or cHV205="22" or cHV205="23"														then cHV205="2"; /*pit latrine (inconvienient)*/
if cHV205="30" or cHV205="31" or cHV205="41" or cHV205="42" or cHV205="43"   									then cHV205="3"; /*no facility (unsafe)*/
if cHV205="96" or cHV205="99" or cHV205=" ."																	then delete;
	
/*cHV213 : MAIN FLOOR MATERIAL*/
if cHV213="30" or cHV213="31" or cHV213="32" or cHV213="33" or cHV213="34" or cHV213="35" 				 		then cHV213="1"; /*Very good quality*/
if cHV213="20" or cHV213="21" or cHV213="22"																	then cHV213="2"; /*Rudimentary*/
if cHV213="10" or cHV213="11" or cHV213="12" or cHV213=" ."					   									then cHV213="3"; /*Precarious*/
if cHV213="96" or cHV213="99" 																					then delete;

/*cHV214 : MAIN WALL MATERIAL*/
if cHV214="30" or cHV214="31" or cHV214="32" or cHV214="33" or cHV214="34" or cHV214="35" or cHV214="36" 		then cHV214="1"; /*Very good quality*/
if cHV214="20" or cHV214="21" or cHV214="22" or cHV214="23" or cHV214="24" or cHV214="25" or cHV214="26" or cHV214="27"		then cHV214="2"; /*Rudimentary*/
if cHV214="10" or cHV214="11" or cHV214="12" or cHV214="13"	or cHV214=" ."	   									then cHV214="3"; /*Precarious*/
if cHV214="96" or cHV214="99" 																					then delete;

/*cHV215 : MAIN ROOF MATERIAL*/
if cHV215="30" or cHV215="31" or cHV215="32" or cHV215="33"  											 		then cHV215="1"; /*Very good quality*/
if cHV215="20" or cHV215="21" or cHV215="22"																	then cHV215="2"; /*Rudimentary*/
if cHV215="10" or cHV215="11" or cHV215="12" or cHV215="96"					   									then cHV215="3"; /*Precarious*/
if cHV215="99" or cHV215=" ."																					then delete;

/*cHV226 : TYPE OF COOKING FUEL*/
if cHV226=" 1" or cHV226=" 2" or cHV226=" 4" 																 	then cHV226="1"; /*Very good quality*/
if cHV226=" 5" or cHV226=" 6" or cHV226=" 7" or cHV226=" 8"														then cHV226="2"; /*Rudimentary*/
if cHV226=" 9" or cHV226="10" or cHV226="11" or cHV226="95" 					   								then cHV226="3"; /*Precarious*/
if cHV226="96" or cHV226="99" or cHV226=" ."																	then delete;

/*SUPPRESSION DES MODALITÉS "NOT APPLICABLE", "MISSING", et "OTHER"*/
if cHV206="." or cHV208="." or cHV209="." or cHV210="."  
or cHV211="." or cHV212="." or cHV221="." 
/*or cHV225="."*/ or cHV227="." 
or cHV106_01="." or cHV106_01="8" then delete;
run;

/*pour tester
proc freq data=mp.menagesimple; table cHV201 cHV202 cHV205 cHV213 cHV214 cHV215 cHV226; run;
proc freq data=mp.menagesimple; table cHV206 cHV208 cHV209 cHV210 cHV211 cHV212 cHV221 cHV225 cHV227 cHV228 cHV106_01    ; run;
*/


/*CREATION DES FORMATS POUR LA TABLE MenageSimple ("fs" pour formats simplifiés)*/

PROC FORMAT LIB=MP;

VALUE $REGIONfs
"1" = "Nairobi"
"2" = "Central"
"3" = "Coast"
"4" = "Eastern"
"5" = "Nyanza"
"6" = "Rift Valley"
"7" = "Western"
"8" = "Northeastern"
;
VALUE $TYPERESfs
"1" = "Urban"
"2" = "Rural"
;
VALUE $PLACERESfs
"0" = "Capital or large city"
"1" = "Small city"
"2" = "Town"
"3" = "Countryside"
"9" = "Missing"
;
VALUE $SOURCEWATERfs
"1" = "Protected et good quality"
"2" = "Medium quality"
"3" = "Unsafe water"
;
VALUE $TYPETOILETfs
"1" = "Flush toilet (convenient)"
"2" = "Pit latrine (inconvenient)"
"3" = "No toilet (unsafe)"
;
VALUE $NOYES
"0" = "No"
"1" = "Yes"
;
VALUE $MATERIALandCOOKINGfs
"1" = "Very good quality"
"2" = "Rudimentary"
"3" = "Precarious"
;
VALUE $RELSHIPSTRUCTfs
"0" = "No adults"
"1" = "One adult"
"2" = "Two adults, opp. sex"
"3" = "Two adults, same sex"
"4" = "Three+ related adult"
"5" = "Unrelated adults"
;
VALUE $HEADHOUSEfs
"1" = "Male"
"2" = "Female"
;
VALUE $CHILDRENBEDNETfs
"0" = "No"
"1" = "All children"
"2" = "Some children"
"3" = "No bednet in HH"
"9" = "Missing"
"." = "No children in household"
;
VALUE $WEALTHfs
"1" = "Poorest"
"2" = "Poorer"
"3" = "Middle"
"4" = "Richer"
"5" = "Richest"
;
VALUE $HIGHESTEDUCfs
"0" = "No education, preschool"
"1" = "Primary"
"2" = "Secondary"
"3" = "Higher"
;
VALUE $NOYESTOILET
"0" = "No"
"1" = "Yes"
"." = "No toilet"
;
RUN;

ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\ANNEXE 2 - TRIS A PLAT APRES TRAITEMENT DES MODALITÉS.pdf" style=report_pdf;

/*TRIS A PLAT APRES TRAITEMENT DES MODALITÉS*/

PROC FREQ DATA=mp.menagesimple ;

TABLE cHV024 cHV025 cHV026 cHV201 cHV202 cHV205 
cHV206 cHV207 cHV208 cHV209 cHV210 cHV211 cHV212
cHV213 cHV214 cHV215 cHV217 /*cHV218*/ cHV219 cHV221		cHV225 cHV226 cHV227 cHV228 cHV270 cHV106_01;

FORMAT cHV024 $REGIONfs. cHV025 $TYPERESfs. cHV026 $PLACERESfs. 
cHV201 $SOURCEWATERfs. cHV202 $SOURCEWATERfs. 
cHV205 $TYPETOILETfs.
cHV206 $NOYES. cHV207 $NOYES. cHV208 $NOYES. cHV209 $NOYES. cHV210 $NOYES. cHV211 $NOYES. cHV212 $NOYES. cHV221 $NOYES.  cHV225 $NOYESTOILET. cHV227 $NOYES. 
cHV213 $MATERIALandCOOKINGfs. cHV214 $MATERIALandCOOKINGfs. cHV215 $MATERIALandCOOKINGfs. cHV226 $MATERIALandCOOKINGfs. 
cHV217 $RELSHIPSTRUCTfs.  cHV219 $HEADHOUSEfs. cHV228 $CHILDRENBEDNETfs. cHV270 $WEALTHfs.
cHV106_01 $HIGHESTEDUCfs.
;

TITLE "TRIS A PLAT DES VARIABLES QUALITATIVES";
RUN;

ods pdf close;

PROC FREQ DATA=mp.menagesimple ;
TABLE cHV270 cHV106_01;
FORMAT cHV270 $WEALTHfs. cHV106_01 $HIGHESTEDUCfs.;
RUN;


/***********************************************************************************/
/*IMPORTANT : On se servira à partir de maintenant que de la table mp.menagesimple */
/***********************************************************************************/

					/*INTERVALLE DE CONFIANCE QUALITATIVE*/
					PROC FREQ DATA=mp.menagesimple;
					TABLE cHV106_01/BINOMIAL;
					FORMAT cHV106_01 $HIGHESTEDUCfs.;
					RUN;
					/*INTERVALLE DE CONFIANCE QUALITATIVE*/

					/*INTERVALLE DE CONFIANCE QUANTITATIVE*/
					PROC FREQ DATA=mp.menagesimple;
					TABLE HV009/BINOMIAL;
					RUN;
					/*INTERVALLE DE CONFIANCE QUANTITATIVE*/

/* Comparaison des statistiques de la table menage et menagesimple pour être sûr qu'elles ne sont pas différentes */

ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\ANNEXE 3 - STATISTIQUES DES VARIABLES QUANTITATIVES AVANT ET APRES TRAITEMENT DES MODALITÉS.pdf" style=report_pdf;

PROC MEANS DATA=mp.menage N MEAN STD MIN MAX clm;
var HV009 HV014 HV009 HV014 HV204 HV216 HV220 HV271 ;
TITLE "Statistiques des variables quantitaves avant traitement des modalités";
FOOTNOTE "Avec les intervalles de confiance à 95%";
RUN;

PROC MEANS DATA=mp.menagesimple N MEAN STD MIN MAX clm;
var HV009 HV014 HV009 HV014 HV204 HV216 HV220 HV271 ;
TITLE "Statistiques des variables quantitaves après traitement des modalités";
FOOTNOTE "Avec les intervalles de confiance à 95%";
RUN;

ods pdf close;



/* On fait l'intervalle de confiance à 95% de la moyenne de toutes les variables quantitatives de la table menagesimple */

PROC MEANS DATA=mp.menagesimple alpha=0.05 clm;
var HV009 HV014 HV009 HV014 HV204 HV216 HV220 HV271;
TITLE "Intervalle de confiance de la moyenne à 95%";
RUN;


/*Visualisations graphiques*/

ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\ANNEXE 4 - GRAPHIQUES DESCRIPTIFS.pdf" style=report_pdf;

PROC GCHART DATA=MP.menagesimple ;
HBAR cHV106_01 ;
FORMAT cHV106_01 $HIGHESTEDUCfs.;
TITLE "Histogramme de la distribution du niveau d'éducation du chef de ménage";
FOOTNOTE;
RUN ;

PROC SGPLOT DATA=MP.menagesimple ;
HBAR cHV270 ;
FORMAT cHV270 $WEALTHf.;  
TITLE "Histogramme de la distribution du facteur de richesse";
RUN ;

PROC GCHART DATA=MP.menagesimple ;
PIE cHV270 ;
FORMAT cHV270 $WEALTHf.;
TITLE "Diagramme circulaire de la distribution du facteur de richesse";
RUN ;

PROC SGPLOT DATA=MP.menagesimple ;
VBOX HV271;
TITLE "Box-plot de la distribution des indices de richesse";
RUN ;

proc sort data=MP.menagesimple;
by cHV270;
run;
proc sgplot data=MP.menagesimple;
	scatter x=HV271 y=cHV270 / transparency=0.0 name='Scatter';
	xaxis grid;
	yaxis grid;
FORMAT cHV270 $WEALTHfs.;
  TITLE "Nuage de points du facteur de richesse par rapport à l'indice de richesse";
run;

ods pdf close;


/* Matrice des corrélations de Pearson des variables de la table menagesimple */
PROC corr data=mp.menagesimple;
TITLE;
RUN; 		


ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\A AJOUTER DANS L'ANNEXE 4.pdf" style=report_pdf;

proc sgplot data=MP.menagesimple;
	vbox HV271 / category=cHV106_01 fillattrs=(color=CXCAD5E5) name='Box';
	xaxis fitpolicy=splitrotate;
	yaxis grid;
FORMAT cHV106_01 $HIGHESTEDUCfs.;
TITLE "Box-plot des scores de richesse groupés par les niveaux d'éducation du chef de ménage";
run;

ods pdf close;
/*************************************************************************************/

ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\ANNEXE 5 - TABLEAUX CROISÉS ET TESTS D'INDEPENDANCE.pdf" style=report_pdf;
ods pdf text="ANNEXE 5 : TABLEAUX CROISÉS ET TESTS D'INDEPENDANCE";
ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";ods pdf text=" "; /*c'est pour faire des sauts de ligne lol*/

/* Analyse bivariée : tableaux croisés et tests d'indépendances (notamment le chi² celui qui nous intéresse) */

PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV026/chisq  ;
FORMAT cHV026 $PLACERESfs. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'place de résidence'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV201/chisq  ;
FORMAT cHV201 $SOURCEWATERfs. cHV106_01 $HIGHESTEDUCfs.;
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'source d'eau potable'"; 
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV205/chisq  ;
FORMAT cHV205 $TYPETOILETfs. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'types de toilettes'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV206/chisq  ;
FORMAT cHV206 $NOYES. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'possède électricité'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV209/chisq  ;
FORMAT cHV209 $NOYES. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'possède réfrigérateur'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV213/chisq  ;
FORMAT cHV213 $MATERIALandCOOKINGfs. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'qualité du sol'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV214/chisq  ;
FORMAT cHV214 $MATERIALandCOOKINGfs. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'qualité des murs'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV215/chisq  ;
FORMAT cHV215 $MATERIALandCOOKINGfs. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'qualité du plafond'";
RUN;
PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV227/chisq  ;
FORMAT cHV227 $NOYES. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'possède moustiquaire'";
RUN;

PROC FREQ DATA= MP.menagesimple;
TABLE cHV106_01*cHV270/expected chisq deviation cellchi2  ;
FORMAT cHV270 $WEALTHfs. cHV106_01 $HIGHESTEDUCfs. ; 
TITLE "Tableau croisé et tests d'indépendance de 'niveau d'éducation' par 'niveaux de richesse'";
RUN;

ods pdf close;



												/*****************************/
												/*            ACM            */
												/*****************************/

  /*****************************************************************************************************************************/
 /* Réalisation d'une ACM des variables cHV201, cHV205, cHV206--cHV209, cHV213, cHV221, cHV226, cHV227 et de cHV270 cHV106_01 */
/*****************************************************************************************************************************/

option fmtsearch=(MP);

PROC FREQ DATA=MP.menagesimple;
TABLE cHV201 cHV205 cHV206--cHV209 cHV213 cHV221 cHV226 cHV227
cHV270 cHV106_01;
FORMAT cHV201 $SOURCEWATERfs. cHV205 $TYPETOILETfs.
cHV206 $NOYES. cHV207 $NOYES. cHV208 $NOYES. cHV209 $NOYES. cHV213 $MATERIALandCOOKINGfs. cHV221 $NOYES. cHV226 $MATERIALandCOOKINGfs. cHV227 $NOYES. 
cHV270 $WEALTHfs. cHV106_01 $HIGHESTEDUCfs.
;
RUN;
/* Tris à plat avant de recoder les modalités */


data MP.menageACP (keep=  HHID	cHV201 cHV205 cHV206--cHV209 cHV213 cHV221 cHV226 cHV227 cHV270 cHV106_01	);
set MP.menagesimple;
run;
PROC PRINT data=MP.menageACP;
RUN;
/* Table initiale (on va faire une ACM mais on l'a appelée ACP parce qu'on a pas fait gaffe, ça arrive des fois...) */

DATA MP.menageACP2 ;
  LENGTH HHID $ 12 cHV201 $ 5 cHV205 $ 3 cHV206 $ 4 cHV207 $ 4 cHV208 $ 3 cHV209 $ 4 cHV213 $ 5 cHV221 $ 4 cHV226 $ 3 cHV227 $ 2 cHV270 $ 3 cHV106_01 $ 3 ;
  SET MP.menageACP ;
RUN ;
/* Création de la table menageACP2 car besoin de + de longueur pour certaines variables */

data MP.menageACP2;
set MP.menageACP2;

select(cHV201);
when('1')cHV201='Eau++';
when('2')cHV201='Eau+';
when('3')cHV201='Eau-';
otherwise; end;

select(cHV205);
when('1')cHV205='T++';
when('2')cHV205='T+';
when('3')cHV205='T-';
otherwise; end;

select(cHV206);
when('0')cHV206='Ele-';
when('1')cHV206='Ele+';
otherwise; end;

select(cHV207);
when('0')cHV207='Rad-';
when('1')cHV207='Rad+';
otherwise; end;

select(cHV208);
when('0')cHV208='Tv-';
when('1')cHV208='Tv+';
otherwise; end;

select(cHV209);
when('0')cHV209='Ref-';
when('1')cHV209='Ref+';
otherwise; end;

select(cHV221);
when('0')cHV221='Tel-';
when('1')cHV221='Tel+';
otherwise; end;

select(cHV213);
when('1')cHV213='Sol++';
when('2')cHV213='Sol-';
when('3')cHV213='Sol-';
otherwise; end;

select(cHV226);
when('1')cHV226='C++';
when('2')cHV226='C+';
when('3')cHV226='C+';
otherwise; end;

select(cHV227);
when('0')cHV227='M-';
when('1')cHV227='M+';
otherwise; end;

select(cHV270);
when('1')cHV270='r--';
when('2')cHV270='r-';
when('3')cHV270='r';
when('4')cHV270='r+';
when('5')cHV270='r++';
otherwise; end;

select(cHV106_01);
when('0')cHV106_01='E-';
when('1')cHV106_01='E';
when('2')cHV106_01='E+';
when('3')cHV106_01='E++';
otherwise; end;
run;
/* RECODAGE DES MODALITÉS */

ods pdf file="C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\_DATA\ANNEXE 6 - ANALYSE DES CORRESPONDANCES MULTIPLES.pdf" style=report_pdf;
ods pdf text="ANNEXE 6 : ANALYSE DES CORRESPONDANCES MULTIPLES";
ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";ods pdf text=" ";


proc corresp data=MP.menageACP2 mca out=resul;
tables cHV201--cHV106_01;
SUPPLEMENTARY cHV106_01;
title "ACM à partir de la table de Burt";
run;
ods pdf close;
/*ACM DES MODALITÉS AVEC TABLE DE BURT : éducations en supplémentaire*/

proc corresp data=MP.menageACP2 mca BENZECRI out=resul;
tables cHV201--cHV106_01;
SUPPLEMENTARY cHV106_01;
title "ACM à partir de la table de Burt";
run;
/* option BENZECRI pour avoir les taux d'inertie modifiés */

proc corresp data=MP.menageACP2 mca out=resul;
tables cHV201--cHV106_01;
SUPPLEMENTARY cHV106_01 cHV270;
title "ACM à partir de la table de Burt";
run;
ods pdf close;
/*ACM DES MODALITÉS AVEC TABLE DE BURT : éducations en supplémentaire*/


options mautosource sasautos='C:\Users\Lokman\Desktop\M1 MASS COMPLET\MINIPROJET\Macros';
proc options option=sasautos;
run;
%gafcix0(ident=_name_,x=1,y=2,nc=5,tp=0.8);
run;
/* Représentation graphique de l'ACM (mais perso je préfère celle de la proc corresp) */


/* ACM modalités + individus */
PROC CORRESP DATA=MP.menageACP2 observed OUT=resul ;
TITLE "ACM à partir du tableau disjonctif complet";
TABLES HHID, cHV201--cHV106_01 ;
run;
/* Ca prend du temps */
