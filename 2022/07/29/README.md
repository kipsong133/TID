# Dart에서 Futures 그리고 Streams (1)

원본 : https://www.raywenderlich.com/32851541-dart-futures-and-streams

(해당 글을 바탕으로 재구성)


## 도입

## 비동기, 그리고 Dart 에서 비동기 처리

 만약 우리가 비동기 처리를 할 수 없다고 생각하면, 정말 답답한 세상속에서 살아야 할 수도 있어요. 왜냐하면, 한 번에 하나의 일 밖에 하지 못하거든요. 예를 들면, 우리가 혼밥을 한다고 생각해봅시다. 밥 먹을 때, 우린 비동기적으로(= 하나를 하면서 다른 걸 진행) 무언가를 하고 있죠! 바로. 유튜브보기 입니다. 밥먹으면서 유튜브를 못 볼 생각하면, 정말 끔찍스 합니다.

 이렇게, 하나의 동작을 하고, 그 동작이 끝나든지 말든지 다음일을 수행하는 동작을 "비동기" 라고 합니다. 프로그래밍을 할 때는 더 많은 케이스가 있습니다.

- 네트워킹을 하면서, UI 랜더링
- 이미지 처리를 하면서, Event 수신

etc...



비동기 처리를 한다는 것은 결국 "원하는 순서대로 원하는 로직을 실행시키자" 라고 생각합니다. 이 비동기처리를 이번 글에서는 "Dart" 언어로 해보겠습니다. (Swift 도 문법만 다르지 개념인 비슷합니다^^)



## Dart.pad 를 이용한 비동기 예시



### 네트워크에서 받아온 뒤 무언가 처리하고 싶다.

만약 위 타이틀과 같은 요구가 있다고 칩시다. 그러면 이것을 Dart 에서 어떻게 해결할 수 있을까요?





 먼저 아무런 비동기처리가 되지 않은 상태의 코드를 보겠습니다.



```dart
// 비동기 처리가 아닌 상태
List<String> fetchWishList() {
  print('DEBUG: 네트워킹...');
  return [
    '아이패드', '아이폰', '맥북', '플레이스테이션', '엑스박스',
    '스팀덱', '아르세우스', '커피머신',
  ];
}

void printOut(List<String> inputArr) {
  print('RESULT: ');
  for (final element in inputArr) {
    print('    ' + element);
  }
}


main() {
  print('프로그램 시작');
  final response = fetchWishList();
  printOut(response);
}
```

- 위 코드에는 2 개의 메소드가 있습니다. 그리고 마지막에는 main 실행 메소드가 있죠.
- `fetchWishList` 메소드의 경우, 단순히 리스트를 리턴하는 메소드입니다.
- `printOut` 메소드는 리스트를 입력받고, print 를 호출하는 메소드 입니다.



여기까지는 아무런 처리하지 않은 상태입니다. 이걸 실제 프로그래밍이라고 가정하고 순서를 부여하면 다음과 같습니다.

1. 프로그램 시작
2. `fetchWishList` 메소드 호출
3. 네트워킹
4. 결과물 출력 (`printOut` 메소드 호출)



> 그러면 여기 스탭 중에서 시간이 오래 걸려서 프로그램이 멈추는 경우는 없을까요?



그러면 좋겠지만, 3 번 부분이 문제가될 우려가 있습니다. 인터넷 와이파이 상태가 안좋거나, 받아오는 데이터가 너무 많은 경우엔 오래 걸릴 수 있습니다. ~~잘못하면 엑박을 볼 수도~~



정리하면, 리턴 타입인 `List<String>` 을 받는 시간이 언제일지 모르는 상황인거죠. 근데 대략적으로는 우리 알고 있죠. 

"미래" 엔 오죠. 다른 말로 바꾸면, 데이터가 다 받아지면 해당 데이터가 오죠. 미래의 어느 시점이라고 볼 수 있습니다.

그래서 Dart 에서는 뭐라고 표현했는가 하면

"Future" 입니다. 코드를 다시 써보겠습니다.



```dart
// 비동기처리 한 상태
Future<List<String>> fetchAsyncWishList() async {
  print('DEBUG: 데이터를 받아오기시작...');
  await Future.delayed(Duration(seconds: 2));
  return fetchWishList();
}
```

