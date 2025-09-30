import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/manage/data/services/course_helper_service.dart';

class DetailsAndVideosTabPages extends StatelessWidget {
  final List<Widget> tabBuilders;
  const DetailsAndVideosTabPages({super.key, required this.tabBuilders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PColors.backgrndPrimary,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Videos'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: 
                    tabBuilders,

                  
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          showAddVideoDialog(context);},
        backgroundColor: PColors.containerBackground,
        child: Icon(Icons.add,color: PColors.backgrndPrimary,),
        )
        
        );
  }
}
