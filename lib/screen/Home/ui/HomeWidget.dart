import 'package:compiladorestareauno/screen/Home/data/HomeConstants.dart';
import 'package:compiladorestareauno/widget/InputBasic.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (){
                viewModel.compile( state.inputCode.text ) ;
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
      ),
    );
  }
}
