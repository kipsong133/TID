# [dart][language] Dart 의 Mixin 정리

## 도입

 오늘도 손가락에 관절염이 오도록 코딩을 짜고 있었습니다. 그러다가 문득 이런 코드를 발견 했습니다.

A 클래스에서 1 번 기능을 사용해야합니다.

B 클래스에서 1 번 기능을 사용해야합니다.

C 클래서에서 1 번 기능을 사용해야합니다

… 

이 문제를 객체지향에서는 어떻게 해결하더라? 라고 고민해보시면, 아마 “상속" 을 떠올리실 겁니다. 그런데, 지금 제가 짠 코드, 즉 A, B 그리고 C 클래스가 이미 상속을 받고 있다면 어떨가요?

더이상 상속받을 수 없기 때문에, 1 번 기능을 사용하고 있지 않습니다. 여기서 반박이 가능하죠.

> 아니 그러면, A,B, C 슈퍼 클래스에 1 번을 추가하면 되잖음?
> 

여기에 억지 조건을 추가하겠습니다. 슈퍼클래스를 상속받은 다른 객체들도 많이 있는데, 1 번을 사용하지 않는다고요. 즉, 1번을 슈퍼클래스에 추가하는 것은 사용하지도 않는 기능을 많은 객체에 적용해야하는 상황입니다.

(대충봐도 낭비입니다. 물론 이정돈 괜춘괜춘 마인드면 그렇게 하셔도 무방하다고 봅니다. 상황에 맞게 빠세이 하시면 됩니다.)

정리해봅시다. 우리에게 필요한건 다음과 같습니다.

> A, B, C 에 상속은 안하는데, 같은 기능을 사용하도록 하고 싶다능.
> 

그렇다면, Mixin 을 쓰면 됩니다. ~~끝~~

## Mixin?

 Mixin 에 대해서 공식문서는 다음과 같이 정의하고 있습니다.

> Adding features to a class: mixins
Mixins are a way of reusing a class’s code in multiple class
hierarchies.
To *use* a mixin, use the `with` keyword followed by one or more mixin
names. The following example shows two classes that use mixins:
> 

→ 클래스에 기능을 추가한다. 믹스인은 다양한 클래스의 계층구조에서(복잡하다는 뜻) 코드를 재사용하는 방법 중 하나이다. 믹스인을 사용하려면 with와 같이 쓰면된다.

우리가 원하던 기능이죠. 위에서 겪은 복잡한 구조에서 기능을 한 번만 정의하고 공통으로 쓰고 싶다는 뜻 입니다.

## 실습

 이제 공통된 속성을 복잡한 구조 속에서 사용할 수 있다던 Mixin 을 직접 써봅시다.

스마트폰 이라는 클래스를 먼저 만들겠습니다.

```dart
class SmartPhone {
  void call() {
    print('전화 거는 중...');
  }
}
```

그리고 아이폰과 갤럭시를 만들어 볼게요. 이 때, 위에서 정의한 스마트폰을 상속하겠습니다.

```dart
class IPhone extends SmartPhone {
  @override
  void call() {
    print('Apple...');
    super.call();
  }
}

class Galaxy extends SmartPhone {
  @override
  void call() {
    print('쌤쑹');
    super.call();
  }
}
```

자. 상당히 상식적이죠?

근데 아이폰과 갤럭시가 전화만 걸리지 않죠.

- 사진찍기
- Face ID
- 쌤쑹페이

이런 기능들이 있죠. 하지만 사진찍기만 공통기능이고 아래 두 기능은 각각의 플랫폼의 고유한 특징입니다.

정리하면, 다음과 같습니다.

사과 : 사진찍기, Face ID

썜쑹 : 사진찍기, 쌤쑹페이

이렇게 하위 클래스에 기능들을 추가하겠습니다. 

이렇게 기능을 추가하고 싶을 때! `Mixin` 을 사용하면 됩니다.

각 기능들을 추가할게요.

```dart
mixin Photo on SmartPhone {
  void snap() {
    print("찰칵스");
  }
}

mixin FaceID {
  void verify() {
    print('얼굴 인증스');
  }
}

mixin SamsungPay {
  void pay() {
    print('삼페개꿀');
  }
}
```

mixin 은 위처럼 사용합니다. 쉽죠? 

다만 첫 번째 정의한 `Photo` 부분을 보면 `on` 키워드가 있습니다.

공식문서는 on 을 다음과 같이 설명합니다.

> Sometimes you might want to restrict the types that can use a mixin.
For example, the mixin might depend on being able to invoke a method
that the mixin doesn’t define.
As the following example shows, you can restrict a mixin’s use
by using the `on`
 keyword to specify the required superclass:
> 

→ 때로는 mixin을 사용할 수 있는 유형을 제한하고 싶을 수도 있습니다. 예를 들어, 믹스인은 믹스인이 정의하지 않는 메서드를 호출할 수 있는지 여부에 따라 달라질 수 있습니다. 다음 예제에서 볼 수 있듯이 on 키워드를 사용하여 필요한 수퍼 클래스를 지정하여 mixin의 사용을 제한할 수 있습니다. (번역기 삐빅)

요약하자면, mixin의 기능을 특정 클래스로 제한하고 싶다면 on 을 사용하시면 됩니다. 그래서 photo 는 SmartPhone 타입으로 제한했습니다. 나머지도 모두 제한해도 됩니다. (일반적인 정의하는 코드를 보여주기 위해서 그냥 저는 두겠습니다.)

이제 전체코드를 보고 실행해보겠습니다.

```dart
class SmartPhone {
  void call() {
    print('전화 거는 중...');
  }
}

class IPhone extends SmartPhone with Photo, FaceID {
  @override
  void call() {
    print('Apple...');
    super.call();
  }
}

class Galaxy extends SmartPhone with Photo, SamsungPay{
  @override
  void call() {
    print('쌤쑹');
    super.call();
  }
}

mixin Photo on SmartPhone {
  void snap() {
    print("찰칵스");
  }
}

mixin FaceID on SmartPhone {
  void verify() {
    print('얼굴 인증스');
  }
}

mixin SamsungPay {
  void pay() {
    print('삼페개꿀');
  }
}

main() {
  print('start...');
  
  final galaxy = Galaxy();
  final iPhone = IPhone();
  
  galaxy.call();
  galaxy.snap();
  galaxy.pay();
  
  iPhone.call();
  iPhone.snap();
  iPhone.verify();
}
```

콘솔창은 다음과 같습니다.

```dart
start...
쌤쑹
전화 거는 중...
찰칵스
삼페개꿀
Apple...
전화 거는 중...
찰칵스
얼굴 인증스
```

## 정리

- 클래스 구조가 복잡하다. 근데 공통된 기능을 공유하고 싶다면, Mixin
- 그렇다고 아무나 공유하게 하고 싶지 않다, On

읽어주셔서 감사합니다.^^

## 참고자료

- [https://dart.dev/guides/language/language-tour#adding-features-to-a-class-mixins](https://dart.dev/guides/language/language-tour#adding-features-to-a-class-mixins)
- [https://fomaios.tistory.com/entry/Dart-Mixin이란-featwith](https://fomaios.tistory.com/entry/Dart-Mixin%EC%9D%B4%EB%9E%80-featwith)
