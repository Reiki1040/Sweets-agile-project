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
}

/// 通話メモを表現するクラス
class Memo {
  final String content;
  final DateTime createdAt;

  const Memo({required this.content, required this.createdAt});
}


/// 連絡先データを表現するためのクラス（モデル）
class Contact {
  final String companyName;
  final String personName;
  final String phoneNumber;
  final String url;
  final SelectionStatus status;
  final List<ScheduleEvent> events;
  final List<Memo> memos; // メモのリストを追加

  const Contact({
    required this.companyName,
    required this.personName,
    required this.phoneNumber,
    required this.url,
    required this.status,
    this.events = const [],
    this.memos = const [], // デフォルトは空のリスト
  });

  /// 既存のデータを一部だけ変更した新しいインスタンスを返すメソッド
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
}

