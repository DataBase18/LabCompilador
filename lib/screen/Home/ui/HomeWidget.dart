import 'package:compiladorestareauno/screen/Home/data/HomeConstants.dart';
import 'package:compiladorestareauno/widget/InputBasic.dart';
import 'package:flutter/material.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeState.dart';
import 'package:compiladorestareauno/screen/Home/ui/HomeViewModel.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.state, required this.viewModel});

  final HomeState state;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: (){

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
          SizedBox(height: height*0.05,),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*0.02, vertical: height*0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width*0.7,
                    child: InputBasic(
                      maxLines: null,
                      keyboard: TextInputType.multiline,
                      labelTopPosition: true,
                      controller: state.inputCode,
                    ),
                  ),
                  SizedBox(width: width*0.02,),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text(HomeConstants.varsTitle)),
                      DataColumn(label: Text(HomeConstants.terminalsTitle)),
                    ],
                    rows: [
                      DataRow(
                          cells: [DataCell(Text("VAR")), DataCell(Text("TERMINAL A"))   ]
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
