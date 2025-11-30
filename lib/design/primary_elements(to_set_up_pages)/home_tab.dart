import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

//--THESE ARE THE TABS, IMPORT THIS IN INTENDED PAGE--
class ManualTabpagesdoublepage extends StatefulWidget {
  final String tab1;
  final double tab1fontsize;
  final String tab2;
  final double tab2fontsize;

  final Widget firstchildof1;
  final Widget firstchildof2;
  final Widget secondchildof1;
  final Widget secondchildof2;

  final int pg1flexValue1;
  final int pg1flexValue2;
  final int pg2flexValue1;
  final int pg2flexValue2;

  final Color backgroundcolor;


  const ManualTabpagesdoublepage({super.key, 
  required this.tab1,
  required this.tab1fontsize,
  required this.tab2,
  required this.tab2fontsize,


  required this. pg1flexValue1,
  required this. pg1flexValue2,
  required this. pg2flexValue1,
  required this. pg2flexValue2,


  required this.firstchildof1,
  required this.firstchildof2,
  required this.secondchildof1,
  required this.secondchildof2,

  this.backgroundcolor = Apptheme.backgroundlight,


  required
  
  });

  @override
  State<ManualTabpagesdoublepage> createState() => _ManualTabpagesdoublepage();
}

class _ManualTabpagesdoublepage extends State<ManualTabpagesdoublepage> with SingleTickerProviderStateMixin {

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

      backgroundColor: Apptheme.tabbedpageclr,
      body: 
      DefaultTabController(
          length: 2,
          child: 
          Column(
            children: <Widget>[
              
              Material(
                color: widget.backgroundcolor,
                child: TabBar(
                  padding: EdgeInsets.all(0),
                  indicatorPadding: EdgeInsetsGeometry.all(0),
                  unselectedLabelColor: Apptheme.textclrlight,
                  labelColor: Apptheme.textclrlight,
                  indicatorColor: Apptheme.tabbedpageclr,  
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
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ManualColumn(childof1: widget.firstchildof1, childof2: widget.secondchildof1, flexValue1: widget.pg1flexValue1, flexValue2: widget.pg1flexValue2),
                    ManualColumn(childof1: widget.firstchildof2, childof2: widget.secondchildof2, flexValue1: widget.pg2flexValue1, flexValue2: widget.pg2flexValue2),
                  ],
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
                color: (_selectedTab == index ? Apptheme.tabbedpageclr : Apptheme.unselected),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
        ),
              ),
            )
      );

  }
}

//--COLUMN BASED (EQUIVALENT TO FIRSTTAB)--
class ManualColumn extends StatefulWidget {
  final Widget childof1;
  final Widget childof2;
  final int flexValue1;
  final int flexValue2;

  const ManualColumn({
    super.key,
    required this.childof1,
    required this.childof2,
    required this.flexValue1,
    required this.flexValue2,
  
  });

  @override
  State<ManualColumn> createState() => _ManualColumnState();
}

class _ManualColumnState extends State<ManualColumn> {

  @override
  Widget build(BuildContext context) {
    return
    Padding(padding: EdgeInsetsGeometry.all(5),
    child: 
      Align(
        alignment: AlignmentGeometry.topCenter,
        child:
        FlexboxManual2pg(childof1: widget.childof1, childof2: widget.childof2, flexValue1: widget.flexValue1, flexValue2: widget.flexValue2)
        )
    );
  }
}

//--GENERATES THE ASKED NUMBER OF FLEXIBLE BOXES,--
//--NUMBER OF X AT THE END REPRESENTS THE PAGE (Flexboxx=2nd Tabbed Page)
class FlexboxManual2pg extends StatelessWidget {

  final Widget childof1;
  final Widget childof2;
  final int flexValue1;
  final int flexValue2;

  const FlexboxManual2pg({
    super.key,
    required this.childof1,
    required this.childof2,
    required this.flexValue1,
    required this.flexValue2,

  });

  @override
  Widget build(BuildContext context) {
    return 
    Row(
      children: [

        //--INDIVIDUAL FLEXIBLE BOX 1--
        Flexible(
          fit: FlexFit.tight,
          flex: flexValue1,
          child:
          Padding(padding: EdgeInsetsGeometry.all(5),
          child: 
            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Apptheme.widgetclrlight,
            ),
            child: childof1,
            ),
          ),
        ),
        //--INDIVIDUAL FLEXIBLE BOX 1--

        //--INDIVIDUAL FLEXIBLE BOX 2--
        Flexible(
          fit: FlexFit.tight,
          flex: flexValue2,
          child:
          Padding(padding: EdgeInsetsGeometry.all(5),
          child: 
            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Apptheme.widgetclrlight,
            ),
            child: childof2,
            ),
          ),
        ),
        //--INDIVIDUAL FLEXIBLE BOX 2--

      ],
    );

  }
}
