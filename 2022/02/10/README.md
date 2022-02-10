# Today, I learned: Binding 예제

 SwiftUI에서 @State의 파생데이터로 상태에 따른 UI Redrawing을 알아서 해주는 "Binding" 에 대해서 예제를 통해서 알아보려고 합니다.

 Binding은 다음과 같은 관계를 가지고 있습니다. 

> @State - @Binding = 원천데이터 : 파생데이터 

상위뷰에서 @State로 감싸진 프로퍼티를 전달해주면, 하위뷰에서 @Binding 프로퍼티로 전달받아서 해당 UI와 다시 바인딩합니다. 바인딩을 커스텀해서 구현한 코드를 보겠습니다.



```swift
struct ContentView: View {
  // 원천데이터
  @State private var userName = ""
  
  var body: some View {
    // 파생데이터
    let binding = Binding(
    	get: { self.userName },
      set: { self.userName = $0}
    )
    
    return VStack {
      Text(userName)
      TextField("이름을 입력해주세요.", text: binding)
      // == TextField("이름을입력해주세요., text: $username")
    }
  }
  
}
```

- 텍스트와 텍스트필드 두개를 그린 간단한 View 입니다.
- `userName` 이라는 원천데이터와 이를 연결하는 파생데이터인 `binding` 을 만들었고, 그것을 TextField와 연결하고 있습니다.
- 주석처리된 곳을 보면, 보통은 주석처럼 작성하죠. 이번에는 Binding을 어떻게 커스텀해서 생성하는지 알아보기 위해서 작성했습니다.



```swift
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {

    /// The binding's transaction.
    ///
    /// The transaction captures the information needed to update the view when
    /// the binding value changes.
    public var transaction: Transaction

    /// Creates a binding with closures that read and write the binding value.
    ///
    /// - Parameters:
    ///   - get: A closure that retrieves the binding value. The closure has no
    ///     parameters, and returns a value.
    ///   - set: A closure that sets the binding value. The closure has the
    ///     following parameter:
    ///       - newValue: The new value of the binding value.
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void)  
  ...
}
```

- 바인딩의 초기화 함수의 소스코드를 보면 다음과 같이 정의되어 있습니다.

- 클로저를 통해서 바인딩을 생성할 수 있고, get은 바인딩하는 값을 읽어올 수 있습니다. 클로저에는 전달받는 파라미터는 없습니다. set의 경우, 클로저를 통해서 값을 셋팅하고, 클로저는 파라미터로 입력받을 값을 전달받습니다.

  (아래 코드 부분 설명입니다.)

```swift
public init(get: @escaping () -> Value, set: @escaping (Value) -> Void)  
```



바인딩이라는 것은 이런식으로, 상위뷰에서 만들어서 하위뷰로 전달해줄 수도 있습니다. 편하신 방법으로 구현하시면 되겠네요. 한 번 List를 이용해서 다시 바인딩 사용 예제를 보겠습니다.



일단 List를 통해서 기본 UI를 만들고 난 이후에, 이곳에 바인딩을 전달하는 코드로 수정하겠습니다.



먼저, 기본 UI 입니다.

![image](https://user-images.githubusercontent.com/65879950/153415158-2ea9b156-9a86-42a1-8660-90eb11c40ab3.png)


코드 입니다.

```swift
import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    var fristName: String // 데이터가 변경될 예정이므로 var
    var lastName: String  // 데이터가 변경될 예정이므로 var
    
    init(_ fristName: String, _ lastName: String) {
        self.fristName = fristName
        self.lastName = lastName
    }
}


struct ContentView: View {
    
    @State private var people: [Person] = [
        Person("Uno", "Kim"),
        Person("Uno", "Park"),
        Person("Uno", "Lee"),
    ]
    
    var body: some View {
        
        NavigationView {
            VStack {
                HeaderView("Hello, SwiftUI",
                           "by Uno")
                
                List(people) { person in
                    Text("\(person.fristName) \(person.lastName)")
                }
                Spacer()
            }
            .navigationTitle("Binding과 List의 만남")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    init(_ title: String,
         _ subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .padding(.leading, 3)
            }
            .padding(.leading, 18)
            Spacer()
        }
    }
}
```



이제 @State에서 프로퍼티를 전달받아서 바인딩할 @Binding이 있는 서브뷰를 구현하겠습니다.

![image](https://user-images.githubusercontent.com/65879950/153415240-2c1903a3-0a7e-4c54-bb6d-9b1cb4dca36e.png)


```swift
import SwiftUI

struct DetailView: View {
    @Binding var fristName: String
    @Binding var lastName: String

    var body: some View {
        HStack {
            VStack {
                Text("성과 이름을 수정하세요.")
                
                Color.black
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: 1)
                
                TextField(fristName, text: $fristName)
                
                Divider()
                
                TextField(lastName, text: $lastName)
            }
            .padding(10)
            .border(.black, width: 1)
            
            Spacer()
        }
        .navigationTitle("Editing Name")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(fristName: .constant("Uno"), lastName: .constant("Kim"))
        }
    }
}

```



이제 슈퍼뷰로 돌아가서 List 부분의 코드를 수정하겠습니다.

```swift
    var body: some View {
        
        NavigationView {
            VStack {
                HeaderView("Hello, SwiftUI",
                           "by Uno")
                
                List($people) { $person in
                    NavigationLink(destination: {
                        DetailView(
                            fristName: $person.fristName,
                            lastName: $person.lastName)
                    }, label: {
                        Text("\(person.lastName) \(person.fristName)")
                    })
                }
                Spacer()
            }
            .navigationTitle("Binding과 List의 만남")
        }
    }
```

- 나머지 코드는 동일하고 List 부분만 변경되었습니다.
- people 프로퍼티는 @State로 감싸져있습니다. 해당 값을 입력받아서 하나의 데이터마다 바인딩된 값을 서브뷰로 전달하고 있습니다.
- 이전과 크게 다르지 않죠? 다만 바인딩한 값을 전달하므로, 서브뷰에서 데이터를 변경하면 슈퍼뷰에서도 반영되여 Redrawing을 합니다.



실행화면입니다.


![Simulator Screen Recording - iPhone 11 Pro - 2022-02-07 at 14 43 17](https://user-images.githubusercontent.com/65879950/153415052-34309019-dac8-46df-94e1-730003d4bcf4.gif)

## 정리

- Binding와 List를 이용하는 2 가지 방법에 대해서 알아봣다.
  - 1. 일반 프로퍼티를 전달하기
    2. 바인딩가능하도록 State 프로퍼티 래퍼로 감싼 프로퍼티 전달하기
- Binding을 커스텀하여, 직접 바인딩프로퍼티를 전달할 수 있다.



읽어주셔서 감사합니다.



