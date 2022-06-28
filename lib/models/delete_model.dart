import 'package:flutter/widgets.dart';

class Delete{
  bool longPress = false;
  bool deleteColumn = false;
  bool deleteRow = false;
  bool longPressEnd = false;
  bool isEditing = false;
  Offset size = Offset.zero;
  int heightIndex = 0;
  int widthIndex = 0;

  Delete();
}