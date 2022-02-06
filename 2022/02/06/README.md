# Today, I learned: SwiftUI에서 BottomSheet 만들기

이번에는 SwiftUI를 통해서 "BottomSheet" UI를 만들어보겠습니다.

<완성화면>
![Simulator Screen Recording - iPhone 13 Pro - 2022-02-06 at 14 59 24](https://user-images.githubusercontent.com/65879950/152669594-0909d361-55f0-470e-b70a-8c2a90b7b258.gif)

## 구현

 BottomSheet를 구현하기 위해서 먼저 구상해야할 것들이 있습니다.

- 어떤 상호작용을 입력받았을 때, 나타날 것인가.
- 입력을 받았을 때, 어떻게 나오게 할 것인가.
- 크기는 얼만큼으로 결정할 것인가.



먼저, 입력을 받았다는 것을 알기 위해서 Boolean 값을 사용할 예정입니다. 그리고 입력을 받았으면 UI를 다시 그려야겠죠. SwiftUI 에서는 이를 @State 를 통해서 구현가능합니다.



```swift
struct ContentView: View {
  @State private var isShowing = false
}
```

- 초기값은 false 입니다. 왜냐하면, 화면이 나타나자마자 BottomSheet가 나타나는 것이 아니라, 입력을 받은 후에 나타나게 하려고 합니다.



 화면의 Height가 크다면, BottomSheet가 너무많이 올라올 수 있겠죠. 그래서 특정 높이이상 화면이 커졌을 경우엔 BottomSheet를 줄이기 위해서 나누기 인자를 다르게 설정해줄 예정입니다. 



```swift
struct ContentView: View {
    @State private var isShowing = false
    
    
    var heightFactor: CGFloat {
        UIScreen.main.bounds.height > 800 ? 3.6 : 3
    }
    
    var offset: CGFloat {
        isShowing ? 0 : UIScreen.main.bounds.height / heightFactor
    }
    
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}
```

- `heightFactor` 를 통해서 넓은 화면 일 경우에는, 3.6으로 화면의 높이를 나눠서 조금 더 작게 표현할 예정입니다. 그 이하인 경우에는 3 으로 나눕니다.
- `offset`을 통해서 우리가 보는 화면보다, 아래에 BottomSheet가 위치해있다가, 위로 올라오도록 할 예정입니다.



그리고 간단한 버튼을 하나 만들겠습니다.

```swift
var body: some View {
        
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                
            }) {
                HStack {

                    Text("BottomSheet 호출")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .padding(20)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 1)
                )
                
            }
        }
    }
```

<img width="564" alt="image" src="https://user-images.githubusercontent.com/65879950/152669602-e998e0c4-ca21-48e1-b386-fac6300bc10c.png">




 이제 버튼 부분에서 State 변수의 값을 변경시켜주는 로직을 추가합니다.

```swift
Button(action: {
                self.isShowing.toggle() // <------
            }) {
                HStack {

                    Text("BottomSheet 호출")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .padding(20)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 1)
                )
                
            }
```

- `self.isShowing.toggle()` 라는 코드를 추가했습니다.
- 이곳에서 state 변수의 값을 변경시켜줘서 UI를 다시그리도록 합니다.



이제 BottomSheet을 구성하겠습니다.

```swift
struct ContentView: View {
    @State private var isShowing = false

    var heightFactor: CGFloat {
        UIScreen.main.bounds.height > 800 ? 3.6 : 3
    }
    
    var offset: CGFloat {
        isShowing ? 0 : UIScreen.main.bounds.height / heightFactor
    }
    
    
    var body: some View {
        
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                self.isShowing.toggle()
            }) {
             ...
            }
            
            // BottomSheet
            GeometryReader { proxy in
                VStack {
                    Spacer()
                    Color.blue
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height / heightFactor,
                            alignment: .center
                        )
                        .offset(y: offset)
                        .animation(.easeInOut(duration: 0.49), value: self.isShowing)
                        
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}
```

- ZStack 바로 아래에 `GeometryReader` 를 사용해서 BottomSheet가 나타날 공간을 잡아줍니다.
- 그리고 GeometryReader 클로저 바로 뒤에 `edgesIgnoringSafeArea` 중 bottom으로 설정하여, 화면 바로 아래까지 위치하도록 합니다.
- 그러면 현재, BottomSheet는 있지만, 화면상에만 보이지 않은 상태입니다. 이상태서 버튼을 눌러보면 동작합니다.

![Simulator Screen Recording - iPhone 13 Pro - 2022-02-06 at 14 59 24](https://user-images.githubusercontent.com/65879950/152669605-baaf15ef-ac21-4697-911c-2b03f5be5dbc.gif)




## 마무리

 SwiftUI를 통해 BottomSheet를 구현하니, UIKit에 비해서 상대적으로 편한 것 같습니다. `Color.blue` 부분 대신에, View를 넣으시면, 해당 뷰가 파랑색 영역으로 들어가게 됩니다. 



읽어주셔서 감사합니다.



