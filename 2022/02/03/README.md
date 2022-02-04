# Today, I learned: DataStructure(HashTable)

이번에는 해시구조에 대해서 작성하겠습니다.

## 개념

 해시(hash)라는 것은 "어떤 길이의 데이터든지 간에 고정된 길이의 데이터로 매핑하는 것" 입니다. 즉 100개의 문자열의 데이터가 있더라도 10 개의 문자열의 데이터로 변경하는 것입니다. 마치 축약어 혹은 암호같은 느낌이죠. 이렇게 데이터 길이가 고정되면서 검색속도가 빨라집니다. 단순히 현실세계에서 생각해도 쉽죠. 

 예를들면, 길 사이에 양쪽에 집이 있습니다. 두 집이 의사소통을 하고자합니다. 서로 창문을 바라보면서 소통하고자 하죠. 그런데 샤우팅은 할 수 없는 조건입니다. 그렇다면, 처음에는 O와 X 정도만 손으로 표현할 수 있을 겁니다. 그러다가 생각을 하죠. "후레시로 문자를 그리먼 어떨까? ". 그것이 좀더 용이할 것 같습니다. 후레시로 문자를 그리면 좀 더 다양한 표현이 가능하겠네요. 근데 이것도 문제가 있습니다. 문자가 복잡해지면 너무 힘들 것 같아요. 그래서 이제 모스부호라는 걸 이용합니다. 서로 모스부호-자연어 간의 연결된 테이블을 가지고 있고, 모스부호로 길고 짧음을 통해서 문자를 표현하죠. 좀더 명확하고 다양한 것들을 쉽게 표현가능할겁니다. 

 전 해시가 이러한 부호화의 일환이라고 생각해요. 어떤 데이터들인지 간에, 일단 카테고라이징을 해시로 하고, 그래서 범위를 축소시킨 다음에 그 내부에서 제한되 갯수만큼만 순회하면 되니까요. 그런 특징 덕분에 검색속도도 빨라진다고 봅니다. (순회할 데이터가 줄어드니까)


해쉬는 다음그림으로 설명할 수 있습니다. 
<img width="678" alt="image" src="https://user-images.githubusercontent.com/65879950/152476832-027f44cc-2e4f-43f1-9c63-e79677a49bd4.png">


1. 넣고 싶은 데이터를 "키" 로 만든다.
2. "키"를 해시함수에 넣는다. 그 결과 해시 주소를 생성한다.
3. 해쉬주소에 딕셔너리 형태로 해시 테이블에 넣는다.

>  데이터 -(해시)-> 키 -(해시함수)-> 해시주소 -> 해시테이블[해시주소] = 데이터

그러면 코드로 한번 작성해볼게요.



## 코드

1. 해시테이블 만들기

```python
hash_table = list([0 for i in range(10)])
```

- 10개의 0 을 가진 배열을 만들었습니다.
- 아무런 데이터가 추가되지 않았다면 0 이 추가되어 있을겁니다. 이 특성을 활용해서 조건문에서 0인 경우에는 데이터가 없다고 판정할 겁니다.



2. 키 만들기

```python
def generate_key(data):
  return hash(data)
```

- python 내장 함수인 hash를 통해서 해시값을 생성합니다. 이것은 이제 key 역할을 합니다.



3. 해쉬주소만들기

```python
def generate_address(key):
  return key % 8
```

- 주소를 8로 나눈 나머지로 만들겠습니다.
- 데이터가 많아지면 나눌 값도 더 커지겠죠. 



4. 해쉬 테이블에 주소와 값을 넣기

```python
def save_table(data, value):
	key = generate_key(data)
  address = generate_address(key)
  hash_table[address] = value
```

- 이전에 만든 함수 두 개를 이용합니다.
- 키를 생성하고, 주소를 생성합니다.
- 그리고 해시테이블에 딕셔너리 형태로 저장합니다.



## 해시충돌

 위 코드에서 보면 알 수 있듯이, 만약 key에서 생성된 주소가, 동일할 수 있겠죠. 

1 % 8 = 1

9 % 8 = 1

9라는 숫자로 주소를 만들게된 경우랑 1 이라는 숫자로 주소를 만들면, 데이터는 다른데 하나의 키 값을 가지게 되겠죠. 그러면 검색에 용이한 해시테이블의 장점이 사라지겠죠. 그래서 이러한 부분들을 보완하는 방법으로 "체이닝" 과 "선형탐사" 라는 방법이 있습니다.

