Today, I learned: SwiftUI FlashCard 만들기
 오늘은 SwiftUI를 통해서 FlashCard를 만들면서 개념들을 정리해보려고합니다.


구현
UI 구현 -> ObservableObject 구성 -> Gesture 연결 순으로 진행하겠습니다.


1. UI 구현

 플래시 카드니까, 카드 UI가 있어야겠죠. 저는 SwiftUIView를 하나생성해서 다음과 같은 UI를 구성했습니다.

```swift
struct CardView: View {
    var body: some View {
        ZStack {
            // setup BackgroundColor
            Rectangle()
                .fill(Color.blue)
                .frame(width: 320, height: 210)
                .cornerRadius(12)
            
            VStack {
                Spacer()
                Group {
                    Text("Flash Card Title")
                        .font(.largeTitle)
                    
                    Text("Answer")
                        .font(.headline)
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
        .shadow(radius: 8)
        .frame(width: 320, height: 210)
    }
}
```

<img width="384" alt="image" src="https://user-images.githubusercontent.com/65879950/155059304-6d7b2e0a-69db-45fe-a1ca-27a9097bf7b4.png">


 지금까지 구현한 것은 카드 한장이니까, 사용할 때는 카드가 여러장이여야겠죠. 해당 뷰를 다시 만들고 이름을 "DeckView" 라고 하겠습니다.


```swift
struct DeckView: View {
    var body: some View {
        ZStack {
            CardView()
            CardView()
        }
    }
}
```

지금은 단순히, ZStack 이지만, 이곳에 데이터와 바인딩하고 제스처를 추가해줄 예정입니다.


이것으로 UI 구현은 끝났습니다. 이제 ObservableObject 나 타입들을 정의하고 바인딩하겠습니다.


2. ObservableObject 구성

먼저 struct로 카드에 대한 데이터 타입을 정의하겠습니다.

 Quiz  타입을 정의합니다.

```swift
struct Quiz {
    let question: String
    let answer: String
}
```

 그리고 Card를 정의합니다.

```swift
struct Card: Identifiable {
    var card: Quiz
    var id = UUID()
}


extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.card.question == rhs.card.question
        && lhs.card.answer == rhs.card.answer
    }
}
```
Identifiable 을 통해 유일성을 부여했습니다.

Equatable 을 통해 동일성검증 가능하도록 구조체를 정의합니다.


마지막으로 카드들을 모두 가지고 있는 Deck 클래스를 정의합니다.

```swift
class Deck: ObservableObject {
    @Published var cards: [Card]
    
    init(from cards: [Quiz]) {
        self.cards = cards.map { Card(card: $0) }
    }
}
```
View에서 관찰할 수 있도록 ObservableObject 프로토콜을 채택합니다.

UI 업데이트에 관찰될 객체를 cards 로 하기 위해서 @Published 로 프로퍼티를 감싸줍니다.

초기화 메소드에서, 입력받은 [Quiz] -> [Card] 로 타입변경을 해줍니다.


DeckView -> CardView 로 각각의 카드에 대한 정보를 전달해줘야겠죠. 그래서 cardView에서 데이터를 받을 준비를 합니다.

먼저 멤버변수로 Card를 정의합니다.

```swift
struct CardView: View {
    var card: Card
  ... 
}

```
body 프로퍼티 내부에 Text의 StringProtocol 파라미터 부분을 변수로 변경합니다.

```swift
Text(card.quiz.question)
...
Text(card.quiz.answer)
```

꼭 해줘야하는 건 아니지만, 에러가 보기 싫으니 Preview도 다음과 같이 수정합니다.

```swift
struct CardView_Previews: PreviewProvider {
    @State static var card = Card(quiz: quiz01)
    
    static var previews: some View {
        CardView(card: card)
            .previewLayout(.device)
    }
}
```

이제 DeckView에서 card 값을 초기화시점에 전달해주면 데이터가 CardView로 전달됩니다.

```swift
struct DeckView: View {
    
    @StateObject var deck = Deck(from: quizBundle)
    
    var body: some View {
        ZStack {
            ForEach(deck.cards) { card in
                CardView(card: card)
            }
        }
    }
}
```
StateObject의 전체를 전달하는게 아니라 @Published 로 감싸진 프로퍼티 cards 만 전달해야하는 부분 유의하세요~!


여기까지 하면 UI에 대한 작업과 데이터 연결까지는 끝났습니다. 이제 ZStack으로 쌓여있어서 보이지 않는 뒷 카드들을 봐야겠죠. 제스처를 추가해서 FlashCard 기능구현을 마무리하겠습니다.


3. Gesture

