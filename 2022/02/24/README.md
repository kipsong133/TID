# Today, I learned: SwiftUI 아름다운 Button 만들기 예제

 오늘은 SwiftUI에서 뒤에가 빛나는 듯한 UI를 구성해볼까 합니다.

<결과물>

<img width="260" alt="image" src="https://user-images.githubusercontent.com/65879950/155453109-f6ae3181-76ea-4bfe-b853-4377106ec2d7.png">


## 구현

- 제일 먼저 GeometryReader를 이용하여, 뷰에 대한 크기에 접근할 수 있도록 합니다.

```swift
import SwiftUI

struct CustomButton: View {
    var body: some View {
        Button(action: {}) {
            GeometryReader { geo in // <--
                
            }
        }
    }
}
```



- 그리고 배경을 블러처리할 것이고 그 위에 텍스트나 경계선을 추가할 것이므로 ZStack도 추가해줍니다.

```swift
GeometryReader { geo in
	ZStack {
                    
	}
}
```



- GeometryReader를 사용할 때는, 크기에 대한 정보가 전달되어야 버그가 발생하지 않으니 크기에 대한 정보도 바로 주겠습니다.

```swift
Button(action: {}) {
  ...
}
.frame(height: 50)
```



- AngularGradient를 추가하면서 동시에 [Color] 값들도 지역변수로 추가합니다.

```swift
    var gradient1: [Color] = [
        Color(red: 101/255, green: 134/255, blue: 1),
        Color(red: 1, green: 64/255, blue: 80/255),
        Color(red: 109/255, green: 1, blue: 185/255),
        Color(red: 39.255, green: 232/255, blue: 1)
    ]

		var body: some View {
      Button(action: { }) {
      	GeometryReader() { geo in 
					ZStack {
           AngularGradeint(
           	 gradient: gradient1,
           	 center: .center,
             angle: .degrees(0)
           ) 
          }              
				}  
      }
      
    }
```



#### AngularGradient

공식문서상에는 정말 짧께 설명하고 있습니다.

<img width="553" alt="image" src="https://user-images.githubusercontent.com/65879950/155453164-acd4160c-2c0b-45cc-a195-67eb5434314b.png">


네, 맞아요. 각도가 있는 그라데이션 객체입니다. 공식문서를 보시면서 이해하시는 것보다는, 색깔과 각도를 조절하시면서 이해하는게 더 빠를 것 같으니, 한 번 직접 만들어보고 파라미터의 값을 조정해보시는걸 추천합니다.



- 이제 아름답게 그려보는 코드를 추가하겠습니다.

```swift
AngularGradient(
	colors: gradient1,
	center: .center,
	angle: .degrees(8.0))
	.blendMode(.overlay)
	.blur(radius: 8.0)
	.mask(
		RoundedRectangle(cornerRadius: 16.0)
			.frame(height: 50)
			.frame(maxWidth: geo.size.width - 16)
			.blur(radius: 8.0)
	)
```



수식어에 대해서 하나씩 알아보겠습니다.

#### blendMode

<img width="1118" alt="image" src="https://user-images.githubusercontent.com/65879950/155453176-c57a5e12-2d7f-4a26-b200-1a8b455d6371.png">


 뷰를 겹쳐지는 뷰와 합성하기 위한 혼합 모드를 설정할때, 사용하라. 뭐 이런 뜻입니다.

의역을 보면, 뷰가 2개 이상인데 그 두 개를 혼합할 때, 설정해주면, 우리가 원하는 방식으로 섞어주는 듯 합니다.

공식예제를 보면 좀더 와닿겠네요.



- blendMode 적용 전,

```swift
struct Example: View {
    var body: some View {
        HStack {
            Color.yellow.frame(width: 50, height: 50, alignment: .center)

            Color.red.frame(width: 50, height: 50, alignment: .center)
                .rotationEffect(.degrees(45))
                .padding(-20)
//                .blendMode(.colorBurn)
        }
    }
}

```

<img width="399" alt="image" src="https://user-images.githubusercontent.com/65879950/155453199-d1b32c18-2ce6-4478-a63b-1ed24ae87b86.png">




- BlendMode 적용 후,

