# Today, I learned: RxSwift를 이용한 네트워킹 예제

 오늘은 RxSwift를 통한 네트워크 통신에 대해서 알아보겠습니다.

네트워크 통신을 위해서는 아래 단계로 수행해야합니다.

```markdown
1. URL 구성
2. Request 구성 후, 요청
3. 응답에 대한 에러처리
4. 응답에 대한 데이터 가공
5. UI 업데이트
```

1 ~ 5 단계를 살펴보면, 하나의 Sequence라고 생각할 수 있겠죠? 그러므로 Observable을 통해서 정의하면 됩니다. 그리고 원하는 타이밍에 해당 옵저버블을 구독하면 되겠죠. 저는 MVC 패턴이라 가정하고, 바로 구독해서 UITableView에 업데이트한다고 가정하고 코드를 작성하겠습니다.



### 1. URL 구성

먼저 Observable을 만듭니다.

```swift
Observable.just(urlString)
```

- 생성자 오퍼레이터를 이용해서 원하시는 방식으로 생성하시면 됩니다. 저는 URL String을 하나만 전달받도록 하기위해서 just를 사용했습니다.



현재 데이터타입은 `Observable<String> ` 입니다. 

```swift
Observable<String> -> URL
```

위와 같이 타입을 변경하려고합니다. 그러면 `map`을 사용하면 되겠죠.



```swift
Observable.just(urlString)
	map. { urlString -> URL in 
      return URL(string: urlString)!
  }
```

- String -> URL로 변환했습니다.



## 2. Request 구성 후, 요청

URL을 만들었으면, 요청가능한 형태로 변경하기위해선 "URLRequest" 로 바꿔주면됩니다. 이전과 동일하게 map을 이용하겠습니다.

```swift
.map { url -> URLRequest in 
	var request = URLRequest(url: url)
 	request.httpMethod = "GET"
  return request
}
```



이제 실질적으로 요청을 한다음에 다시 Observable을 생성하겠습니다. 이번에는 rx에서 지원하는 URLSession 을 사용하겠습니다. 이번에는 flatMap을 사용하려고합니다.

#### flatMap의 속성

- 스트림에서 방출되는 것을 다시 다른 옵저버블로 만듭니다.

- "최초 옵저버블에서 보낸 아이탬 -> flatMap 옵저버블 아이탬" 이런식으로 진행될겁니다. 만약 최초 옵저버블에서 of연산자로 3 개를 보냈고, flatMap에서 생성한 옵저버블이 of로 4 개가 있다고 가정해보면,

  - 최초 : Observable.of(1, 2, 3)	-> 3 개
  - flatMap옵저버블 : Observable.of("a", "b", "c", "d") -> 4개

  이렇다고 가정하면,

  - 최초옵저버블 1에 대한 방출 -> flatMap옵저버블 a, b, c ,d 방출
  - 최초옵저버블 2에 대한 방출 -> flatMap옵저버블 a, b, c ,d 방출
  - 최초옵저버블 3에 대한 방출 -> flatMap옵저버블 a, b, c ,d 방출
  - 최초옵저버블 4에 대한 방출 -> flatMap옵저버블 a, b, c ,d 방출

  구독했다면, 이렇게 이벤트가 방출될겁니다.

  그러니까 최초 옵저버블에서 1 개 이벤트만 전달되면, flatMap 옵저버블을 그것에 대해서 자신이 방출할 이벤트를 곱연산을 하게 되겠죠.

  마치 구구단에서 2단 만 입력했는데 1~9 가 생성되는 것 처럼요.

  하지만 우리 예시에서는 just로 1 개만 전달하도록 정의했으니 그럴일은 없습니다.



다시 본론으로 돌아와서 rx에서 지원하는 URLSession을 이용해 flatMap으로 다시 옵저버블을 생성하겠습니다.

```swift
.flatMap { request -> Observable<(response: HTTPResponse, data: Data)> in 
	return URLSession.shared.rx.response(request: request)
}
```



