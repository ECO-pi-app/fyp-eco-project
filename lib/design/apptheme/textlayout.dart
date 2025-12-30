import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';


//--Texts inside tab labels--
class Tabtext extends StatefulWidget {
  final String words;
  final double specifysize;
  const Tabtext({super.key, required this.words, required this.specifysize});


  @override
  State<Tabtext> createState() => _TabtextState();
}

class _TabtextState extends State<Tabtext> {
  @override
  Widget build(BuildContext context) {
    return 
    Center(
      child:
      Text( widget.words,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: widget.specifysize,
        color: Apptheme.textclrdark,
        fontWeight: FontWeight.bold
      ),
      )
    );
  }
}

//---------------------------------------------------------------------------------------//

//--Textfield for sensitive info (passwords)--
class Typeheresensitive extends StatefulWidget {
  final String title;
  const Typeheresensitive({super.key, required this.title});

  @override
  State<Typeheresensitive> createState() => _TypeheresensitiveState();
}

class _TypeheresensitiveState extends State<Typeheresensitive> {

  @override
  Widget build(BuildContext context) {
    return 

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: 
                TextField(  
                obscureText: true,
                obscuringCharacter: '*',


                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Apptheme.textclrdark,),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 0),
                  hintText: widget.title,
                  hintStyle: TextStyle(
                    color: Apptheme.texthintclrdark,
                    fontSize: 16,
                    fontWeight: FontWeight.w100,

                  ),
                ),
              )
            );
  }
}

//--Textfield for general info--
class Typehere extends StatefulWidget {
 final String title;
  const Typehere({super.key, required this.title});

  @override
  State<Typehere> createState() => _TypehereState();
}

class _TypehereState extends State<Typehere> {

  @override
  Widget build(BuildContext context) {
    return 
    Align(
      alignment: AlignmentGeometry.centerLeft,
      child: 
        TextField(  
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500 ,
            color: Apptheme.textclrdark,
          ),
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 0),
          hintText: widget.title,
          hintStyle: TextStyle(
            color: Apptheme.texthintclrdark,
            fontSize: 16,
            fontWeight: FontWeight.w100,

          ),
        ),
      )
    );
  }
}

//---------------------------------------------------------------------------------------//

//--Big Focused Text (APP NAME)--
class Bigfocusedtext extends StatefulWidget {
  final String title;
  final double fontsize;
  final Color color;

  const Bigfocusedtext({super.key, 
  required this.title,
  this.fontsize = 60,
  this.color = Apptheme.textclrlight,
  });

  @override
  State<Bigfocusedtext> createState() => _BigfocusedtextState();
}

class _BigfocusedtextState extends State<Bigfocusedtext> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(widget.title,
      style: TextStyle(
        fontSize: widget.fontsize,
        fontWeight: FontWeight.bold,
        color: widget.color,
      ),
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
      ),
    );
  }
}

//--Title texts for pages--
class Titletext extends StatelessWidget {

  final String title;
  final Color color;
  final double fontsize;

  const Titletext({super.key,
  required this.title,
  this. color = Apptheme.textclrdark,
  this.fontsize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(
        color: color,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }
}

//--Text inside headers in each page()--
class Headertext extends StatefulWidget {
  final String words;
  final Color backgroundcolor;

  const Headertext({super.key, 
  required this.words,
  this.backgroundcolor = Apptheme.widgetsecondaryclr,
  });

  @override
  State<Headertext> createState() => _HeadertextState();
}

class _HeadertextState extends State<Headertext> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.backgroundcolor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text( widget.words,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrspecial,
        fontSize: 20
      ),
      overflow: TextOverflow.fade,
      maxLines: 2,
      softWrap: true,
      ),
    );
  }
}

//---------------------------------------------------------------------------------------//

//--Labels for containers--
class Labels extends StatelessWidget {
  final String title;
  final Color color;
  final double fontsize;
  final double toppadding;
  final double leftpadding;

