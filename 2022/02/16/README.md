# Today, I learned: EnvironemntObject

 오늘은 EnvironmentObject에 대해서 알아보겠습니다.



이전에 AppStorage에 대해서 정리했었죠. 그리고 글은 작성하지 않았지만, 데이터의 범위만 줄어든 SceneStorage라는 것도 있습니다. 그리고 이번에는 EvironmentObject입니다.

 셋 다 뭔가 유사한 면이 있습니다. 데이터 엑세스 범위에 따라서 저장된 데이터를 공유한다는 차원에서 유사합니다. 다만 범위의 차이가 존재하죠.

AppStorage: 앱의 전체 범위

SceneStorage: Scene의 범위

EnvironmentObject: View의 범위 (SuperView ~ SubView 포함)

## 1. Problem

 하나의 뷰가 있고, 그 하위 뷰에서 공유하는 하나의 데이터 객체를 공유하고 싶다고 문제상황을 가정해보겠습니다. 여기서 이전에 설명했던 AppStorage나 SceneStorage를 사용해도 문제는 해결은 되겠죠. 하지만 이것은 앱이 너무 상호의존적인 관계에 놓이게 됩니다. 만약 상황에 따라서 다른 객체로 넣고 싶을 수도 있겠죠. 하지만 AppStorage라면, 앱의 전역범위에서 다루기만하면 되는 데이터 뿐만아니라, 아주 국소적으로 사용되는 데이터도 가지고 있게되죠. 그렇게 되면, AppStorage를 떼고 기능구현을 할 수 없습니다. 즉, 모듈성에 악영향이 갈 수 밖에 없습니다. 그래서 View내에서만 생존하는 그런 객체가 필요합니다.

그림을 그리면 범위에 대한 생존 기간은 다음과 같을 겁니다.

<img width="1116" alt="image" src="https://user-images.githubusercontent.com/65879950/154284390-1d05196f-17d6-4f9c-b413-3dbd6a3b089d.png">


- 생존 기간이 다른 만큼, 저장되는 데이터 유형도 달라야겠죠.
- 직관적으로 생각해보면, 생존기간이 길면 무조건 좋다고 생각할 수 있지만, 길수록, 해당 구조는 점점 상호의존적인 관계로 앱을 분리할 수 없는 상황으로 이어집니다.
- 앱의 생존기간이 짧을수록, 분리하기도 쉽고 다른것으로 교체하기도 쉬워지므로 코드를 변형하기 좋은 형태가 되겠죠.



그러한 맥락에서 `EnvironmentObject` 를 사용한다고 봅니다.



## 2. Solution

그러면 이것을 어떻게 사용하면될까요?

아주 간단합니다.

App의 EntryPoint가 다음과 같습니다.

```swift
@main
struct EnvironmentObject_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```



그리고 ObservableObject를 하나 생성하겠습니다.

```swift
class UserInfo: ObservableObject {
    @Published var name = ""
}
```



그리고 앱을 실행하면 처음으로 보이는 View는 다음과 같습니다.

```swift
struct ContentView: View {
    
    var body: some View {
        TabView {
            FirstTabView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("첫 번째 탭")
                }
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("두 번째 탭")
                }
        }
        .environmentObject(UserInfo())
    }
}
```

- TabView 안에 2 개의 View가 있어서 2 개의 탭을 형성하고 있습니다.

```swift
.environmentObject(UserInfo())
```

- 이부분이 EnvironmentObject를 전달하는 부분입니다. 이제 `UserInfo ` 객체를 하위뷰에서 접근할 수 있습니다.
- 이러면 외부 View에서는 같은 UserInfo 객체에는 접근할 수 없습니다. 적절한 시점에 소멸되겠죠. 그리고 이부분에 다른 객체를 넣을 필요가 있을경우, 교체만 해주면 하위뷰에도 교체된 새로운 객체로 접근할 수 있을 겁니다.

<img width="333" alt="image" src="https://user-images.githubusercontent.com/65879950/154284458-13647409-b4be-4ec3-a9c1-c77bbdc5c872.png">


아주 간단한 UI 입니다..^^



하위뷰에서는 다음과 같이 접근합니다.

```swift
struct FirstTabView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        VStack {
            Text("첫 번째 탭")
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .padding(.top, 35)
            Spacer()
            Text("INPUT")
            TextField("값을 입력해보세요.", text: $userInfo.name)
            Spacer()
        }
    }
}
```

```swift
@EnvironmentObject var userInfo: UserInfo
```

- 이렇게 접근하면 끝입니다.
- 이제 해당 데이터에 접근할 수 있습니다. TextField이므로 ObservableObject의 Published 객체에 바인딩하여 데이터를 바로바로 업로드하고 UI를 업데이트 하고 있죠.



다른 뷰에서도 아래와 같이 접근하고 있으며 같은 데이터를 공유하고 있습니다.

```swift
struct SecondTabView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        VStack {
            Text("두 번째 탭")
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .padding(.top, 35)
            Spacer()
            Text("Output")
            Text(userInfo.name)
            Spacer()
        }
    }
}
```


![Simulator Screen Recording - iPhone 13 Pro - 2022-02-16 at 23 10 36](https://user-images.githubusercontent.com/65879950/154284516-eb2abc45-da49-4d20-92ac-c59dc8d13594.gif)





### 3. 개념

 위 상황을 도식화 하면 다음과 같습니다.

<img width="1114" alt="image" src="https://user-images.githubusercontent.com/65879950/154284566-15f698d0-b719-4d4b-923b-06d2c33c416c.png">


- 하나의 탭뷰에 두 개의 뷰가 있으며, 탭뷰에 공유된 하나의 ObservableObject가 하위 뷰에 모두 공통적으로 공유되고 있는 상황이죠. 이렇게 병렬적이면서 수직적인 상황에서도 사용이 가능합니다.



아무리 병렬적으로 가능하다고 해도 아래와 같은(보라색) 처럼 데이터 공유는 불가능합니다. (직접적인 공유는 안되고, 구조에 따라서 위로 전달 된 이후에, 하위로 다시 내려오는 식으로 전달은 되겠죠.)

<img width="1093" alt="image" src="https://user-images.githubusercontent.com/65879950/154284606-91febf3f-5be1-4331-9fc1-f514813feda2.png">




이 외 사항들을 정리해보면 다음과 같습니다.

- 상위뷰에서 사용안하더라도 하위 뷰에서 사용가능합니다.
- init을 통한 로직처리는 불가능합니다.

ex) 불가능한 예시

```swift
@EnvironmentObject var viewModel: CommonViewModel

init() {
  if viewModel.username == "Uno" {
    title = "Uno"
  }
}
```



## 정리

- AppStorage / SceneStorage는 UserDefault의 개념에 가깝다. 그에 비해 EnvironmentObject는 의존성 주입의 개념이 더 강하다.
- 초기화함수에서 로직처리는 불가능하다.
- 중간에 EnvironmentObject를 호출하지 않더라도 최하위뷰에서도 여전히 접근이 가능하다.



읽어주셔서 감사합니다.





