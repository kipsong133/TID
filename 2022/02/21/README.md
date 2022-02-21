# Today, I learned: SwiftUI로 ColorScheme 변경하기

 오늘은 ColorScheme을 변경하는 코드를 작성하면서, CaseIterable, Identifiable 그리고 tag 수식어에 대해서 알아보겠습니다.



## 구현



#### 1. Appearenace Enum 생성

 	enum을 생성해서, 앱의 Color Scheme을 light, dark 그리고 automatic 으로 변경하는 데이터를 관리하려고 합니다. 

```swift
import SwiftUI

enum Appearance: Int, CaseIterable, Identifiable {
case light, dark, automatic
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .automatic: return "Automatic"
        }
    }
    
    func getColorScheme() -> ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
```

- 단순히 case 만 나열한 것이 아니라, 외부객체에서 사용하기 편리하도록 연산프로퍼티 및 메소드를 구현해두었습니다.
- 채택한 프로토콜이 "CaseIterable" 과 "Identifiable" 프로토콜이 있죠. 이것에 대해서 먼저 알아볼까합니다.



##### CaseIterable Protocol

> protocol
>
> CaseIterable
>
> a type that provides a collection of all of its values

(공식문서)

 공식문서의 내용대로 해석해보면, ''하나의 타입에 콜렉션을 모든 값에 제공해준다'' 라고 합니다. 즉, enum을 collection 처럼 순회할 수 있게 해준다는 뜻 입니다. 단어 뜻 그대로 case를 iterable 하게 해준다는 뜻이죠. 앞으로 for / forEach 와 같은 순회문에 해당 enum 타입을 사용하도록 해준다는 뜻이죠.



##### Identifiable Protocol

> Protocol
>
> Identifiable
>
> A class of types whose instances hold the value of an entity with stable identity

(공식문서)

 해석해보면, "인스턴스가 안정적인 ID를 가진 엔터티 값을 보유하는 유형의 클래스입니다." 이죠. 인스턴스에 ID를 준다는 뜻입니다.

해당 프로토콜을 준수하려면 id에 값을 줘야합니다.

소스코드에 이렇게 적혀있거든요.

```swift
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Identifiable {

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    associatedtype ID : Hashable

    /// The stable identity of the entity associated with this instance.
    var id: Self.ID { get }
}
```

그래서 제일 위에서 작성한 Appearance Enum에서 id를 주석처리하면, 컴파일에러가 발생합니다. 현재 rawValue를 id로 설정했습니다. 그러므로 Int 입니다. (light == 0 / dark == 1 / automatic == 2)



이제 UI와 데이터를 선언하겠습니다.

먼저 데이터를 선언합니다.

```swift
@AppStorage("appearance") var appearance: Appearance = .automatic
```

- Appearance는 앱의 전역적으로 사용되는 데이터입니다. 그러므로 "AppStorage"에 저장합니다.



 그리고 body 변수에 아래와 같은 코드를 추가합니다.

```swift
List {
    Text("Settings")
        .font(.largeTitle)
        .padding(.bottom, 8)
    
    Section {
        VStack(alignment: .leading) {
            Picker(
                "Pick",
                selection: $appearance) {
                    ForEach(Appearance.allCases) { appearance in
                        Text(appearance.name)
                    }
                }
        }
    } header: {
        Text("Pick Appearance")
    }
    .pickerStyle(.segmented)
}
```

- List에 값을 넣을 건데, 최상위에 "Setting" 값을 넣습니다.
- 그 아래는 Section으로 구분합니다. 그리고 VStack으로 감싼 후, Picker 객체를 사용합니다.
- Section의 해더는 "Pick Appearance" 입니다.
- Picker의 이름에는 Pick을 넣어주시고, ForEach문에 보면, Appearance를 순회하고 있죠. 이것이 이전에 CaseIterable 프로토콜 채택의 효과입니다. 각각을 순회하면서 name 연산프로퍼티의 값을 받아 Text에 할당합니다. 그러면 아래 그림처럼 나타납니다.

<img width="361" alt="스크린샷 2022-02-21 13 38 27" src="https://user-images.githubusercontent.com/65879950/154890218-ab34311c-5a89-4fc3-95f1-4f7bc6379b50.png">

