import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/cubit/salesreport_cubit.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/cubit/salesreport_state.dart';

class RecentReportSheet extends StatelessWidget {
  final ResponsiveConfig size;
  RecentReportSheet({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SalesReportCubit()..startListening(),
        child: Container(
            width: size.percentWidth(0.9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: PColors.iconPrimary)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "RECENT SALES REPORT",
                  style: GoogleFonts.agdasima(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                //Items name
                Container(
                  color: PColors.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.percentWidth(0.03),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "COURSE",
                            style: TextStyle(
                                color: PColors.textWhite,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        width: size.percentWidth(0.03),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("CUSTOMER NAME",
                              style: TextStyle(
                                  color: PColors.textWhite,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(
                        width: size.percentWidth(0.03),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("AMOUNT",
                              style: TextStyle(
                                  color: PColors.textWhite,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                
                BlocBuilder<SalesReportCubit, SalesReportState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const CircularProgressIndicator();
                    } else if (state.error != null) {
                      return Text('Error: ${state.error}');
                    }
                    return Column(

                      children: state.sales.map((sale) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: size.percentWidth(0.03)),
                              Expanded(
                                  flex: 1, child: Text(sale["name"] ?? "")),
                              SizedBox(width: size.percentWidth(0.03)),
                              Expanded(
                                  flex: 1, child: Text(sale["Customer"] ?? "")),
                              SizedBox(width: size.percentWidth(0.03)),
                              Expanded(
                                  flex: 1, child: Text("₹ ${sale["amount"]}" ?? "" )),
                              
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  
                ),
              ],
            )));
  }
}
