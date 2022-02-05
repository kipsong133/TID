# Today, I learned: ViewBuilder?

 저번에 SwiftUI의 View 프로토콜을 따르는 구조체에서 body는 1 개의 객체만 리턴한다고 배웠습니다.그러면 아래 코드는 어떤 일이길래 여러개의 뷰를 리턴할 수 있는 걸까요?

```swift
struct ManyTextsView: View {
  var body: some View {
    	VStack {
        Text("Hello SwiftUI")
        Text("Very fun... really?")
      }
  }
}
```

- 코드에는 Text가 분명히 두 개가 있고 그 상위에 VStack 이 하나가 있습니다.
- 단순히 보기에는 여러 개의 뷰가 있는 것 처럼 보입니다.



 body는 분명히 1 개의 뷰만 리턴할 수 있습니다. 만약 한 개 이상의 뷰를 리턴하면 에러가 발생할 겁니다. 당장 배열로 감싸도 안됩니다.  위 예시를 보면, VStack이 Text 2 개를 감싸고 있습니다. 즉, VStack == Container 입니다. VStack은 `Trailing closure`라는 문법 개념으로 사용되고 있는 겁니다. (표현식을 작성하는 코드블럭입니다.) 

 후행 클로져(Trailing Closure)를 사용한 것으로 봐서는 초기화함수(init)에서 표현식을 받고 있다는 뜻이겠죠? 한번 코드를 보겠습니다.

```swift
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct VStack<Content> : View where Content : View {

    @inlinable public init(alignment: HorizontalAlignment = .center,
                           spacing: CGFloat? = nil,
                           @ViewBuilder content: () -> Content)

}
```

- 소스코드를 보면 제일 하단에 `@ViewBuilder content: () -> Content` 에 함수를 파라미터로 받고 있습니다.



그렇지만 아직 의문점이 해소되지 않았습니다.

> VStack 도 결국 var body 의 내부에 있으므로 1 개의 View 프로토콜을 채택한 객체만 리턴해야하는게 아닌가요?



 이 질문에 답하기 위헤서는, 위 VStack의 정의부분 중 `@ViewBuilder`개념이 도입되어야 합니다. 이것 덕분에 수많은 View들을 선언하도록 도와주기 때문입니다.



## ViewBuilder

 @ViewBuilder 는 10 개까지 하위 뷰를 빌드하도록 해줍니다. 만약 그것보다 더 많은 뷰가 필요하다면 Group 으로 감싸주면 간단히 해결할 수 있습니다. 단어 뜻 그대로 View를 빌드하도록 해주는 접두사입니다. 

```swift
@resultBuilder struct ViewBuilder
```

 해당 공식문서를 보면, 이것이 어떤 구성원리로 되어있는지에 대한 설명은 없습니다. 다만, 하위 뷰를 생성할 때, 붙여주라고만 나와있습니다. 해당 처리는 SwiftUI가 해주는 지는 나중에 이유를 찾게되면, 수정하겠습니다.



## 정리

- 어쨌든 View 채택 객체 하나만 리턴가능하다. 
- 그래서 컨테이너로 감싸게 될텐데, 그것은 "ViewBuilder" 의 개념활용 덕분이다.



읽어주셔서 감사합니다.

