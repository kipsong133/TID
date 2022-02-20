# Today, I learned: SwiftUI LayoutPriority

 오늘은 "LayoutPriority"에 대해서 작성해볼까합니다.



## LayoutPriority

 레이아웃을 구성할 때, Spacing이나 frame 수식어를 이용해서 layout을 잡아서 많은 UI 문제를 해결하곤 했습니다. 그러다가 "LayoutPriority" 를 알게되었습니다. 

 LayoutPriority 는 단어 뜻처럼, 레이아웃에 우선순위를 부여합니다. 숫자가 높을수록 우선순위가 높구요. 낮을수록 낮습니다. 우선순위가 높은 레이아웃이 가장먼저 공간을 차지하고, 그 다음 우선순위가 공간을 차지합니다. 이런식으로 높은순서에서 낮은순서로 레이아웃을 차지합니다.

아래와 같은 간단한 UI가 있다고 가정하겠습니다.

<img width="717" alt="image" src="https://user-images.githubusercontent.com/65879950/154828567-bd1d8b32-b181-46be-affd-034eade02cc4.png">


```swift
struct LayoutPriorityView: View {
    var body: some View {
        HStack {
            Text("안녕하세요. 저는 매일매일 공부하는 iOS 개발자 우노입니다.")
                .foregroundColor(.white)
                .background(Color.black)
            
            Text("제 강아지는 슈나우저이구요. 이름은 모야 입니다.")
                .foregroundColor(.blue)
                .background(Color.green)
            
            Text("SwiftUI는 정말 재미있는 UI 프레임워크입니다. 해도해도 공부할게 넘쳐요.")
                .foregroundColor(.purple)
                .background(Color.yellow)
        }
        .background(Color.gray)
    }
}
```

- 3 개의 Text 가 동일한 공간을 차지하고 있는 상태입니다.
- 이곳에 LayoutPriority 를 부여해보겠습니다.

<img width="477" alt="image" src="https://user-images.githubusercontent.com/65879950/154828573-527b2f7d-f6a9-4a12-8512-f05962188aa2.png">




```swift
        HStack {
            Text("안녕하세요. 저는 매일매일 공부하는 iOS 개발자 우노입니다.")
                .layoutPriority(-1) // <---
                .foregroundColor(.white)
                .background(Color.black)
            
            Text("제 강아지는 슈나우저이구요. 이름은 모야 입니다.")
                .layoutPriority(1) // <---
                .foregroundColor(.blue)
                .background(Color.green)
            
            Text("SwiftUI는 정말 재미있는 UI 프레임워크입니다. 해도해도 공부할게 넘쳐요.")
                .foregroundColor(.purple)
                .background(Color.yellow)
        }
        .background(Color.gray)
```

- 우선순위가 1 인 중간 Text가 가장먼저 공간을 차지하고 그 다음으로 우선순위가 없는 세 번째 Text가 공간을 차지합니다.
- 그러고 공간이 없어서 첫 번째 Text는 보이지 않습니다.



여기서 첫 번째 Text를 보여주고 싶다면, frame에서 minWidth 파라미터에 값을 넘겨주면 될 것 같습니다.

<img width="480" alt="image" src="https://user-images.githubusercontent.com/65879950/154828577-d3324cec-3856-4549-8ac3-4defc672ec8f.png">


```swift
           Text("안녕하세요. 저는 매일매일 공부하는 iOS 개발자 우노입니다.")
                .layoutPriority(-1)
                .frame(minWidth:1) // <---
                .foregroundColor(.white)
                .background(Color.black)
```

- `minWidth` 파라미터에 값을 전달해줘서, 아무리 작아지더라도, 최소 값은 확보할 수 있습니다. 



## 정리

- layoutPriority 를 이용하여, UI 공간확보 시, 어떤 UI를 우선적으로 레이아웃을 구성해야하는지 명시할 수 있다.
- 만약 특정 레이아웃이 없어지거나, 작아진다면, minWidth(or minHeight) 를 이용하자.



읽어주셔서 감사합니다.
