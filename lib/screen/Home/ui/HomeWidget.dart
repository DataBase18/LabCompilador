import 'package:compiladorestareauno/screen/Home/data/HomeConstants.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeScreen.dart';
import 'package:compiladorestareauno/widget/InputBasic.dart';
import 'package:compiladorestareauno/widget/NoDataList.dart';
import 'package:flutter/material.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeState.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeViewModel.dart';
import 'package:flutter/services.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.state, required this.viewModel});

  final HomeState state;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode(), 
        onKeyEvent: (value) {
          if (value.runtimeType == KeyDownEvent) {
            String key = value.logicalKey.keyLabel.isNotEmpty ? value.logicalKey.keyLabel : value.logicalKey.debugName!;
            if(key == "F5"){
              viewModel.compile(state.inputCode.text);
            }
          }
        },
        child: Column(
          children: [
            Column( 
              children: [
                SizedBox(height: height*0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(HomeConstants.myName, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                    Text(HomeConstants.myCode, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20
                    )),
                    Text(HomeConstants.course, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20
                    )),
                    IconButton(
                      onPressed: (){
                        viewModel.compile( state.inputCode.text ) ;
                      },
                      icon:  IntrinsicWidth(
                        child:   Row(
                          children: [
                            const Icon(Icons.play_arrow, color: Colors.green,),
                            SizedBox(width: width*0.01,),
                            Text("Execute", style: Theme.of(context).textTheme.titleMedium,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height*0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width*0.45,
                      child: InputBasic(
                        maxLines: 8,
                        keyboard: TextInputType.multiline,
                        labelTopPosition: true,
                        expandInput: false,
                        controller: state.inputCode,
                        placeholderHelp: HomeConstants.placeholderInputCode,
                        labelText:HomeConstants.placeholderInputCode,
                        fontSize: 20,
                        labelFontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: width*0.45,
                      child: InputBasic(
                        maxLines: 8,
                        labelTopPosition: true,
                        expandInput: false,
                        enabled: false,
                        controller: state.inputNewDramatic,
                        placeholderHelp: HomeConstants.placeholderInputNewDramatic,
                        labelText:HomeConstants.placeholderInputNewDramatic,
                        fontSize: 20,
                        labelFontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height*0.02,),
            Expanded(
              child: state.vars.isEmpty?
              const NoDataList():
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(HomeConstants.leftTabTitle),
                                SizedBox(width: width*0.02,),
                                Icon(Icons.table_chart),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(HomeConstants.rightTabTitle),
                                SizedBox(width: width*0.02,),
                                Icon(Icons.table_chart_outlined),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height*0.03,),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(HomeConstants.titleVectors, style: Theme.of(context).textTheme.titleLarge,),
                                      SizedBox(height: height*0.01,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          DataTable(
                                            border: TableBorder.all(
                                              color: Colors.black,
                                              width: 0.4,
                                            ),
                                            headingRowHeight: 35,
                                            dataRowMinHeight: 25,
                                            dataRowMaxHeight: 30,
                                            columns: const [
                                              DataColumn(label: Text(HomeConstants.varsTitle), ),
                                            ],
                                            rows: state.vars.map((e) {
                                              return DataRow(
                                                  cells: [
                                                    DataCell(Text(e.varName), ),
                                                  ]
                                              );
                                            },).toList(),
                                          ),
                                          SizedBox(width: width*0.005,),
                                          DataTable(
                                            border: TableBorder.all(
                                              color: Colors.black,
                                              width: 0.4,
                                            ),
                                            headingRowHeight: 35,
                                            dataRowMinHeight: 25,
                                            dataRowMaxHeight: 30,
                                            columns: const [
                                              DataColumn(label: Text(HomeConstants.terminalsTitle)),
                                            ],
                                            rows: state.terminals.map((e) {
                                              return DataRow(
                                                  cells: [
                                                    DataCell(Text(e.toString()))
                                                  ]
                                              );
                                            },).toList(),
                                          ),
                                          SizedBox(width: width*0.01,),
                              
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width*0.025,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(HomeConstants.titleTableProductions, style: Theme.of(context).textTheme.titleLarge,),
                                      SizedBox(height: height*0.01,),
                                      DataTable(
                                        border: TableBorder.all(
                                          color: Colors.black,
                                          width: 0.4,
                                        ),
                                        headingRowHeight: 35,
                                        dataRowMinHeight: 25,
                                        dataRowMaxHeight: 30,
                                        columns: const [
                                          DataColumn(label: Text(HomeConstants.varsTitle), ),
                                          DataColumn(label: Text(HomeConstants.productionTitle)),
                                        ],
                                        rows: state.productions.map((e) {
                                          return DataRow(
                                              cells: [
                                                DataCell(Text(e.varName), ),
                                                DataCell(Text(e.value))
                                              ]
                                          );
                                        },).toList(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width*0.025,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(HomeConstants.titleVectorsWithoutRecursion, style: Theme.of(context).textTheme.titleLarge,),
                                      SizedBox(height: height*0.01,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          DataTable(
                                            border: TableBorder.all(
                                              color: Colors.black,
                                              width: 0.4,
                                            ),
                                            headingRowHeight: 35,
                                            dataRowMinHeight: 25,
                                            dataRowMaxHeight: 30,
                                            columns: const [
                                              DataColumn(label: Text(HomeConstants.varsTitle), ),
                                            ],
                                            rows: state.varsWithoutRecursion.map((e) {
                                              return DataRow(
                                                  cells: [
                                                    DataCell(Text(e.varName), ),
                                                  ]
                                              );
                                            },).toList(),
                                          ),
                                          SizedBox(width: width*0.01,),
                                          DataTable(
                                            border: TableBorder.all(
                                              color: Colors.black,
                                              width: 0.4,
                                            ),
                                            headingRowHeight: 35,
                                            dataRowMinHeight: 25,
                                            dataRowMaxHeight: 30,
                                            columns: const [
                                              DataColumn(label: Text(HomeConstants.terminalsTitle)),
                                            ],
                                            rows: state.terminals.map((e) {
                                              return DataRow(
                                                  cells: [
                                                    DataCell(Text(e.toString()))
                                                  ]
                                              );
                                            },).toList(),
                                          ),
                              
                                          SizedBox(width: width*0.01,),
                              
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width*0.025,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(HomeConstants.titleTableProductionsWithoutRecursive,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      SizedBox(height: height*0.01,),
                                      DataTable(
                                        border: TableBorder.all(
                                          color: Colors.black,
                                          width: 0.4,
                                        ),
                                        headingRowHeight: 35,
                                        dataRowMinHeight: 25,
                                        dataRowMaxHeight: 30,
                                        columns: const [
                                          DataColumn(label: Text(HomeConstants.varsTitle), ),
                                          DataColumn(label: Text(HomeConstants.productionTitle)),
                                        ],
                                        rows: state.productionsWithoutRecursion.map((e) {
                                          return DataRow(
                                              cells: [
                                                DataCell(Text(e.varName), ),
                                                DataCell(Text(e.value))
                                              ]
                                          );
                                        },).toList(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width*0.025,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(HomeConstants.titleFunctions, style: Theme.of(context).textTheme.titleLarge,),
                                      SizedBox(height: height*0.01,),
                                      DataTable(
                                        border: TableBorder.all(
                                          color: Colors.black,
                                          width: 0.4,
                                        ),
                                        headingRowHeight: 35,
                                        dataRowMinHeight: 25,
                                        dataRowMaxHeight: 30,
                                        columns: const [
                                          DataColumn(label: Text(HomeConstants.functionsTitle), ),
                                          DataColumn(label: Text(HomeConstants.functionFirstTitle), ),
                                          DataColumn(label: Text(HomeConstants.functionNextTitle), ),
                                        ],
                                        rows: state.functions.map((e) {
                                          return DataRow(
                                              cells: [
                                                DataCell(Text(e.varName), ),
                                                DataCell(Text(e.firstFunction.toString()), ),
                                                DataCell(Text(e.nextFunction.toString()), ),
                                              ]
                                          );
                                        },).toList(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(HomeConstants.titleTableSymbol, style: Theme.of(context).textTheme.titleLarge,),
                                SizedBox(height: height*0.01,),
                                DataTable(
                                  border: TableBorder.all(
                                    color: Colors.black,
                                    width: 0.4,
                                  ),
                                  headingRowHeight: 35,
                                  dataRowMinHeight: 25,
                                  dataRowMaxHeight: 30,
                                  columns: state.symbolTable[0].map((t){
                                    return  DataColumn(
                                        label: Text(t)
                                    );
                                  }).toList(),
                                  rows: state.symbolTable.skip(1).map((currentVar) {
                                    return DataRow(
                                        cells: currentVar.map((value){
                                          return DataCell(Text(value));
                                        }).toList()
                                    );
                                  },).toList(),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}




/*

                  SizedBox(width: width*0.02),


                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(HomeConstants.titleFunctions, style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(height: height*0.01,),
                      DataTable(
                        border: TableBorder.all(
                          color: Colors.black,
                          width: 0.4,
                        ),
                        headingRowHeight: 35,
                        dataRowMinHeight: 25,
                        dataRowMaxHeight: 30,
                        columns: const [
                          DataColumn(label: Text(HomeConstants.functionsTitle), ),
                          DataColumn(label: Text(HomeConstants.functionFirstTitle), ),
                          DataColumn(label: Text(HomeConstants.functionNextTitle), ),
                        ],
                        rows: state.functions.map((e) {
                          return DataRow(
                              cells: [
                                DataCell(Text(e.varName), ),
                                DataCell(Text(e.firstFunction.toString()), ),
                                DataCell(Text(e.nextFunction.toString()), ),
                              ]
                          );
                        },).toList(),
                      )
                    ],
                  ),


            Expanded(
              child: state.vars.isNotEmpty ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: height*0.02,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(width: width*0.025,),

                      ],
                    ),
                  ],
                ),
              ) : const NoDataList(),
            )
          ],
        ),

**/