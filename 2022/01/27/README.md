# Today, I learned: Signal 과 Driver

#### RxSwift에서 signal 이란?

`Signal`은 PublishSubject와 동일하게 동작하지만, UI와 바인딩되는 Subject입니다
PublishSubject가 있다면, BehaviorSubject처럼 동작하는 UI용 Subject도 있겠죠.
그것이 `Driver` 입니다.

예시를 들어보면,

Signal은 아래 그림과 같습니다.

```
-----(A)-----(B)--------------(C)----|  (Signal)

			(구독)---------(C)----|  (Observer)

```

- 위 그림처럼 구독을 한 이후부터 이벤트를 옵저버에게 방출합니다.



Driver는 아래 그림과 같습니다.

```swift
-----(A)-----(B)--------------(C)----|  (Driver)

	(구독)-(B)--------(C)----|  (Observer)
```

- 구독을 하자마자 B 이벤트를 받고 이후의 이벤트에 대해서는 동일하게 받습니다.



> Subject와 동일하게 동작하는데, 왜 굳이 따로 이름을 나눠서 사용할까?

- 이유는 UI를 처리하는 메인스레드에서 동작하도록 해줘야하기 때문이죠.
- Subject로도 불가능한 것이 아니지만, 편의를 위해서 사용합니다.



예시코드입니다.

```swift
/* ViewConroller */
// 1. tap 이벤트를 vm의 subject에 전달한다.
버튼.rx.tap
	.bind(to: vm.버튼탭액션)
	.disposed(by: disposeBag)

// 3. 시그널에서 반환하는 이벤트를 받아서, 원하는 방식으로 처리한다.
vm.output
	.emit(onNext: { print($0) })
	.disposed(by: disposeBag)

/* ViewModel */
let 버튼탭액션 = PublishRelay<Void>()
let 뷰컨에전달해줄결과값: Signal<String>

// 2. VC에서 탭이 발생하면, 릴레이를 시그널로 변경해서 값을 저장하는데, 이 때, 원하는 이벤트 모양으로 변형한다.
버튼탭액션 = 뷰컨에전달해줄결과값
	.map { _ in 
       print("버튼을 탭했습니다.")
       }
	.asSignal(...)

```