- 현재 Appearnce Picker를 아무리 선택해도 아무일도 일어나지 않습니다.
- 왜냐하면, 데이터의 name만 보여줬지, 어떤 데이터와 연결되었는지 pickker입장에서는 전혀 알 수 없는 상태입니다. 이럴 때, 사용하는 수식어가 `tag`입니다.



ForEach 문 내부 코드블럭을 변경해줍니다.

```swift
Text(appearance.name).tag(appearance)
```



그러면 아래와 같이 동작하게됩니다.



![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-21 at 13 08 52](https://user-images.githubusercontent.com/65879950/154890239-913d5985-d8d6-4a54-80fa-009817ba794c.gif)


##### Tag(_:)

> Instance Method
>
> tag(_:)
>
> Sets the unique tag value of this view

(공식문서)

 tag는 식별자를 부여해주는 수식어입니다. 해당 뷰를 다른 것들과 구분할 수 있는 id를 준다고 보시면됩니다. ForEach에서 id값을 전달해줘야하죠. 혹은 이미 내부적으로 Identifiable이 구현되어 있어야합니다. 위 Picker를 기준을 말씀드리면, Picker에 Text 3 개를 보여줬지만, 각각이 아직 구분되진 않은 상태입니다. 즉, 보여주기만한겁니다. 그래서 각각을 구분할 수 있도록 .tag를 붙여줬고, 해당 값을 appearance tpye으로 구분했습니다.

 tag는 list나 picker 에서 각각의 뷰들을 구분짓는데 사용합니다. tag 수식어는 Hashable Protocol을 따르는 타입을 취할 수 있습니다. Enum의 경우, 자동적으로 그것을 따르고 있습니다. 그래서 바로 사용할 수 있는 것이죠. Section에 Appearance를 바인딩하고 있고, 그것에 맞는 tag를 설정해주면됩니다.



UI와 데이터 바인딩이 끝났으니, 실제 동작하도록 해보겠습니다.

App의 EntryPoint 인 App 프로토콜을 채택한 곳으로 갑시다.

(앱을 처음 생성하면 앱프로젝트이름+App.swift 파일로 이동하시면됩니다.)

그곳에 프로퍼티로 다음 코드를 추가합니다.

```swift
@AppStorage("appearance")
var appearnace: Appearance = .automatic
```

- 앱 전체에 적용되는 값이므로 AppStorage에 저장했습니다.

- 다만 UserDefault(=AppStorage) 는 모든 값을 저장할 수는 없습니다. 

  - Int, Double, String, Bool
  - Data, URL
  - RawPresentable Protocol을 따르는 데이터

  위 3 가지 경우만 저장이 가능합니다. 그러면 Appearance는 모두 적용이 안되는 것 같은데 AppStorage에 왜 저장이 되는 걸까요?

  우리가 정의한 Appearance 를 보면 이렇게 정의하고 있습니다.

  ```swift
  enum Appearance: Int ... { ... }
  ```

  Int를 rawValue로 지정하고 있는거죠. 열거형에서 기본데이터타입으로 rawValue를 지정하면 자동으로 RawPresentable 프로토콜을 따르게 됩니다. 그래서 enum 값이 AppStorage에 잘 저장이 됩니다.

  

그리고 body에 있는 View에 앱의 ColorScheme을 설정하는 수식어를 추가해줍니다.

```swift
WindowGroup {
    ContentView()
        .preferredColorScheme(appearnace.getColorScheme()) // <--
}
```



이렇게 코드를 설정한 후, 실행하면 다음과 같은 화면이 나타납니다.

![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-21 at 13 24 53](https://user-images.githubusercontent.com/65879950/154890251-f12643c6-3d41-43db-8636-28f1f633bd75.gif)




## 정리

- Picker를 사용할 때는, tag값을 추가해줘야한다.
- 그 태그값은 Hasble Protocol을 준수해야하는데 enum의 경우, 이미 준수된 타입이다.
- colorScheme을 변경하기 위해서 AppStorage에 데이터를 저장하고, 해당 값은 App 생성 시점에 `preferredColorScheme` 에서 설정해준다.





## 참고자료

- https://developer.apple.com/documentation/swift/iteratorprotocol
- https://0urtrees.tistory.com/197
- https://www.raywenderlich.com/books/swiftui-by-tutorials/v4.0/chapters/10-more-user-input-app-storage
- https://developer.apple.com/documentation/swiftui/list/tag(_:)
