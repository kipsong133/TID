# Today, I learned: State-Binding + PopView 

이번에 만들어볼 프로젝트입니다.


![02_11_gif](https://user-images.githubusercontent.com/65879950/153592532-16177b56-1266-4c6e-a2e7-7cd5bb0ececd.gif)

 @State를 통해서 특정 Cell을 클릭하게되면, Re-Rendering을 수행하고, 이것에 맞게, 팝업창을 나타나게 할 예정입니다. 그리고, 팝업창에서 입력한 데이터가, 원천데이터인 @State를 변경할 수 있도록 @Binding 처리를 할 예정입니다. 

이 예시를 통해서 @State와 @Binding을 통해 화면을 나타나게 할 수도 있고, 또 새로나온 화면에서 이전 데이터를 변경하는 로직을 어떻게 해야하는지 알 수 있을 겁니다.

**(전체 코드는 제일 하단에 추가해두었으니, 코드를 보면서 읽으신다면, 해당 코드를 미리 보시면 되겠습니다.)**

## 구현

#### 1. Model 만들기

```swift
struct Food: Identifiable {
    let id = UUID()
    var name: String
    var price: String
}
```

- id를 부여하여, 데이터마다 식별자를 추가해줍니다. 클릭한 데이터가 어떤 것인지 알 수 있어야 팝업창에서 클릭한 데이터를 바인딩을 해줄 수 있겠죠.
- id는 UUID를 활용합니다.



#### 2. UI 

```swift
struct LazyVStack_Example: View {
    // State 프로퍼티를 선언한다.
    @State private var food = [
        Food(name: "대방어", price: "33000"),
        Food(name: "갈비찜", price: "50000"),
        Food(name: "신선로", price: "70000"),
        Food(name: "베이징덕", price: "100000")
    ]
    
    @State private var selectedMenuID: UUID?
    
    var body: some View {
            // PopupView를 나타내기 위한 ZStack
            // 추후에 조건문에 따라서 Z축 방향으로 View를 쌓아야한다.
            ZStack {
                ScrollView { // 1
                    LazyVStack {
                        
                        // Title and Subtitle Text
                        headerView // 2
                            .padding(.top, 25)
                        
                        // description Text
                        descView // 3
                            .padding(.top, 10)
                        
                        ForEach(food) { menu in // 4
                            HStack {
                                Text("\(menu.name) \(menu.price)원")
                                Spacer()
                                Image(systemName: "pencil.circle")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .onTapGesture {
                                // State 프로퍼티에 값을 할당하여 re-rendering한다.
                                selectedMenuID = menu.id
                            }
                        }
                    }
                }
                
                // re-rendering 시, 옵셔널해제를 하면서, Zstack에 해당 View를 추가한다.
                if let id = selectedMenuID {
                    EditMenuPopupView(
                        food: $food[$food.firstIndex(where: { person in
                        person.id == id
                    })!], id: $selectedMenuID)
                }
            }
    }
}

extension LazyVStack_Example {
    var headerView: some View {
        HStack {
            HeaderView(
                title: "우노의 심야식당",
                subTitle: "Binding with LazyVStack")
            Spacer()
        }
    }
    
    var descView: some View {
        HStack {
            Spacer()
            Text("@State - @Bidning을 통한\n 양방향 바인딩을 연습해봅시다.")
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .bold()
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color.yellow)
    }
}

```

- 1. 전체 스크롤이 가능하도록 ScrollView 내부에 UI를 추가합니다.

- 2,3 : 코드를 간소화 하기위해서 따로 Extension에 추가해두었습니다.
- 4. 이부분이 이번 구현에서 말씀드리고 싶은 부분입니다. 코드를 그부분만 가져오겠습니다.

```swift
ForEach(food) { menu in // 4
    HStack {
        Text("\(menu.name) \(menu.price)원")
        Spacer()
        Image(systemName: "pencil.circle")
            .foregroundColor(.blue)
    }
    .padding()
    .onTapGesture {
        // State 프로퍼티에 값을 할당하여 re-rendering한다.
        selectedMenuID = menu.id
    }
}
```

- ForEach 상위에는 LazyVStack이 있습니다. 
- food라는 값은 @State 프로퍼티입니다. ForEach할 때는, 바인딩하고 있지 않았죠. 왜냐하면, 보여주기만 할 예정이기때문입니다.
- Tap하게되면 `onTapGesture` 코드블럭이 동작하게 될텐데, 보시면 `selectedMenuID`로 값을 전달하고 있습니다.

바로 이부분이죠.

```swift
@State private var selectedMenuID: UUID?
```

- 이 부분도 @State로 감싸져 있기에, 다시 UI를 그릴겁니다.
- 이부분과 연결된 로직이 있다면, UI가 다시그려질텐데, ZStack 코드 마지막 바로 전에 보면 아래 코드가 있습니다.

```swift
// re-rendering 시, 옵셔널해제를 하면서, Zstack에 해당 View를 추가한다.
if let id = selectedMenuID {
    EditMenuPopupView(
        food: $food[$food.firstIndex(where: { person in
        person.id == id
    })!], id: $selectedMenuID)
}
```

- 이 코드에서 id값이 이미 있다면, `EditMenuPopupView`를 Z축으로 추가합니다. 그리고 이곳에서 값을 바인딩해줍니다.
- 바인딩되었기에, `EditMenuPopupView`에서 값이 변경되면, 원천데이터인 @State에 있는 값들도 다시 UI가 업데이트 될겁니다.

`EditMenuPopupView`코드입니다.

```swift
import SwiftUI

struct EditMenuPopupView: View {
    
    @Binding var food: Food
    @Binding var id: UUID!
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("메뉴를 수정하세요.")
                .font(.largeTitle)
            
            TextField("메뉴명", text: $food.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("가격", text: $food.price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("완료") {
                id = nil
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .shadow(radius: 8)
            
        }
        .padding(24)
    }
}
```



  이렇게 하면, 시뮬레이터처럼

 슈퍼뷰 ---(클릭한 셀의 버튼데이터 전달)---> 팝업뷰 ----(변경된 데이터 전달)---> 슈퍼뷰

의 관계가 형성됩니다.

 이제 양방향으로 데이터가 송수신하고 그것에 맞게 UI가 자동으로 업데이트 되고 있죠? 기존의 UIKit으로 Rx와 같은 개념 없이 구현하려고 하면, 생명주기를 활용해서 팝업창이 사라질때, Delegate나 Notification을 활용해서 데이터를 전달해야겠죠. 그리고 슈퍼뷰에서는 해당 값을 입력받고, 어떤 UI를 업데이트 해줄지 결정해야하구요. 이러한 과정을 @State와 @Binding으로 아주 손쉽게 처리할 수 있습니다.



## 정리

- @State와 @Binding을 통해서 슈퍼뷰와 서브뷰의 데이터를 수정하고 읽어올 수 있다.
- 추가로, UI업데이트는 알아서 된다.



## 전체코드

- LazyVStack_Example.swift

```swift
import SwiftUI

struct Food: Identifiable {
    let id = UUID()
    var name: String
    var price: String
}


struct LazyVStack_Example: View {
    // State 프로퍼티를 선언한다.
    @State private var food = [
        Food(name: "대방어", price: "33000"),
        Food(name: "갈비찜", price: "50000"),
        Food(name: "신선로", price: "70000"),
        Food(name: "베이징덕", price: "100000")
    ]
    
    @State private var selectedMenuID: UUID?
    
    var body: some View {
            // PopupView를 나타내기 위한 ZStack
            // 추후에 조건문에 따라서 Z축 방향으로 View를 쌓아야한다.
            ZStack {
                ScrollView {
                    LazyVStack {
                        
                        // Title and Subtitle Text
                        headerView
                            .padding(.top, 25)
                        
                        // description Text
                        descView
                            .padding(.top, 10)
                        
                        ForEach(food) { menu in
                            HStack {
                                Text("\(menu.name) \(menu.price)원")
                                Spacer()
                                Image(systemName: "pencil.circle")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .onTapGesture {
                                // State 프로퍼티에 값을 할당하여 re-rendering한다.
                                selectedMenuID = menu.id
                            }
                        }
                    }
                }
                
                // re-rendering 시, 옵셔널해제를 하면서, Zstack에 해당 View를 추가한다.
                if let id = selectedMenuID {
                    EditMenuPopupView(
                        food: $food[$food.firstIndex(where: { person in
                        person.id == id
                    })!], id: $selectedMenuID)
                }
            }
    }
}

struct LazyVStack_Example_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStack_Example()
    }
}



extension LazyVStack_Example {
    var headerView: some View {
        HStack {
            HeaderView(
                title: "우노의 심야식당",
                subTitle: "Binding with LazyVStack")
            Spacer()
        }
    }
    
    var descView: some View {
        HStack {
            Spacer()
            Text("@State - @Bidning을 통한\n 양방향 바인딩을 연습해봅시다.")
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .bold()
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color.yellow)
    }
}

struct HeaderView: View {
    
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(.title, design: .rounded))
                .bold()
            Text(subTitle)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
        .padding(.leading, 10)
    }
}



```



- EditMenuPopupView.swift

```swift
import SwiftUI

struct EditMenuPopupView: View {
    
    @Binding var food: Food
    @Binding var id: UUID!
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("메뉴를 수정하세요.")
                .font(.largeTitle)
            
            TextField("메뉴명", text: $food.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("가격", text: $food.price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("완료") {
                id = nil
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .shadow(radius: 8)
            
        }
        .padding(24)
    }
}

struct EditMenuPopupView_Previews: PreviewProvider {
    static var previews: some View {
        EditMenuPopupView(food: .constant(Food(name: "신선로", price: "24000")), id: .constant(UUID()))
    }
}
```













