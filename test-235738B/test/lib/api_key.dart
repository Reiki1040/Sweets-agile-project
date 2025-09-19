// このファイルは、コンパイル時に渡される環境変数からAPIキーを読み込むためのものである。
// 使い方： flutter run --dart-define=GEMINI_API_KEY=YOUR_API_KEY

/// Gemini APIキー。
/// ビルド時に `--dart-define` フラグで指定された値が設定される。
const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');