## 3. 응답에 대한 에러처리

받은 데이터 중에서 200~299에 해당하는 응답만 필터링해서, 정상적으로 통신된 경우의 데이터만 거르겠습니다.

```swift
.filter { (response, data in 
	return 200..<300 ~= response.statusCode          
}
```

- 여기서 data파라미터는 사용하지 않으니 와일드카드 패턴을 사용하셔도 됩니다.



## 4. 응답에 대한 데이터 가공

에러경우를 필터링했으니, 이제 데이터를 받아온 경우에 대해서 직렬화를 하겠습니다.

```swift
.map { (response, data) -> [[String: Any]] in 
	guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
      	let result = json as? [[String: Any]] else { return [] }
  return result
}
```

- 이번코드 역시 response를 사용하지 않으니 와일드카드패턴처리해줘도 무방합니다.
- json으로 직렬화를 하고난 이후에, 타입캐스팅까지 성공한 결과를 리턴해주는 map 오퍼레이터입니다.



이제 데이터까지 만들었습니다. 그런데 받은 데이터가 0 개 일 수도 있겠죠. 즉, Get 요청했는데, 받은데이터가 없을 수도 있습니다. 이것에 대한 처리를 해주겠습니다.

```swift
.filter { filteredResponse in 
	return filteredResponse.count > 0
}
```

- 지금 `filteredResponse` 의 타입은 [[String: Any]] 입니다.
- 해당 데이터 중에서 값이 0 이상일 때만, 필터연산자를 통과할 수 있습니다.



5. UI 업데이트이제 데이터를 우리가 원하는 데이터 모델로 변환시켜주는 작업을 해줍니다. 여기서는 제가 임의로 설정한 Model로 코드를 작성하겠습니다.

(UserInfo가 임의로 생성한 Decodable Struct 입니다.)

```swift
.map { finalResponse in 
	return finalResponse.compactMap { dic -> UserInfo in
		guard let userID = dic["userId"] as? Int
					let	userName = dic["username"] as? String				
					let userEmail = dic["email"] as? String
					let userPhone = dic["phoneNum"] as? String
		else { return nil }
		
		return UserInfo(userID, userName, userEmail, userPhone)
	}         
}
```

- 파라미터로 전달받은 것은 [[String: Any]] 입니다. 그것들을 딕셔너리를 다루는 것으로 값들을 상수로 선언하고, 최종적으로는 struct로 데이터를 구조화시켰습니다.



## 5. UI 업데이트

이제 구독해서, 옵저버블을 실행시키면 되겠죠?

```swift
.subscribe(onNext: { [unown self] response in 
	self.tableViewDataModel.onNext(response)
	
	DispatchQueue.main.async {
    self.tableView.reloadData()
  }
})
```

- 구독을 하는데 보면 `tableViewDataModel`라는 게 있죠, 이것은 제가 임의로 지은 이름이구요

```swift
private let tableViewDataModel = BehaviorSubject<[UserInfo]>(value: [])
```

 이렇게 선언했습니다. 보시면 `BehaviorSubject` 이죠. 옵저버블이나 서브젝트에게 이벤트를 전달받으면, 그것을 자신의 구독자에게 전달하는 서브젝트이고 동시에 초기값을 가지죠. 그래서 네트워킹통신한 결과를 서브젝트에 전달해서 tableview에서 사용할 수 있도록 해주는 징검다리 역할을 합니다. 물론 RxDataSoure를 활용해서 구현하면, 다른 방식으로 구현하겠지만, 이번에는 네트워킹에만 집중하기위해서 이렇게 작성했습니다.



## 정리

- 크게 보면, 타입은 이런식으로 변경되고 있습니다.Observable< String > -> Observable< HTTPResponse, Data > -> UserInfo 
- 네트워킹을 위해서 URLSession+Rx 를 사용합니다.
- 최종적으로 완성된 데이터를 전달합니다.



읽어주셔서 감사합니다.^^
