# Dart 문법 Cheat Sheet



- 문자열 보간법

```dart
print('${3 + 2}'); // 5
print('${'word'.toUpperCase()}'); // WORD
print('$객체'); // The value of 객체.toString()
```



- Null 사용 예시

```dart
int age = null; // 컴파일 에러!!

int? age = null; // OK

int? age; // OK
```



- Null 사용 예시 2

```dart
int? a; // = null
a ??= 3;
print(a); // <-- Prints 3.

a ??= 5;
print(a); // <-- Still prints 3.
```



- Null 인 프로퍼티에 접근하기

```dart
sampleObject?.memberVar; // 1

(sampleObject != null) ? sampleObject.memeberVar : null; // 2

sampleObject?.memeberVar?.method() // 3

```



- Collection Type 정의 및 초기화

```dart
// List
final listString = ['가', '나',' 다'];

// Set
final setString = {'가', '나', '다'};

// Map
final mapStringInt = {
  '가': 1,
  '나': 2,
  '다': 3
};

// 빈 값들로 초기화하기
final listString = <String>[];
final setString = <String>{};
final mapStringInt <String, Int>{};
```



- 화살표 문법 (함수 표현법) + 연산 프로퍼티

```dart
class Circle {
  // 초기화 함수
  Circle(this.radius);
  
  // 멤버변수
  final double radius;

  // 연산 프로퍼티 + 화살표 표현법
  double get diameter => radius * 2.0;
}
```



- 연산프로퍼티 

```dart
/* 1 */
// 파라미터를 받지 않는 경우
double get diameter => radius * 2.0;

// 파라미터를 받는 경우
bool isValid(num) => listInt.contains(num);

/* 2 */
class DataService {
  var _storage = <int>[];
  
  int get count => _storage.length;
  
  List<int> get getAllData => _storage;
  
  void append(int data) {
    _storage.add(data);
  }
}

void main() {
  var dataService = DataService();
  
  print(dataService.count);
  
  print(dataService.getAllData);
  
  [1,2,3,4,5]
  .forEach( (num) { dataService.append(num); });
  
  print(dataService.getAllData);
}

// Result
// 0
// []
// [1, 2, 3, 4, 5]
```



- 프로퍼티 옵저버 (Dart 에 없음)



- Abstract class (Swift, Protocol)

```dart
// 추상클래스 정의
abstract class StarbucksServerManual {
  void askMenu();
  void calculateBill();
  void callCustomer(String name);
}

// 구현
class Server01 implements StarbucksServerManual {
  @override
  void askMenu() {
    // 메뉴를 손님에게 물어본다.
  }
  
  @override
  void calculateBill() {
    // 계산한다.
  }
  
  @override
  void callCustomer(String name) {
    // 손님을 호출한다.
  }
}

```

- 추상클래스를 따를 때, extends를 하든 implements를 하든, 추상클래스에서 정의한 것들은 모두 구현해야합니다.
- 사실 extends로 할 이유는 없다고 봅니다. 왜냐하면, extends 를 통해서 이미 구현된 로직을 바로 사용하기 위한 장점이 있는데, 추상클래스를 extends 할 경우, 다른 것은 extends할 수도 없고, 로직도 어차피 구현해야기 때문입니다.





- extends vs implements vs with(Mixins) vs abstract Class

**결론**

- abstract class를 만들었으면, implements 를 이용해서, 하위 클래스에서 메소드를 구현하도록 합니다.
- 특정 기능을 공유하고 싶고 + 오버라이딩이 안되었으면 한다면(반드시) => extends
- 여러 개의 클래스 혹은 mixin 의 기능을 이용하고 싶다. + 오버라이딩도 하고 싶다 => with



> Q. 그러면 StatelessWidget은 왜 extend Widget 인가?

- Widget 클래스에서 구현한 기능을 그대로 사용하고 싶고,
- 오버라이딩으로 인한 변환을 막고 싶으며,
- 하나의 클래스만 받도록 보장하고 싶기 때문이 아닐까 생각합니다.



1. extends

- 부모 클래스의 메소드를 구현 없이 바로 사용 가능
- 오버라이딩해서 사용 가능
- 다중 상속은 불가능

```dart
class Vehicle {
  void sound() {
    print('Vehicle: 기계소리...');
  }
}

class Car extends Vehicle { // 더이상 상속받을 수 없음.
  
  @override
  void sound() {
    super.sound();
    print("CAR: 빵빵");
  }
}
```

```dart
void main() {
  Car car = Car();
  car.sound();
}
```

<Result>

```dart
Vehicle: 기계소리...
CAR: 빵빵
```





2. implements

- 부모 클래스의 메소드를 오버라이딩 해야합니다.
- Swift에서 Protocol 을 채택하는 과정과 동일하게, super에 접근하거나 그런건 없음... 그냥 따로 구현해야합니다.
  (super.method() 이런건 불가능하다는 뜻)
- 다중 상속 가능

```dart
class Vehicle {
  void sound() {
    print('Vehicle: 기계소리...');
  }
}

class machine {
  void run() {
    print("기계: 움직임시작...");
  }
}

class Car implements Vehicle, machine { 
  
  @override
  void sound() {
    print("CAR: 빵빵");
  }
  
  @override
  void run() {
    print("CAR: 동작시작...");
  }
}
```

