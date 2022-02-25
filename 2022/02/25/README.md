# Today, I learned: SwiftUI Animation Basic

 오늘은 SwiftUI 의 Animation에 대해서 작성해보겠습니다.



## Animation?

 animation 이라는 단어는 "생명을 불어넣는 것" 이라는 뜻을 가지고 있습니다. 우리가 UI를 배치만 하면, 스티커처럼 붙어서 아무런 동작도 하지 않습니다. 클릭 했을 때, 단지 로직이 실행될 뿐이죠. 이러한 UI에 생명을 불어 넣는 기능이 "Animation" 입니다.



 애니메이션은 3 가지 파트로 구성됩니다.

1. 시작 : 뷰의 최초의 상태입니다.
2. 상태변화 : 뷰가 최초상태에서 멈추는 단계까지의 진행과정 상태입니다.
3. 도착 : 뷰가 도달하려는 목표지점이고, 도착하면 멈추는 상태입니다.

 

 모든 애니메이션은 위 3 가지를 구성하는 것에 지나지 않습니다. 

![image](https://user-images.githubusercontent.com/65879950/155703432-e093502a-4d07-4bc7-b2c7-e15350ffdc43.png)




 애니메이션에 어떤 요소들이 있어야 할까요? 아마 "트리거" 가 있어야 할 겁니다. 언제부터 시작해야하는 지 알아야 하니까요. 간단한 프로젝트를 통해서 설명하겠습니다.



## 구현 1

간단하게 UI를 구현하겠습니다.

```swift
struct ContentView: View {
    
    @State private var bounce = true
    
    var body: some View {
        VStack {
            Text("SwiftUI Animation")
                .font(.largeTitle)
                .bold()
            
            Button(action: {
                bounce.toggle()
            }) {
                Text("농구공 드리블 시작")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 1)
                    )
            }

            Circle()
                .fill(Color.orange)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 0, y: bounce ? 0 : 300)
            
        }
    }
}
```

![image](https://user-images.githubusercontent.com/65879950/155703479-470fba3f-25fc-407b-8648-83287fa47921.png)


"농구공 드리블 시작" 버튼을 클릭하면 오랜지 색 원이 아래로 가고, 다시 누르면 위로 올라옵니다. 하지만 갑자기 순간이동해서 아래에 생기고 순간이동해서 위로 나타나는 상태입니다. 아래처럼요.


![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-25 at 19 40 40](https://user-images.githubusercontent.com/65879950/155703549-01b76661-a172-48ae-8cc5-6fa270ed3cd1.gif)


이곳에 생명을 불어넣어보겠습니다.

Button의 action에 하나의 코드만 추가해주면됩니다.

```swift
withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                    bounce.toggle()
                }
```



그러면 다음과 같이 동작합니다.


![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-25 at 19 42 27](https://user-images.githubusercontent.com/65879950/155703591-732b9d17-6c86-4be6-8047-e0c129e7ba31.gif)


그런데 농구공은 제가 드리블한다는건, 올라오는걸 제어하진 않죠. 우리가 공을 떨어뜨리면, 해당 위치에너지가 바닥에 닿으면서, 반력으로 다시 튀어 오르게 되죠. 그러면 내려가자마자 다시 올라가는 로직을 추가해주면 됩니다.



버튼의 액션 파라미터 부분을 수정하겠습니다.

```swift
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                    bounce.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        bounce.toggle()
                    }
                }
```

- 애니메이션을 실행하고, 0.25초 뒤에 다시 애니메이션을 실행해서 원위치 시킵니다. 코드는 아주 단순하죠?
- `.spring` 의 부분은 애니메이션의 효과중 하나인 spring입니다. 



![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-25 at 19 44 22](https://user-images.githubusercontent.com/65879950/155703616-f64983fa-12dc-4372-8be9-215311b2f6d1.gif)


## 구현 2

 지금은 우리가 값을 변경하는 부분에서 애니메이션 효과를 부여했습니다. 이제는 Circle에 애니메이션이 동작하도록 해보겠습니다.

버튼을 다음과 같이 수정합니다.

```swift
            Button(action: {
                    bounce.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    bounce.toggle()
                }
                
            }
```



Circle 부분에 이전에 없던 `.animation` 수식어를 추가해줍니다.

```swift
            Circle()
                .fill(Color.orange)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 0, y: bounce ? 0 : 300)
                .animation(.spring(), value: bounce) // <---
```



결과는 다음과 같습니다.


![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-25 at 19 47 24](https://user-images.githubusercontent.com/65879950/155703646-e7f00e37-f6b4-4d4c-87d1-b53169b9404c.gif)



## 정리

애니메이션을 구현하기 위해서 2 가지 방법에 대해서 알아봤습니다.

1. `.withAnimation` 을 이용하여, 값이 변경되는 시점에 애니메이션을 부여한다.
2. `.animation` 을 이용하여, 애니메이션이 적용될 View에 애니메이션을 부여한다.

애니메이션의 효과를 부여할 기준이 데이터라면 첫 번째를 이용하면 되고, 뷰가 기준이라면 두 번째를 활용하면 되겠습니다.



참고로, 뷰에 특정 부분은 애니메이션을 적용하기 싫을 수도 있겠죠.

```swift
.animation(nil, value: bounce)
```

 코드를 해당 뷰에 추가해주면 됩니다. 그 이후에 있는 애니메이션들은 모두 동작하지 않습니다.





읽어주셔서 감사합니다.

