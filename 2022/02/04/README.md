# Today, I learned: SwiftUI 에서 Body

SwiftUI를 공부하다보면 제일 많이 보는 프로퍼티가 하나 있습니다 "body" 입니다. 이것에 대해서 짧은 글을 작성해볼까 합니다.



## Body가 연산프로퍼티?

```swift
struct BeatifulView: View {
	var body: some View {
    Text("Hello SwiftUI")
	}
}
```

- 코드만 보면 body는 연산프로퍼티처럼 생겼습니다.
- 그러면 get과 return은 어디에 있는 것일까요? set은 어디서할까요?



 프로퍼티는 보통 getter와 setter로 로직을 분리해서 구현하고 하죠. 하지만, setter를 구현하지 않았다면, 그것은 "Read-Only" 프로퍼티일 겁니다. 해당 프로퍼티는 값을 저장하지 않습니다. 이러한 프로퍼티를 우리는 연산 프로퍼티(Computed Property) 라고 부릅니다. 이러한 연산 프로퍼티는 읽힐때마다 값을 연산하고 생산해서 읽을 수만 있도록 합니다. 일반적인 예시를 보겠습니다.



```swift
struct Airplane {
  
  var planeType: String {
    get {
      return "Boing-737"
    }
  }
  
}
```

- 가장 일반적으로 볼 수 있는 연산프로퍼티입니다. 여기서 한 줄일 경우 생략이 가능한 return을 생략해보겠습니다.



```swift
struct Airplane {
  
  var planeType: String {
    get {
      "Boing-737"
    }
  }
  
}
```

- return을 생략했죠. 한번더 생략해보겠습니다.



```swift
struct Airplane {
  
  var planeType: String {
		"Boing-737"
  }
  
}
```

- 상당히 깔끔해졌죠.
- 참고로 return을 생략할 때, 한줄의 표현식이 아니라면, 생략이 불가능합니다.



그렇지만, 아직 SwiftUI body를 설명하긴 아래 질문은 모르겠습니다.

> 연산프로퍼티니까 그렇게 쓴 것은 알겠는데, some??? some은 뭐지?



## Opaque Types (불투명 타입)

 결론먼저 말하자면 `some` 은 불투명 타입입니다. 불투명 타입은 리턴이 될 때, 확정된다는 것을 의미하는 타입입니다. 불투명타입? 이게 뭘까요. 불투명타입을 단어 뜻 그대로 해석하자면, "확실하지 않은, 이해하기 어려운" 정도의 뜻으로 해석될 것 같습니다. 전 이 해석이 맞다고 생각됩니다. 말 그대로 해당 view는 어떤 타입인지 정확히는 알 수 없는 상태임을 나타내는 겁니다. 

 ```swift
struct BeatifulView: View {
	var body: some View {
    Text("Hello SwiftUI")
	}
}
 ```

 맨 처음에 봤던 예시 view를 보면, 해당 스크린을 드로잉 할 때는, 구체적으로 어떤타입인지 알 필요가 없습니다. 그냥 화면에 그릴 수 있는 타입인 View 프로토콜만 만족하면 되는 것이죠. 드로잉을 하기위해서 필요한 최소한의 정보만 some View라고 작성되어 있는 것 입니다. 즉, `View` 프로토콜만 준수한다면, 어떤 것이든 리턴할 수 있고 그릴 수 있는 정보만 필요한 상태입니다. 만약 처음부터 구체적으로 정의한다면, 가능한 타입을 모두 기입해야하는 일이 발생하겠죠.

 아래 예시를 보겠습니다.

```swift
struct EasyView: View {
  var isEmpty: Bool = true
  
  var body: some View {
    if isEmpty {
      return Color.red
    } 
    
    return Text("Not Empty")
  }
  
}
```

- 위 코드를 보면 `isEmpty`라는 프로퍼티에 따라서 Color 가 리턴되거나 Text가 리턴되고 있죠.
- 이렇게 코드를 작성하면 다음과 같은 에러가 뜹니다.

```
Function declares an opaque return type, but the return statements in its body do not have matching underlying types
```

-> 함수는 불투명 리턴타입을 선언하고 있다. 그러나 리턴 문법을 보면, 매칭되고 있지 않다. 



이게 무슨일일까요? 



 불투명 타입을 리턴으로 결정했을 때는, 가능한 모든 리턴의 경우의세의 경우 모두 동일한 타입을 리턴해야한다는 조건을 가지고 있습니다. 그렇기에 Color일 수도 있고 Text일 수도 있을 수는 없습니다. 리턴타입은 종류가 하나여야 한다는 뜻입니다. 조건에 따라서 달라지면은 안됩니다.

 그래서 위 코드를 아래와 같이 수정해주면 에러가 없어집니다.

```swift
struct TestView: View {
  var isEmpty: Bool = true
  
  var body: some View {
    if isEmpty {
      return Color.red
    }
    
    return Color.blue
  }
  
}
```



## 정리

 불투명타입을 쓰는 이유는 View 프로토콜을 따르는 다양한 객체들을 편리하게 사용하기 위함입니다.(SwiftUI의 Body의 경우) 그 덕분에 View 프로토콜을 따른다면, 어떤 객체든 리턴할 수 있죠. 다만 신경써야한다면, 조건에 따라서 최종적으로 리턴하는 값은 구체적인 View프로토콜을 따르는 하나의 타입이어야 한다는 점 입니다.



문제에 대한 해결책으로 결론을 짓겠습니다.

- return 타입을 동일하게 맞추자. -> ContainerView로 감싸버리면 문제해결



읽어주셔서 감사합니다^^



