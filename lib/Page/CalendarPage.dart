import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/DateController.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage>{
  DateController _controller = DateController();

  @override
  void initState() {
    _controller.fetch();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: StreamBuilder<CalendarDataSource>(
        stream: _controller.allSchedule,
        builder: (context, snapshot) {
          CalendarDataSource _schedules;
          if(snapshot.hasData){
            _schedules = snapshot.data;
            return SfCalendar(
              view: CalendarView.schedule,
              dataSource: _schedules,
              scheduleViewSettings: ScheduleViewSettings(
                appointmentItemHeight: 70
              ),
            );
          } else {
           return Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }
}