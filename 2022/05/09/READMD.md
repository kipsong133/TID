## 첫 화면 출력하기

Entry Point 는 void main() 에서 runApp 호출 시점입니다.

```dart
void main() {
  runApp(const MenuCoolTimeApp());
}
```

- `void main()` 코드 좌측에 보면, 녹색 재생 아이콘이 있는데, 누르게 되면, 앱을 실행하게 됩니다.

- `const` 가 있는 이유는, lint 에서 가능하면 붙여달라고 하네요.



아직 MenuCoolTimeApp 클래스를 생성하지 않았습니다.

Android Studio 에 자동완성을 통해서 위젯을 하나 생성해보겠습니다.

<img width="653" alt="image" src="https://user-images.githubusercontent.com/65879950/167323151-6dfc10fe-9570-414b-a136-8b5a165defb2.png">


stl 까지만 작성해도, 앱에서 아래와 같은 코드를 자동완성 해줄겁니다.

```dart
class <여기에 이름적으면됨> extends StatelessWidget {
  const ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```



최초에 프로젝트를 생성하면 이곳에 MyApp 이라는 클래스가 구성되어 있을 겁니다. 그리고

```dart
Widget build(BuildContext context) {
  return MaterialApp(...)
}
```

이런식으로 구성되어 있었을 겁니다.



build 함수는 위젯이 빌드되는 시점에 호출되는 생명주기 함수입니다. 그 때, MaterialApp 을 반환하고 있는 절차입니다.



지금까지 코드를 정리하면 다음과 같습니다.

- (최상위) MenuCoolTimpApp
  - MaterialApp
  - (아직없음)

기억해야하는 건, main 에서 호출되는 위젯이 최상위 위젯이 되고, 앞으로 이 위젯 하위에 붙여나갈 예정이라는 점 입니다.



## MeterialApp

stl 을 통해서 statelessWidget 자동완성을 하고, 아래와 같이 코드를 작성하겠습니다.

runApp에서 호출하는 `MenuCoolTimeApp` 에서 return 으로 MeterialApp 을 리턴합니다.

```dart
class MenuCoolTimeApp extends StatelessWidget {
  const MenuCoolTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuListApp',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomeWidget(),
    );
  }
}
```



전체 코드 중에서 return 부분만 보겠습니다.

```dart
return MaterialApp(
	title: 'MenuListApp',
  theme: ThemeData(primaryColor: Colors.blue),
  home: HomeWidget(),
)
```



`HomeWidget` 을 아직 생성안했으니 먼저 코드를 작성하겠습니다.

```dart
class HomeWidget extends StatelessWidget {
  const HomeWidget({Key?: key}) : super(key: key);
  
  @overrdie
  Widget build(BuildContext context) {
    return Scaffold(
    	appBar: AppBar(backgroundColor: Colors.white60,),
    )
  }
}
```



다시 본론으로 돌아와서 `MaterialApp` 부분을 보면, title, theme, home 이 있습니다. 이 외에도 정말 많은 것들을 파라미터로 전달해줄 수있습니다.

<img width="731" alt="image" src="https://user-images.githubusercontent.com/65879950/167323181-8c0e2660-7014-4085-a044-fb09a5fcee7a.png">


(정신건강을 위해서 3 개만 보겠습니다.)



이 많은 것들 중에 필수는 `home` 입니다. 단어 뜻 그대로, 최초에 실행되는 화면을 이곳에 전달해주면 됩니다. 그러기 위해서 HomeWidget을 생성해서 전달해주고 있습니다. 이것을 앞으로 '페이지' 라고 부르겠습니다.

하나의 화면은 하나의 페이지 입니다. 그 페이지는 `Scaffold` 라는 위젯으로 구성합니다. 



Scaffold 의 어원은 공사장에서 처음에 공사할 때, 철골 구조물만 건설하는 장면을 상상하시면 됩니다.

<img width="260" alt="image" src="https://user-images.githubusercontent.com/65879950/167323190-04ba19c9-4e3c-4c6c-b830-ab5f140407ac.png">




여기까지 정리하면, 아래와 같습니다.

> runApp -> MaterialApp 생성 -> Home에 첫 페이지 전달 -> 전달할 페이지는 Scaffold 



여기까지 코드를 전체는 다음과 같습니다.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MenuCoolTimeApp());
}

class MenuCoolTimeApp extends StatelessWidget {
  const MenuCoolTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuListApp',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomeWidget(),
    );
  }
}


class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white60,),

    );
  }
}
```



실행화면입니다.

<img width="311" alt="image" src="https://user-images.githubusercontent.com/65879950/167323202-0d5b6e03-fe08-46a2-be24-efe95ab1c72c.png">



## 정리

- void main 가 Entry Point 이다.
- 최초 실행할 앱은 주로 MaterialApp 혹은 CupertinaoApp 이다.
- 위에서 실행한 앱에서 첫 화면은 home 파라미터에 전달한다.
- home 파라미터는 Widget을 전달해줘야하고, 그것은 Scaffold 를 전달해줘야 한다.
