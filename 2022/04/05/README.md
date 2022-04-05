# Xcode 환경분리예제

## 결론

> Target 을 2 개로 나누고, 각각 Info.plist 를 이용하여, 다른 환경에서 동작하도록 한다.

---

## 개요

 실제 프로덕트를 운영하는 팀에서, 하나의 Target으로만 앱을 구성하진 않을겁니다. 이름은 여러가지겠지만, 맥락은 같으리라 봅니다. "로컬 / 개발용 / 통합 / QA(혹은 RC=Release Candidate) / Staging / Production" 으로 나뉩니다.  (나누는 기준은 맥락에 맞게 유연하게 하리라 생각함.) 이렇게 프로젝트를 나눠서 관리해야, 현재 상용화되고 있는 앱에 영향을 주지 않으면서 동시에 개발하기에 용이합니다. 이것을 "개발 환경 분리" 라고 합니다.
 개발환경 분리란, 개발 환경(Phase) 는 어플리케이션이 동작하는 '환경' 을 의미합니다. 개발환경을 그렇다면 왜 분리할까요?

이유는 "목적에 맞는 다양한 환경조성" 입니다. 각 단계별 자세한 내용은 아래 글을 참조해보시면 큰 도움이 될겁니다.

- 개발환경 분리 설명글 1: https://jungseob86.tistory.com/11
- 개발환경 분리 설명글 2: https://bcho.tistory.com/759
- iOS Tutorial : https://cocoacasts.com/tips-and-tricks-managing-build-configurations-in-xocde

## 배경지식

### Target

공식문서 : https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Targets.html

<img width="401" alt="image" src="https://user-images.githubusercontent.com/65879950/161719038-e5f84e50-6cfc-4537-965d-1957605ef6b8.png">


 Target 은 빌드하게될 product를 선택합니다. 그리고 빌드할 때, 어떤식으로 빌드할 지, 설정들을 위한 Resource&Source 를 가지고 있습니다. (ex. Asset / Xib / Info.plist / swift파일들)Target : product = 1: 1 관계입니다. 동시에, Project : Target = 1 : N 관계 입니다. 정리하면, 하나의 프로젝트에는 다수의 타겟이 있고 다수의 타겟 갯수 만큼 프로덕트가 있습니다.
 Target 은 다른 Target 에 의존할 수 있습니다. (하나가 다른 하나에 종속된다는 뜻) Xcode 가 알아서 두 Target의 종속성을 파악하고 순서대로 빌드합니다. 이러한 관계를 "암시적 종속성" 이라고 합니다. 또한 이를 커스텀하게 종속하지 않도록 할 수도 있습니다.

정리하면 다음과 같습니다.

1. Target은 빌드할 때, 어떻게 빌드할 지 구성된 하나의 프로덕트다.
2. 하나의 Target은 다른 Target에 종속관계를 가질 수 있다.
3. 하나의 Target 은 하나의 프로덕트다.

## 구현

- 먼저 프로젝트를 생성하시고, 타겟을 아래와 같이 복사합니다.

<img width="400" alt="image" src="https://user-images.githubusercontent.com/65879950/161719090-b318c58c-3c7f-4ed4-9ff6-cd6b0df0f3ad.png">


- 그러면 다음과 같이 뭐가 많이 생길겁니다.

<img width="564" alt="image" src="https://user-images.githubusercontent.com/65879950/161719120-3ab13986-9e72-40cb-ba00-d5541a9d4910.png">


- 이제 이름을 바꿔줍니다.(클릭하고 엔터치면됩니다.)

<img width="239" alt="image" src="https://user-images.githubusercontent.com/65879950/161719196-9166f6c6-9759-4dca-916e-3efa1dc98e7e.png">


- 빌드 환경에 Target이 복사되어있는지 확인합니다. 거기서 "Manage Schemes" 를 클릭합니다.

<img width="900" alt="image" src="https://user-images.githubusercontent.com/65879950/161719228-e1208457-40f4-45ef-8b55-03454884dbca.png">



- 들어가보면 다음과 같이 되어있을겁니다.

<img width="901" alt="image" src="https://user-images.githubusercontent.com/65879950/161719254-31eb1ad9-3d74-4203-a845-2ad7aa5584be.png">



- 이름을 변경하지 말고 삭제하시고 두 개의 타겟을 각각 다시 만들어줍니다.

<img width="896" alt="image" src="https://user-images.githubusercontent.com/65879950/161719284-ce3e2d80-cd1f-4bd2-8494-56a1b9afe6d2.png">


- 이제 Info.plist의 이름을 변경해줍시다.

<img width="239" alt="image" src="https://user-images.githubusercontent.com/65879950/161719304-20425dbe-9f7c-4f83-8910-89f172c8c6b1.png">


- Info.plist 위치를 변경하거나 이름을 변경해주면 Build settings > Packaging 에서 값을 꼭 변경해주어합니다. 그곳으로 갑시다.

<img width="907" alt="image" src="https://user-images.githubusercontent.com/65879950/161719342-009d8e63-c5dd-444e-82a9-a850f262ee3c.png">


- 그리고 Development의 Info.plist의 이름도 변경해줍시다. (이 때, 폴더위치에 따라서 폴더 경로가 달리질 수 있으니 유의하세요. 전, 생긴 그대로 했기때문에, 폴더위치 경로가 최상위입니다. 그래서 "/" 가 없습니다.)

<img width="896" alt="image" src="https://user-images.githubusercontent.com/65879950/161719369-8a54f76b-088e-453e-a653-7a3ce5e18eb6.png">

- 전처리문에서 타켓을 확인하고 싶으시다면, 아래 설정을 해주시면됩니다. (안해도됨)

<img width="900" alt="image" src="https://user-images.githubusercontent.com/65879950/161719400-cc2898c5-ba43-4339-8d5d-4fb2488a1233.png">



- SceneDelegate 에 아래와 같이 코드를 작성해서 로그를 찍어보면 나옵니다 (위에것 안했으면 안나옴)

```swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        #if Dev
            print("현재 개발 타겟입니다.")
        #else
            print("현재 제품 타겟입니다.")
        #endif
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
```



- 혹시 라이브러리를 설치하신다면, 새롭게 생성된 Target 에도 꼭 추가해주세요

  (위치 : Project > Targets > 새로추가한타켓 > General > Frameworks, Libraries, and Embeded Content)

<img width="867" alt="image" src="https://user-images.githubusercontent.com/65879950/161719436-804adb45-4229-4991-bbf9-844e19d95f0a.png">

​	저는 SnapKit 을 추가했습니다.

- 추가로 이름을 변경하고 싶으시면, 바로 변경하시거나 이곳에서 변경하셔도 됩니다.

<img width="898" alt="image" src="https://user-images.githubusercontent.com/65879950/161719471-afaaa55c-346b-499f-91e1-ee1c7d49219b.png">


그리고 프로젝트에 Swift파일을 추가하다보면, cannot find 에러가 발생할 수 있는데, 아래 글을 참조하시면 큰 도움이 되실겁니다.

https://www.zehye.kr/ios/2021/09/03/iOS_target_membership/







### 참고자료

-  https://cocoacasts.com/tips-and-tricks-managing-build-configurations-in-xocde
- https://vapor3965.tistory.com/97
- https://leechanho.tistory.com/48
- https://jungseob86.tistory.com/11
- https://hongdonghyun.github.io/2020/06/iOS-환경변수-분리하기/
- https://xtring-dev.tistory.com/entry/iOS-Xcode-Pro-처럼-빌드환경-세팅하기
- https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Targets.html
