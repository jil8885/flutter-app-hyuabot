import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DateController.dart';
import 'package:flutter_app_hyuabot_v2/Config/GlobalVars.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "/calendar");
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: GetBuilder<DateController>(
        builder: (controller) {
          CalendarDataSource _schedules;
          _schedules = controller.meetingDataSource;
          return SfCalendar(
            dataSource: _schedules,
            view: CalendarView.month,
            onTap: (CalendarTapDetails details){
              List _appointments = details.appointments;
              for(var _data in _appointments){
                print(_data);
              }
            },
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
                  backgroundColor: const Color.fromARGB(255, 20, 75, 170),
                  trailingDatesBackgroundColor: Color(0xff216583),
                  leadingDatesBackgroundColor: Color(0xff216583),
                  todayBackgroundColor: const Color.fromARGB(255, 20, 75, 170),
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Godo'),
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