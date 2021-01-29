import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DateController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget{
  final _controller = Get.put(DateController());
  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/calendar");
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Obx((){
          CalendarDataSource _schedules;
          if(_controller.isLoading.value){
            return Center(child: CircularProgressIndicator(),);
          }
          _schedules = MeetingDataSource(_controller.meetingDataSource);
          return SfCalendar(
            dataSource: _schedules,
            view: CalendarView.month,
            appointmentTextStyle: TextStyle(fontFamily: 'Godo', fontSize: 12, color: Colors.white),
            monthViewSettings: MonthViewSettings(
              numberOfWeeksInView: 6,
              showAgenda: false,
              agendaViewHeight: MediaQuery.of(context).size.height / 5,
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
                  backgroundColor: Get.theme.backgroundColor,
                  trailingDatesBackgroundColor: Colors.grey,
                  leadingDatesBackgroundColor: Colors.grey,
                  todayBackgroundColor: Get.theme.backgroundColor,
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Godo',
                      color: Get.theme.textTheme.bodyText1.color
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