좌측이나 우측으로 카드를 움직이면, 움직인 위치를 파악해서 card를 오른쪽으로 사라지거나 왼쪽으로 사라지게 하려고 합니다. 그러기 위해서는 아래 사항들을 구현해야 할겁니다.

gesture 인식

gesture 구분 ( left or right)

Drag에 의한 객체 위치 이동(Transition)

Drag 종료 이후에, 카드 이동 (DragGesture + onEnded)

 하나씩 추가해보겠습니다.


먼저 좌측이동인지 우측이동인지 확인하기 위해 enum 을 정의합니다.

```swift
enum DismissCardDirection {
    case left
    case right
}

```
드래그가 되는 뷰는 "CardView"입니다. 이곳에서 드래그에 관련된 제스쳐와 애니메이션을 추가해주겠습니다.

```swift
struct CardView: View {
  ...
  @State var offset: CGSize = .zero
  
  var body: some View {
    let drag = DragGesture()
      .onChanged { offset = $0.translation }
    
    return ZStack {
      ...
    }
    ...
    .animation(.spring(), value: offset)
    .offset(offset)
    .gesture(drag)
  }
}
```
offset을 통해서 카드위치가 이동할 때마다, 이동한 위치로 변경해줍니다.

translation 프로퍼티는 시작위치와 변경된 위치의 차이값을 가지는 프로퍼티입니다. 드래그된 객체의 이동한 거리만큼을 offSet에 할당하여 위치를 이동시킵니다.

애니메이션으로는 spring 효과를 줄 예정이고, animation되는 값은 offset입니다

뷰의 위치는 offSet에 맞게 변경됩니다.

마지막으로 gesture를 추가해줘서 상호작용할 수 있도록 해줍니다. 


여기까지하면, 다음과 같이 실행됩니다.
![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-22 at 12 24 06](https://user-images.githubusercontent.com/65879950/155059498-35bcea06-9dac-4b8e-bc92-aa9e846fd3c6.gif)


이제 좌측으로 이동했는지 혹은 우측으로 이동했는지에 따라서 카드가 사라지도록 하려고합니다.

먼저 CardView에서 드래그에 값에 따른 카드 위치를 변경하는 로직을 추가해줍니다.

```swift
let drag = DragGesture()
    .onChanged { offset = $0.translation }
    .onEnded {
        // move left
        if $0.translation.width < -100 {
            // dismiss left
            offset = .init(width: -1000, height: 0)
            // memorized card
            dragged(card, .left)
            
        // move right
        } else if $0.translation.width > 100 {
            // dismiss right
            offset = .init(width: 1000, height: 0)
            // memorized card
            dragged(card, .right)
        
        // move in the middle
        } else {
            // move base
            offset = .zero
        }
    }
```
그리고 미쳐 추가하지 않았떤 프로퍼티와 typealias를 추가합니다.

```swift
    typealias CardDrag = (_ card: Card,
                          _ direction: DismissCardDirection) -> Void
    let dragged: CardDrag
```
이번 기능구현에서는 외운카드와 안외운 카드에 대한 로직은 구현은 안하지만, 이렇게 해당 데이터를 주고받을 수 있도록 처리는 해주겠습니다.


init코드를 수정합니다.

```swift
   init(
        card: Card,
        onDrag dragged: @escaping CardDrag = {_, _ in }) {
            self.card = card
            self.dragged = dragged
        }
```
마지막으로 DeckView에서 카드뷰의 선언을 수정합니다.

```swift
struct DeckView: View {
    
    @StateObject var deck = Deck(from: quizBundle)
    
    let onMemorized: (Card) -> Void = { _ in }
    
    var body: some View {
        ZStack {
            ForEach(deck.cards) { card in
                CardView(card: card) { card, direction in
                    if direction == .left {
                        onMemorized(card)
                    } else {
                        // do something
                    }
                }
            }
        }
    }
}
```
그리고 실행하면 다음과 같이 동작합니다.
![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-22 at 12 33 45](https://user-images.githubusercontent.com/65879950/155059556-9ff87c38-e89d-4e28-be9d-1ef7b8443583.gif)




정리
이번에 사용한 개념들을 정리해보겠습니다.

ObservableObject 를 구성하여, 외부객체의 프로퍼티로부터 View의 UI를 업데이트하도록 구성했습니다.

DragGesture 와 translation 프로퍼티를 이용해서 객체의 위치 변경을 여부를 확인했습니다.

확인한 위치로 animation 을 부여했습니다. 

마지막으로는 offset 과 gesuter 를 추가해주면서 위에 구성한 드래그와 이동하는 애니메이션이 동작하도록 했습니다.

읽어주셔서 감사합니다.
## 참고자료
- https://www.raywenderlich.com/books/swiftui-by-tutorials/v4.0/chapters/11-gestures#toc-chapter-015-anchor-001
