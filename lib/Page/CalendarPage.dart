import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DateController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if(prefManager!.getString("localeCode")!="ko_KR"){
      Fluttertoast.showToast(msg: "Sorry, this menu supports only korean!");
    }
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: StreamBuilder(
          stream: dateController.scheduleList,
          builder : (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasError){
              return Container(child: Center(child: Text("loading_error".tr()),), height: 50,);
            }
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            CalendarDataSource _schedules;

            _schedules = MeetingDataSource(snapshot.data);
            return SfCalendar(
              dataSource: _schedules,
              view: CalendarView.month,
              appointmentTextStyle: TextStyle(fontFamily: 'Godo', fontSize: 16, color: Colors.white),
              initialSelectedDate: DateTime.now(),
              monthViewSettings: MonthViewSettings(
                showAgenda: true,
                agendaViewHeight: MediaQuery.of(context).size.height / 4.5,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                agendaStyle: AgendaStyle(
                  appointmentTextStyle: TextStyle(
                      fontFamily: 'Godo'
                  ),
                  dateTextStyle: TextStyle(
                      fontFamily: 'Godo'
                  ),
                ),
                monthCellStyle: MonthCellStyle(
                    backgroundColor: Theme.of(context).backgroundColor,
                    trailingDatesBackgroundColor: Colors.grey,
                    leadingDatesBackgroundColor: Colors.grey,
                    todayBackgroundColor: Theme.of(context).backgroundColor,
                    textStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Godo',
                        color: Theme.of(context).backgroundColor == Colors.white ? Colors.black : Colors.white
                    ),
                    trailingDatesTextStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        fontFamily: 'Godo'),
                    leadingDatesTextStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        fontFamily: 'Godo')
                )
              ),
            );
        }
      ),
    );
  }
}