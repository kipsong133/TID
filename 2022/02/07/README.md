# Today, I learned, DispatchGroup

먼저 코드를 보겠습니다.

```swift
DispatchQueue.global().async { [weak self] in
  NetworkLayer().getData() { response in 
                            
		DispatchQueue.main.async {
	    self?.title = response.title      
    }
  }
}
```

- 위 코드는 네트워크 통신을 통해서 데이터를 받아온 뒤, UI를 업데이트 해주는 로직을 나타냅니다.
- `NetworkLayer`에서 HTTP 통신을 하고요. 클로저에 인자를 받아서 받아온 데이터 중 "title" 변수를 ViewController의 title로 할당해주고 있습니다.



네트워킹할 때는, 메인쓰레드가 아닌 다른 쓰레드에서 작업을 처리하고, 마지막에는 메인스레드에서 작업을 처리하겠죠. 일련의 과정을 하나의 Task 혹으 Group 이라고 칭합니다. 부족하지만, 그림으로 표현하면 아래와 같을 겁니다.

```markdown
|Main| ----------------|UI처리|---> 
|Thread1| --|네트워킹처리|---------->
|Thread2| ----------------------->
```



 여기서 DispatchGroup을 통해서 알 수 있는 것은 "언제 해당 테스트가 끝나는지" 를 알 수 있습니다. 바로 notify 메소드를 통해서 말이죠.

```swift
let animationGroup = DispatchGroup()
let animationQueue = DispatchQueue(label: "Animation")

// 첫 번째 애니메이션을 실행하고 animationGroup에 추가한다.
animationQueue.async(group: animationGroup) {
    sleep(1)
    print("DEBUG: 첫 번째 애니메이션 종료")
}

// 두 번째 애니메이션을 실행하고 animationGroup에 추가한다.
animationQueue.async(group: animationGroup) {
    usleep(1)
    print("DEBUG: 두 번째 애니메이션 종료")
}

// 세 번째 애니메이션을 실행하고 animationGroup에 추가한다.
animationQueue.async(group: animationGroup) {
    usleep(1)
    print("DEBUG: 세 번째 애니메이션 종료")
}

// animationGroup에 있는 모든 동작이 종료된 이후에, 코드블럭에 있는 로직을 main쓰레드에서 실행한다.
animationGroup.notify(queue: DispatchQueue.main) {
    print("끗")
}
```

- 결과

```swift
DEBUG: 첫 번째 애니메이션 종료
DEBUG: 두 번째 애니메이션 종료
DEBUG: 세 번째 애니메이션 종료
끗
```

- 코드를보면 그룹으로는 `animationGroup`을 생성하고 있습니다.
- Queue로는 `animationQueue`라고 생성하고 있습니다.
- 맨 마지막에 notify 메소드를 활용해서 끝나는 동시해 코드블럭을 실행시키고, main 쓰레드에서 해당 동작을 실행합니다.



갑자기 이런 의문이 들지 않나요?

> 그러면, notify에서 다른 queue를 동작시켜서 테스크 간의 동기처리도 가능할 것 같은데?

네, 맞습니다. 가능합니다.



위 코드에서 notifiy 주변에 아래와 같이 코드를 수정해줍니다.

```swift
let networkingGroup = DispatchGroup()
let networkingQueue = DispatchQueue(label: "Networking", target: .global())

// animationGroup에 있는 모든 동작이 종료된 이후에, 코드블럭에 있는 로직을 main쓰레드에서 실행한다.
animationGroup.notify(queue: DispatchQueue.main) {
    print("끗")
}

networkingQueue.async(group: networkingGroup) {
    print("네트워킹 통신을 시작합니다. 삐빅스")
    sleep(1)
}

```

- 실행결과

```swif
네트워킹 통신을 시작합니다. 삐빅스
DEBUG: 첫 번째 애니메이션 종료
DEBUG: 두 번째 애니메이션 종료
DEBUG: 세 번째 애니메이션 종료
끗
```

- 분명히, 우리가 원하는 것은 애니메이션이 끝나고 네트워크 통신하는 것인데, 그렇게 동작하지 않고 있습니다.
- 그래서 코드를 수정해보겠습니다.