#### 1. 체이닝

 체이닝은 단어 뜻 그대로, 그 뒤에 이어붙이는 겁니다. 이미 해당 주소에 해당하는 값이 있다면, 그 뒤에 이어서 붙이는 겁니다. 여기서 배열이나 연결리스트 모두 가능합니다. 연결리스트가 좀더 용이할 것 같습니다. 왜냐하면, 필요한 저장공간만큼만 차지하니까요. 

코드를 보겠습니다.

```python
# key생성 함수
def generate_key(data):
  return hash(data)

# 주소 생성함수
def generate_address(key):
  return key % 8

# 데이터를 해시테이블에 저장하는 함수
def save_data(data, value):
  # 해시키
  key = generate_key(data)
  # 해시주소
  address = generate_address(key)
  
  # 테이블에 주소에 접근했는데, 이미 데이터가 있는 경우
  if hash_table[address] != 0:
    # 해당 주소에 있는 데이터들을 모두 순회하면서 동일한 키를 가진 데이터가 있는지 확인한다.
    for index in range(len(hash_table[address])):
      # 해당 주소에 있는 데이터들을 순회하다가 키가 동일하다면, 해당 데이터를 업데이트한다.
      if hash_table[address][index][0] == key:
        hash_table[address][index][1] = value
        return
      
      # 같은 키를 가진 데이터가 없는 경우 == 새로운 데이터추가
      hash_table[address].append([key, value])
      
   # 해당 주소에 데이터가 없는 경우 == 0
   else:
    hash_table[address] = [[key, value]]
    
    
	def read_data(data):
    key = generate_key(data)
    address = generate_address(key)
   
   	# 해당 주소 데이터에 데이터가 있는 경우 
   	if hash_table[address] != 0:
    	for index in range(len(hash_table[address])):
        # 동일한 키를 가진 데이터가 있으면 해당 데이터를 리턴한다.
        if hash_table[address][index][0] == key:
          return hash_table[address][index][1]
        # 동일한 키를 가진 데이터가 없으면, 데이터가 없으므로 None을 리턴한다.
        return None
    
    # 해당주소에 데이터가 없으므로, None을 리턴한다.
    else:
      return None
    
    
    
    
```



## 2. 선형탐사 (Linear Probing)

 선형탐사법은 해시테이블 내에서 빈공간에 동일한 주소를 가진 데이터를 추가하는 방법입니다. 추가적인 공간확보가 필요 없으므로, 공간이 좀더 절약됩니다.

```python
def get_key(data):
    return hash(data)

def hash_function(key):
    return key % 8

hash_table = list([0 for i in range(8)])

def save_data(data, value):
    index_key = get_key(data)
    hash_address = hash_function(index_key)
    
    # 해시테이블의 해당 주소에 값이 이미 있는 경우 (충돌처리)
    if hash_table[hash_address] != 0:
        # 해쉬주소들을 순회힌다. 그러다가 비어있으면, 그곳에 요소를 추가한다.
        for index in range(hash_address, len(hash_table)):
            if hash_table[index] == 0:
                hash_table[index] = [index_key, value]
                return
            # 순회하다가, key가 동일한 것이 있는경우 == 같은 데이터에 덮어쓰기를 하는경우
            # 덮어써준다.
            elif hash_table[index][0] == index_key:
                    hash_table[index][1] = value
                    return
        
    # 해당주소에 한번도 데이터가 들어간적이 없는 경우
    else:
        hash_table[hash_address] = [index_key, value]


def read_data(data):
    index_key = get_key(data)
    hash_address = hash_function(index_key)
    
    # 데이터가 해당 주소에 있는경우
    if hash_table[hash_address] != 0:
        # 해쉬주소를 기준으로 순회한다.
        for index in range(hash_address, len(hash_table)):
            # 만약 해쉬테이블 내 모든 주소에 데이터가 없는 경우
            if hash_table[index] == 0:
                return None
            # 만약 해쉬테이블 내 동일한 해쉬키가 있는 경우 -> 우리가 찾는 데이터
            elif hash_table[index][0] == index_key:
                return hash_table[index][1]
    
    # 데이터가 해당 주소에 없는 경우
    else:
        return None
```





















