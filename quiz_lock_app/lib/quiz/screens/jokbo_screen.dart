import 'package:flutter/material.dart';

/// 족보 페이지 - 여백·왼쪽 정렬, 글자·이미지 자유 편집용
class JokboScreen extends StatelessWidget {
  const JokboScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('족보'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '여기에 제목이나 글을 넣으세요.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                '본문 텍스트. 자유롭게 수정해서 사용하세요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              // 이미지 넣을 곳 (assets/images/xxx.png 등)
              // Image.asset('assets/images/jokbo.png', width: double.infinity),
              const SizedBox(height: 16),
              Text(
                '추가 내용...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
