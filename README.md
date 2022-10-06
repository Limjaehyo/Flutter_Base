#  BaseCor
![clean arch](https://github.com/MahmoudElbokl/flutter_clean_arch_sample_demo/raw/master/flutter_clean_arch.png " Call Flow")

## 프로젝트 빌드 옵션
대괄호 중 하나의 옵션을 선택 맨 마지막의 옵션은 입력하지 않으면 --release가 디폴트값이다.

### Android

```bash
flutter build [apk | appbundle] --flavor [dev | prod] [--debug | --release(default) | --profile] -t lib/main_[dev/stage/prod].dart
```

### iOS
--export-method 옵션을 넣지 않으면 --export-method app-store가 기본값이다.

```bash
flutter build ipa --flavor [dev | prod] --export-method [ad-hoc | app-store(default) | development] -t lib/main_[dev/stage/prod].dart [--debug | --release(default) | --profile]
```

## 프로젝트 실행 전 세팅

### Splash
Splash 추가

root 디렉토리의 flutter_native_splash.yaml 파일을 기반으로 빌드한다.
```bash
flutter pub run flutter_native_splash:create
```
Splash 삭제
```bash
flutter pub run flutter_native_splash:remove
```

### Retrofit, JsonSerializable, freezed
클래스를 자동생성 하려면 아래의 명령어를 터미널에서 실행한다.
```bash
flutter pub run build_runner build
또는 
flutter pub run build_runner build --delete-conflicting-outputs
```

### Localizely
필요 시 [Localizely 문서](https://localizely.com/what-is-localizely/)를 참고

안드로이드 스튜디오 / 인텔리J, vscode는 Flutter Intl (개발자: Localizely)이라는 플러그인을 설치하면 새로운 .arb파일이 업데이트되면 새로 l10n폴더를 생성해준다.

위 플러그인을 사용하지 않는 경우 intl_utils패키지가 설치되어 있다면 아래 명령어로 코드를 생성할 수 있다.

```bash
flutter pub run intl_utils:generate
```

만약에 로컬에서 .arb파일을 수정했다면 아래와 같은 명령어로 localizely 계정에 파일을 업로드 할 수 있다.


- 명령어와 옵션
    ```bash
    flutter pub run intl_utils:localizely_upload_main [--project-id <PROJECT_ID> --api-token <API_TOKEN> --arb-dir <ARB_DIR> --main-locale <MAIN_LOCALE> --branch <BRANCH> --[no-]upload-overwrite --[no-]upload-as-reviewed] --upload-tag-added <UPLOAD_TAG_ADDED> --upload-tag-updated <UPLOAD_TAG_UPDATED> --upload-tag-removed <UPLOAD_TAG_REMOVED>
    ```
- pubspec.yaml과 .localizely/credentials.yaml 파일에 프로젝트 id와 api token값이 정의 되어 있다. credential.yaml 파일에 있는 api token 값을 복사해서 아래 명령어를 실행하면 업로드 된다. 
    ```bash
    flutter pub run intl_utils:localizely_upload_main --api-token [api-key]
    ```

    ```

### flutter_flavorizr

#### 안드로이드 스튜디오 기준 설정법
1. Run/Debug Configuration 설정창을 켠다.
2. 새로운 Flutter 설정 추가 버튼을 클릭한 후 flavor에 맞는 이름을 기입한다. (Dev / Prod)
3. Dart entrypoint를 새로 추가한 설정에 맞는 파일로 설정한다. e.g. `/lib/main_dev.dart`
4. Additional run args에 flavor 옵션을 주고 flavor의 이름을 기입힌다. e.g. `--flavor dev / --flavor prod`
