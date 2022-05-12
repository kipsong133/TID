# [Flutter][Libary] Beamer 사용방법 간단 정리



1. App 을 전달하는 시점에 router 를 통해서 전달합니다.

```dart
class LemonApp extends StatelessWidget {
  const LemonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // routering 정보를 해석할 방식을 결정해줍니다. => Beamer 해석으로 결정
      routeInformationParser: BeamerParser(),
      // 딜리게이트 객체 전달
      routerDelegate: _routerDelegate,);
  }
}
```

- 기존에는 `MaterialApp(home:...)` 으로 작성될 부분입니다.
- 이 부분을 `.router` 로 변경해줍니다.
- `MaterialApp.router` 는 기존의 `Navigator` 를 사용하는 것이 아닌 `Router`를 사용하기 위한 시작 작업입니다.
- `routeInformationParser` 는 하위 서브 클래스들이 init을 할 수 있도록 해주는 역할을 합니다. 
- `routerDelegate` 는 바로 위에 있는 Parser가 해석한 정보를 전달받는 객체입니다. 그 정보를 받아서 위젯트리를 구성하게 됩니다.



2. 전달은 했지만 생성하지 않은 `_routerDelegate` 를 생성합니다.

```dart
// 전역변수로 정해줘야, 에러가 안생김(Hot-reload)
final _routerDelegate = BeamerDelegate(
  // beamLocations 는 Beamer에게 어떤 화면을 맡길지 알려주는 파라미터입니다.
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
    ],
  ),
);
```

- 우리는 Beamer를 사용할 예정이므로 BeamerDelegate를 생성합니다.
- 그러면 다음과 같은 객체가 생성됩니다.
   `BeamerDelegate(locationBuilder: BeamerLocationBuilder(beaLocation:))`

- 이 코드는 Beamer에게 어떤 화면들이 어디에 있는지를 전달해주는 과정입니다. (그래서 배열로 전달하고 있죠.)
- 아직 생성안한 `HomeLocation()` 을 생성해보도록 하겠습니다.



3. HomeLocation을 생성합니다.

```dart
class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    return [
      BeamPage(
        child: HomeScreen(),
        key: ValueKey('home'),
      ),
    ];
  }

  // 홈 페이지가 어딘지를 알려주는 메소드
  @override
  List<Pattern> get pathPatterns => ['/'];
}
```

- HomeLocation 을 생성할 때 `BeamLocation` 을 채택합니다.
- 이 때, `buildPages`에는 BeamPage 객체를 추가합니다. 어떤 화면을 보여줄지는 `child`, `key` 에는 해당 화면을 지칭할 key를 할당합니다.
- `HomeScreen` 은 단순 Container에 color 값을 준 statelessWidget 입니다.
- pathPatterns 에는 패턴을 넣어줍니다, 즉 어떤 화면이 어디에 위치해있는지 알려주는 메소드입니다. 
- 참고로 공식문서의 설명은 다음과 같습니다. (buildPages / pathPatterns)

> The most important construct in Beamer is a `BeamLocation` which represents a state of a stack of one or more pages.
> `BeamLocation` has **3 important roles**:
>
> - know which URIs it can handle: `pathPatterns`
> - know how to build a stack of pages: `buildPages`
> - keep a `state` that provides a link between the first 2





## 정리

1. 어떤화면을 보여줄지 결정 = `BeamLocation` 클래스 생성
2. Beamer에게 전달 = `BeamerDelegate` 생성
3. App객체에 전달
   = `MaterialApp.router(routeInfomationParser:routerDelegate)`에 객체 할당
