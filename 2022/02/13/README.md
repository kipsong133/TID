# Today, I leanred: SwiftUI ObservableObject

 오늘은 SwiftUI 에서 ViewModel을 구성할 때, 자주 사용되는 "ObservableObject" 를 예제를 통해서 알아보겠습니다.



## 1. 문제상황

 먼저 아래와 같은 앱이 있다고 하겠습니다.

<img width="467" alt="image" src="https://user-images.githubusercontent.com/65879950/153749942-3609733f-3687-497e-aa6f-4d20b0398991.png">


 특별한 기능은 없고, 성과 이름을 입력받으면 입력된 정보 하단에 값이 표시됩니다.

 코드를 보겠습니다.

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var lastname = ""
    @State private var firstname = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.77)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                titleText
                
                sentenceText
                
                GroupBox {
                    TextField("성", text: $lastname)
                    TextField("이름", text: $firstname)
                } label: {
                    Text("성과 이름을 입력해주세요.")
                        .foregroundColor(.brown)
                }
                .textFieldStyle(.roundedBorder)
                
                Text("입력된 정보:")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding()
                
                Text("\(lastname) \(firstname)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                
                Spacer()
            }
            .foregroundColor(.white)
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    
    var titleText: some View {
        Text("ObservableObject \nExamle")
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .padding(.top,50)
    }
    
    var sentenceText: some View {
        HStack {
            Spacer()
            VStack {
                Text("문제상황")
                    .font(.system(size: 23, weight: .bold, design: .monospaced))
                Text("1. 데이터가 변경되자마자 UI를 다시 그리고 싶다.\n2. 데이터는 외부 객체로 존재했으면 좋겠다.")
                    .multilineTextAlignment(.leading)
            }
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .padding()
            
            Spacer()
        }.background(Color.green)
    }
}

```

- 정상적으로 동작하는 코드입니다. 하지만 이전에 알아봤던 예제들과 다를 바 없이 @State 프로퍼티래퍼를 통해서 UI update를 하고 있습니다.
- 이번에는 뷰 안에 프로퍼티가 있는 것이 아니라 외부에 두고 싶을 때, 어떻게 구현하는지 입니다.



## 2. 문제 해결과정

#### 객체를 외부로 추출

 외부에 데이터를 관리하는 객체를 생성하겠습니다.

```swift
class Username {
    var lastname = ""
    var firstname = ""
}
```



 그리고 내부에 있던 @state 프로퍼티를 'Username' 으로 변경하겠습니다.

```swift
@State var username = Username()

...

GroupBox {
	TextField("성", text: $username.lastname)
	TextField("이름", text: $username.firstname)
}

...

Text("\(username.lastname) \(username.firstname)")
```

- lastname 과 firstname을 username 안에 선언하고, 선언한 username을 @State로 감싸고 있습니다.
- 뭔가 @State도 잘 줬고, 각각의 객체도 잘 연결했으니 이상없이 동작할 것만 같습니다.



그래서 실행시켜보면 다음과 같이 실망스러운 결과가 나타납니다.

![22_02_13_1](https://user-images.githubusercontent.com/65879950/153749948-875e5eb8-df70-4ddb-952c-9c65317a28f5.gif)


 성과 이름이 입력되었는데, 하단에 아무런 Text가 변화가 없죠. 이번에는 @ObservableObject를 데이터모델에 채택하고, 이전에 선언했떤 view 내부의 객체에는 @StateObject라는 것을 추가해보겠습니다.



#### 객체의 프로퍼티 수정

```swift
class Username: ObservableObject {
    var lastname = ""
    var firstname = ""
}
```

```swift
@StateObject var username = Username()
```

- 이제 뭔가 될 것만 같습니다. 실행시켜보겠습니다.



여전히 원하는대로 업데이트되지 않습니다.

![22_02_13_2](https://user-images.githubusercontent.com/65879950/153749955-6a31616a-240c-4451-8156-4fb688fe0c75.gif)



게다가 다음과 같은 버그도 나타납니다.

```markdown
Binding<String> action tried to update multiple times per frame.
```

- 프레임당 너무많은 UI 업데이트가 발생하는데 그것은 Binding<String> 때문이라고 말하고 있네요. 뭐가 문제일까요?
- 데이터 변화에 대해서 너무 많은 업데이트가 발생하므로 뭔가 제한해줘야하는 것 같습니다.



#### @Published

그래서 @Published 라는 프로퍼티 래퍼를 추가해보겠습니다.

```swift
class Username: ObservableObject {
    @Published var lastname = ""
    @Published var firstname = ""
}
```

![22_02_13_3](https://user-images.githubusercontent.com/65879950/153749961-64a47f08-7b33-4e9b-b6de-385cba0556ec.gif)


위 상황을 정리해보겠습니다.

 @StateObject인 "Username" 이라는 클래스에는 두 가지 객체가 있습니다.

1. `@Published var lastname`
2. `@Published var firstname`

이 두 객체는 View에 있는 TextField 가 Model을 업데이트 해주고 있는 것이죠. (Model == Username 클래스) 그리고 업데이트 된 모델은 다시 이 사실을 View에게 알려줘서 다시 UI를 그립니다.



## 3. 개념

#### @Published

 @Published는 프로퍼티의 값이 변경되면, 이것들을 사용하는 객체들에게 업데이트하라고 알려주는 프로퍼티 래퍼입니다. 마치 @State와 같죠. 하지만 외부객체일 때, 사용된다는 점이 다릅니다. @Published 개념은 `Combine`에 있는 개념입니다. 

 @Published라고 래퍼를 프로퍼티에 붙이는 순간, 데이터가 업데이트 되는 동안에는 계속 UI를 업데이트하도록 알려줍니다. 그리고 언제 이것을 그만할지나 메모리에서 해제할지와 같은 것을든 SwiftUI가 알아서 처리해줍니다.

 아까 버그중에서 @Published를 안했을 때, 경고창이 나타났었죠. ObservableObject를 채택해서 해당 데이터를 관찰하고 있는데, 어떤 데이트를 통해서 업데이트해야할지 모르는 상황이여서 발생한 겁니다. 위 예시는 코드가 별로 없어서 큰 문제로 이어지진 않겠지만, 업데이트하게될 프로퍼티와 안할 프로퍼티를 구분하지 않게되면, 너무나도 많은 데이터를 관찰해야겠죠. 즉, 데이터 모델중에서 UI업데이트가 되는 Output이 무엇인지 명시해주는 개념이라고 생각하면 되겠네요.
(마치 RxSwift에서 옵저버블을 많이 만들고 하지만, UI업데이트를 위한 옵저버블은 Driver를 선언하는 것처럼요.)



## 4. 정리

- 원하는 데이터 외부객체에 `ObservableObject` 프로토콜을 채택한다.
- 해당 외부객체에서 UI를 업데이트할 데이터를 `@Published` 로 명시해준다.
- 마지막으로 View에서 데이터 외부객체의 생성하고 `@StateObject`라고 명시한다.



읽어주셔서 감사합니다.

