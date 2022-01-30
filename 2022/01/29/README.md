# Today, I learned: Render Loop

우리가 AutoLayout을 하나 연결하게 되면, iOS는 어떤 과정으로 화면을 그리게 되는지에 대해서 알아보고자 합니다.


먼저 전반적인 흐름을 설명드리겠습니다/

#### Event phase

- 이벤트를 전달하여, 상태를 변경하는 과정입니다.
- ex) Touch / Networking / Keyword / Timers



우리가 화면을 터치하거나, 네트워킹요청이나 키보드가 나타나거나 사라지는 애니메이션 그리고 타이머와 같은 트리거의 역할을 하는 것들을 이벤트라고 칭합니다.

아래 예시를 보면서 설명드릴게요.

1. 배경색을 변경하는 이벤트가 호출되었습니다. (setBackgroundColor 메소드를 호출한다.)

![image](https://user-images.githubusercontent.com/65879950/151690618-f35e03ab-0832-441c-b327-2ada1da5426b.png)


- 여기선 단순히 이벤트가 호출되었고, 이제 상태가 변해야 하는 시작점이 됩니다.



2. Bounds 값을 설정합니다.

![image](https://user-images.githubusercontent.com/65879950/151690647-6922899d-7528-4027-a77d-636b203bcb4e.png)


- 각 하위 뷰들의 Bounds 값을 정해줍니다. Bounds는 View 자기 자신을 기준으로 결정하는 좌표계입니다. (frame은 superView를 기준으로 잡은 좌표계입니다.)

- 마치, Bounds를 잡는 것은 View 각각의 차지할 크기나 각자가 가지고 있어야할 범위를 가지고 있는 개념으로 이해됩니다. 즉, 아직은 View 간의 관계는 정의되지 않은거죠. 그냥 각자 자기 자신의 값을 소유하고 있는 겁니다. 



3. setNeedsLayout 메소드를 호출하여 하위 뷰들에 대해서 Layout을 설정합니다.

![image](https://user-images.githubusercontent.com/65879950/151690654-14f11d41-02b0-4bf9-b7c6-231301ba3eff.png)


- 레이아웃을 구성할 때, 자기 자신의 크기만 안다고 배치할 수는 없겠죠. 이제 각각의 뷰들 간의 관계인 Layout을 부여합니다. 그러면 각각의 뷰들이 어디에 위치해야하는지도 알 수 있고, 이전단계에서 어느정도의 크기를 가지고 있는지도 알 수 있으니 위치를 잡아둘 수 있겠죠.
- 하지만, 아직 어떻게 그릴지는 결정하지 않은 상태입니다. 그냥 위치와 크기만 결정한 상태라고 생각하시면 되겠습니다.



#### Commit phase



1. Layout을 위치시키고, 그리고 그림을 그리도록 실행합니다.

![image](https://user-images.githubusercontent.com/65879950/151690658-b4eac17d-8636-45f2-a334-bb39c5973637.png)




2. Layout 에서 Draw로 `setNeedDislay`를 통해 다음 드로잉 사이클 때, 해당 layout을 그리도록 메시지를 전달하고 있습니다.

![image](https://user-images.githubusercontent.com/65879950/151690668-6d589c14-86e7-4540-ba26-22aeea3042cd.png)




#### Render prepare phase



1. 메시지를 받았으니, 그릴 준비를합니다.

![image](https://user-images.githubusercontent.com/65879950/151690673-042a4634-6465-4e91-8ad7-a93089762dd9.png)



(위에서부터 아래로 랜더링함)

- 영상에서는 멘 위에 회색 뷰부터 맨아래 뷰 까지 순차적으로 진행합니다. 즉, Rendering은 최상위 View 부터 하위 View 로 진행됨을 알 수 있겠죠.



#### Render execute phase



1. 준비를 마친 뒤, "Core Animation is Fun" 이라는 문구가 있는 그림을 랜더링합니다.

![image](https://user-images.githubusercontent.com/65879950/151690678-07ff2cb0-0c9f-4f10-9e18-4170df8d73e3.png)




#### Render Loop

![image](https://user-images.githubusercontent.com/65879950/151690680-4f210047-0907-4394-9ffb-c47033e47ee6.png)


- 랜더 루프는 모두 개별적으로 동작합니다. 즉, 비동기적으로 동작하죠. 하지만 동작 내에서는 serial 하게 동작합니다.
- App -> Render server -> Display 이런식으로 순서대로 동작합니다.



## Render Loop 실습

그러면, 어떤식으로 호출되는지 print 메소드의 도움을 받아 확인해보겠습니다.

![image](https://user-images.githubusercontent.com/65879950/151690685-a6a3227a-6e81-4739-b011-41249c7da8f2.png)


- 녹색뷰가 "SuperView" 이고, 보라색뷰가 "SubView" 입니다.

코드는 아래와 같습니다.

- ViewController.swift

```swift
import UIKit

class ViewController: UIViewController {
    // 메모리에 로드할 때, 호출
    override func loadView() {
        super.loadView()
        print("ViewController: loadView 호출")
    }
    
    // 메모리에 로드된 이후에 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController: viewDidLoad 호출")
    }
    
    // display 되기 직전에 호출
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController: viewWillAppear 호출")
    }

    // 제약조건을 업데이트 할 때, 호출
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("ViewController: updateViewConstraints 호출")
    }
    
    // 하위 뷰의 레이아웃을 계산할 때, 호출
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ViewController: viewWillLayoutSubviews 호출")
    }
    
    // 하위 뷰의 레이아웃을 계산을 마친 후, 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ViewController: viewDidLayoutSubViews 호출")
    }
}
```



- SuperView.swift

```swift
import UIKit

class SuperView: UIView {
    
    override func updateConstraints() {
        super.updateConstraints()
        print("SuperView: UpdateConstraints 호출")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        print("SuperView: setNeedsLayout 호출")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("SuperView: layoutSubviews 호출")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("SuperView: draw 호출")
    }
}
```



- SubView.swift

```swift
import UIKit

class SubView: UIView {
    
    override func updateConstraints() {
        super.updateConstraints()
        print("SubView: UpdateConstraints 호출")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        print("SubView: setNeedsLayout 호출")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("SubView: layoutSubviews 호출")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("SubView: draw 호출")
    }
}
```



- 특별한 로직은 전혀 없고, 단순히, 어떤 메소드가 어떤 타이밍에 호출되는지 print 문만 작성한 코드입니다.

- 실행결과는 아래와 같습니다.

```markdown
# 메모리에 저장
ViewController: loadView 호출
ViewController: viewDidLoad 호출
ViewController: viewWillAppear 호출

# Constraint 계산 (SubView -> SuperView -> ViewController 순으로 실행)
SubView: UpdateConstraints 호출
SuperView: UpdateConstraints 호출
ViewController: updateViewConstraints 호출

# Layout 구성 (ViewController -> SuperView -> SubView 순으로 실행)
ViewController: viewWillLayoutSubviews 호출
SuperView: setNeedsLayout 호출
SuperView: setNeedsLayout 호출
SuperView: setNeedsLayout 호출
SuperView: setNeedsLayout 호출
ViewController: viewDidLayoutSubViews 호출
SuperView: layoutSubviews 호출
SubView: layoutSubviews 호출
SubView: layoutSubviews 호출

# 화면에 그리기 (SuperView -> SubView 순으로 실행)
SuperView: draw 호출
SubView: draw 호출
```

- 메모리에 먼저 객체를 저장합니다.
- 그리고 Constraint를 하위뷰 부터 조건을 구성합니다.
- Layout은 다시 위에서 부터 아래로 내려갑니다.
- 마지막으로 랜더링도 위에서 아래로 내려갑니다.



조금 이 말을 쉽게 설명하자면, 아래처럼 되지 않을까 생각합니다.

> 1. 일단, 메모리에 올려둬봐. 
> 2. AutoLayout으로 그려져있네, 그러면 방정식을 풀 듯이 각각의 방정식(x, y, width 그리고 height에 대한 방정식)을 풀어야겠네, 한 번 식 세워봐 어떤 객체랑 어떤 객체가 서로 관계식을 가지고 있는지.
> 3. 이제 방정식 모두 세웠으니까, 식에 맞게 배치를 해야지 배치하자.
> 4. 자 배치 다했다, 이제 그리기만하면된다. 그리자!



방정식이라는 말이 조금 어색하실 수도 있지만, WWDC 2018에서 다음과 같은 그림과 함께 설명하고 있는 내용입니다.

![image](https://user-images.githubusercontent.com/65879950/151690756-ea164f2f-21e1-4c0e-9f1a-a9fe97ca8def.png)


- 위 그림을 보면, View 위에 Window가 있죠? 우리가 코드로 UI를 구성하게 되면 다음과 같은 코드에 익숙하실 겁니다.

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
    var window: UIWindow?
  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = ViewController()
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
}
```

여기서 보면, window를 생성해서 할당하고 있죠. 그안에 들어가있는 것은 UIViewController 입니다. 이 구조를 생각하시면 좋을 것 같아요.

- Window 아래 보면, "Engine" 이 있죠. 엔진은 말그대로 이 Constraint가 동작하도록 해주는 동력원입니다. View에서 Constraint를 부여한다는 것은 방정식을 세우는 겁니다.
- 해당 방정식을 View가 계산할리는 없겠죠. 그 계산을 Engine이 해줍니다.
- 그래서 Engine 하위에 Equation 이라는 박스가 있죠.
- 그렇게 Engine이 방정식을 세워서 view에게 주면, 이후 방정식은 적절한 x, y, width 그리고 height 값만 넣어주면, 방정식이 바로 풀리겠죠.
- 그 결과에 따라서 Constraint 조건을 모두 설정하게 됩니다.
- 만약 Constraint가 추가되거나 변경되게 되면, 방정식을 새롭게 구성하게 됩니다.





참고로 방정식을 연산하는 Engine의 과정입니다.

- Engine이 Constraint 방정식을 푸는 과정

![image](https://user-images.githubusercontent.com/65879950/151690768-52841ae4-8a63-4748-b145-15e40303cd47.png)


![image](https://user-images.githubusercontent.com/65879950/151690775-04a23544-f586-4f42-918d-add9b91b105a.png)
- UpdateConstraint 과정에서 Engine이 값들 모두 연산했다면, View에게 알려주고, View는 setNeedsLayout을 호출합니다.
- 그와 동시에 Constraint phase에서 Layout phase로 넘어가게 됩니다.



![image](https://user-images.githubusercontent.com/65879950/151690778-bb3f1226-1805-4697-96eb-36e114494999.png)
- 그겋게 layoutSubView가 동작하게되면, View가 엔진에게 연산한 값에 대해서 값을 확인합니다.
- 하위 뷰에게 Bounds와 Center 값을 설정하게되죠.
- 하위 뷰에 Bounds와 Center  값을 설정한다는 의미는, bounds는 말그대로 자기 자신을 기준으로 위치와 크기를 결정하는 CGRect 값입니다.(사각형 모양임) 그리고 Center는 뷰 프레임 내에서 사각형의 중심점을 결정하는 겁니다.
- 위 과정이 layout을 잡는 과정이죠. 크기는 어느정도이다. 그러니 이곳에 레이아웃을 형성하자. 이 과정인거죠.

- Bound는 크기를 가지고 있고, 자신을 기준으로 위치를 잡으므로 CGRect값이고, center는 뷰 내부에서의 위치이므로 CGPoint일 수 밖에 없겠죠.





그림으로 보면 다음과 같습니다.

1. Update Constraint (하위 뷰에서 상위뷰  순서로 계산)
![image](https://user-images.githubusercontent.com/65879950/151690786-19f61788-f7e3-4ada-b137-8ed2af2b26e4.png)


2. Layout (상위 뷰에서 하위뷰로 계산)
![image](https://user-images.githubusercontent.com/65879950/151690790-ade2e1c9-8ed9-424a-802b-48cdc56dc4fe.png)




3. Display (상위뷰에서 하위뷰로 랜더링)
![image](https://user-images.githubusercontent.com/65879950/151690795-97f8895a-f719-47d0-936c-690038a5dba2.png)




각 단계별 호출하는 메소드 혹은 호출되는 메소드들에 대한 자료입니다.(WWDC18)
![image](https://user-images.githubusercontent.com/65879950/151690797-92470304-b600-4c9b-ac2c-f93636bae446.png)


- 두 번째, 행에 보면 set으로 시작하는 것들들은, 각 단계이 있는 동작을 다음 Render Loop에 동작하도록 메뉴얼하게 추가해줍니다.
- 위 동작들은 초당 120회 정도 호출된다는 점, 그리고 각각은 동작은 병렬적으로 동작합니다.



코드를 보면서 해당 동작들이 어떻게 동작하는지와 동시에, 안좋은 케이스 그리고 개선하는 것들을 보겠습니다.



- Bad Example01

```swift
override func updateConstraint() {
  NSLayoutConstraint.deactivate(myConstraints) // <-- 비활성화
  myConstraint.removeAll()
  let views = ["text1": text1, "text2": text2]
  myConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text1]-[text2]",
                                                  options: [.aligAllFirestBaseline],
                                                  metrics: nil,
                                                  views: views)
    myConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[text1]-|",
                                                  options: [],
                                                  metrics: nil,
                                                  views: views)
  NSLayoutConstraint.activate(myConstraints) // <-- 활성화
  super.updateConstraints()
}
```

- 안좋은 케이스로 설명된 이유는, 이 제약조건은 추가와 삭제가 초당 120회 반복되기 때문입니다.



- Bad Example02

```swift
override func layoutSubViews() {
  text1.removeFromSuperView()  // <-- 상위뷰에서 제거
  text1 = nil
  text1 = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 30))
  self.addSubView(text1) // <-- 상위뷰에 추가
  
  text2.removeFromSuperView() // <-- 상위뷰에서 제거
  text2 = nil
  text2 = UILabel(frame: CGRect(x: 340, y: 20, width: 300, height: 30))
  self.addSubView(text2) // <-- 상위뷰에 추가
}
```

- 이 케이스도 마찬가지로, 상위뷰에 제거되고 추가되고가 초당 120회 반복되기에 안좋은 케이스 입니다.



#### 그러면 어떻게 개선할 수 있을까요?

- Bad Example 01 개선코드

```swift
override func updateConstraint() {
	if self.myConstraints == nil {
      NSLayoutConstraint.deactivate(myConstraints) // <-- 비활성화
		  myConstraint.removeAll()
		  let views = ["text1": text1, "text2": text2]
		  myConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text1]-[text2]",
                                                  options: [.aligAllFirestBaseline],
                                                  metrics: nil,
                                                  views: views)
    	myConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[text1]-|",
                                                  options: [],
                                                  metrics: nil,
                                                  views: views)
		  NSLayoutConstraint.activate(myConstraints) // <-- 활성화
  }
  super.updateConstraints()
}
```

- if 절에서 해당 값이 메모리에 없는지를 확인하고, 없는 경우에만 동작하도록 합니다. 그렇게 되면 초당 120회를 호출하더라도, 이미 메모리에 로드된 이후에는 반복적으로 호출될 일이 없겠죠.







## 그러면 어떻게 AutoLayout 가장 최적상태로 유지할 수 있을까?

- 영상에서는 페이스북의 타임로그처럼 된 UI를 보여주면서, 사진이 있는 경우와 없는 경우, UI가 다른데, 이것에 대한 Resource가 많이 발생한다고 말합니다.
- 그러면서 만약 없는 경우지만, 그 공간에 다른 것이 들어가지 않는다면 removeSuperView 가 아니라 isHidden을 사용하는 것이 2 번 계산할 우려가 없이게 최적화하는 방안이라고 합니다.
- 추가로, 이미지가 없는 경우의 Constraint와 있는경우 Constraint가 다른데, 모든 것들을 다시 Constraint를 구성하는 것이 아니라, 바뀌는 몇 개의 Constraint만 업데이트하는게 최적화의 팁이라고 합니다.



## 정리

- 해당 WWDC는 일단 어떤식으로 레이아웃을 형성하고 렌더링을하는지에 대해서 내부 동작을 알 수 있어서 정말 흥미로웠습니다.
- 그리고 오토레이아웃의 방정식 계산 과정도 단순화된 부분이지만 볼 수 있어서 좋았습니다.
- AutoLayout의 최적화하는 방안은 결국 몇 가지 원리를 바탕으로 생각해볼 수 있겠네요.
  1. AutoLayout의 방정식을 연산하는 Engine을 최소한으로 동작하도록 고민한다.
  2. removeSuperView 했다가 다시 생성하는 경우, 모든 레이아웃을 다시 연산해야하므로, 가능하면 isHidden을 활용하자.(1번과 맥락은 동일)
  3. (마지막은 개인적인 아이디어입니다.) Constraint 방정식을 연산할 때, 두 객체 사이에 하나의 방정식으로 하는 것은 어째든, 연산을 할 때, 지연시키는 로직이 조금이나마 추가된다고 생각합니다. 예를들면, `A객체.bottom = B객체.top + 20` 이라는 방정식이 있다면, Constraint는 하위 뷰부터 시작하는데 A객체와 B객체를 모두 가진 SuperView를 연산하기 전까지 해당 식이 풀리지 않을 겁니다. 이렇게 다른 슈퍼뷰 안에 있는 서브뷰와 방정식을 세우면, 아주 조금차이일지 모르겠지만, 연산에 시간이 더 소비될 것 같습니다. 가능하면, 자신의 슈퍼뷰 내에서 해결하려는 습관이 조금이나마 성능 개선에 도움이 될 것 같네요.



읽어주셔서 감사합니다.





#### 참고자료

- https://developer.apple.com/videos/play/wwdc2018/220/

- https://developer.apple.com/videos/play/tech-talks/10855/

- https://caution-dev.github.io/wwdc/2019/02/11/WWDC-2018-High-Performance-Autolayout.html
- https://medium.com/@duwei199714/ios-why-the-ui-need-to-be-updated-on-main-thread-fd0fef070e7f
- https://junyng.tistory.com/38
- https://stackoverflow.com/questions/54018668/trying-to-understand-render-loop-of-autolayout-in-ios
