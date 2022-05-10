# [Flutter][Basic][async] main 함수에서 async를 사용할 때, 해줘야 하는 처리

파이어베이스나 Shared_Preferences 를 사용하다보면, 

> WidgetsFlutterBinding.ensureInitialized()
> 

이 코드를 호출하는 경우가 있습니다. 이것에 대해서 이유를 알고 싶어서 이렇게 글을 작성합니다.

## 결론

iOS / AOS 와 커뮤니케이션 해야하는데, 이게 비동기적으로 동작한다. 그런데 그 전에 Binding 처리가 필수이고, 이것을 보장해주기 위해서 작성한다.

## 내용

```dart
void main() async {
  // main 에서 async 를 사용하려면 필요
  WidgetsFlutterBinding.ensureInitialized(); // <--

  // shared_preferences 인스턴스 생성
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService()),
      ],
      child: const MyApp(),
    ),
  );
}
```

`WidgetsFlutterBinding.ensureInitialized();` 이것을 호출해줘야 main 함수에서 async 를 사용할 수 있습니다.

## 사용하는 이유

 먼저, `WidgetsFlutterBinding` 이 무엇인지 보면, 소스코드에 다음과 같이 설명하고 있습니다.

```
/// A concrete binding for applications based on the Widgets framework.
///
/// This is the glue that binds the framework to the Flutter engine.
```

→ 위젯프레임워크로 구성된 앱을 바인딩하게 됩니다. 이것은 프레임워크와 플러터 엔진과 결합해주는 역할을 하는 객체입니다.

말 그대로 플러터위젯과 플러터 엔진을 연결시켜준다고 합니다. 주석을 가져오진 않았지만, 추가설명으로는 runApp 호출 바로 직전에 호출해줘야 한다고 합니다. 

 이 코드를 통해서, `runApp` 의 시작 시점에는 플러터 엔진과 위젯이 바인딩 되도록 “확정적으로" 보장해주기 위한 처리를 할 수 있습니다.

플러터는 각각의 플랫폼(iOS, AOS) 와 채널을 메시징방식으로 소통합니다. 이 플랫폼 채널과 위젯을 바인딩을 보장해야하므로, `ensureInitialized()` 함수 호출이 필요한 겁니다.

### 플랫폼? 채널?

<img width="544" alt="image" src="https://user-images.githubusercontent.com/65879950/167741944-eb6b50f4-4d42-454b-a222-e07dec36a604.png">

구성도를 보면 이렇게 되어 있습니다.

플러터 앱이 하나 있으면, 채널을 통해서 iOS, AOS 와 소통하고 있죠. 이 연결이 비동기적으로 처리되는데, 앱이 실행 되기 전에, 이 연결이 보장되어야 합니다. 그러므로 위 코드를 사용합니다.

이 바인딩은 “정적 바인딩(Static Binding)” 으로 컴파일 타임에 결정됩니다. 

(바인딩이 궁금하다면, 링크로 이동 → [https://secretroute.tistory.com/entry/140819](https://secretroute.tistory.com/entry/140819))

## 참고자료

- [https://velog.io/@kyj5394/WidgetsFlutterBinding.ensureInitialized-사용-이유](https://velog.io/@kyj5394/WidgetsFlutterBinding.ensureInitialized-%EC%82%AC%EC%9A%A9-%EC%9D%B4%EC%9C%A0)
- [https://docs.flutter.dev/resources/architectural-overview#architectural-layers](https://docs.flutter.dev/resources/architectural-overview#architectural-layers)
- [https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding-class.html](https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding-class.html)
- [https://changjoopark.medium.com/flutter-main-메소드에서-비동기-메소드-사용시-반드시-추가해야하는-한줄-728705061375](https://changjoopark.medium.com/flutter-main-%EB%A9%94%EC%86%8C%EB%93%9C%EC%97%90%EC%84%9C-%EB%B9%84%EB%8F%99%EA%B8%B0-%EB%A9%94%EC%86%8C%EB%93%9C-%EC%82%AC%EC%9A%A9%EC%8B%9C-%EB%B0%98%EB%93%9C%EC%8B%9C-%EC%B6%94%EA%B0%80%ED%95%B4%EC%95%BC%ED%95%98%EB%8A%94-%ED%95%9C%EC%A4%84-728705061375)
- [https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html](https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html)
- [https://secretroute.tistory.com/entry/140819](https://secretroute.tistory.com/entry/140819)
- [https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do](https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do)
- [https://iosroid.tistory.com/12#:~:text=Platform channels&text=Flutter가 Platform API 에,메세지로 받는 방식이다](https://iosroid.tistory.com/12#:~:text=Platform%20channels&text=Flutter%EA%B0%80%20Platform%20API%20%EC%97%90,%EB%A9%94%EC%84%B8%EC%A7%80%EB%A1%9C%20%EB%B0%9B%EB%8A%94%20%EB%B0%A9%EC%8B%9D%EC%9D%B4%EB%8B%A4)
