# Today, I learned: SwiftUI Testing Basic(1)

 오늘은 Testing 에 대해서 공부했습니다. SwiftUI에서 UI Test에 대해서 정리해보려고 합니다.

## 테스팅에 대하여

 엔지니어링에서 Test를 통해서 보통 신뢰성을 검증하곤 하죠. 그래서 이번에는 Test를 해서 SwiftUI의 동작을 테스트하는 문제상황을 가정하고 글을 작성합니다.

 테스트 하면 3 가지가 떠오릅니다.

1. Unit Test
2. Integration Test
3. User Interface Test

 이 셋 중에서 가장 기본이 되는 것이 **Unit Test** 라고 생각해요. 각각의 유닛들이 예상되는 Output이 나오는지 검증할 수 있는 테스트이죠. 그 다음 스탭으로는 **Integration Test** 입니다. 다른 코드들이 얼마나 서로 잘 동작하는 지를 확인합니다. 또는 외부 앱과 어떻게 함께 잘 동작하는지를 확인할 수도 있다고 봅니다. 구체적인 예시로 외부 API를 통해서 특정 동작을 하는 경우가 있겠네요. 마지막으로 **UI Test**가 있습니다. 제일 마지막에 있는 만큼 제일 복잡합니다. 유저가 접하는 인터페이스에서의 앱의 동작을 검증하는 과정입니다. 



## UI Test

 SwiftUI는 UI에 관한 프레임 워크이므로 UI Test에 대해서 작성해보고자 합니다.

테스트를 원하는 페이지에서 File > New > Target 을 클릭하면 다음과 같은 탬플릿 선택 창이 나타납니다.

![image](https://user-images.githubusercontent.com/65879950/154803083-c81c41ea-9876-418f-8505-dc03f1624b2e.png)


이 중에서 `UI Testing Bundle` 을 찾아서 생성해줍니다.

![image](https://user-images.githubusercontent.com/65879950/154803085-9b3bee65-fd44-47cb-8a62-00ebab9e4f0e.png)


에디터 영역을 보면 맨 위에 다음과 같은 프레임워크를 `import` 하고 있습니다.

```swift
import XCTest
```

 이 프레임워크는 Apple이 제공하는 테스팅 프레임워크 입니다. 이 프레임워크를 통해서 테스트를 진행할 예정입니다.



이렇게 하고 메소드들을 보면 다양한 것들이 있죠?

- setUpWithError() : 현재 클레스 내에서 테스트 메소드를 호출하기 전에 이 메소드를 호출합니다. 그리고 난 다음에  아래있는 메소드 "tearDownWithError" 를 호출합니다. 이 메소드를 통해서 모든 테스트가 동일한 조건에서 실행되도록 합니다.
- tearDownWithError() : 이 메소드는 테스트 메소드를 모두 종료한 다음에 호출합니다. 이 메소드는 각각의 테스트가 종료되고 난 다음에 뒷정리를 하는 메소드 입니다. 뒷정리는 다음 테스트를 다른 조건에서 시작해야겠죠. 그래서 이전에 테스트를 모두 제거해야합니다.
- testExample() : 테스트 작성에 대한 예제입니다.
- testLaunchPerformance() : 앱 실행 퍼포먼스에 대한 테스팅 메소드입니다.



-> 간단하게 생각해보면 setupWithError -> Test진행 -> tearDownWithError -> Test 2 진행 -> .. 이런식으로 진행됩니다.



그 중에서 `testExample` 메소드를 보면 다음과 같을 겁니다.

```swift
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()        
    }
```

- 코드만 봐도 느낌이 오긴 하겠지만, 앱을 실행하는 코드입니다.



이 곳에 코드를 조금 작성해볼게요.

```swift
let someButton = app.buttons["someButton"]
someButton.tap()
```

- app(type = XCUIApplication) 에는 UI Object들을 가지고 있습니다. 
- 그 중에서 `.buttons` 라고 메소드를 호출했으므로, 그것들 중에서 button 속성만 필터링합니다.
- 그리고 해당 button의 Label 중에서 "someButton" 만 필터링합니다.
- 그리고 마지막에는 tap을 합니다.

이렇게 하고 테스트를하면, 아주 높은 확률로 테스트가 성공합니다. 왜냐하면 테스트가 실패하는 케이스가 애초에 정의되어 있지 않으니까요. 다른 예시를 보겠습니다.



테스트를 원하는 Text 객체에 아래 코드를 추가합니다.

```swift
.accessibilityIdentifier("display")
```

- 이 modifier를 추가해줌으로서, 테스트 코드 작성시 app에서 찾을 수 있게됩니다.



그리고 메소드를 하나 더 만드시거나 혹은 있던 메소드를 변경하셔서 아래 코드로 변경해줍니다.

```swift
let display = app.staticTexts["display"]
let displayText = display.label
XCTAssert(displayText == "0")
```

- 대부분의 UI Element는 `XCUIElemnt` 입니다. 그 중에서 우리는 Label 프로퍼티를 원해서 `staicTexts`메소드를 통해 접근하고 있구요.
- `XCTAssert` 을 통해서 Label을 검증합니다. 



지금과 같은 방식으로 버튼이나 레이블의 상태를 점검할 수 있습니다.



## 정리

 저도 처음 해보는 테스팅이다보니, 글의 수준이 많이 부족하네요. 지속적으로 글을 작성해보도록 하겠습니다.^^..





읽어주셔서 감사합니다.





