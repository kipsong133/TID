# Inherited Widget

### Inherited Widget 공식문서

> Base class for widgets that efficiently propagate information down the tree.
>
> To obtain the nearest instance of a particular type of inherited widget from a build context, use [BuildContext.dependOnInheritedWidgetOfExactType](https://api.flutter.dev/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html).
>
> Inherited widgets, when referenced in this way, will cause the consumer to rebuild when the inherited widget itself changes state.

공식문서에는 다음과 같이 설명하고 있습니다.



기본적으로 데이터를 Tree 아래로 전달하는데 용이한 위젯이라고 합니다. 

만약에 가장 가까운 Inherited-widget 에 접근을 원한다면, `dependOnInheritedWidgetOfExactType` 를 사용하라고 합니다.

마지막으로, Inherited-widget 은 자기자신을 누군가 참조한다면, 자기 자신이 Re-build 할 때, 자신을 참조하는 위젯의 state 도 변경합니다. (~~데이터 바인딩이라고 보면 될 듯?~~)



기본적으로 이러한 목적으로 설계되었다고 합니다. (영상 이미지 참조)

<img width="941" alt="image" src="https://user-images.githubusercontent.com/65879950/179724863-95893187-1fb3-41d6-b427-fc43272e7398.png">


- 그림을 보면 맨 하단에 있는 위젯이 "InheritedWidget" 을 참조하고 있죠?
- 이렇게 되면, 하나하나의 노랑색과 파란색 사이에 있는 4 개의 위젯의 파라미터로 데이터를 전달할 필요 없이(의존성 주입) 한 번에 접근이 가능합니다. (SwiftUI 에서는 EnviromentObject or StateObject... 등등 과 유사하다고 보면 됩니다.)



### 예시

부모 위젯을 먼저 만들어 보겠습니다.
(영상에서 이 Widget 을 설명하면서, 코가 유전되는 것으로 비유해서 Nose 라는 이름이 붙었네요^_*)

```dart
class InheritedNose extennds InheritedWidget {
  final Image asset; // 상위 위젯에 이러한 데이터를 저장했다고 가정
  
  InheritedNose({Widget child}): super(child: child);
  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
```



이제 하위 위젯을 만듭니다.

```dart
class FilipWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 여기 코드를 보면, context 다음 메소드를 통해서 "asset" 데이터까지 접근하고 있습니다.
    final nose = context.inheritedFromWidgetOfExactType(InheritedNose).asset;
    // ...
  }
}
```



여기까지만해도, 충분히 접근이 가능하지만, 부모위젯에 조금만 코드를 더 추가하면, 깔끔하게 접근할 수 있습니다.
~~딱봐도 inherited.... 메소드는 이름부터 너무 긺...~~



그래서 코드를 조금 추가하겠습니다.

```dart
class InheritedNose extennds InheritedWidget {
  final Image asset; // 상위 위젯에 이러한 데이터를 저장했다고 가정
  
  InheritedNose({Widget child}): super(child: child);
  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  // 하위 위젯에서 접근할 때, of 전역메소드에 접근하면 됩니다 앞으로~
	static InheritedNose of(BuildContext context) => contet.inheritedFromWidgetOfExactType(InheritedNose);
 
}
```



이러면 하위 위젯에서 다음과 같이 접근이 가능합니다.

```dart
class FilipWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 와... 진작에..이래야지
    final nose = InheritedNose.of(context);
    // ...
  }
}
```



사실 이미 Flutter 내부에는 위와 같은 패턴으로 코드가 작성되어 있습니다.

```dart
Theme.of(context).primaryColor
```



기본적으로 InheritedWidget 으로 접근한 (즉, 상위 위젯에 접근한) 데이터를 변경하는 것은 비추천합니다. 만약 변경을 해야한다면, 상위 위젯의 함수를 호출하고, 해당 함수에서 변경하도록 하는걸 추천합니다.
(즉, 해당 위젯 내부에서 변경하도록)



### 정리

- InheritedWidget 을 통해, 상위 위젯에 접근이 가능하다.
- 하지만 하위 위젯에서 상위위젯을 단순 접근이 아니라 값을 변경하는 것은 X
- 만약 하고 싶다면, 메소드를 통해서 Stream 을 구성하는 것을 추천한다.



사실 InheritedWidget 을 사용하기보단, 높은 확률로 상태관리 라이브러리를 사용할 것 같습니다. Provider 와 같이. 다만 내부 코드를 보면 이 개념을 바탕으로 구성된 라이브러리니 중요한 내용 같아 보입니다.



## 참고자료

- https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
- https://youtu.be/1t-8rBCGBYw
- https://youtu.be/Zbm3hjPjQMk
