import 'package:flutter/material.dart';

/// 選考ステータスを定義する列挙型
enum SelectionStatus {
  entry('エントリー済み', Colors.blue),
  internship('インターン参加済み', Colors.cyan),
  passed('内定', Colors.green),
  failed('お祈り', Colors.red),
  pending('結果待ち', Colors.orange),
  notSet('未設定', Colors.grey);

  // Enumに表示名と色を持たせる
  const SelectionStatus(this.displayName, this.displayColor);
  final String displayName;
  final Color displayColor;
}

/// 連絡先データを表現するためのクラス（モデル）
class Contact {
  final String companyName;
  final String personName;
  final String phoneNumber;
  final String url;
  final SelectionStatus status; // 選考ステータスをプロパティとして追加

  // コンストラクタ
  const Contact({
    required this.companyName,
    required this.personName,
    required this.phoneNumber,
    required this.url,
    required this.status, // 必須項目にする
  });

  /// 既存のデータを一部だけ変更した新しいインスタンスを返すメソッド
  Contact copyWith({
    String? companyName,
    String? personName,
    String? phoneNumber,
    String? url,
    SelectionStatus? status,
  }) {
    return Contact(
      companyName: companyName ?? this.companyName,
      personName: personName ?? this.personName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      url: url ?? this.url,
      status: status ?? this.status,
    );
  }
}
