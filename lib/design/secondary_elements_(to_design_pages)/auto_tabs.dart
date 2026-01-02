import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

//--THESE ARE 2 PAGED TABS, IMPORT THIS IN INTENDED PAGE--
class ManualTab2pages extends StatefulWidget {
  final String tab1;
  final double tab1fontsize;
  final String tab2;
  final double tab2fontsize;
  final String tab3;
  final double tab3fontsize;

  final Widget firstchildof1;
  final Widget firstchildof2;
  final Widget firstchildof3;
  final Widget secondchildof1;
  final Widget secondchildof2;
  final Widget secondchildof3;

  final Color backgroundcolor;

  const ManualTab2pages({super.key, 
  required this.tab1,
  required this.tab1fontsize,
  required this.tab2,
  required this.tab2fontsize,
  required this.tab3,
  required this.tab3fontsize,

  required this.firstchildof1,
  required this.firstchildof2,
  required this.firstchildof3,
  required this.secondchildof1,
  required this.secondchildof2,
  required this.secondchildof3,

  this.backgroundcolor = Apptheme.backgroundlight,


  required
  
  });

  @override
  State<ManualTab2pages> createState() => _ManualTab2pages();
}

class _ManualTab2pages extends State<ManualTab2pages> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener((){
      if (!_tabController.indexIsChanging){
        setState(() {
          _selectedTab = _tabController.index; 
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Apptheme.transparentcheat,
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              
              Material(
                color: widget.backgroundcolor,
                child: TabBar(
                  padding: EdgeInsets.all(0),
                  indicatorPadding: EdgeInsetsGeometry.all(0),
                  unselectedLabelColor: Apptheme.textclrlight,
                  labelColor: Apptheme.textclrlight,
                  indicatorColor: Apptheme.widgetsecondaryclr,  
                  indicator: null,
                  controller: _tabController,
                  labelPadding: const EdgeInsets.only(left: 0, right: 0),
                  tabs: [
                    _getTab(0, Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Center(child: Text(widget.tab1, style: TextStyle(fontSize: widget.tab1fontsize, fontWeight: FontWeight.w600),textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1,softWrap: false,)),
                    )),
                    _getTab(1, Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Center(child: Text(widget.tab2, style: TextStyle(fontSize: widget.tab2fontsize, fontWeight: FontWeight.w600),textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1,softWrap: false,)),
                    )),
                    
                  ],
                ),
              ),


              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomLeft: Radius.circular(28), 
                    bottomRight: Radius.circular(28)),
                  child: Container(
                    color: Apptheme.widgetsecondaryclr,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        ManualColumn2(childof1: widget.firstchildof1, childof2: widget.secondchildof1,),
                        ManualColumn2(childof1: widget.firstchildof2, childof2: widget.secondchildof2,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

//--Tabs Displayed--
  _getTab(index, child) {
    return 

    Tab(
      child: 
      SizedBox.expand(
        child: 
            Container(
              child:child,
              decoration: BoxDecoration(
                color: (_selectedTab == index ? Apptheme.tertiarysecondaryclr : Apptheme.widgetsecondaryclr),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
        ),
              ),
            )
      );

  }
}

//--COLUMN BASED (EQUIVALENT TO FIRSTTAB)--
class ManualColumn2 extends StatefulWidget {
  final Widget childof1;
  final Widget childof2;

  const ManualColumn2({
    super.key,
    required this.childof1,
    required this.childof2,
  
  });

  @override
  State<ManualColumn2> createState() => _ManualColumn2State();
}

class _ManualColumn2State extends State<ManualColumn2> {

  @override
  Widget build(BuildContext context) {
    return
    Padding(padding: EdgeInsetsGeometry.only(left: 5, right: 5, top: 10, bottom:10),
    child: 
      Align(
        alignment: AlignmentGeometry.topCenter,
        child:
        FlexboxManual(childof1: widget.childof1, )
        )
    );
  }
}


//--THESE ARE 3 PAGED TABS, IMPORT THIS IN INTENDED PAGE--
class ManualTab3pages extends StatefulWidget {
  final String tab1;
  final double tab1fontsize;
  final String tab2;
  final double tab2fontsize;
  final String tab3;
  final double tab3fontsize;

  final Widget firstchildof1;
  final Widget firstchildof2;
  final Widget firstchildof3;
  final Widget secondchildof1;
  final Widget secondchildof2;
  final Widget secondchildof3;

  final Color backgroundcolor;

  const ManualTab3pages({super.key, 
  required this.tab1,
  required this.tab1fontsize,
  required this.tab2,
  required this.tab2fontsize,
  required this.tab3,
  required this.tab3fontsize,

  required this.firstchildof1,
  required this.firstchildof2,
  required this.firstchildof3,
  required this.secondchildof1,
  required this.secondchildof2,
  required this.secondchildof3,

  this.backgroundcolor = Apptheme.backgroundlight,


  required
  
  });

  @override
  State<ManualTab3pages> createState() => _ManualTab3pages();
}

class _ManualTab3pages extends State<ManualTab3pages> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);

    _tabController.addListener((){
      if (!_tabController.indexIsChanging){
        setState(() {
          _selectedTab = _tabController.index; 
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Apptheme.transparentcheat,
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              
              Material(
                color: widget.backgroundcolor,
                child: TabBar(
                  padding: EdgeInsets.all(0),
                  indicatorPadding: EdgeInsetsGeometry.all(0),
                  unselectedLabelColor: Apptheme.textclrdark,
                  labelColor: Apptheme.textclrlight,
                  indicatorColor: Apptheme.widgetclrlight,  
                  indicator: null,
                  controller: _tabController,
                  labelPadding: const EdgeInsets.only(left: 0, right: 0),
                  tabs: [
                    _getTab(0, Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Center(child: Text(widget.tab1, style: TextStyle(fontSize: widget.tab1fontsize, fontWeight: FontWeight.w600),textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1,softWrap: false,)),
                    )),
                    _getTab(1, Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Center(child: Text(widget.tab2, style: TextStyle(fontSize: widget.tab2fontsize, fontWeight: FontWeight.w600),textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1,softWrap: false,)),
                    )),
                    _getTab(2, Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Center(child: Text(widget.tab3, style: TextStyle(fontSize: widget.tab3fontsize, fontWeight: FontWeight.w600),textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1,softWrap: false,)),
                    )),
                  ],
                ),
              ),


              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomLeft: Radius.circular(28), 
                    bottomRight: Radius.circular(28)),
                  child: Container(
                    color: Apptheme.widgetclrlight,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        ManualColumn3(childof1: widget.firstchildof1, childof2: widget.secondchildof1, ),
                        ManualColumn3(childof1: widget.firstchildof2, childof2: widget.secondchildof2,),
                        ManualColumn3(childof1: widget.firstchildof3, childof2: widget.secondchildof3,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

//--Tabs Displayed--
  _getTab(index, child) {
    return 

    Tab(
      child: 
      SizedBox(
        height: 35,
        child: 
          Container(
            child:child,
            decoration: BoxDecoration(
              color: (_selectedTab == index ? Apptheme.widgetsecondaryclr : Apptheme.widgettertiaryclr),
              borderRadius: BorderRadius.all(Radius.circular(5))
            ),
          ),
        )
      );

  }
}

//--COLUMN BASED (EQUIVALENT TO FIRSTTAB)--
class ManualColumn3 extends StatefulWidget {
  final Widget childof1;
  final Widget childof2;

  const ManualColumn3({
    super.key,
    required this.childof1,
    required this.childof2,
  
  });

  @override
  State<ManualColumn3> createState() => _ManualColumn3State();
}

class _ManualColumn3State extends State<ManualColumn3> {

  @override
  Widget build(BuildContext context) {
    return
    Padding(padding: EdgeInsetsGeometry.only(left: 5, right: 5, top: 10, bottom:10),
    child: 
      Align(
        alignment: AlignmentGeometry.topCenter,
        child:
        FlexboxManual(childof1: widget.childof1, )
        )
    );
  }
}

//--GENERATES THE ASKED NUMBER OF FLEXIBLE BOXES,--
//--NUMBER OF X AT THE END REPRESENTS THE PAGE (Flexboxx=2nd Tabbed Page)
class FlexboxManual extends StatelessWidget {

  final Widget childof1;

  const FlexboxManual({
    super.key,
    required this.childof1,

  });

  @override
  Widget build(BuildContext context) {
    return 
    Row(
      children: [

        //--INDIVIDUAL FLEXIBLE BOX 1--
        Flexible(
          fit: FlexFit.tight,
          child:
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
          child: 
            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Apptheme.transparentcheat,
            ),
            child: childof1,
            ),
          ),
        ),
        //--INDIVIDUAL FLEXIBLE BOX 1--

      ],
    );

  }
}