```dart
void main() {
  Car car = Car();
  car.sound();
  car.run();
}
```

<Result>

```dart
CAR: 빵빵
CAR: 동작시작...
```







3. with

- 부모 클래스의 메소드를 구현없이 사용 가능합니다.
- 오버라이딩도 가능합니다.
- 다중상속 가능

```dart
mixin EmergencyProtocol {
  void run() {
    print("위험상황이니 뛰어도망가시오.");
  }
}


class DaliyWorkProcess {
  void run() {
    print("천천히 일해도 됩니다.");
  }
}

class Chef with DaliyWorkProcess, EmergencyProtocol {
  Chef() {}
  
  void cook() {
    print("Chef: 요리시작");
  }
  
  @override
  void run() {
    super.run();
    print("Chef: 뛰기 싫은데...");
  }
}
```

```dart
void main() {
  Chef chef = Chef();
  chef.run();
  chef.cook();
}
```

<Result>

```dart
위험상황이니 뛰어도망가시오.
Chef: 뛰기 싫은데...
Chef: 요리시작
```



- CaseCade

클래스에 있는 오퍼레이터들을 메소트체이닝 마냥 호출할 수 있습니다.

```dart
class CaseCadeObject {
  void fisrt() {
    print("1");
  }
  
  void second() {
    print("2");
  }
  
  void third() {
    print("3");
  }
}
```

```dart
void main() {
  CaseCadeObject myObject = CaseCadeObject();
  myObject
    ..fisrt()
    ..second()
    ..third();
}
```

<Result>

```dart
1
2
3
```



- 이름있는 파라미터 + 함수를 파라미터로 전달받기

```dart
void main() {
  signIn(
    phoneNumber: '01011112222',
    password: '123456',
    onError: (error) { print(error); },
    onSuccess: () { print('가입성공'); }
  );
}

void signIn({
  required String phoneNumber,
  required String password,
  required Function(String error) onError,
  required Function onSuccess
}) {
  if (phoneNumber.length < 11) { 
    return onError('휴대전화번호를 확인해주세요.');
  }
  
  if (password.length < 5) {
    return onError('비밀번호를 확인해주세요.');
  }
  
  return onSuccess();
}
```



- try ~ on ~ catch 

**에러 발생 상황**

```dart
void main() {
  print(5 ~/ 3);
  
  int x = 12;
  int y = 0;
  
  print("에러발생직전!!");
  int answer = x ~/ y; // 0으로 나누게 되면 무한대이므로 에러가 발생합니다.
  print('정상적으로 종료된 케이스');
}
```

주석에 있는 설명처럼, 에러가 발생하는 코드를 작성했습니다.



이렇게 특정 부분에러 에러가 발생하는 경우, 해당 로직을 `try` 로 감싸게 되고, 에러가 발생했을 시, 이를 catch 해서 핸들링하도록 catch 문에서 처리해줍니다.



**try~catch를 적용한 코드**

```dart
void main() {
  int x = 12;
  int y = 0;
  
  // 에러가 발생할 우려가 있는 코드를 try로 감쌉니다.
  try {
    print("시작합니다.");
    int answer = x ~/ y; // 0으로 나눴으므로 이곳에서 에러가 발생합니다.
    print('정상적으로 종료된 케이스');
  } catch (error) {
    // 에러 발생시 이곳에서 핸들링합니다.
    print('에러 핸들링: ${error.runtimeType}');
  }
}
```



여기에 에러마다 다르게 분기처리를 할  수 있는 것이 `try~on~catch` 입니다.

**Example01**

```dart
main() {
  int x = 12;
  int y = 0;

  try {
    print("1. start");
    int res = x ~/ y; // UnsupportedError 에러 발생
   
    print("2. finish"); // 에러가 없는 경우 실행
  } on UnsupportedError catch (e) {
    print("3. UnsupportedError 에러 : ${e.runtimeType}"); // UnsupportedError 담당
    
  } catch (e) {
    print("4. 기타 에러 : ${e.runtimeType}"); // 기타 에러
  }
}
```

**Example02**

```dart
main() {
  try {
    print("1. start");
    assert(false); // AssertionError 발생 
   
    print("2. finish"); // 에러가 없는 경우 실행
  } on UnsupportedError catch (e) {
    print("3. UnsupportedError 에러 : ${e.runtimeType}"); // UnsupportedError 담당
    
  } catch (e) {
    print("4. 기타 에러 : ${e.runtimeType}"); // 기타 에러
  }
}
```









## 참고자료

- https://dart.dev/codelabs/dart-cheatsheet
- https://stackoverflow.com/questions/54946036/flutter-inherit-from-abstract-stateless-widget
- https://velog.io/@kyj5394/Dart-extends-VS-implements-VS-withMixins
- https://betrider.tistory.com/entry/flutter-상속-추상-클래스-믹스인
- https://masswhale.tistory.com/entry/Dart언어공부-25List-심화-forEach-map-reduce-fold
