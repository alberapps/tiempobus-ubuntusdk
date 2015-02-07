/**
*  TiempoBus - Informacion sobre tiempos de paso de autobuses en Alicante
*  Copyright (C) 2014 Alberto Montiel
*
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.2


Rectangle {
    width: 0
    height: 0


    //Informacione estatica de las lineas
    property variant lineasDescripcion: ["21 ALICANTE-P.S.JUAN-EL CAMPELLO","22 ALICANTE-C. HUERTAS-P.S. JUAN","23 ALICANTE-SANT JOAN-MUTXAMEL","24 ALICANTE-UNIVERSIDAD-S.VICENTE","25 ALICANTE-VILLAFRANQUEZA","26 ALICANTE-VILLAFRANQUEZA-TANGEL","27 ALICANTE(O.ESPLA) - URBANOVA","30 SAN VICENTE-LA ALCORAYA","C-55 EL CAMPELLO-UNIVERSIDAD","35 ALICANTE-PAULINAS-MUTXAMEL","36 SAN GABRIEL-UNIVERSIDAD","38 P.S.JUAN-H.ST.JOAN-UNIVERSIDAD","39 EXPLANADA - C. TECNIFICACIÓN","21N ALICANTE- P.S.JUAN-EL CAMPELLO","22N ALICANTE- PLAYA SAN JUAN","23N ALICANTE-SANT JOAN- MUTXAMEL","24N ALICANTE-UNIVERSIDAD-S.VICENTE","01 S. GABRIEL-JUAN XXIII  (1ºS)","02 LA FLORIDA-SAGRADA FAMILIA","03 CIUDAD DE ASIS-COLONIA REQUENA","04 CEMENTERIO-TOMBOLA","05 EXPLANADA-SAN BLAS-RABASA","06 AV.ÓSCAR ESPLÁ - COLONIA REQUENA","07 AV.ÓSCAR ESPLÁ-EL REBOLLEDO","8A EXPLANADA -VIRGEN REMEDIO","09 AV.ÓSCAR ESPLÁ - AV. NACIONES","10 EXPLANADA - VIA PARQUE","11 V.REMEDIO-AV DENIA (JESUITAS)","11H V.REMEDIO-AV. DENIA-HOSP.ST JOAN","12 AV. CONSTITUCION-S. BLAS(PAUI)","16 PZA. ESPAÑA-MERCADILLO TEULADA","17 ZONA NORTE-MERCADILLO TEULADA","8B EXPLANADA-VIRGEN DEL REMEDIO","191 PLA - CAROLINAS - RICO PEREZ","192 C. ASIS - BENALUA - RICO PEREZ","M MUTXAMEL-URBANITZACIONS","136 MUTXAMEL - CEMENTERIO","C2 VENTA LANUZA - EL CAMPELLO","C-51 MUTXAMEL - BUSOT","C-52 BUSOT - EL CAMPELLO","C-53 HOSPITAL SANT JOAN - EL CAMPELLO","C-54 UNIVERSIDAD-HOSP. SANT JOAN","C-6 ALICANTE-AEROPUERTO","45 HOSPITAL-GIRASOLES-MANCHEGOS","46A HOSPITAL-VILLAMONTES-S.ANTONIO","46B HOSPITAL-P.CANASTELL-P.COTXETA","TURI BUS TURÍSTICO (TURIBUS)","31 MUTXAMEL-ST.JOAN-PLAYA S. JUAN","30P SAN VICENTE-PLAYA SAN JUAN","C-6* ALICANTE-URBANOVA-AEROPUERTO"];
    property variant lineasCodigoKml: ["ALC21","ALC22","ALC23","ALC24","ALC25","ALC26","ALC27","ALC30","ALCC55","ALC35","ALC36","ALC38","ALC39","ALC21N","ALC22N","ALC23N","ALC24N","MAS01","MAS02","MAS03","MAS04","MAS05","MAS06","MAS07","MAS8A","MAS09","MAS10","MAS11","MAS11H","MAS12","MAS16","MAS17","MAS8B","MAS191","MAS192","MUTM","MUT136","CAMPC2","ALCC51","ALCC52","ALCC53","ALCC54","ALCC6","ALCS45","ALCS46A","ALCS46B","Turibus","ALC31","ALC30B","ALCC6"];
    property variant lineasNum: ["21","22","23","24","25","26","27","30","C-55","35","36","38","39","21N","22N","23N","24N","01","02","03","04","05","06","07","8A","09","10","11","11H","12","16","17","8B","191","192","M","136","C2","C-51","C-52","C-53","C-54","C-6","45","46A","46B","TURI","31","30P","C-6*"];



}