```swift
            Color.red.frame(width: 50, height: 50, alignment: .center)
                .rotationEffect(.degrees(45))
                .padding(-20)
                .blendMode(.colorBurn) // <--
```

<img width="433" alt="image" src="https://user-images.githubusercontent.com/65879950/155453228-3f5a72e3-b660-4f37-ad89-dc1a042446e5.png">


- `colorBurn` 이라는 블랜드모드는 겹쳐지지 않은 곳은 제거하는 특성이라고 합니다.



 저희는 겹쳐지는 Overlay라는 특성을 사용했습니다. overlay는 레이어들 중에서 가장 위에있는 레이어가 밝은 부분은 밝아집니다. 그리고 가장 아래에 있는 레이어의 어두운 부분은 어두워집니다. 즉, 광원효과처럼 뭔가 빛나는 효과에 적절하겠죠. 



#### Blur

<img width="660" alt="image" src="https://user-images.githubusercontent.com/65879950/155453244-15e3e579-f234-479f-b801-acad60fd42b9.png">


 블러는 이름에서도 바로 느껴지듯, 흐릿하게 처리해주는 수식어입니다. 다만 가우시안 블러 라는게 좀 생소하시죠. 자세한 설명은 힘들지만, 가우스 함수로 만든 블러 연산을 한 블러처리입니다. 블러처리에 자주 사용되곤 합니다. CoreImage 단에서 CIFilter 필터에도 있는 필터 중 하나입니다.



블러 이후에 mask 수식어를 추가해줍니다.

```swift
.blur(radius: 8.0)
.mask(alignment: .center) { // <-- 여기서부터추가
	RoundedRectangle(cornerRadius: 16.0)
		.frame(height: 50)
		.frame(maxWidth: geo.size.width - 16)
		.blur(radius: 8.0)
}
```

- mask는 뜻 그대로 masking 처리리를 해주는 겁니다. 여기서는 직사각형의 태두리를 잡아주고, 그 태두리로 자른 이후에, 블러처리를 다시 한 번 해줍니다.



여기까지 하셨으면, 다음과 같은 이미지 결과가 됩니다.

<img width="258" alt="image" src="https://user-images.githubusercontent.com/65879950/155453264-c8230be2-b08e-49d8-ba51-8ae39aad4412.png">


현재 ZStack이니 이 배경위에 올리기만하면 끝입니다.



이것은 버튼의 뒷배경을 담당할 예정입니다. 이제 배경위에 텍스트를 올려야겠죠?

- 텍스트를 올려줍니다. 각각의 속성은 원하시는대로 하시면됩니다.

```swift
Text("회원가입")
	.font(.title2.bold())
	.foregroundColor(.white)
```



이후에 원하시는 효과들을 섞어보세요. 저는 아래와 같이 했습니다.

```swift
                    Text("회원가입")
                        .blur(radius: 0.5)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: geo.size.width - 16)
                        .frame(height: 50)
                        .background(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16.0)
                                .stroke(.white, lineWidth: 1.9)
                                .blendMode(.normal)
                                .opacity(0.7)
                        )
                        .cornerRadius(16.0)
```



그리고 배경을 검정색으로 하고 실행시키면 다음과 같은 결과가 나타납니다.

<img width="549" alt="image" src="https://user-images.githubusercontent.com/65879950/155453283-4abe58b8-0596-472a-8e90-dc65db61d793.png">


아름다운 버튼이 완성되었습니다.^^ (프로젝트는 해당 README가 있는 디렉토리에 함께 추가해두겠습니다.)



## 정리

- Geometry로 크기를 설정한다.
- Gradient / blendMode / blur / mask 를 통해서 배경을 설정한다.
- Text 에 background로 설정한 배경위에 덮을 배경을 설정하고, overlay를 통해서 코너의 UI를 설정한다.


읽어주셔서 감사합니다.


## 참고자료
- DesignCode, Advanced SwiftUI lesson 3 (https://designcode.io)
- https://developer.apple.com/documentation/swiftui/view/blur(radius:opaque:)
- https://developer.apple.com/documentation/swiftui/angulargradient
- https://developer.apple.com/documentation/swiftui/view/blendmode(_:)
- https://developer.apple.com/documentation/swiftui/view/mask(_:)