- 이전에 없던 코드가 몇 개 생겼죠.
  1. 리턴 타입이 `List<String>` -> `Future<List<String>>>` 로 변경되었습니다.
  2. 함수 이름 옆에 `async` 라는 키워드가 추가되었습니다.
  3. 코드 블럭 내부에 보면 await 와 그 옆에 딜레이 인자가 추가되었습니다.
- 이 코드들은 무엇이냐면, 억지로 네트워킹을 통한 데이터 패치 과정을 모사한 것 입니다.



이러한 코드라면 아래와 같은 순서로 프로그래밍 될 것 입니다.

1. 프로그램 실행
2. 패치 함수 호출 (위 함수)
3. 2초 대기 (실제 서비스에서는 받아오는 시간 및 지연 시간 기타 등등...)
4. 결과값 받아서 화면에 보여줌



실행코드는 다음과 같습니다.

```dart
main() async {
  print('프로그램 시작');
  final response = await fetchAsyncWishList();
  printOut(response);
}
```



콘솔은 다음과 같이 나타납니다.

```
프로그램 시작
DEBUG: 데이터를 받아오기시작...
DEBUG: 네트워킹...
RESULT: 
    아이패드
    아이폰
    맥북
    플레이스테이션
    엑스박스
    스팀덱
    아르세우스
    커피머신
```



여기까지만 하면, Dio 혹은 HTTP 라이브러리에서 리턴 값을 왜 Future 로 줘야하는지 이해하실 수 있을 겁니다. 네트워킹 결과값은 바로 못 받고 "미래" 의 어느 시점에 받을 것이고, 받았다면 어떻게 하겠다라는 코드가 await 이후에 작성되어 있는 것이죠.( Future 에 then 문법을 이용해서도 가능합니다.)



`네트워크에서 받아온 뒤 무언가 처리하고 싶다.` 에 대한 문제는 해결 되었죠?

> Future - async - await 문법을 사용해서 어떤 시점에 기다려야하고 받고난 뒤 무엇을 해야하는지 코드로 작성하면 된다!



### 네트워킹 처리는 네트워킹대로하고, 동시에 다른 것도 하고 싶다.

만약 위 와 같은 요구는 어떻게 해야하는 걸까요? 먼저 간단한 순서도를 구상해볼게요.

```markdown
1. 프로그램을 시작한다.
2. 네트워킹 통신을 시작한다 / 이때, 동시에!!!! 다른 무언가 처리한다.
3. 네트워킹 결과가 나타나면 화면에 보여준다. / 다른 무언가를 계속 한다.
4. 종료
```

- 위 순서도를 보면 2번과 3 번에 보면 분명히 동시에 2 작업을 하고 있습니다.
- 이 작업의 형태가 하나의 테스크가 끝나는 것과 무관하게 다른 테스크기 진행된 상태죠.
- 이런 작업 형태를 "비동기" 라고 칭합니다.
- 하지만 ""네트워킹 시작 -> 결과가 나타나면 화면 보여준다." 이 과정은 다른 작업이 끝나기까지 기다리고 있죠. 이 과정은 "동기" 라고 칭합니다.



우리는 비동기적 임과 동시에 세부적으로는 동기적으로 프로그래밍을 해줘야하는 상황입니다.

코드를 보겠습니다.



```dart
void main() {
  print('프로그램 시작');
  
  // #1 
  final firstTask = Future.delayed(
    const Duration(seconds: 3),
    fetchWishList,
  );
  
  // #2
  print('첫 번째 테스트를 실행하고 난 이후임 이 시점에 두 번째 테스크 하면됨...');
  
  // #3
  firstTask.then((response) {
    print('첫 번째 테스크에서 결과를 받은 상태');
    printOut(response);
  });
  
  print('프로그램 끝');
}
```

- 이번에는 Future 자체를 인스턴스로 생성해서 호출했습니다.
- #1 `firstTask` 줄을 보면, 딜레이 줄 시간을 인자로 전달해주고, 실행할 메소드를 그 다음 인자로 전달합니다.
- #2 지점에 도달하는 시점을 콘솔 로그로 보겠습니다.



결과

```markdown
프로그램 시작
첫 번째 테스트를 실행하고 난 이후임 이 시점에 두 번째 테스크 하면됨...
프로그램 끝
DEBUG: 네트워킹...
첫 번째 테스크에서 결과를 받은 상태
RESULT: 
    아이패드
    아이폰
    맥북
    플레이스테이션
    엑스박스
    스팀덱
    아르세우스
    커피머신
```

