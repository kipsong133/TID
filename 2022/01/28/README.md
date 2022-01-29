# Today, I learned: Compositional Layouts

2019's WWDC 에서 다음과 같은 내용이 추가됩니다.

> Advances in Collection View Layout

  이 발표는 "Compositional Layout" 에 대한 발표입니다.



## Compositional Layout 이걸 왜 만든걸까?

결론부터 말씀드리면, 발표에서도 언급하듯,

바로 "복잡한 인터페이스의 요구사항의 증가" 때문입니다.

iOS 앱 중에서 "사진첩" 이나 "앱 스토어" 의 레이아웃을보면, 순수하게 기존 기능들만으로는 구현하기 어려운 UI 들이 많이 있습니다.
예를들면, 컬렉션뷰 안에 컬렉션뷰를 다시 넣는 경우라든지 말이죠. 트릭들을 사용해서 구현을 하려고 하면 불가능한 부분은 아닙니다.
다만, 이런 생각이 들긴하죠.

> 아니, 이렇게 자주 사용되고 그러면, 애플에서 제공해줬으면 얼마나 좋을까?

그래서 제공해주었습니다.

"Compositional Layouts" 

단어 뜻처럼, 우리가 원하는 대로 구성할 수 있는 레이아웃을 의미합니다.
Pinterest나 Instagram 앱에서 보면, 검색 부분에 이미지의 크기가 가지각색으로 배치되는 경우가 있죠?
그런 경우에 이 기능을 사용해서 구현 가능합니다.



<img width="751" alt="image" src="https://user-images.githubusercontent.com/65879950/151654217-dd70598b-1163-4f43-b104-262dd4b4c017.png">


