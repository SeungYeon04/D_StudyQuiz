## 첫 설치 (PC에 Flutter 없을 때, 한 번만)

`flutter pub get` / `flutter run` **하기 전에** 아래를 **위에서부터 순서대로** 끝내세요.  
`flutter`가 인식되지 않으면 이 단계를 아직 안 한 것입니다.

### Git

Flutter SDK 받을 때 필요합니다.

```powershell
winget install -e --id Git.Git --accept-source-agreements --accept-package-agreements
```

### Flutter SDK

`C:\src\flutter`에 stable 버전을 받습니다.

```powershell
git clone https://github.com/flutter/flutter.git -b stable C:\src\flutter
```

### PATH

터미널에서 `flutter` 명령이 인식되게 합니다. 아래 두 줄 다 실행하세요.

```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
$env:Path += ";C:\src\flutter\bin"
```

**PATH 적용:** 위를 실행했는데도 `flutter`가 안 되면 **터미널을 닫았다가 새로 연 다음** `flutter doctor`를 치세요.  
그래도 안 되면 새 터미널에서 `$env:Path += ";C:\src\flutter\bin"` 한 줄 더 실행.

### 설치 확인

Chrome만 쓸 거면 Visual Studio 없어도 됩니다.

```powershell
flutter doctor
```

### Windows 네이티브 앱만 쓸 때 (선택)

`flutter run -d windows` 할 때만 필요합니다. **Docker와 무관**합니다.  
`Unable to find suitable Visual Studio toolchain` 나오면 아래로 C++ 워크로드를 추가하세요.

```powershell
winget install -e --id Microsoft.VisualStudio.2022.BuildTools --accept-source-agreements --accept-package-agreements --override "--passive --wait --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended"
```

설치 끝난 뒤 PC 재부팅 또는 터미널 재시작 → `flutter doctor`에서 Visual Studio가 √인지 확인.

```powershell
flutter doctor
```

---

> ## GitHub.io 웹 배포 (GitHub Pages)
>
> **배포 주소:** https://SeungYeon04.github.io/D_StudyQuiz/
>
> 소스 코드는 `main` 브랜치, 웹 빌드 결과는 **`gh-pages` 브랜치**에 올립니다.  
> `build/web`을 `main`에 푸시하면 Flutter 소스가 덮어씌워지므로 **`gh-pages`만** 사용하세요.
>
> ### GitHub 설정 (최초 1회)
>
> [저장소 Settings → Pages](https://github.com/SeungYeon04/D_StudyQuiz/settings/pages)
>
> - **Source:** Deploy from a branch
> - **Branch:** `gh-pages` / `/ (root)` → **Save**
>
> ### 빌드 & 배포 (코드 수정 후마다)
>
> 저장소 루트(`D_StudyQuiz`)에서:
>
> ```powershell
> cd quiz_lock_app
> flutter clean
> flutter pub get
> flutter build web --release --base-href /D_StudyQuiz/
> cd build/web
> git init
> git remote add origin https://github.com/SeungYeon04/D_StudyQuiz.git
> git checkout -b gh-pages
> git add .
> git commit -m "Deploy Flutter Web"
> git push -u origin gh-pages --force
> ```
>
> > **주의**
> >
> > - `--base-href`는 저장소 이름과 같아야 합니다 → `/D_StudyQuiz/` (빼면 흰 화면)
> > - `build/web`에서 `git init` 하므로 소스 브랜치(`main`)와 **완전히 별개**입니다
> > - 배포 반영까지 1~2분 걸릴 수 있습니다

---

## 앱 실행 (매번)

### `flutter`가 안 될 때 (지금 터미널에서만)

설치는 했는데 **이 창**에서만 `flutter`가 안 되면, PATH 넣기 전에 연 터미널입니다. **아래 한 줄** 먼저 치세요.

```powershell
$env:Path += ";C:\src\flutter\bin"
```

또는 터미널 **전부 닫고 새로 연 뒤** `flutter --version` 확인.

PATH 없이 한 번만 돌릴 때 (전체 경로):

```powershell
C:\src\flutter\bin\flutter.bat pub get
C:\src\flutter\bin\flutter.bat run -d chrome
```

---

### Chrome으로 실행 (권장, Docker·Visual Studio 불필요)

예전에 별도 설치 없이 됐다면 대부분 이 방식입니다. 브라우저 창에 앱이 뜹니다.

저장소 루트(`D_StudyQuiz`)에서:

```powershell
cd quiz_lock_app
flutter pub get
flutter run -d chrome
```

### Windows 앱으로 실행 (선택)

PC에 뜨는 `.exe` 형태. **Visual Studio C++ 워크로드**가 있어야 합니다 (위 **Windows 네이티브** 참고).

```powershell
cd quiz_lock_app
flutter pub get
flutter run -d windows
```

`flutter pub get`은 `pubspec.yaml`이 바뀐 뒤에만 다시 치면 됩니다.
