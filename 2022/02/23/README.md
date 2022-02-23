# Today, I learned: SwiftUI Function Builders(현, ResultBuilder)

 오늘은 함수빌더에 대해서 알아보겠습니다.



## 개념

 함수 빌더(Function Builder) 는 내장 DSL (Domain Specific Languages)를 정의하는 문법입니다. (Swift 5.4 에서 추가됨, 현재는 공식적으로 Function Builder -> ResultBuilder 라는 이름으로 지원함)

 함수 빌더는 우리가 그동한 사용한 많은 View에 있는 content에 이미 사용되고 있습니다. 정의를 보면 `@ViewBuilder` 라는 것이 함수 빌더입니다. 이것을 사용하는 이유는 간략한 코드로 원하는 기능을 쉽게 구현할 수 있다는 "편의성"이 있기 때문입니다.



cf) 속성에 대하여

```
Swift에서 @ 기호가 붙은 것을 "속성" 이라고 합니다.
우리가 그동안 자주봤던 @available / @objc 이런 것들이 구체적인 예시에 해당합니다. 
타입, 메소드, 프로퍼티에 선언하는 것을 "선언 속성"(Declaration Attributes) 라고 칭합니다.
```

ViewBuilder를 통해서 커스텀 VStack 을 만들어 보겠습니다.

```swift
struct CustomVStack<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder conent: () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      content
    }
  }
}
```

- CustomVStack 을 사용하면, 왼쪽정렬과 5 만큼 뷰 마다 간격이 부여되는 VStack이 생성됩니다.



간단하게 ViewBuilder가 View들을 전달받으면 어떤식으로 코드가 구성되는지 예시를 들어보겠습니다.



아래와 같은 3 개의 뷰를 가지는 VStack이 있다고 가정해보겠습니다.

```swift
VStack {
  Text("무조건 보이는 TEXT") 					 			 // 첫 번째 뷰 
  Bool.random() ? Spacer() : Color.blue  // 두 번째 뷰
	if 	Bool.random() { Text("있다.") }     // 세 번째 뷰
}
```



이런 코드를 뷰빌더가 전달받으면 아래와 같이 처리합니다.

```swift
VStack {
  ViewBuilder.buildBlock(
  	Text("무조건 보이는 TEXT"), // 첫 번째 뷰
    
    Bool.random() ? ViewBuilder.builEither(first: Spacer())
    							: ViewBuilder.builEither(second: Color.blue), // 두 번째 뷰
    
    ViewBuilder.buildIf(
      Bool.random() ? Text("있다.") 
      							: nil )
  )
}
```



직접 만들어 보면서, 이해를 해보도록 하죠.

```swift
// 1
struct Person {
    var name: String
    var age: Int
}

// 2 
@resultBuilder
struct ParticipantsName {
    static func buildBlock(_ components: Person...) -> [String] {
        components.map { $0.name + "님이 참석하셨습니다."}
    }
}

// 3
let uno = Person(name: "우노", age: 22)
let moya = Person(name: "모야", age: 7)
let harry = Person(name: "해리", age: 30)

// 4
@ParticipantsName
func getName() -> [String] {
    uno
    moya
    harry
}

print(getName())
// RESULT: ["우노님이 참석하셨습니다.", "모야님이 참석하셨습니다.", "해리님이 참석하셨습니다."]
```

- 1. Person 구조체를 정의합니다.
- 2. resultBuilder를 생성합니다. 입력받은 Person 타입의 값을 String으로 변경해서 저장합니다.
- 3. 인스턴스를 만듭니다. (uno, moya, harry)
- 4. 커스텀 resultBuilder를 이용하여 데이터를 처리합니다.



## 정리

 대략적으로 어떤식으로 활용하면 되는지 방법은 이해했는데, 어떤순간에 유용할지는 좀 더 공부를 해봐야할 것 같습니다. 추후에 추가되면 이부분을 수정하든 글을 다시 작성해보려고합니다.





읽어주셔서 감사합니다.



## 참고자료

- 스윗한 SwiftUI