(링크 : https://developer.apple.com/videos/play/wwdc2019/215/)

발표에서, 요즘의 앱들은 많이 복잡하고, 다양하다고 합니다.
그러면서 App Store를 예시로 들고 있습니다.
이러한 다양한 요구사항에 편리하게 구성하도록 기능을 추가한 것이 "Compositional Layout" 입니다.

 물론 이전에도 앱스토어와 같은 화면을 구현하지 못할 이유는 없습니다. 수직으로 UITableView or UICollectionView를 사용하면 되고, UICollectionViewCell 안에 다른 UICollectionView를 넣어서 구현하면 되는 거죠. 사실 저도 이전까지는 그러한 방식으로 구현해왔습니다. 많은 앱들이 이러한 기능들을 구현하고 있는데, 어찌보면 Trick처럼 이용해서 문제를 해결해왔죠. 

이것에 대해서 공식적으로 기능을 구현한 것이 Compositional Layout 이라고 생각하시면 되겠습니다.



## 그러면 Compositional Layout이 뭔데?

 1장의 사진으로 설명하라고 하면, 아래 사진을 보시면 됩니다.

<img width="431" alt="image" src="https://user-images.githubusercontent.com/65879950/151654240-2148254c-6c46-404a-9972-fe065ff7af3a.png">


- Section안에 Group이 있고, Group 안에 Item 이 있습니다.
- Section은 가장 큰 단위의 묶음입니다. 코드를 작성할 때, Section은 group에 대한 값에 대해 의존성을 주입받아야 합니다. 
- Group의 경우 Item에 대해 의존성을 주입받아야 하구요.
- 그림을 보시면, 그륩 안에 Item이 하나를 받을 수도 있지만, 여러개를 가지고 있기도 하죠. 이것도 구현 방식에 따라서 여러개를 넣을 수도 있는 겁니다.



## 그러면, 어떤식으로 구성해야하는데?

이것에 대한 질문은, 사실 내용이 길기도 해서, 다음에 프로젝트와 함께 다시 작성할 예정입니다.

그전에 대략적인 아웃라인만 설명드리고, 다음글에서 프로젝트로 작성하겠습니다.



```markdown
ViewController

- CollectionView

  - UICollectionViewLayout 

    - UICollectionViewCompositonalLayout 

      (여기서 Section별로 어떤 Layout을 생성해줄지 결정합니다.)

      

  - UICollectionViewDiffableDataSoure

    (여기서 어떤 cell을 생성할 지, 구체적으로 결정합니다. like cellForItemAt)

    - NSDiffableDataSourceSnapshot

      (DiffableDataSoure는 snapshot을 통해서 UICollectionView에 데이터를 전달합니다.
      물론 데이터구성이므로 DataSoure에 적용하고 Datasoure에 collectionView에 의존성을 주입해줍니다.)

      - Sections (복수가능)
      - Items (복수가능)


```



전반적인 계층구조는 이런식으로 구현되어 있습니다.

DataSoure가 데이터 및 UI 구성에 관한 모든 로직을 담당하고 있습니다. 
Section은 어떤식으로 구성할지는 `supplementaryViewProvider`를 이용하고,
Item은 `UICollectionViewDiffableDataSource` 초기화 할 때, Parameter로 IndexPath를 받으므로, 그에 맞게 cell을 리턴해주로고 처리하면 됩니다. (cellForItemAt과 동일합니다.)

간략한 코드로 보면 다음과 같습니다.

```swift
dataSoure = UICollectionViewDiffableDataSoure<Section, CellItem>(collectionView: collectionView) {
  (collectionView: UICollectionView,
   indexPath: IndexPath,
   cellItem: CellItem) -> UICollectionViewCell? in
  // cell을 생성
  let section = Section.....
  switch section {
    case .profile:
    ...
    return cell
    case .myPostings:
    ...
    return cell
  }
  
  // header생성
  dataSource.supplementaryViewProvider = {(
  	collectionView: UICollectionView,
    kind: String,
    indexPath: IndexPath) -> UICollectionViewReusableView? in 
  	
		guard let supplymentaryView = collectionView.dequeue...SupplymentaryView(...)
	  ...
		return supplymentaryView
  )}
	
	// snapshot 등록
	let snapshot = NSDiffableDataSourceSnapshot<Section, CellItem> ... 
	dataSource.apply(snapshot, animatingDifferences: false)
```

위코드는 Section에 어떤 cell을 넣을 것이고, Header는 어떤걸로 만들 지만 결정한 코드입니다.



아직 우리가 원하는 Layout에 대한 커스텀은 이뤄지지 않은 상태입니다.

위에서 작성한 계층을 봐도 두 개는 병렬적으로 구성되고 있죠?

```markdown
- CollectionView

  - UICollectionViewLayout 

    - UICollectionViewCompositonalLayout  <=== 이제 이것에 대해 이야기하려고 합니다.

	  - UICollectionViewDiffableDataSoure
```



layout객체는 collectionView를 생성할 때, 주입해주는 객체입니다.

```swift
let collectionView = UICollectionView(
  frame: containerView.bounds,
	collectionViewLayout: customLayout()) // <---
```



> 그러면 어떤식으로 Layout을 만들까요?



`UICollectionViewCompositionalLayout`객체를 통해서 만듭니다.

```swift
func createPerSectionLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        let columns = sectionIndex == 0 ? 2 : 4
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                          subitem: item,
                                                            count: columns)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    return layout
}
```

- 이런식으로 item을 group에 넣고 group을 section에 넣고 section을 layout에 넣습니다. 그리고 해당 값을 리턴합니다.
- 리턴을 해줘서 collectionView에 주입해주면 끝입니다.
- 여기서 section별로 다양하게 값을 넣어주고 싶으시면, enum으로 나눠주고 switch로 개별적으로 구현하면됩니다. (이부분은 다음 글에서 코드로 작성하겠습니다.) 이것이 가능한 이유는,  `sectionIndex` 라는 색션에 대한 정보를 파라미터로 전달받기 때문입니다.



## 정리

기존에 DataSoureDelegate로 모든걸 처리해보다보니, 조금 생소한 감은 있습니다만,

이렇게 구성되어 있어서, dataSoure를 객체로 따로 빼두면, 코드가 훨씬 깔끔하겠다라는 생각도 듭니다. 그리고, 기존에 트릭을 통해서 구현하던 것들을 많은 부분 대체할 수 있다고 생각하니, 훨씬 코드가 읽기도 좋아질 것 같습니다.



다음 글에서는 구체적으로 코드를 작성하면서 다시 복습해보려고합니다.



읽어주셔서 감사합니다.







