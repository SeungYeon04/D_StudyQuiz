/// 족보 과목 목록 — 이름·md 경로는 여기만 수정하면 됨.
class JokboEntry {
  const JokboEntry({required this.title, required this.assetPath});

  final String title;
  final String assetPath;
}

class JokboCatalog {
  JokboCatalog._();

  static const sectionTitle = '자격증 공부 족보';

  static const List<JokboEntry> entries = [
    JokboEntry(title: '정보처리기사 실기', assetPath: 'assets/jokbo/Information.md'),
    JokboEntry(title: 'JLPT 일본어', assetPath: 'assets/jokbo/JLPT.md'),
  ];
  // !!취업비자 법적 최소 N2 112점 이상 합격증 제출!! 단계는 나중에 보고 
  // 번외: 현장직은 N4 이상 또는 JFT-Basic이나 직무별 기능시험 - 나는 아마 굳이 참고만 

  static List<String> get titles =>
      entries.map((entry) => entry.title).toList(growable: false);

  static String? assetPathFor(String title) {
    for (final entry in entries) {
      if (entry.title == title) return entry.assetPath;
    }
    return null;
  }
}
