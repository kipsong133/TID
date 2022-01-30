# Today, I learned : UITableView를 Rx를 이용하여 만들기

Rx를 이용해서 가장 기본적인 UITableView를 만드는 법에 대해서 정리해보겠습니다.

#### 구조

|Observable| ---(bind)--- |UITableView.rx.items|

이렇게 이어주기만 하면 끝입니다.

앞으로 UICollectionView나 다른 UI와 엮어보기도 할 텐데, 원리는 동일합니다. 



#### 구성

1. Cell을 구성합니다.

```swift
import UIKit
import SnapKit

class WishListCell: UITableViewCell {
    static let reuseIdentifier = "WishListCell"
    
    let wishItemLabel = UILabel()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupData(_ data: String) {
        wishItemLabel.text = data
    }
    
    
    private func setupAttribute() {
        wishItemLabel.font = .systemFont(ofSize: 15)
        wishItemLabel.textColor = .darkGray
        wishItemLabel.textAlignment = .center
    }
    
    private func setupLayout() {
        contentView.addSubview(wishItemLabel)
        wishItemLabel.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
```

- SnapKit을 이용해서 UI를 구성했습니다.
- Rx 사용전과 크게 다를 바는 없습니다.



2. ViewModel 을 만듭니다.

```swift
import RxSwift
import Foundation

class MainViewModel {
    
    var wishItem: [String]

    init() {
        // dummy data
        wishItem = ["MacBook M1 Pro", "iPhone 13 Pro max", "iPad Pro 15"]
    }
    
    func getCellData() -> Observable<[String]> {
        return Observable.of(wishItem)
    }
}
```

- getCellData에서 옵저버블을 생성해서 리턴해주고 있습니다. 그리고 wishItem을 of를 통해서 전달해주어서 이벤트를 생성하고 있습니다.
- `getCellData` 에 파라미터로 값을 전달받아도되고, 서버를 통해서 전달받는 경우는 여기서 다시 다른 옵저버블에서 호출해야겠죠?



3. ViewController를 구성합니다.

```swift
import RxCocoa
import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    
    // MARK: - Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Lifecycle
extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttribute()
        setupLayout()
    }
}

// MARK: - Binding
extension MainViewController {
    public func bind(_ viewModel: MainViewModel) {

        viewModel.getCellData().bind(to: tableView.rx.items) {
            (tableView: UITableView,
             index: Int,
             element: String)
            -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListCell.reuseIdentifier) as? WishListCell else { fatalError() }
            cell.setupData(element)
            return cell
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Helpers
extension MainViewController {
    
    func setupAttribute() {
        tableView.register(WishListCell.self, forCellReuseIdentifier: WishListCell.reuseIdentifier)
        tableView.rowHeight = 100
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
```

- 위 코드에서 일부분만 따로 보겠습니다.



```swift
// MARK: - Binding
extension MainViewController {
    public func bind(_ viewModel: MainViewModel) {

        viewModel.getCellData().bind(to: tableView.rx.items) {
            (tableView: UITableView,
             index: Int,
             element: String)
            -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListCell.reuseIdentifier) as? WishListCell else { fatalError() }
            cell.setupData(element)
            return cell
        }
        .disposed(by: disposeBag)
    }
}
```

- bind 함수는 viewModel을 주입받아야 합니다.
- public 이라고 선언한 것처럼, 외부에서 주입해줍니다.
- 이후에 viewModel에 있는 Observable<String> 과 tableView를 바인딩합니다.
- 이후 코드는 `cellForRowAt`처럼 구성하면 됩니다.



참고로 SceneDelegate에서 viewModel을 전달하고 바인딩해주고 있습니다.

- SceneDelegate.swift

```swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let mainViewModel = MainViewModel()
        let rootViewController = MainViewController()
        rootViewController.bind(mainViewModel)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
```



#### 시뮬레이터 모습

<img width="542" alt="image" src="https://user-images.githubusercontent.com/65879950/151701624-82fc8ca2-92bd-4a17-817c-35609a67f8b0.png">




## 정리

이번 글은 아주 기본적인 UITableView를 Rx로 구성했습니다. 이후에 글에서는 이곳에 하나씩 살을 붙인 글을 작성 예정입니다.



읽어주셔서 감사합니다.
