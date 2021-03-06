/**
* @licence app begin@
* SPDX-License-Identifier: MPL-2.0
*
* \copyright Copyright (C) 2013-2014, PCA Peugeot Citroen
*
* \file NavigationSearchAddress.qml
*
* \brief This file is part of the navigation hmi.
*
* \author Martin Schaller <martin.schaller@it-schaller.de>
* \author Philippe Colliot <philippe.colliot@mpsa.com>
*
* \version 1.1
*
* This Source Code Form is subject to the terms of the
* Mozilla Public License (MPL), v. 2.0.
* If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/.
*
* For further information see http://www.genivi.org/.
*
* List of changes:
* 2014-03-05, Philippe Colliot, migration to the new HMI design
* <date>, <name>, <description of change>
*
* @licence end@
*/
import QtQuick 2.1 
import "Core"
import "Core/genivi.js" as Genivi;
import "Core/style-sheets/navigation-search-address-menu-css.js" as StyleSheet;
import lbs.plugin.dbusif 1.0

HMIMenu {
	id: menu
    headlineFg: "grey"
    headlineBg: "blue"
    text: Genivi.gettext("NavigationSearchAddress")
	property string pagefile:"NavigationSearchAddress"
	property Item currentSelectionCriterionSignal;
	property Item searchStatusSignal;
	property Item searchResultListSignal;
	property Item contentUpdatedSignal;
	property real lat
	property real lon

    function loadWithAddress()
    {
        //load the field with saved values
        if (Genivi.address[Genivi.NAVIGATIONCORE_COUNTRY] !== "")
        {//need to test empty string
            countryValue.text=Genivi.address[Genivi.NAVIGATIONCORE_COUNTRY];
            accept(countryValue);
            cityValue.disabled=false;
            if (Genivi.address[Genivi.NAVIGATIONCORE_CITY] !== "")
            {
                cityValue.text=Genivi.address[Genivi.NAVIGATIONCORE_CITY];
                accept(cityValue);
                streetValue.disabled=false;
                if (Genivi.address[Genivi.NAVIGATIONCORE_STREET] !== "")
                {
                    streetValue.text=Genivi.address[Genivi.NAVIGATIONCORE_STREET];
                    accept(streetValue);
                    numberValue.disabled=false;
                }
            }
        }
    }

	function currentSelectionCriterion(args)
	{
	}

	function searchStatus(args)
	{
		if (args[3] == 2) 
			menu.text="Search (Searching)";
		else
			menu.text="Search";
	}

	function searchResultList(args)
	{
        Genivi.locationinput_message(dbusIf,"SelectEntry",["uint16",Genivi.entryselectedentry]);
	}

	function setContent(args)
	{
        countryValue.text="";
        cityValue.text="";
        streetValue.text="";
        numberValue.text="";
		for (var i=0 ; i < args.length ; i+=4) {
			if (args[i+1] == Genivi.NAVIGATIONCORE_LATITUDE) lat=args[i+3][1];
			if (args[i+1] == Genivi.NAVIGATIONCORE_LONGITUDE) lon=args[i+3][1];
            if (args[i+1] == Genivi.NAVIGATIONCORE_COUNTRY) countryValue.text=args[i+3][1];
            if (args[i+1] == Genivi.NAVIGATIONCORE_CITY) cityValue.text=args[i+3][1];
            if (args[i+1] == Genivi.NAVIGATIONCORE_STREET) streetValue.text=args[i+3][1];
            if (args[i+1] == Genivi.NAVIGATIONCORE_HOUSENUMBER) numberValue.text=args[i+3][1];
		}
	}

	function setDisabled(args)
	{
        countryValue.disabled=true;
        cityValue.disabled=true;
        streetValue.disabled=true;
        numberValue.disabled=true;
		for (var i=0 ; i < args.length ; i++) {
            if (args[i] == Genivi.NAVIGATIONCORE_COUNTRY) countryValue.disabled=false;
            if (args[i] == Genivi.NAVIGATIONCORE_CITY) cityValue.disabled=false;
            if (args[i] == Genivi.NAVIGATIONCORE_STREET) streetValue.disabled=false;
            if (args[i] == Genivi.NAVIGATIONCORE_HOUSENUMBER) numberValue.disabled=false;
		}
        if (countryValue.disabled)
            countryValue.text="";
        if (cityValue.disabled)
            cityValue.text="";
        if (streetValue.disabled)
            streetValue.text="";
        if (numberValue.disabled)
            numberValue.text="";
	}

	function setFocus()
	{
		var focus;
        if (!countryValue.disabled)
            focus=countryValue;
        if (!cityValue.disabled)
            focus=cityValue;
        if (!streetValue.disabled)
            focus=streetValue;
        if (!numberValue.disabled)
            focus=numberValue;
		focus.takeFocus();
	}

	function contentUpdated(args)
	{
		if (args[3]) {
			ok.disabled=false;
		}
		setDisabled(args[5]);
		setContent(args[7]);
		setFocus();
	}

	function connectSignals()
	{
		currentSelectionCriterionSignal=dbusIf.connect("","/org/genivi/navigationcore","org.genivi.navigationcore.LocationInput","CurrentSelectionCriterion",menu,"currentSelectionCriterion");
		searchStatusSignal=dbusIf.connect("","/org/genivi/navigationcore","org.genivi.navigationcore.LocationInput","SearchStatus",menu,"searchStatus");
		searchResultListSignal=dbusIf.connect("","/org/genivi/navigationcore","org.genivi.navigationcore.LocationInput","SearchResultList",menu,"searchResultList");
		contentUpdatedSignal=dbusIf.connect("","/org/genivi/navigationcore","org.genivi.navigationcore.LocationInput","ContentUpdated",menu,"contentUpdated");
	}
	
	function disconnectSignals()
	{
		currentSelectionCriterionSignal.destroy();
		searchStatusSignal.destroy();
		searchResultListSignal.destroy();
		contentUpdatedSignal.destroy();
	}

	function accept(what)
	{
		ok.disabled=true;
		Genivi.locationinput_message(dbusIf,"SetSelectionCriterion",["uint16",what.criterion]);
		Genivi.locationinput_message(dbusIf,"Search",["string",what.text,"uint16",10]);
	}


	function leave(toOtherMenu)
	{
		disconnectSignals();
		if (toOtherMenu) {
			Genivi.loc_handle_clear(dbusIf);
		}
		//Genivi.nav_session_clear(dbusIf);
	}

	DBusIf {
                id: dbusIf
        Component.onCompleted: {
            connectSignals();

            var res=Genivi.nav_message(dbusIf,"Session","GetVersion",[]);
            if (res[0] != "error") {
                res=Genivi.nav_session(dbusIf);
                res=Genivi.loc_handle(dbusIf);
            } else {
                Genivi.dump("",res);
            }
            if (Genivi.entryselectedentry) {
                Genivi.locationinput_message(dbusIf,"SelectEntry",["uint16",Genivi.entryselectedentry-1]);
            }
            if (Genivi.entrydest == 'countryValue')
            {
                accept(countryValue);
            }
            if (Genivi.entrydest == 'cityValue')
            {
                accept(cityValue);
            }
            if (Genivi.entrydest == 'streetValue')
            {
                accept(streetValue);
            }
            if (Genivi.entrydest == 'numberValue')
            {
                accept(numberValue);
            }
            Genivi.entrydest=null;
        }
    }

    HMIBgImage {
        image:StyleSheet.navigation_search_by_address_menu_background[StyleSheet.SOURCE];
        anchors { fill: parent; topMargin: parent.headlineHeight}
        id: content

        Text {
            x:StyleSheet.countryTitle[StyleSheet.X]; y:StyleSheet.countryTitle[StyleSheet.Y]; width:StyleSheet.countryTitle[StyleSheet.WIDTH]; height:StyleSheet.countryTitle[StyleSheet.HEIGHT];color:StyleSheet.countryTitle[StyleSheet.TEXTCOLOR];styleColor:StyleSheet.countryTitle[StyleSheet.STYLECOLOR]; font.pixelSize:StyleSheet.countryTitle[StyleSheet.PIXELSIZE];
            style: Text.Sunken;
            smooth: true;
            id: countryTitle
            text: Genivi.gettext("Country");
        }
        EntryField {
            x:StyleSheet.countryValue[StyleSheet.X]; y:StyleSheet.countryValue[StyleSheet.Y]; width: StyleSheet.countryValue[StyleSheet.WIDTH]; height: StyleSheet.countryValue[StyleSheet.HEIGHT];
            id: countryValue
			criterion: Genivi.NAVIGATIONCORE_COUNTRY
            globaldata: 'countryValue'
			textfocus: true
            next: cityValue
			prev: back
			onLeave:{menu.leave(0)}
		}
        Text {
            x:StyleSheet.streetTitle[StyleSheet.X]; y:StyleSheet.streetTitle[StyleSheet.Y]; width:StyleSheet.streetTitle[StyleSheet.WIDTH]; height:StyleSheet.streetTitle[StyleSheet.HEIGHT];color:StyleSheet.streetTitle[StyleSheet.TEXTCOLOR];styleColor:StyleSheet.streetTitle[StyleSheet.STYLECOLOR]; font.pixelSize:StyleSheet.streetTitle[StyleSheet.PIXELSIZE];
            style: Text.Sunken;
            smooth: true;
            id:streetTitle
            text: Genivi.gettext("Street");
        }
		EntryField {
            x:StyleSheet.streetValue[StyleSheet.X]; y:StyleSheet.streetValue[StyleSheet.Y]; width: StyleSheet.streetValue[StyleSheet.WIDTH]; height: StyleSheet.streetValue[StyleSheet.HEIGHT];
            id:streetValue
			criterion: Genivi.NAVIGATIONCORE_STREET
            globaldata: 'streetValue'
            next: numberValue
            prev: cityValue
			disabled: true
			onLeave:{menu.leave(0)}
		}
        Text {
            x:StyleSheet.cityTitle[StyleSheet.X]; y:StyleSheet.cityTitle[StyleSheet.Y]; width:StyleSheet.cityTitle[StyleSheet.WIDTH]; height:StyleSheet.cityTitle[StyleSheet.HEIGHT];color:StyleSheet.cityTitle[StyleSheet.TEXTCOLOR];styleColor:StyleSheet.cityTitle[StyleSheet.STYLECOLOR]; font.pixelSize:StyleSheet.cityTitle[StyleSheet.PIXELSIZE];
            style: Text.Sunken;
            smooth: true;
            id:cityTitle
            text: Genivi.gettext("City");
        }
        EntryField {
            x:StyleSheet.cityValue[StyleSheet.X]; y:StyleSheet.cityValue[StyleSheet.Y]; width: StyleSheet.cityValue[StyleSheet.WIDTH]; height: StyleSheet.cityValue[StyleSheet.HEIGHT];
            id:cityValue
			criterion: Genivi.NAVIGATIONCORE_CITY
            globaldata: 'cityValue'
            next:streetValue
            prev:countryValue
			disabled: true
			onLeave:{menu.leave(0)}
		}
        Text {
            x:StyleSheet.numberTitle[StyleSheet.X]; y:StyleSheet.numberTitle[StyleSheet.Y]; width:StyleSheet.numberTitle[StyleSheet.WIDTH]; height:StyleSheet.numberTitle[StyleSheet.HEIGHT];color:StyleSheet.numberTitle[StyleSheet.TEXTCOLOR];styleColor:StyleSheet.numberTitle[StyleSheet.STYLECOLOR]; font.pixelSize:StyleSheet.numberTitle[StyleSheet.PIXELSIZE];
            style: Text.Sunken;
            smooth: true;
            id:numberTitle
            text: Genivi.gettext("Number");
        }
        EntryField {
            x:StyleSheet.numberValue[StyleSheet.X]; y:StyleSheet.numberValue[StyleSheet.Y]; width: StyleSheet.numberValue[StyleSheet.WIDTH]; height: StyleSheet.numberValue[StyleSheet.HEIGHT];
            id:numberValue
			criterion: Genivi.NAVIGATIONCORE_HOUSENUMBER
            globaldata: 'numberValue'
			next: ok
            prev: streetValue
			disabled: true
			onLeave:{menu.leave(0)}
		}

        StdButton { source:StyleSheet.ok[StyleSheet.SOURCE]; x:StyleSheet.ok[StyleSheet.X]; y:StyleSheet.ok[StyleSheet.Y]; width:StyleSheet.ok[StyleSheet.WIDTH]; height:StyleSheet.ok[StyleSheet.HEIGHT];textColor:StyleSheet.okText[StyleSheet.TEXTCOLOR]; pixelSize:StyleSheet.okText[StyleSheet.PIXELSIZE];
            id:ok
            next:back
            prev:numberValue
            text:Genivi.gettext("Ok")
            disabled: true
            onClicked:{
                leave(1);
                //save address for next time
                Genivi.address[Genivi.NAVIGATIONCORE_COUNTRY]=countryValue.text;
                Genivi.address[Genivi.NAVIGATIONCORE_CITY]=cityValue.text;
                Genivi.address[Genivi.NAVIGATIONCORE_STREET]=streetValue.text;
                Genivi.address[Genivi.NAVIGATIONCORE_HOUSENUMBER]=numberValue.text;
                Genivi.data['lat']=menu.lat;
                Genivi.data['lon']=menu.lon;
                Genivi.data['description']=countryValue.text;
                if (!cityValue.disabled)
                    Genivi.data['description']+=' '+cityValue.text;
                if (!streetValue.disabled)
                    Genivi.data['description']+=' '+streetValue.text;
                if (!numberValue.disabled)
                    Genivi.data['description']+=' '+numberValue.text;
                //save entered location into the history
                Genivi.updateHistoryOfLastEnteredLocation(Genivi.data['description'],Genivi.data['lat'],Genivi.data['lon']);
                pageOpen("NavigationRoute");
            }
        }

        StdButton { source:StyleSheet.back[StyleSheet.SOURCE]; x:StyleSheet.back[StyleSheet.X]; y:StyleSheet.back[StyleSheet.Y]; width:StyleSheet.back[StyleSheet.WIDTH]; height:StyleSheet.back[StyleSheet.HEIGHT];textColor:StyleSheet.backText[StyleSheet.TEXTCOLOR]; pixelSize:StyleSheet.backText[StyleSheet.PIXELSIZE];
            id:back; text: Genivi.gettext("Back"); explode:false; next:countryValue; prev:ok;
            onClicked:{leave(1); pageOpen("NavigationSearch");}
        }
	}
    Component.onCompleted: {
        if (Genivi.preloadMode==true)
        {
            Genivi.preloadMode=false;
            loadWithAddress();
        }
    }
}
