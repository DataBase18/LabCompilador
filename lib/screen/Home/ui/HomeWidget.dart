import 'package:compiladorestareauno/screen/Home/data/HomeConstants.dart';
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
              viewModel.compile(state.inputCode.text, state.terminals);
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (){
                viewModel.compile( state.inputCode.text, state.terminals ) ;
              },
              icon:  IntrinsicWidth(
                child:   Row(
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.green,),
                    SizedBox(width: width*0.01,),
                    const Text("Execute"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: width*0.01, vertical: height*0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height*0.02,),
                    Text(HomeConstants.myName, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),),
                    Text(HomeConstants.myCode, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 25
                    )),
                    Text(HomeConstants.course, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20
                    )),
                    SizedBox(height: height*0.03,),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width*0.4,
                            child: InputBasic(
                              maxLines: 5,
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
                          SizedBox(width: width*0.02,),
                          Expanded(
                            child: state.vars.isNotEmpty ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(HomeConstants.titleTableTerminals, style: Theme.of(context).textTheme.titleLarge,),
                                SizedBox(height: height*0.01,),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ],
                                ),
                      
                                SizedBox(height: height*0.05,),
                      
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
                            ) : const NoDataList(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
