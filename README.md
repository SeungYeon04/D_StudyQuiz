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

> ## 웹 배포
>
> **배포 주소**
>
> - Netlify: https://classy-creponne-487057.netlify.app/
> - GitHub Pages: https://SeungYeon04.github.io/D_StudyQuiz/
>
> ### Netlify (자동 배포, 권장)
>
> 저장소 루트의 [`netlify.toml`](netlify.toml)로 빌드·배포 설정이 들어 있습니다.  
> Netlify는 사이트 **루트(`/`)** 에 배포하므로 `--base-href /D_StudyQuiz/` 같은 GitHub Pages용 옵션은 **쓰지 않습니다**.
>
> #### Netlify 연결 (최초 1회)
>
> 1. [Netlify](https://www.netlify.com) 가입·로그인
> 2. **Add new site → Import an existing project**
> 3. GitHub에서 `D_StudyQuiz` 저장소 선택
> 4. Build settings는 `netlify.toml`이 자동 적용됨 → **Deploy site**
>
> 첫 빌드는 Flutter SDK 설치 때문에 **5~10분** 걸릴 수 있습니다.
>
> #### 자동 배포 (코드 수정 후)
>
> `main` 브랜치에 push하면 Netlify가 자동으로 다시 빌드·배포합니다.
>
> #### 수동 배포 (로컬에서만 올릴 때)
>
> ```powershell
> cd quiz_lock_app
> flutter clean
> flutter pub get
> flutter build web --release
> ```
>
> Netlify 대시보드 → **Deploys → Drag and drop** 에서 `quiz_lock_app\build\web` 폴더를 올리면 됩니다.
>
> ### GitHub Pages (수동 배포)
>
> 소스 코드는 `main` 브랜치, 웹 빌드 결과는 **`gh-pages` 브랜치**에 올립니다.
>
> #### GitHub 설정 (최초 1회)
>
> [저장소 Settings → Pages](https://github.com/SeungYeon04/D_StudyQuiz/settings/pages)
>
> - **Source:** Deploy from a branch
> - **Branch:** `gh-pages` / `/ (root)` → **Save**
>
> #### 빌드 & 배포 (코드 수정 후마다)
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
> > - Netlify와 GitHub Pages는 **`base-href`가 다릅니다** — Netlify는 `/`, GitHub Pages는 `/D_StudyQuiz/`
> > - GitHub Pages용 빌드를 Netlify에 올리면 **흰 화면**이 납니다
> > - `build/web`에서 `git init` 하므로 소스 브랜치(`main`)와 **완전히 별개**입니다

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
