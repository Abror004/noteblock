import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteblock/models/blocks_model.dart';
import 'package:noteblock/models/delete_model.dart';

import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(
      HomePageState(
        blocks: Blocks.empty(),
        delete: Delete(),
        scrollController1: ScrollController(),
        scrollController2: ScrollController(),
        info: [["",""]],
  ));

  void addHeight() {
    for(int i=0; i<state.info.length; i++) {
      state.info[i].add("${state.info[i].length}");
    }
    state.info.add(state.info.last);
    state.blocks.height++;
    // print(state.info);
    // print(state.info);
    emit(
        HomePageState(
            blocks: Blocks(width: (state.blocks.width), height: state.blocks.height),
            delete: state.delete,
            scrollController1: state.scrollController1,
            scrollController2: state.scrollController2,
            info: state.info
        )
    );
  }

  void addWidth() {
    state.info.add(state.info.last);
    for(int i=0; i<state.info.length; i++) {
      state.info[i].add("${state.info[i].length}");
    }
    state.blocks.width++;
    emit(
        HomePageState(
            blocks: Blocks(width: (state.blocks.width), height: state.blocks.height),
            delete: state.delete,
            scrollController1: state.scrollController1,
            scrollController2: state.scrollController2,
            info: state.info
        )
    );
  }

  void delete({required Delete delete}) {
    if(delete.deleteColumn) {
      state.blocks.height--;
    } else if(delete.deleteRow) {
      state.blocks.width--;
    }
    emitFunction();
  }

  void checkInfo() {
    if(state.info == [[""]]) {
      state.info = [["a1","a2"],["b1", "b2"]];
    }
    emitFunction();
    print("state.info = ${state.info}");
  }

  List<List<String>> getList() {
    print("list = ${state.info}");
    print("height = ${state.blocks.height}");
    print("width = ${state.blocks.width}");
    return state.info;
  }

  void emitFunction() {
    emit(
        HomePageState(
          blocks: Blocks(width: (state.blocks.width), height: state.blocks.height),
          delete: state.delete,
          scrollController1: state.scrollController1,
          scrollController2: state.scrollController2,
          info: state.info
        )
    );
  }
}