#  BaseCore
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


### flutter_flavorizr

#### 안드로이드 스튜디오 기준 설정법
1. Run/Debug Configuration 설정창을 켠다.
2. 새로운 Flutter 설정 추가 버튼을 클릭한 후 flavor에 맞는 이름을 기입한다. (Dev / Prod)
3. Dart entrypoint를 새로 추가한 설정에 맞는 파일로 설정한다. e.g. `/lib/main_dev.dart`
4. Additional run args에 flavor 옵션을 주고 flavor의 이름을 기입힌다. e.g. `--flavor dev / --flavor prod`
