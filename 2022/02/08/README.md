# Today, I learned: SwiftUI에서 프로퍼티

 SwiftUI에서는 프로퍼티를 있는 그대로 사용하지 않습니다. 한 번 감싸줍니다. 바로.. `Property Wrapper` 라는 이름으로 감싸줍니다. 말그대로 랩핑합니다.(No 알 에이 피)

먼저 아래 코드를 볼까요?

```swift
struct BeatifulView: View {
  
  var name: String = "Uno"
  
  var body: some View {
    
    VStack {
      Text(name)
      
      Button(action: {
        self.name = "Moya"
      }) {
        Text("Name changed")
      }
    }
  }
}
```

- 위 코드에서 버튼을 누른다고 해서 UI가 변경될까요?
- 변하지 않습니다. 

```swift
var a = 1
var b = 2
a + b // 3
a = 100
```

- 위 코드처럼 나중에 값을 변경한다고 해서 그 위에 덧셈결과가 변경되진 않죠.
- 다시 a+b를 실행시켜야 변경됩니다.
- 그래서 애플은 이것이 상당히 불편했나봅니다.
- 그래서 나온 것이 `@State` 프로퍼티래퍼입니다.



## @State

```swift
struct BeatifulView: View {
  
  @State var name: String = "Uno"
  
  var body: some View {
    
    VStack {
      Text(name)
      
      Button(action: {
        self.name = "Moya"
      }) {
        Text("Name changed")
      }
    }
  }
}
```

- name 변수 옆에 `@State` 만 붙여준 코드입니다.
- 이제 버튼을 누르게 되면, UI가 자동으로 업데이트 됩니다.



 @State 자체를 처음 봤다면, @objc와 같은 뭐 그런건가? 라는 생각을 하실 수도 있겠습니다. 그냥 단순하게 프로퍼티 계의 'Extension' 이다. 라고 생각하시면 될 것 같습니다. 애플이 제공해주는 것분에 우리는 didSet이나 willSet처럼 줄줄이 코드를 작성할 필요가 줄어들었죠.

 정리해보면, @State를 사용하는 목적은 다음과 같습니다.

> 해당 변수가 변경됨에 따라서 UI를 다시 그려주고 싶을 때

"이 변수를 사용하고 있다면, 해당 로직과 코드는 이 변수가 변경 될때마다 실행된다!"

라고 요약할 수 있겠네요.



@State의 동작 순서를 작성해보면, 다음과 같습니다.

1. @State 변수에 값이 변경시키려는 이벤트를 받았다.
2. 변수를 업데이트 한다.
3. 현재 스크린은 예전 화면으로 판정되고, 새롭게 그린다.
4. 새롭게 그릴 때, 업데이트된 변수로 그린다.



여기서 질문이 생기실텐데요.

> @State가 선언된 View가 아니지만, 해당 데이터와 바인딩될 수도 있을텐데, subView에서는 이걸 어떻게 연결하지? 

@State -> 서브뷰 -> 특정데이터와 연결 -> 특정데이터가 변경 -> 수퍼뷰 > @State

이런식으로 양방향으로도 연결되어 있으면 좋을텐데말이죠. 사실 위에서 내려주기만 한다면, @State가 없더라도 어렵지 않게 구현이 가능하긴 하니까요.

그래서 애플이 만들었습니다.

## @Binding

```swift
struct BeatifulView: View {
  
  @State var name: String = "Uno"
  
  var body: some View {
    
    VStack {
      Text(name)
      
			TextField("이름을 입력하세요", text: $name)
    }
  }
}
```

- 위 코드에서 `Button` 대신에 `TextField`로 변경했습니다.
- TextField는 지금 "BeatifulView"의 서브뷰 이죠. 서브뷰에서 데이터 변경을 상위뷰 프로퍼티와 연결했죠.
- 이것을 "Binding 했다" 라고 합니다. 실제로 서브뷰에서는 @Binding 이라고 프로퍼티래퍼를 붙여줘야합니다.



@State와 @Binding으로 인해서 우리는 코드를 작성할 때, 생각하는 관점이 달라지게 될겁니다.

- 데이터를 중심으로 어떤 UI와 연결할지를 고민합니다.
- UI컨트롤을 구체적으로 어떻게 해야하는지(데이터가 변경될 때) 고민할 필요가 없습니다.



간단한 On/Off Switch 를 만들어보겠습니다.

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var isOn = true // <---
    
    var body: some View {
        Button(action: {
            isOn.toggle() // <---
        }) {
            ZStack(alignment: isOn ? .trailing : .leading) { // <--
                HStack {
                    Spacer()
                    Text("On").opacity(isOn ? 1 : 0) // <--
                    Spacer()
                    Text("Off").opacity(isOn ? 0 : 1) // <--
                    Spacer()
                }
                .frame(width:90, height: 50)
                .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .frame(width:45, height: 50)
                    
            }
        }.padding(8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isOn ? Color.green : Color.red)
            }
            .animation(.default, value: isOn) // <--
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

- `<--`이렇게 표시한 코드를 보면, isOn이라는 프로퍼티 래퍼로 감싸진 데이터를 활용하거나 값을 변경하는 코드들 입니다.
- 이 부분이 다시 그려질 때, 업데이트 됩니다.
- 그래서 동작화면을 보면 다음과 같습니다.



(방정맞음 주의)

![Simulator Screen Recording - iPhone 13 Pro - 2022-02-06 at 22 49 13](https://user-images.githubusercontent.com/65879950/152994653-96544bf2-d8cc-4642-83a8-2f2c188bfec1.gif)




끝까지 읽어주셔서 감사합니다.

