# [Flutter][Error][Xcode][Pod] Error pod install…에러 발생 시, 대처방법 리스트

아마 에러가 다음과 같이 떠서 이 글을 보고 계실겁니다.

```
Error running pod install
Error launching application on iPhone 기종명.
```

## 1. CocoaPods 를 설치한다.

- flutter doctor 실행해서 확인합니다.
- 설치되지 않았으면, 구글링으로 설치하러 고고

## 2. CocoaPods 을 재설치한다.

- `sudo gem uninstall cocoapods` 를 터미널에 입력한다. (삭제하는 거임)
- `sudo gem install cocoapods` 를 터미널에 입력한다. (설치하는 거임)

## 3. Android Stdio 의 캐시를 제거한다.

- 안드로이드 스튜디오 → File (맥북 좌측 상단 첫 번째 탭) → Invalidate Caches / Restart … 을 클릭합니다.

## 4. Podfile 의 iOS 버전을 올린다.

- `Podfile` 에 들어가서 최상단에 보면 아래와 같은 코드가 적혀있습니다.

```dart
# platform :ios, '9.0'
```

이 코드를 11 이상으로 변경합니다. (참고로 GoogleMap을 쓴다면 12 부터 지원하는 것 같으니 유의)

```dart
# platform :ios, '11.0'
```

## 5. (애플실리콘-m1 유저) Gem install & Pod install 을 x86 으로 변경한다.

- 터미널에 gem을 아키텍쳐를 변경해서 설치한다

```dart
sudo arch -x86_64 gem install ffi
```

- 그리고 Android studio 에 가서 터미널 간 이후, Podfile 의 파일위치로 이동합니다. (터미널 상 이동)
- 아래 커맨드로 Pod install 을 명령합니다. (x86 으로)

```dart
arch -x86_64 pod install
```

추가로 다른 해결책이 보이면, 아카이빙 해두겠습니다.

## 참고자료

- [https://velog.io/@tmdgks2222/Flutter-CocoaPods-not-installed-Skipping-pod-install-error](https://velog.io/@tmdgks2222/Flutter-CocoaPods-not-installed-Skipping-pod-install-error)
- [https://velog.io/@kyleryu/Error-running-pod-install-Flutter](https://velog.io/@kyleryu/Error-running-pod-install-Flutter)
