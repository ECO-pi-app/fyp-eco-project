import 'package:flutter/material.dart';

class Apptheme{
  //--contents color theme--
  static const Color lightpallete1 = Color(0xFFF7F4EB);//--White Backgrounds--
  static const Color lightpallete2 = Color(0xFFEFE8DF); //--For parent widgets--
  static const Color palleteaccentual1 = Color(0xFF838D75) ; //--Primary inner widgets--
  static const Color palleteaccentual2 = Color(0xFF595E48); //--Headers and main--
  static const Color darkpallete5 = Color(0xFF4E5454); //--
  static const Color darkpallete6 = Color(0xFF2B343F);

  static const Color texthintclrlight = Color(0x6DF9ECE0);
  static const Color texthintclrdark = Color(0x874E5454);
  static const Color texthintbgrnd = Color(0xFFEFE8DF);

  static const Color transparentcheat = Color(0x00000000);
  static const Color error = Color(0xFFFF0000);
  static const Color systemUI = Color(0xFF393D3D);

  //--general --
  static const Color header= palleteaccentual2;//--Headers and parent widget borders--
  static const Color auxilary = palleteaccentual1;//--Lighter version of Aux 2, for text backgrounds--
  static const Color backgrounddark = darkpallete5;
  static const Color backgroundlight = lightpallete1; //--Eg. background--


  //text colors--
  static const Color textclrlight =  lightpallete1;
  static const Color textclrdark = darkpallete6;
  static const Color textclrspecial = lightpallete1; //--Title (SPHERE)--

  //--drawer exclusive color theme--
  static const Color drawer =  darkpallete6;
  static const Color drawerlight =  lightpallete1;
  static const Color drawerbackground = backgrounddark;

  //--universal widgets--
  static const Color widgetclrlight = lightpallete2;
  static const Color widgetsecondaryclr = palleteaccentual1;
  static const Color widgetclrdark = darkpallete6;
  static const Color widgetborderlight = lightpallete1;
  static const Color widgetborderdark = darkpallete6;
  static const Color tabbedpageclr = palleteaccentual1;
  static const Color unselected = darkpallete5; //--Unselected--

  //--icons and buttons--
  static const Color iconslight = textclrlight;
  static const Color iconsdark = textclrdark;
  static const Color iconsprimary = palleteaccentual2;
  static const Color windowcontrols = lightpallete1;
  static const Color dividers = lightpallete1;
  
  static const Color eXTRA1 = Color.fromARGB(255, 123, 89, 91) ;
  static const Color eXTRA2 = Color(0xFF5F1D20);
  static const Color eXTRA3 = Color(0xFF733438);
}