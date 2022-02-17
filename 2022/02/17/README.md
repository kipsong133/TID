# Today, I learned: SwiftUI Basic Architecture

 오늘은 SwiftUI에서 사용될 아키텍처에 대해서 알아보겠습니다.

 아키텍처를 고민하고, 적용하는 이유는 다음과 같다고 생각합니다.



1. 코드의 가독성을 향상시킨다.
2. 코드를 변경하기 쉽다.
3. 기존의 코드에 무언가 추가하기 쉽다.
4. 코드를 테스트하기 쉽다.

 이것들 이 외에도 있겠지만, 개인적으로 느낀 아키텍쳐 적용 시 장점들을 입니다.

이것들을 3 개의 키워드로 정리하면, "모듈성", "확장가능성" 그리고 "가독성" 으로 정리할 수 있겠네요.

 이런 개념적인 설명이 아니라 이번 글에서는 SwiftUI에서 어떻게 적용하는지에 대한 구체적인 이야기를 하겠습니다.



## 1. Problem

제가 생각한 문제정의는 다음과 같습니다.

> SwiftUI에서는 어떻게 구조를 나눌 수 있을까?



그래서 더이상 나눌 수 없는 가장 작은 단위로부터 시작해보려고합니다. (like 원자)

 SwiftUI를 통해서 앱을 구성할 때, 크게 보면 3 가지정도로 생각해볼 수 있습니다. (특정 패턴 적용안한 상태에서)

1. 화면을 보여주는 `View`
2. 데이터를 연산하는 `ObservableObject` (like ViewModel)
3. 데이터를 정의하는 `Data Object` 



문제에 대해서 정의하고 어떻게 풀어갈지 정했으니 코드를 작성해보겠습니다.



## 2. Solution

View의 코드입니다.

```swift
struct TodoListView: View {
    @StateObject private var todoObservableObject = TodoObservableObject()
    
    var body: some View {
        VStack {
            List(todoObservableObject.taskList) { task in
                Text(task.name)
                    .foregroundColor(.black)
                    .font(.title2)
            }
        }
    }
}
```



ObservableObject코드입니다.

```swift
class TodoObservableObject: ObservableObject {
    @Published var taskList: [Task] = []
    
    init() {
        self.getTaskList()
    }
    
    func getTaskList() {
        taskList = [
            Task(name: "아침 5시에 기상"),
            Task(name: "이불정리"),
            Task(name: "아침 조깅"),
            Task(name: "TIL 작성")
        ]
    }
}
```



DataObject코드입니다.

```swift
struct Task: Identifiable {
    let id = UUID()
    var name: String
}
```



폴더구성입니다.

![image](https://user-images.githubusercontent.com/65879950/154430530-122b4600-e507-4022-abaf-3fc39c9dc682.png)




## 3. 정리

 보면, ObservableObject라는 이름 대신에 ViewModel이라고만 붙이면 MVVM 아키텍쳐 패턴으로 구성됩니다. 다만 이번에는 가장 작은 컴포넌트 단위를 알아보기 위해서 ObservableObject라고 이름을 붙였습니다. 이곳에 Combine을 엮기 시작하면, 정말 아름다워지겠죠?^^

- V: View / OO: ObservableObject / DO: DataObject
- SwiftUI의 에서 가장 작은 단위로 쪼갠 3 개의 객체이다.
- UIKit에서 MVC와 다르게 V와 Controller의 기능이 확실히 구분되어있다.





읽어주셔서 감사합니다.





