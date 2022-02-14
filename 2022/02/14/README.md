# Today, I learned: SwiftUI @ObservedObject

 오늘은 @ObservedObject 에 대해서 정리하겠습니다.



오늘 작성내용을 그림으료 요약하면 다음과 같습니다.

![image](https://user-images.githubusercontent.com/65879950/153882674-f45f4d88-ae56-4579-ba74-8c901b118047.png)


- ObservableObject로 선언된 클래스 데이터를 최상위 뷰에 인스턴스를 생성한다. 그 때, @StateObject를 붙여준다.
- 해당 데이터를 서브뷰에서도 사용할 경우 @ObservedObject로 선언한 프로퍼티(서브뷰에 있는)로 전달해준다.



## 1. Problem

> ObservableObject를 선언한 뷰 뿐만아니라 하위뷰에서도 사용하고 싶으면 어떻게 해야할까요?

 이 질문을 들으면, "@State는 @Binding을 통해서 해결했는데, 이것도 데이터가 외부에 있냐 내부에 있냐 차이니까 그런게 있지 않을까?" 라고 생각하실 것 같습니다.

맞습니다. @Binding같은 무엇을 찾기 위해서 이 글을 작성했습니다.

지금의 문제를 "하위뷰에서 데이터를 어떻게 전달하지?" 로 축소시키겠습니다.



## 2. Solution

 문제가 너무 추상적이니까, 코드를 통해서 이해를 돕겠습니다.



#### 1. 데이터 정의

```swift
enum Weather {
    case cloudSnow
    case sunnyMin
    case sunnyMax
    case cloudDrizzle
}

struct CityWeather: Identifiable {
    let name: String
    var weather: Weather
    let id = UUID()
}

class Forecast: ObservableObject {
    @Published var citiesWeather = [CityWeather]()
    
    init() {
        [CityWeather(name: "서울", weather: .sunnyMin),
         CityWeather(name: "경기", weather: .cloudDrizzle),
         CityWeather(name: "인천", weather: .cloudSnow),
         CityWeather(name: "부산", weather: .sunnyMax)]
            .forEach { citiesWeather.append($0) }
    }
}
```

- 다음과 같이 데이터 클래스를 만들겠습니다. 



#### 2. UI 구성

먼저 Superview 입니다.

![image](https://user-images.githubusercontent.com/65879950/153882709-ea6befc0-1b76-4d64-a2e4-0c2c23468910.png)


코드입니다.

```swift
import SwiftUI

struct ContentView: View {
    
    @StateObject var forcast = Forecast()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.66)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    NavigationLink(destination: {
                        WeatherInfoView(weathers: forcast)
                            .onAppear {
                                UITableView.appearance().separatorStyle = .none
                                UITableViewCell.appearance().backgroundColor = .darkGray
                                UITableView.appearance().backgroundColor = .darkGray
                            }
                    }) {
                        Group {
                            Text("날씨 정보 조회 Go!")
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(
                            Rectangle()
                                .fill(Color.green)
                                .cornerRadius(15)
                        )
                    }
                    Spacer()
                }
                .navigationTitle("전국 날씨정보")
            }
                
        }
    }
}
```



다음은 SubView 입니다.

![image](https://user-images.githubusercontent.com/65879950/153882753-ab5ae16d-0bee-4158-858b-f263e0a8861b.png)


```swift
import SwiftUI

struct WeatherInfoView: View {
    
    @ObservedObject var weathers: Forecast
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                List(weathers.citiesWeather) { cityWeather in
                    Label(
                        title: {
                            Text(cityWeather.name)
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                        },
                        icon: {
                            Image(systemName: cityWeather.weather.rawValue)
                                .foregroundColor(.brown)
                        })
                    
                }
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("뒤로가기")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                }
                Spacer()
            }
        }.navigationTitle("날씨 상세정보")
    }
}
```



#### 3. ObservableObject 전달

 이미 코드는 모두 작성하셨겠지만, 다시 코드를 가져와서 설명하겠습니다.



ContentView.swift

```swift
@StateObject var forcast = Forecast()
```

- 이 부분에서 ObservableObject의 인스턴스를 생성합니다, 원천데이터가 처음으로 생성되는 순간입니다.



ContentView.swift

```swift
WeatherInfoView(weathers: forcast)
```

- 조금 더 내려가시면, 다음화면을 보여주기 위해서 init으로 StateObject를 전달합니다. 이전 Binding과 다르게 $ 사인이 없습니다.



WeatherInfoView.swift

```swift
@ObservedObject var weathers: Forecast
```

- 이 부분이 오늘 말씀드릴 전부입니다.
- @ObservedObject로 감싸고 있습니다. 기존 Rx와 같았다면, 아마 이곳에서 Driver와 Subject를 만들어서 Subject로 데이터를 받고 Driver로 전달해서 UI를 업데이트 했을 겁니다.
- Combine의 파워로.. 아주 간단하게 구현되었죠.



#### 4. 최종화면

(UI 작성관련 설명은 생략합니다.)

최종 구현화면입니다.

![Simulator Screen Recording - iPhone 13 Pro Max - 2022-02-14 at 23 22 49](https://user-images.githubusercontent.com/65879950/153882790-29390f05-af0a-4504-885c-1277c4f72302.gif)


- 사실 화면은 별 것 없습니다. 다만, 데이터를 외부 데이터 객체를 어떻게 서브뷰로 전달하는지를 알아보는 예제였습니다..^^



## 정리

- @State : @Binding = @StateObject : @ObservedObject
- ObservableObeject는 클래스로선언한다.
- 추가로, ObservedObject에는 인스턴스를 생성하지 않습니다. 하게되더라도, 동작은 될 수 있으나, 원하는대로 UI 업데이트가 되진 않을 확률이 매우매우 높아집니다.







읽어주셔서감사합니다.





