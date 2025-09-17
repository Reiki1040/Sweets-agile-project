# 就活コールフィルター

## 概要

就活生を、就活エージェントなどからの不要な電話のストレスから解放するためのアプリです。
知らない番号からの着信時に、発信元情報を表示することで、電話に出るべきかを瞬時に判断できるようになります。

## 🚀 はじめに

このプロジェクトはFlutterで開発されています。
開発環境をセットアップした後、以下のコマンドでアプリを実行できます。

```bash
flutter run
```


### `pubspec.yaml`

これはFlutterプロジェクトの設定ファイルです。アプリの名前や使用するライブラリなどを定義します。

```yaml
name: my_app
description: "A new Flutter project."
publish_to: 'none' 
version: 1.0.0+1

environment:
  sdk: '>=3.2.3 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true