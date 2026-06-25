
### 로컬 실행
```
cd quiz_lock_app
flutter pub get # 처음에만 한 번 
flutter run -d chrome
```

### GitHub Pages 배포 (PowerShell — `quiz_lock_app` 폴더에서)
```
flutter build web --release --base-href "/D_StudyQuiz/"
cd build/web
git init -b gh-pages
git add .
git commit -m "deploy"
git push -f https://github.com/SeungYeon04/D_StudyQuiz.git HEAD:gh-pages
```
로컬 **지금 체크아웃된 코드** 기준으로 빌드 → **`gh-pages` 브랜치**에 올라감 (main 자동 배포 아님). GitHub Settings → Pages에서 branch `gh-pages` 선택.

