# Today, I learned: SwiftUI에서 Single Source of Truth

## Single Source of Truth

 WWDC 20에서 소개된 SwiftUI 자료 중, 다음과 같은 단어가 상당히 자주 보입니다.

![스크린샷 2022-02-09 12 22 28](https://user-images.githubusercontent.com/65879950/153115907-602a5d0a-a06d-408c-844d-4c8c12a72324.png)

(이 그림은 WWDC20, Introduction SwiftUI에서 나온 사진 일부입니다.)

- 데이터의 관계를 보면 `Source of Truch : Derived Value = @State : @Binding` 입니다.
- 원천데이터와 파생데이터라고 해석하면 적절할 것 같습니다.



 여기서 말하는 Source of Truth라는 단어 자체가 한글로 번역했을 때, 뭔가 직관적으로 느낌이 오지 않았습니다.~~저만그럴수도~~ 제가 이것을 받아들이기로는 "단 하나의 원천데이터" 입니다. 데이터 관점에서 생각해보겠습니다. 예를들어, 제가 데이터입니다. 데이터는 결국, 여러가지 가공을 거친 후에 UI에 전달해줘야겠죠. 그리고 변경이 생기면 UI에게 다시 말해줘야 합니다. 안그러면 사용자에게 정확하지 않은 데이터를 보여주니까요. 그런데 저 말고 해당 UI에 다른 데이터가 또 전달해준다고 칩시다. 그러면, 해당 UI가 정확한 데이터를 보여줄 수 있을까요? 누가 업데이트했는지 어떤데이터인지 모를 겁니다. 그래서 "Single" 단 하나여야 하고, "Source" 데이터는 "Truth" 그것을 보장해야합니다.

> Single Source of Truth == 단 하나의 데이터임을 보장해야한다.

 UI : 원천데이터 = 1 : N 은 될 수 없습니다. 다만 역은 성립합니다.

 UI : 원천데이터 = N : 1 은 가능합니다.

간단한 예시코드를 보면서 설명드릴게요.

전체코드입니다.

```swift
import SwiftUI

// 데이터 구조
struct UserName {
    var firstName = ""
    var lastName = ""
}

struct ContentView: View {
    // Source of Truth
    @State private var name = UserName()
    
    var body: some View {
        VStack {
            Text("너의 이름은?")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.bottom, 100)
                .padding(.top, 100)
            
            HStack {
                Text(name.lastName)
                Text(name.firstName)
            }
            .font(.system(.body))
            .frame(width: 400, height: 50)
            .background(Color.gray)
            .padding(.bottom, 100)
            
            HStack {
                Group {
                    // 첫 번째 텍스트필드와 연결
                    TextField("성을 입력해주세요.", text: $name.lastName)
                    
                    // 두 번째 텍스트필드와 연결
                    TextField("이름을 입력해주세요.", text: $name.firstName)
                }
                .border(.black, width: 1)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

```



실행한 모습입니다.

![Simulator Screen Recording - iPhone 13 Pro - 2022-02-07 at 10 47 06](https://user-images.githubusercontent.com/65879950/153116272-8fe8620e-14c6-4aeb-a758-6b07e64f1ee0.gif)




- 코드에 보면 `@State private var name = UserName()` 하나의 원천데이터가 구성되어있죠.
- 그리고 2 개의 UI가 있습니다.
  - `TextField("성을 입력해주세요.", text: $name.lastName)`
  - `TextField("이름을 입력해주세요.", text: $name.firstName)`
- 이런식으로 원천데이터는 다수의 UI와 연결이 가능합니다.



설명하다보니 @State에 대해서 설명하게되었는데, 정리하겠습니다.

## @State

@State를 통해서 원천데이터 생성이 가능하죠. 그러면 언제사용하면 좋을까요?

- 프로퍼티 -> UI 관계를 구성하고 싶을 때

- 데이터 업데이트에 따른 UI업데이트가 필요할 때,

- 양방향 바인딩을 통해 하위 뷰에서 데이터를 변경하면 상위 뷰도 변경되도록 하고 싶을 때

  (@State와 @Binding을 사용해서 가능)



@State는 다음 타입에 모두 사용가능합니다.

- String
- Int
- Bool
- Struct
- Array
- Tuple
- Dictionary



## 정리

- Single Source of Truth는 원천데이터가 하나임을 보장한다는 뜻이다.
- 그 덕분에 UI에 새로운 데이터를 연결할 때, 기존에 연결된 데이터만 확인하면된다. (UI 업데이트를 위한 추가 코드 필요 없음, 그저 연결하면 된다.)
- Binding을 활용하면 서브뷰에서 업데이트된 데이터를 원천데이터에 반영이 가능하다.





읽어주셔서 감사합니다.