  const Labels({super.key, 
  required this.title,
  required this.color,
  this.fontsize = 20,
  this.toppadding = 0,
  this.leftpadding = 5,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints) {
      
      return
      Container(
        padding: EdgeInsets.only(left: leftpadding, top: toppadding, bottom: 0),
        child: 
        Text(title, style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: fontsize,
        ),
        maxLines: 2,
        overflow: TextOverflow.fade,
        softWrap: true,
        )
      );
    } 

    );
  }
}

//--Texts inside containers--
class Textsinsidewidgets extends StatelessWidget {
  final String words;
  final Color color;
  final double fontsize;
  final double leftpadding;
  final double toppadding;
  final int maxLines;
  final FontWeight fontweight;
  final bool softWrap;

  const Textsinsidewidgets({super.key, 
  required this.words,
  required this.color,
  this.fontsize = 15,
  this.leftpadding = 0,
  this.toppadding = 10,
  this.maxLines = 10,
  this.fontweight = FontWeight.w500,
  this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints) {
      
      return
      Container(
        padding: EdgeInsets.only(left: 5+leftpadding, top: toppadding, right: 5),
        child: 
        Align(
          alignment: Alignment.centerLeft,
          child: Text(words, style: TextStyle(
            color: color,
            fontWeight: fontweight,
            fontSize: fontsize,
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.fade,
            softWrap: softWrap,
            maxLines: maxLines,
          ),
        )
      );
    } 

    );
  }
}
TextStyle bodyTextLight() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Apptheme.textclrlight,
  );
}
TextStyle bodyTextdark() {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Apptheme.textclrlight,
  );
}
TextStyle bodyTextlightmini(double fontsize) {
  return TextStyle(
    fontSize: fontsize,
    fontWeight: FontWeight.w700,
    color: Apptheme.textclrlight,
  );
}

class RichTextsInsideWidget extends StatelessWidget {
  final String firstPart;
  final String secondPart;
  final Color firstColor;
  final Color secondColor;
  final double fontSize;
  final double leftPadding;
  final int maxLines;
  final FontWeight fontWeight;

  const RichTextsInsideWidget({
    super.key,
    required this.firstPart,
    required this.secondPart,
    required this.firstColor,
    required this.secondColor,
    this.fontSize = 15,
    this.leftPadding = 0,
    this.maxLines = 10,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.only(left: 5 + leftPadding, top: 0, right: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            maxLines: maxLines,
            overflow: TextOverflow.fade,
            text: TextSpan(
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
              children: [
                TextSpan(
                  text: firstPart,
                  style: TextStyle(color: firstColor),
                ),
                TextSpan(
                  text: secondPart,
                  style: TextStyle(color: secondColor),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}


//--Texts inside buttons--
class Labelsinbuttons extends StatelessWidget {
  final String title;
  final Color color;
  final double fontsize;

  const Labelsinbuttons({super.key, 
  required this.title,
  required this.color,
  this.fontsize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints) {
      
      return
      ClipRRect(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 0,
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: 
          Text(title, style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: fontsize,
          ),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          textAlign: TextAlign.center,
          )
        ),
      );
    } 

    );
  }
}

//---------------------------------------------------------------------------------------//

//--Texts inside hoverdrawer--
class Labelsinhoverdrawer extends StatelessWidget {
  final String label;
  final double? verticalpad;
  const Labelsinhoverdrawer({super.key,
  this.label = 'Type here',
  this.verticalpad =20
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: verticalpad,
      child: Text(
        label,
        style: const TextStyle(
          color: Apptheme.textclrlight,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.visible,
        softWrap: false,
        maxLines: 1,
        textAlign: TextAlign.justify,
      ),
    );
}
}

//--Texts inside subdrawer--
class Labelsinsubdrawer extends StatelessWidget {
  final String label;
  const Labelsinsubdrawer({super.key,
  this.label = 'Type here',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Apptheme.textclrlight,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.visible,
      softWrap: false,
      maxLines: 1,
      textAlign: TextAlign.justify,
    );
}
}

//---------------------------------------------------------------------------------------//

