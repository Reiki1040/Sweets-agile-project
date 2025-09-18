/// 連絡先データを表現するためのクラス（モデル）
class Contact {
  final String companyName;
  final String personName;
  final String phoneNumber;
  final String url;

  // コンストラクタ
  const Contact({
    required this.companyName,
    required this.personName,
    required this.phoneNumber,
    required this.url,
  });
}
