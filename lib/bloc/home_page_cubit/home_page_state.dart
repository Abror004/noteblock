import 'package:flutter/material.dart';
import 'package:noteblock/models/blocks_model.dart';
import 'package:noteblock/models/delete_model.dart';

class HomePageState {
  // fields //
  Blocks blocks = Blocks.empty();
  Delete delete = Delete();
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollControllerHeight = ScrollController();
  ScrollController scrollController2 = ScrollController();
  List<List<String>> info = [["a1","a2"],["b1", "b2"]];
  HomePageState({required this.blocks, required this.delete, required this.scrollController1, required this.scrollController2, required this.info});
}