- 아직 네트워킹 중인데, 호출되었습니다. (#2 지점)
- 그 뜻은 첫 번째 Task 가 끝나지 않았지만, 다음 프로세스가 실행된 것 입니다.
- 이번 주제의 하나의 테스크를 실행하고 다른 테스크를 실행하는 문제가 해결되었죠?



나머지 까지 보겠습니다.

- #3 번 지점을 보면 then 이라고 future 인스턴스 뒤에 뭐가 붙어 있죠?
- 이 부분이, "미래에 받을 데이터를 받았다치고, 아래 코드를 실행하겠따." 라는 뜻 입니다.
- async - await 에서 await 다음 코드라고 보시면 됩니다.



> 네트워킹 처리는 네트워킹대로하고, 동시에 다른 것도 하고 싶다. 

라는 문제도 이제 해결 했습니다~!



## Future 가 가진 상태값들

Future 타입은 2 가지 상태가 있습니다.

(자세한 내용은 공식문서 : https://api.flutter.dev/flutter/dart-async/Future-class.html)

- uncompleted
- completed

그리고 completed 에는 value 를 리턴하거나 error 를 리턴합니다. 간단하게 생각해보면, 네트워킹을 했는데, 성공하거나 실패한 경우죠.



이번에 로딩 인디케이터를 콘솔로 만들어 보겠습니다.



```dart
import 'dart:async';

void main() {
  // #1
  final future = fetchAsyncWishList();
  
  // #2
  final loadingIndicator = Timer.periodic(
    const Duration(milliseconds: 250),
    (timer) => print('.')
  );
  
  // #3
  future.whenComplete(() => loadingIndicator.cancel());
  
  // #4
  future.then((wishList) {
    printOut(wishList);
  });
}
```

- 맨 위에 보면 `import 'dart:async'` 라는 패키치를 추가해줘야 `Timer` 를 사용할 수 있습니다.
- #1 코드는 future 를 생성하는 코드입니다.
- #2 는 로딩 인디케이터를 생성하는 코드입니다. Timer 를 통해서 생성하고 있죠.
- #3 은 앞서 생성한 future 의 상태가 completed 가 되면, 종료하도록 하는 코드 입니다.
- #4 은 값을 받아왔을 경우 동작하는 코드 입니다. (사실 맨 위 에 써도 무방합니다. 즉, 4 번이 1 번 바로 아래로 가도 됩니다.)



콘솔은 다음과 같이 출력됩니다.

```markdown
DEBUG: 데이터를 받아오기시작...
.
.
.
.
.
.
.
DEBUG: 네트워킹...
RESULT: 
    아이패드
    아이폰
    맥북
    플레이스테이션
    엑스박스
    스팀덱
    아르세우스
    커피머신
```

위 코드에 UI 만 연결하면 로딩인디케이터에 대한 로직은 모두 구현 한 겁니다.^^



## Future 의 타입 (리턴타입)

앞서, Future 의 상태를 알아 봤습니다. 이번에는 Future가 될 수 있는 값, 즉 타입에 대해서 알아볼게요. 

결론 먼저 말하자면, 2 가지 타입이 될 수 있습니다.

1. Value
2. Error

~~네트워킹을 성공하거나 실패하거나, 이미지 처리를 성공하거나 실패하거나, 기타 등등...~~

 

코드를 보겠습니다.

```dart
void main() {
  // #1
  final valueFuture = Future.value('부르는게 값이야~!');
  
  // #2
  final errorFuture = Future.error('어제까지 분명 된 코든데....');
  
  // #3
  valueFuture.then((value) {
    print('얼마?? => ' + value);
  });
  
  errorFuture.then((value) {
    print('결과는?? => ' + value);
  });
}
```

콘솔

```markdown
얼마?? => 부르는게 값이야~!
Uncaught Error: 어제까지 분명 된 코든데....
```

- #1 번과 #2 번을 보면 하나는 value 하나는 error 에 인자로 값을 전달하고 있습니다. 

- #3 은 호출하는 코드 입니다. 

- 그리고 에러의 경우 출력이 조금 생소하죠? error 로 판정되었는데 이에 대한 처리를 안해줘서 입니다.

  ~~erorr 를 처리안하면 어떻게 된다? 앱이 크래쉬 난다. 크래쉬나면? 앱 평점이 떨어진다...ㅠ~~



에러는 다음과 같이 다뤄주면 됩니다. (멋있는 말로 핸들링)

```dart
  errorFuture
    .then((value) {
    print('결과는?? => ' + value);
  })
    .catchError((error) {
      print('잡았다 요놈 ' + error);
    });
```

- 추가된 코드는 `.catchError` 부분 입니다. 에러가 잡히면 어떻게 하겠다라고 명시만 해주면됩니다.
- 그런데, 파라미터로 error 를 또 받고 있죠?
- 이건 왜 받을까요? error 가 어떤 종류인지 구분하기 위해서 받습니다. 에러의 종류마다 다르게 처리하고 싶을 수 있잖아요. 그건 어떻게 하느냐! 다음 바로 보시죠.



## Future 의 Error 를 다양하게 다루기

먼저 코드를 보겠습니다.

```dart
// #1 
class UnauthorizationError implements Exception {}
class UnknownError implements Exception {}
class InvaildError implements Exception {}

void main() {
  // #2
  final errorFuture = Future.error(UnauthorizationError());
  
  // #3
  errorFuture
    .then((value) => print('성공적...'))
    .catchError((error) => print('삐빅... 유효하지 않음'),
               test: (error) => error is InvaildError,
               )
    .catchError((error) => print('삐빅... 나도 모름'),
               test: (error) => error is UnknownError,
               )
    .catchError((error) => print('삐빅... 권한이 없다능...'),
               test: (error) => error is UnauthorizationError,
               );   
}

// 콘솔 결과
삐빅... 권한이 없다능...
```

- #1 을 보면, 커스텀으로 Error 를 정의하는 부분입니다. `Exception` 을 채택해서 구현해주면 되겠습니다.

- 그러면 이런 의문이 들 수 있겠죠. 아니 미리 정의된거 없나?? 라구요.

  그건 여기를 참조해주세요 => https://www.tutorialspoint.com/dart_programming/dart_programming_exceptions.htm

- #2 를 보면, Future 객체를 생성하는데, 우리는 에러를 보고 싶으니 인자로 에러를 전달하고 있습니다.

- #3 에서는 에러를 다루는 모습입니다. 만약 에러가 아니라면 맨 첫 번째 줄에 있는 "성공적..." 이 호출됩니다. 

- 아닌 경우는 `catchError` 문을 지나가면서 자신이 해당하는 에러에 반응할 겁니다.

- 근데 자신이 해당하는 에러임을 어떻게 안다?~?~

  - 바로 test 파라미터에서 확인하고 있죠.



여기까지는 Future 객체를 직접 생성해서 에러를 다룬 경우 입니다. async - await 를 썻다면, try catch 를 통해서 다룰 수 있습니다.



## Async - await 가 Error 를 다루는 법

 이전 Future 에러 다룬 것과크게 다르진 않습니다. 코드를 먼저 보겠습니다.

```dart
// #1
Future<int> getCount() async {
  throw UnknownError();
}

void main() async {
  // #2
  try {
    final response = await getCount();
    print('결과는? $response');
  } catch(error) {
    // #3
    print('ERROR: $error');
  }
}
```

```
ERROR: Instance of 'UnknownError'
```

- #1 은 에러를 생성하는 간단한 메소드 입니다.
- #2 는 try 문이고, 해당 코드블럭을 보면, 에러가 리턴될 우려가 있는 코드가 실행되고 있습니다.
- #3 은 에러인 경우, 어떻게 처리할지를 정의한 코드블럭입니다.



사용하는게 그리 어렵지 않죠?



Stream 을 다루는 건 다음 글에 이어서 작성하겠습니다.



## 정리

- Future 는 "나중에 받을 데이터" 를 의미하는 타입입니다.
- "만약 받게되면 이렇게 해줘" 를 의미하는 것은 then 입니다.
- Future - then 을 이용해서 비동기를 처리할 수 있습니다.
- Async - await 를 이용해서 비동기처리를 할 수 있습니다.
- catchError 혹은 try-catch 를 이용해서 에러를 핸들링할 수 있습니다.



읽어주셔서 감사합니다.^^



## 참고자료

- https://api.flutter.dev/flutter/dart-async/Future-class.html
- https://www.raywenderlich.com/32851541-dart-futures-and-streams
- https://dart.dev/codelabs/async-await
- https://www.tutorialspoint.com/dart_programming/dart_programming_exceptions.htm

- https://otrodevym.tistory.com/entry/flutter-15-Future-async-%EC%8B%AC%ED%99%94

