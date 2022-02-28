# Today, I learned:Packge 만들어서 프로젝트에 추가하기

 오늘은 객체들을 모듈화하기 위한 Package 생성 방법에 대해 정리해보겠습니다.



## 구현

 간단하게 프로젝트를 하나 만들어줍니다.

<img width="1275" alt="image" src="https://user-images.githubusercontent.com/65879950/155955937-076f54be-3007-42d3-98bc-4c5c8b2266ba.png">

Xcode 탭바 중에서 File > new > Package 를 클릭합니다.

<img width="739" alt="image" src="https://user-images.githubusercontent.com/65879950/155955969-91c69dd1-e529-4885-9019-b3f3c73d5410.png">


<img width="1039" alt="image" src="https://user-images.githubusercontent.com/65879950/155956010-75e6f042-db50-404d-9536-9627e751779a.png">


 클릭하시고, 원하는 이름으로 저장하시되 , 하단에 있는 앱을 잘 선택해주세요~!



그리고 Sources 폴더에 생성된 초기 파일로 이동해보겠습니다.

<img width="340" alt="image" src="https://user-images.githubusercontent.com/65879950/155956045-1df17383-9ecd-4fd3-997e-757a994388c7.png">






```swift
public struct Networking {
    public var text = "Hello, World!"

    public init(text: String) {
        self.text = text
    }
}
```

 간단한 코드를 작성합니다.



프로젝트 > Target 에서 노랑색 박스 부분에 라이브러리를 추가해줍니다.

<img width="1147" alt="image" src="https://user-images.githubusercontent.com/65879950/155956078-7a79868a-6839-4528-b9d2-0fa68e383f24.png">




당연히 방금 생성한 패키지를 추가해주면 됩니다.

<img width="618" alt="image" src="https://user-images.githubusercontent.com/65879950/155956102-cdd1205b-7572-44ec-b742-6caf26918bab.png">




그리고 간단하게 ContentView.swift에서 호출해보겠습니다.

<img width="1281" alt="image" src="https://user-images.githubusercontent.com/65879950/155956137-fcdf3c38-b888-4e6e-9a34-37d595456f49.png">


- `Networking` 이라고 새로만든 패키지가 정상적으로 추가되었죠?
- 그리고 상수로 간단하게 생성하고 있습니다.
- 해당 값을 Text 에 랜더링하고 있습니다.



## 정리

 이번 실습은 단순히 패키지를 생성해봤습니다. 이렇게 굳이 프로젝트를 나눈 이유는 다음과 같습니다.

- 많은 개발자들이 협업을 하게 될 때, 각각의 패키지만 건들면 되므로 협엽에 용이하다.
- 다양한 프로덕트에 공통적으로 사용되는 모듈을 뽑아서 중복되는 코드를 피할 수 있다.
- 패키지 빌드할 때, 빌드되기 때문에, 하위 모듈에 있을 때보다, 빌드 시간을 단축을 기대할 수도 있다.(상황에 따라 다름)
- 모듈화된 아키텍처로 앱을 만들기 좋은 구조다.



읽어주셔서 감사합니다.
