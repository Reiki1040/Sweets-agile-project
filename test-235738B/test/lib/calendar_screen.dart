import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'contact.dart';

/// カレンダーに表示するためのイベント情報をまとめるヘルパークラス。
class CalendarDisplayEvent {
  final String companyName;
  final ScheduleEvent event;
  CalendarDisplayEvent({required this.companyName, required this.event});
}

/// カレンダー表示画面。
class CalendarScreen extends StatefulWidget {
  final List<Contact> contacts;
  const CalendarScreen({super.key, required this.contacts});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late List<CalendarDisplayEvent> _selectedEvents;
  late Map<DateTime, List<CalendarDisplayEvent>> _eventsByDate;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _eventsByDate = _groupEventsByDate(widget.contacts);
    _selectedEvents = _getEventsForDay(_selectedDay);
  }

  @override
  void didUpdateWidget(covariant CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contacts != oldWidget.contacts) {
      setState(() {
        _eventsByDate = _groupEventsByDate(widget.contacts);
        _selectedEvents = _getEventsForDay(_selectedDay);
      });
    }
  }

  /// 全連絡先の全イベントを日付ごとにグループ化する。
  Map<DateTime, List<CalendarDisplayEvent>> _groupEventsByDate(List<Contact> contacts) {
    final Map<DateTime, List<CalendarDisplayEvent>> eventMap = {};
    for (final contact in contacts) {
      for (final event in contact.events) {
        final dateOnly = DateTime.utc(event.date.year, event.date.month, event.date.day);
        if (eventMap[dateOnly] == null) {
          eventMap[dateOnly] = [];
        }
        eventMap[dateOnly]!.add(
          CalendarDisplayEvent(companyName: contact.companyName, event: event)
        );
      }
    }
    eventMap.forEach((key, value) {
      value.sort((a, b) => a.event.date.compareTo(b.event.date));
    });
    return eventMap;
  }

  /// 特定の日のイベントリストを取得する。
  List<CalendarDisplayEvent> _getEventsForDay(DateTime day) {
    final dateOnly = DateTime.utc(day.year, day.month, day.day);
    return _eventsByDate[dateOnly] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedEvents = _getEventsForDay(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<CalendarDisplayEvent>(
          locale: 'ja_JP',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelected,
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ListView.builder(
            itemCount: _selectedEvents.length,
            itemBuilder: (context, index) {
              final displayEvent = _selectedEvents[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event_note),
                  title: Text('${displayEvent.companyName} - ${displayEvent.event.title}'),
                  subtitle: Text(DateFormat('HH:mm').format(displayEvent.event.date)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

