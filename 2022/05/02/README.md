의존성 주입이라고 하면, 필요한 객체를 생성할 객체에 전달하는 방법에 대한 이야기 입니다.

이번에는 의존성 주입에 있어서 "Protocol을 통한 정의" 와 "함수(클로저)를 통한 정의" 에 대해서 알아보려고 합니다.



## Swift 의존성 주입 두 가지 방법

1. Protocol을 이용한 방법

```swift
import UIKit

// MARK: - 프로토콜을 이용한 의존성 주입

// ID를 생성한다.
protocol IDProvider {
    func getGameID() -> UUID
}

struct UserID: IDProvider {
    let userID: UUID
    func getGameID() -> UUID { userID }
}

// 시간을 생성한다.
protocol TimeProvider {
    func now() -> Date
}

struct GameStartTime: TimeProvider {
    let starteTime: Date
    func now() -> Date { starteTime }
}

// 게임을 생성한다.
struct Game {
    private let startTime: Date
    private let userID: UUID
    
    init(userID: UUID, startTime: Date) {
        self.userID = userID
        self.startTime = startTime
    }
}

// 게임을 담당하는 객체를 생성한다.
class GameService01 {
    
    private let idProvider: IDProvider // ID
    private let timeProvider: TimeProvider // Time
    
    init(idProvider: IDProvider, timeProvider: TimeProvider) {
        self.idProvider = idProvider
        self.timeProvider = timeProvider
    }
    
    // 게임을 생성한다.
    func createGame() -> Game {
        
        let id = idProvider.getGameID() // ID 생성
        let date = timeProvider.now() // 시간 생성
        let game = Game(userID: id, startTime: date) // 게임 생성
        return game
    }
}

// 초기화
let gameService01 = GameService01(
    idProvider: UserID(userID: UUID()),
    timeProvider: GameStartTime(starteTime: Date()))

// 호출
gameService01.createGame()
```

장점

- 구현과 정의를 나눌 수 있다.

단점

- 테스트를 할 때, 프로토콜을 준수하는 객체들을 모두 구현해야 한다. 
- 기능상 작은 프로토콜을 하나하나 모두 작성해줘야 한다.



2. Function(클로저) 를 이용한 의존성 주입

```swift
// MARK: - 함수를 이용한 의존성 주입
class GameService02 {

    private let getID: () -> UUID
    private let getTime: () -> Date

    init(getID: @escaping () -> UUID, getTime: @escaping () -> Date) {
        self.getID = getID
        self.getTime = getTime
    }

    func createGame() -> Game {
        
        let id = getID()
        let date = getTime()
        let game = Game(userID: id, startTime: date)

        // Do something with the game
        return game
    }
}

let gameService02 = GameService02(
    getID: { UUID() }, // getID: UUID.init
    getTime: { Date() }) // getTime: Date.init
gameService02.createGame()

```

장점

- 작은 기능에 대한 Protocol 선언을 생략할 수 있습니다.
- 테스트 시, 좀 더 직관적이고 적은 코드로 테스트를 수행할 수 있습니다.

단점

- `getID` 나 `getTime` 처럼 직관적이고 간단한 기능이 아닌 경우엔, 가독성을 오히려 해칠 우려가 있습니다.

  그런 예시가 아래 코드에 있습니다.



## 프로토콜이 유리한 케이스

```swift
protocol Logger {
  func log(message: String, file: String)
}
```

- 위 코드는 로그를 남기는 코드입니다. 첫 번째 파라미터에서는 메시지를 두 번째는 해당 메시지가 어디에 해당하는 파일인지 정확히 알 수 있습니다.
- 이 코드를 만약에 클로저를 사용한다면 아래와 같습니다.



```swift
let log: (String, String) -> Void

log("게임이 성공적으로 생성되었습니다.", "GameService.swift")

log("GameService.swift", "게임이 성공적으로 생성되었습니다.")
```

- 이렇게 2 개의 로그가 있어도 어떻게 사용하는 것이 작성자의 의도인지 알 수 없습니다.
- 파라미터에 의미가 담겨 있어서 이전에는 구분이 가능했지만, 클로저를 사용하면, 해당 의미가 없어지기 때문이죠.



이런 경우에는 오히려 프로토콜을 사용하는 것이 가독성을 올릴 수 있습니다.





## 결론

- 가능하면 Protocol을 대신해서 함수를 사용하는 것이 좋을 것 같습니다.
- 다만, 해당 경우가 코드를 읽는 사람에게 의미 전달이 정확한 경우로 한정해야 합니다.



## 참고자료

- https://medium.com/better-programming/use-functions-for-dependency-injection-in-swift-a885f38d8ed0

