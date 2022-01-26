# Today, I learned : RxSwift 활용 1

선언형으로 개발할 수 있는 방법 중 하나가 "RxSwift" 를 활용하는 것이라고 생각합니다.

예시코드를 먼저 보겠습니다.



- Bindings Example

```swift
Observable
	.combineLatest(
  	firstName.rx.text,
  	lastName.rx.text
  ) { $0 + " " + $1 }
	.map { "Greetings, \($0)" }
	.bind(to: greetingLabel.rx.text)	
	.disposed(by: disposeBag)
```

- Observable은 "이벤트의 흐름" 입니다. 
- "combineLatest" 는 "여러 개의 값을 조합할 수 있도록 도와주는 오퍼레이터" 입니다. 여기서보면, 2 개의 텍스트를하나로 합치는데 클로져에서 어떻게 합쳐서 하나의 값으로 반환하는지 알 수 있겠죠.
- 그 다음 줄 map 에서 하나로 받은 값을 바꾸고 있습니다.
- 값을 모두 바꿨다면, 어떤 것이랑 엮어야 하는지 "bind" 에서 결정하고 있습니다.



- 재시도

```swift
func callingAPI(input: Input) throws -> Response { ... }
```

- 이러한 API를 호출하는 메소드가 있다고 가정합니다. 그런데, 실패할 수도 있겠죠. 실패의 경우, 몇 회 이상 자동으로 다시 시도해줬으면 좋겠습니다. 그럴 때, Rx를 이용하면 미리 구현된 편리한 오퍼레이터로 인해서 코드도 줄고 구현도 빨리 할 수 있겠죠.

그래서 아래와 같이 사용하면됩니다.

```swift
callingAPI(input: input)
	.retry(3)
```



- Delegate

```swift
public func scrollViewDidScroll(scrollView: UIScrollView) { [weak self] in 
	...
  self.leftPosition... = scrollView.contentOffset.x
}
```

- 이 델리게이트 메소드를 볼 때, 이것이 어떤 스크롤뷰인지 바로 알 수 없습니다. 코드 전체를 읽은 후에, 이 스크롤 뷰가 어떤 것인지 알 수 있죠.
- 델리게이트는 선언해주었는지 확인도 해야합니다. 이것은 아래와 같이 개선할 수 있습니다.

```swift
self.tableView.rx.contentOffset
	.map { $0.x }
	.bind(to: self.leftPositionConstraint.rx.constant)
```

- 테이블 뷰의 콘텐츠 오프셋을 특정 좌측 제약조건과 바인딩해서, 테이블 뷰의 오프셋이 바뀌면, 해당 값만큼 이동하도록 처리하는 rx를 이용한 코드입니다.
- 이렇게 내가 설정하고자하는 값과 변경되는지 확인해야하는 값을 직관적으로 알 수 있게 도와주는 것이 Rx의 장점입니다.



### Observable

```swift
Observable<T>
```

- Rx 코드의 근간이라고 할 수 있습니다.

- T 형태의 데이터 snapshot을 "전달" 할 수 있는 일련의 이벤트를 비동기적으로 생성하는 기능을 합니다.

  - 즉, T에서 정한 타입을 이벤트로 생성합니다. 공장에서 무언가 찍어내는 그림을 연상해보시면 도움이 되지 않을가 생각되네요.

- Observable이 이벤트를 발송하는 주체면, 그 이벤트를 받아서 처리하는 객체는 Observer입니다.

- 세 가지 유형의 이벤트를 방출할 수 있습니다.

  ```swift
  enum Event<Element> {
    case next(Element)
    case error(Error)
    case completed
  }
  ```

  - 위 코드를 기반으로 설명드리면 "next" 는 T를 전달하는 이벤트입니다.
  - 에러는 말그대로 에러를 전달합니다
  - completed는 종료됨을 알립니다.



옵저버블은 크게 2 종류로 생각해볼 수 있습니다.

1. 언젠가 반드시 끝나야하는 옵저버블
2. 무한한 옵저버블



#### 언젠가 반드시 끝나야하는 옵저버블

ex) 네트워크를 통해서 데이터를 전달받는 옵저버블

```swift
Network.download(file: "https://www....") // 데이터를 전달하는 옵저버블 Observable<Data>
	.subscribe(onNext: { data in 
                     // 임시 파일에 데이터를 추가한다.
                     },
             onError: { error in 
                      // 에러를 사용자에게 전달한다.
                      },
             onCompleted: {
               // 다운로드가 완료되었으니 다운로드된 파일을 활용한다.
             })
```

#### 무한한 옵저버블

ex) UI를 담당하는 옵저버블

```swift
UIDevice.rx.orientation // Observable<Orientation>
	.subscribe(onNext: { current in 
		switch current {
      case .landscape:
      	// 가로모드 UI 배치
      case .portrait:
      	// 세로모드 UI 배치
    	}
	})
```











