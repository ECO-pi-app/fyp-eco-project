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
        color: Apptheme.textclrlight,
        fontWeight: FontWeight.bold
      ),
      )
    );
  }
}


//--Texts inside Setting drawer--
class Stgdrawertext extends StatelessWidget {
  final String title;

  const Stgdrawertext({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return  
    Container(
      padding: EdgeInsets.only(left: 10),
      child: 
      Text(title,
        style: TextStyle(
          color: Apptheme.textclrdark,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      ),
      );

  }
}


//--Textfield for sensitive info--
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


//--Big Focused Text--
class Bigfocusedtext extends StatefulWidget {
  final String title;
  const Bigfocusedtext({super.key, required this.title});

  @override
  State<Bigfocusedtext> createState() => _BigfocusedtextState();
}

class _BigfocusedtextState extends State<Bigfocusedtext> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(widget.title,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrspecial,
      ),
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
      ),
    );
  }
}


//--Summaries in each page--
class Subtitlesummary extends StatefulWidget {
  final String words;
  final Color color;
  const Subtitlesummary({super.key, required this.words, required this.color});

  @override
  State<Subtitlesummary> createState() => _SubtitlesummaryState();
}

class _SubtitlesummaryState extends State<Subtitlesummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text( widget.words,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Apptheme.textclrspecial,
      ),
      overflow: TextOverflow.fade,
      maxLines: 6,
      softWrap: true,
      ),
    );
  }
}


//--Labels for containers--
class Labels extends StatelessWidget {
  final String title;
  final Color color;
  final double fontsize;

  const Labels({super.key, 
  required this.title,
  required this.color,
  this.fontsize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints) {
      
      return
      Container(
        padding: EdgeInsets.only(left: 5, top: 10, bottom: 0),
        child: 
        Text(title, style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: fontsize,
        ),)
      );
    } 

    );
  }
}


//--Labels for texts inside buttons--
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
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: 
        Center(
          child: Text(title, style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: fontsize,
          ),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          )
        )
      );
    } 

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
  this. color = Apptheme.textclrlight,
  this.fontsize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Attributes',
      style: TextStyle(
        color: Apptheme.textclrlight,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }
}