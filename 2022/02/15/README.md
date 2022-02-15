# Today, I learned: SwiftUI @AppStorage

 오늘은 SwiftUI에서 UserDefault인 @AppeStorage에 대해서 알아보겠습니다.



## 1. 문제상황

 우리가 SwiftUI로 앱을 구성하다보면, 앱 프로젝트 전체범위에서 접근 가능한 데이터가 필요할 때가 있죠. 예를들면, 다음과 같은 것들 입니다.

```markdown
- 사용자가 앱을 처음으로 켰는지 여부 -> Onboarding 화면을 보여준다.
- 사용자가 서버에서 받은 JWT -> 네트워크통신을 할 때, 데이터를 헤더에 함께 전달해준다.
- 앱의 전체에 적용되는 TintColor -> 사용자가 선택한 색상으로 일괄적으로 UI색상을 변경한다.
```

 물론 다른 해결방법으로도 해결 가능합니다. 서브클래싱을 통해서 데이터를 전달할 수도 있고, 프로토콜에 extension + computed Property를 활용할 수도 있죠. 여러 가지 해결방법 중에서 이번에는 `@AppStorage`를 통해서 해결해보겠습니다.

(물론 JWT같은 데이터는 개인정보에 접근이 가능한 데이터이므로, 가능하면 저장하지 않는게 좋겠죠? 예시를 위한 예시입니다.)

## 2. 해결

 다음과 같은 뷰가 있다고 합시다.

![image](https://user-images.githubusercontent.com/65879950/154042872-8953683d-b06d-4d9d-b898-ec3ff2b76d41.png)


 AppStorage는 다음과 같이 초기화했습니다.

```swift
@AppStorage("username") var username = "Moya"

...
Text("사용자 이름:")
	.font(.system(size: 20, weight: .medium, design: .rounded))
Text("\(username)").bold()
```

- "username" 이 key이고 "Moya"가 초기값입니다.
- 아래에서 단순히 값을 접근해서 "사용자 이름:" 아래에서 값을 호출하고 있습니다.



그리고 상세화면입니다.

![image](https://user-images.githubusercontent.com/65879950/154042905-6b516aeb-23ff-4aee-98ca-8b815c1ddf1c.png)


```swift
@AppStorage("username") var username: String!
@State private var newUsername = ""
...

TextField("이름", text: $newUsername)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

...

Button("업데이트") {
	username = newUsername
}
```

- 서브뷰에서는 다음과 같이 값을 입력받습니다.
- 그리고 @Steta와 textFiend값을 Binding 했습니다.
- 마지막으로 업데이트 버튼을 누르면 해당 값을 AppStorage에 저장합니다.



그러면 다음과 같이 정상적으로 저장됩니다.

![Simulator Screen Recording - iPhone 13 Pro - 2022-02-15 at 19 17 39](https://user-images.githubusercontent.com/65879950/154042934-a6d63f4f-df6c-4f3a-9e4f-cfcc6728ab76.gif)




이렇게 AppStorage를 사용할 수 있습니다. 다만 이런 의문이 듭니다.

> AppStorage 변경을 버튼을 통해서 말고 Binding은 안되나??



가능합니다. 코드를 수정할게요.

```swift
//@AppStorage("username") var username: String!
@Binding var username: String
//@State private var newUsername = ""

...
//TextField("이름", text: $newname)
TextField("이름", text: $username)
```

- SubView에서 AppStorage로 접근했던 프로퍼티를 아래 바인딩으로 감싸줍니다.
- 기존에 연결했던 @State 변수를 주석처리하고, TextField에 Binding으로 감싸진 프로퍼티로 변경합니다.



```swift
NavigationLink("Edit", destination: AppStorage_Edit(username: $username))
```

- SuperView에서는 SubView로 넘어갈 때, Binding 변수를 init에 전달해주면 끝입니다.


![Simulator Screen Recording - iPhone 13 Pro - 2022-02-15 at 19 20 42](https://user-images.githubusercontent.com/65879950/154042985-79af2997-c75f-4122-aaa0-6901b8f626b2.gif)



이번에는 버튼을 없애도 이렇게 바로 업데이트 되고 있죠?





## 3. 개념

 AppStorage의 저장되는 위치를 설명하기 위해, App - Scenes - Views 의 관계도를 보겠습니다.

![image](https://user-images.githubusercontent.com/65879950/154043039-567b858d-4492-496f-946b-e671e6e53eec.png)


(한땀한땀만듦)

이 구조를 한 번 코드로 보겠습니다.

```swift
import SwiftUI

@main
struct AppStorage_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

```

- App 프로토콜을 채택하고 있는 구조체 바로 아래 body에 보면 Scene이라고 있죠. 그리고 Scene이 있습니다.
- Scene 안에는 WindowGroup이 있습니다. WindowGroup은 Scene의 한 종류입니다. 
- 그리고 그 안에 보면 View가 있죠. 



 AppStorage는 말그대로 App 위치에 저장되는 저장소입니다, UIKit에서 자주사용하던, UserDefault 의 SwiftUI 버전입니다. 그래서 이 위치에 데이터를 저장하면, 프로젝트 전역범위에서 접근 가능한 데이터를 보관할 수 있죠.



공식문서의 AppStore설명을 보면 다음과 같습니다.

![image](https://user-images.githubusercontent.com/65879950/154043090-cf9f0829-b19b-416a-931d-f856cc9c4e75.png)


- 프로퍼티 레퍼타입인데, "UserDefaults"로부터 데이터를 가져와서 반영하고, 뷰를 무효화하는데, UserDefault에 있는 데이터가 변경되는 도중에는 해당 뷰를 무효화 한다고 합니다.
- UserDefault의 값이 변경되면 해당 값으로 UI를 Refresh 한다고 합니다.



AppStorage의 개념은 저장소의 의미 외에는 딱히 없다고 생각됩니다.

저장소니까 두 가지로 나눠서 생각할 수 있겠네요

- Value
- Optional Value



## 4. 정리

- AppStorage는 UserDefault의 SwiftUI 버전이다.
- App의 전역범위에서 데이터를 공유 가능하다.
- Binding으로 서브뷰로 전달하여 데이터를 바로바로 업데이트 할 수 있다.





읽어주셔서 감사합니다.
