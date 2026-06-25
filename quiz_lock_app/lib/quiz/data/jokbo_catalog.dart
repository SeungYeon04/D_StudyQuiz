/// 족보 과목 목록 — 이름·md 경로는 여기만 수정하면 됨.
class JokboEntry {
  const JokboEntry({required this.title, required this.assetPath});

  final String title;
  final String assetPath;
}

class JokboCatalog {
  JokboCatalog._();

  static const sectionTitle = '정보처리산업기사';

  static const List<JokboEntry> entries = [
    JokboEntry(title: '데이터베이스구축', assetPath: 'assets/jokbo/database.md'),
    JokboEntry(title: '운영체제 네트워크 보안', assetPath: 'assets/jokbo/network.md'),
  ];

  static List<String> get titles =>
      entries.map((entry) => entry.title).toList(growable: false);

  static String? assetPathFor(String title) {
    for (final entry in entries) {
      if (entry.title == title) return entry.assetPath;
    }
    return null;
  }
}
