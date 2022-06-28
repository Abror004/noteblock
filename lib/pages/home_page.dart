import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteblock/bloc/home_page_cubit/home_page_cubit.dart';
import 'package:noteblock/bloc/home_page_cubit/home_page_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void emit() {
    BlocProvider.of<HomePageCubit>(context).emitFunction();
  }
  double size = 76;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomePageCubit>(context).checkInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        print("--->: " + BlocProvider.of<HomePageCubit>(context).getList().toString());
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10,left: 10, top: 10),
                    child: Text("NoteBlocks",style: TextStyle(fontSize: 25, fontFamily: "Kelson_Sans", color: Colors.black),),
                  ),
                ),
                if(state.delete.isEditing)
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          state.delete.longPress = false;
                          state.delete.deleteRow = false;
                          state.delete.deleteColumn = false;
                          state.delete.isEditing = false;
                          emit();
                        },
                        child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      /// ####
                      InkWell(
                        onTap: () {
                          if(!((state.delete.deleteColumn && state.blocks.width == 1) || (state.delete.deleteRow && state.blocks.height == 1))) {
                            if(state.delete.isEditing) {
                              if(state.delete.deleteColumn) {
                                state.blocks.width -= 1;
                                print("-- width");
                                print("height = ${state.blocks.height} : widht = ${state.blocks.width}");
                              } else {
                                state.blocks.height -= 1;
                                print("-- height");
                                print("height = ${state.blocks.height} : widht = ${state.blocks.width}");
                              }
                            }
                            state.delete.longPress = false;
                            state.delete.deleteRow = false;
                            state.delete.deleteColumn = false;
                            state.delete.isEditing = false;
                            emit();
                          }
                        },
                        child: Icon(Icons.delete, color: !((state.delete.deleteColumn && state.blocks.width == 1) || (state.delete.deleteRow && state.blocks.height == 1)) ? Colors.red : Colors.grey, size: 30,),
                      ),
                    ],
                  )
              ],
            ),
          ),
          body:SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// numbers row
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: SingleChildScrollView(
                    controller: state.scrollController2,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      children: [
                        for(int i=1 ; i<=state.blocks.width; i++)
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ColoredBox(
                              color: Colors.white,
                              child:Align(
                                alignment: Alignment.center,
                                child: Text("$i", style: const TextStyle(fontWeight: FontWeight.w900),),
                              ),
                            ),
                          ),
                        
                        const SizedBox(
                          width: 100,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height-130,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: (50 * (state.blocks.height+2))+50,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: NotificationListener<ScrollNotification>(
                              child: ListView.builder(
                                controller: state.scrollController1,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: state.blocks.width+2,
                                itemBuilder: (context, dx) {
                                  if(dx == state.blocks.width+1) {
                                    /// button add width
                                    if(!state.delete.isEditing) {
                                      return addButton(state, true, addWidth: true);
                                    } else {
                                      return addButton(state, false, addWidth: false);
                                    }
                                  } else {
                                    /// blocks column => blocks | numbers | button add height |
                                    return Column(
                                      children: [
                                        if(dx > 0)
                                          for(int dy = 0; dy <= state.blocks.height; dy++)
                                          /// blocks
                                            block(state, dx, dy, state.info[dx-1][dy]),
                                        if(dx == 0)
                                        /// numbers
                                          const SizedBox(
                                            height: 0,
                                            width: 0,
                                          ),
                                        if(dx == 1)
                                        /// button add width
                                          if(!state.delete.isEditing)
                                            addButton(state, true, addWidth: false),
                                      ],
                                    );
                                  }
                                },
                              ),
                              onNotification: (position) {
                                state.scrollController2.jumpTo(position.metrics.pixels);
                                emit();
                                return false;
                              },
                            ),
                          ),
                          Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for(int i = 0; i <= state.blocks.height; i++)
                              /// numbers
                                numbersColumn(i),
                              const SizedBox(
                                height: 50,
                                width: 40,
                                child: ColoredBox(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget numbersColumn(int i) {
    return SizedBox(
        height: 50,
        width: 40,
        child: ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: Text(i == 0 ? "" : "$i", style: const TextStyle(fontWeight: FontWeight.w900),),
          ),
        )
    );
  }

  Widget block(state, int dx, int dy, String value) {
    if(dy == 0) {
      return blockBody(state, dx, dy, value);
    } else {
      return GestureDetector(
        onLongPress: () {
          if(!state.delete.isEditing && dx != 0) {
            state.delete.heightIndex = dy;
            state.delete.widthIndex = dx;
            state.delete.longPress = true;
          }
          emit();
        },
        onLongPressEnd: (location) {
          print("long press end");
          state.delete.longPressEnd = true;
          state.delete.size = Offset.zero;
          if(!state.delete.isEditing) {
            state.delete.longPress = false;
            state.delete.isEditing = false;
          }
          emit();
        },
        onLongPressMoveUpdate: (location) {
          if(!state.delete.isEditing) {
            // for get position
            if(state.delete.size == Offset.zero) {
              print("======================================");
              state.delete.size = location.globalPosition;
              print("======================================");
              emit();
            }
            // for console
            if(state.delete.isEditing) {
              print("tugadi");
            } else {
              print("${(state.delete.size.dy - location.globalPosition.dy).abs().toInt()} - ${(state.delete.size.dx - location.globalPosition.dx).abs().toInt()}");
            }
            // for get deleting blocks
            if((!state.delete.isEditing) && size < (state.delete.size.dy - location.globalPosition.dy).abs()) {
              print((state.delete.size.dy - location.globalPosition.dy).abs().toInt());
              print("select column");
              state.delete.deleteColumn = true;
              state.delete.isEditing = true;
              emit();
            } else if ((!state.delete.isEditing) && size < (state.delete.size.dx - location.globalPosition.dx).abs()) {
              print((state.delete.size.dx - location.globalPosition.dx).abs().toInt());
              print("select row");
              state.delete.deleteRow = true;
              state.delete.isEditing =  true;
              emit();
            }
          }
        },
        child: blockBody(state, dx, dy, value)
      );
    }
  }

  Container blockBody(state, int dx, int dy, String value) {
    return Container(
      padding: EdgeInsets.all((state.delete.longPress) && (((state.delete.deleteColumn && state.delete.widthIndex == dx) || (state.delete.deleteRow && state.delete.heightIndex == dy)) || (state.delete.widthIndex == dx && state.delete.heightIndex == dy)) ? 5 : 1,),
      height: 50,
      width: 100,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          )
      ),
      child: ColoredBox(
        color: dy == 0 ? Colors.blue.withOpacity(0.5) : Colors.green.withOpacity(0.5),
        // child: TextField(
        //   decoration: InputDecoration(
        //       labelText: "$dy : $dx"
        //   ),
        // ),
        child: Text(BlocProvider.of<HomePageCubit>(context).getList()[dx-1][dy]),
        // child: Text(value),
      ),
    );
  }

  SizedBox addButton(state, bool have, {required bool addWidth}) {
    if(have) {
      return SizedBox(
        width: 100,
        child: Align(
          alignment: Alignment.topCenter,
          child: MaterialButton(
            onPressed: () {
              print("((( ${state.info}");
              if(addWidth) {
                BlocProvider.of<HomePageCubit>(context).addWidth();
                // print("+ width");
                // print("height = ${state.blocks.height} : widht = ${state.blocks.width}");
              } else {
                BlocProvider.of<HomePageCubit>(context).addHeight();
                // print("+ height");
                // print("height = ${state.blocks.height} : widht = ${state.blocks.width}");
              }
              print("))) ${state.info}");
            },
            color: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 50,
        width: 100,
      );
    }
  }
}