```swift
let networkingGroup = DispatchGroup()
let networkingQueue = DispatchQueue(label: "Networking", target: .global())

// animationGroup에 있는 모든 동작이 종료된 이후에, 코드블럭에 있는 로직을 main쓰레드에서 실행한다.
animationGroup.notify(queue: DispatchQueue.main) {
    print("끗")
    networkingQueue.async(group: networkingGroup) {
        print("네트워킹 통신을 시작합니다. 삐빅스")
        sleep(1)
    }
}
```

- 실행결과

```swift
DEBUG: 첫 번째 애니메이션 종료
DEBUG: 두 번째 애니메이션 종료
DEBUG: 세 번째 애니메이션 종료
끗
네트워킹 통신을 시작합니다. 삐빅스
```

- 이제 정상적으로 호출이 되었네요. 근데 이렇게 하면, 코드가 계속 코드블럭 내에 들어가서 보기 안좋을 것 같습니다.
- 조금 개선해보겠습니다.



```swift
let networkingGroup = DispatchGroup()
let networkingQueue = DispatchQueue(label: "Networking", target: .global())

// animationGroup에 있는 모든 동작이 종료된 이후에, 코드블럭에 있는 로직을 main쓰레드에서 실행한다.
animationGroup.notify(queue: DispatchQueue.main) {
    print("끗")
}


networkingQueue.async(group: networkingGroup) {
    animationGroup.wait()
    print("네트워킹 통신을 시작합니다. 삐빅스")
    sleep(1)
}
```

- 실행결과

```swift
DEBUG: 첫 번째 애니메이션 종료
DEBUG: 두 번째 애니메이션 종료
DEBUG: 세 번째 애니메이션 종료
끗
네트워킹 통신을 시작합니다. 삐빅스
```

- `animationGroup.wait()`라는 코드를 추가했습니다.
- 이 코드는 animationGroup이 종료될 댸까지 기다렸다가, 종료가 된 이후부터 실행합니다.
- 그래서 이렇게 wati를 한번 쓴 이후에 로직이 아무리 추가되어도, wait하고 있는 그룹이 끝나기 전까지는 실행되지 않습니다.



```swift
networkingQueue.async(group: networkingGroup) {
    animationGroup.wait()
    print("네트워킹 통신을 시작합니다. 삐빅스")
    sleep(1)
}

networkingQueue.async(group: networkingGroup) {
    print("네트워킹 통신 중...")
}
```

- 실행결과

```swift
DEBUG: 첫 번째 애니메이션 종료
DEBUG: 두 번째 애니메이션 종료
DEBUG: 세 번째 애니메이션 종료
끗
네트워킹 통신을 시작합니다. 삐빅스
네트워킹 통신 중...
```

- 마지막 코드블럭에서는 wait를 사용하지 않아도 기다렸다가 호출됩니다.



wait메소드는 아래와 같이 사용할 수도 있습니다.

```swift
// 30초 동안 끝나지 않았는지 확인하는 조건문
if animationGroup.wait(timeout: .now() + 30) == .timedOut {
    print("애니메이션이 끝나지 않습니다.")
}
```



 이처럼, group이라는 개념을 통해서 언제 끝나는지 개발자가 확인할 수 있게되고, 이를 통해서 다음 Task를 이어서 처리할 수도 있습니다.



## 정리

- DispatchQueue에 작업을 보냄과 동시에 해당 작업이 어디에 속하는지 group을 알려준다.

  (인스타그램의 해시태그같은 느낌)

- DispatchGroup이 지원하는 notify 메소드를 통해서 종료 이후에 동작하도록 처리할 수 있다.

  (테스크 간 동기처리)



 Dispatch관련헤서 개념을 정리하면서 RxSwift가 떠올랐습니다. timeout 상태를 통해서 특정시간동안 네트워크 통신이 되지 않으면 다시 네트워크를 실행할 수 있겠죠. 그리고 그 횟수를 프로퍼티에 저장해두었다가, 특정 횟수 이상 지나면, 실패한 것으로 리턴값을 보내면, 여러가지 상황에 대해서 처리할 수 있네요. 지금 설명한 개념은 RxSwift의 retry 오퍼레이터 입니다.

  RxSwift의 내부 코드는 아마도 DispatchQueue를 이리저리 볶아 놓은 형태일 겁니다. Dispatch에 관해서 제대로 모르고 RxSwift를 사용하는 사람은 아마도 없겠지만, 제가 그랬던 것 같네요. 앞으로도 Dispatch 관련글을 작성해볼 예정입니다.^^



읽어주셔서 감사합니다.









