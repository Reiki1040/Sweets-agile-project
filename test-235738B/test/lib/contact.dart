import 'package:flutter/foundation.dart'; // listEquals を使うためにインポート
import 'package:flutter/material.dart';

/// 選考ステータスを定義する列挙型
enum SelectionStatus {
  notSelected('未選択', Colors.grey),
  entry('エントリー済み', Colors.blue),
  internship('インターン参加済み', Colors.cyan),
  offer('内定', Colors.green),
  rejected('お祈り', Colors.red),
  pending('結果待ち', Colors.orange);

  const SelectionStatus(this.displayName, this.displayColor);
  final String displayName;
  final Color displayColor;
}

/// 面接などの予定を表現するクラス
class ScheduleEvent {
  final String title;
  final DateTime date;

  const ScheduleEvent({required this.title, required this.date});

  // ★修正点：オブジェクトの比較を可能にする
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleEvent &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          date == other.date;

  @override
  int get hashCode => title.hashCode ^ date.hashCode;
}

/// 通話メモを表現するクラス
class Memo {
  final String content;
  final DateTime createdAt;

  const Memo({required this.content, required this.createdAt});

  // ★修正点：オブジェクトの比較を可能にする
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memo &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          createdAt == other.createdAt;

  @override
  int get hashCode => content.hashCode ^ createdAt.hashCode;
}

/// 連絡先データを表現するためのクラス（モデル）
class Contact {
  final String companyName;
  final String personName;
  final String phoneNumber;
  final String url;
  final SelectionStatus status;
  final List<ScheduleEvent> events;
  final List<Memo> memos;

  const Contact({
    required this.companyName,
    required this.personName,
    required this.phoneNumber,
    required this.url,
    required this.status,
    this.events = const [],
    this.memos = const [],
  });

  Contact copyWith({
    String? companyName,
    String? personName,
    String? phoneNumber,
    String? url,
    SelectionStatus? status,
    List<ScheduleEvent>? events,
    List<Memo>? memos,
  }) {
    return Contact(
      companyName: companyName ?? this.companyName,
      personName: personName ?? this.personName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      url: url ?? this.url,
      status: status ?? this.status,
      events: events ?? this.events,
      memos: memos ?? this.memos,
    );
  }

  // ★修正点：オブジェクトの比較を可能にする
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          companyName == other.companyName &&
          personName == other.personName &&
          phoneNumber == other.phoneNumber &&
          url == other.url &&
          status == other.status &&
          listEquals(events, other.events) &&
          listEquals(memos, other.memos);

  @override
  int get hashCode =>
      companyName.hashCode ^
      personName.hashCode ^
      phoneNumber.hashCode ^
      url.hashCode ^
      status.hashCode ^
      events.hashCode ^
      memos.hashCode;
}

