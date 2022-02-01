# Today, I learned: DataStructure (LinkedList)

오늘은 연결리스트에 대해서 정리해보겠습니다.

기존에 배열에서는 제가 고정된 크기만큼만 저장이 가능하고, 실제로 추가로 저장이 될 경우, 배열을 새로 만드는 과정이 생긴다고 말씀드렸죠. 이 문제를 보완한 방법이 연결리스트 입니다.

그리고 연결리스트에서는 단방향으로만 연결된 연결리스트가 있고 양방향으로 연결된 연결리스트가 있습니다. 연결된 하나하나의 데이터를 노드(Node) 라고 칭합니다.

```python
class Node:
  def __init__(self, element, next = None):
    self.element = element
    self.next = next
```

코드를 보시면, `element` , `next` 가 있습니다.

element는 값을 저장하는 변수이고, next는 다음 노드를 가리키는 주소를 가지고 있습니다. 배열은 인덱스를 통해서 접근했다면, 연결리스트는 이렇게 next로 연결되어 있어서 다음 데이터로 이동합니다. 이로 인해서 Randomaccess는 불가능하겠죠. 대신에, 데이터가 추가되면, 그냥 next에 다음 노드를 연결해주기만하면됩니다. 게다가 메모리주소상 일렬로 저장할 필요도 없습니다. 그냥 비어있는곳 아무곳에 저장한다음에 주소만 전달받으면 되니까요. 이러한 배열에 비해서 제한된 크기가 아니라는 장점이 생깁니다.

 다만 단점으로는 주소를 저장하는 메모리 공간을 차지하므로, 그만큼 공간상의 트레이드오프가 발생하겠죠. 그리고 Random-Access가 불가능한 만큼, 데이터 접근 시, O(n)을 가질 수 밖에 없습니다. 추가적인 단점이라고 하긴 그렇지만, 귀찮음? 은 구현을 해야한다는점? 정도가 있겠네요.



한 번처음부터 끝까지 구현해보겠습니다.(양방향만 구현)

```python
class Node: 
  # 양방향이므로 이전 노드에 대한 주소와 이후 노드에 대한 주소도 저장해야합니다.
  def __init__(self, element, prev = None, next = None):
    self.element = element
    self.prev = prev
    self.next = next
```

- 노드입니다. 이제 이 노드를 이용해서 연결하기도하고 자르고 붙이고 해보겠습니다.



이후에 노드를 이용해서 양방향 연결리스트를 구현합니다.

```python
# 노드를 생성한다.
class Node:
    def __init__(self,
                element,
                prev = None,
                next = None):
        self.prev = prev
        self.next = next
        self.element = element
        
# DoubleLinkedList를 생성한다.
class DoubleLinkedList:
    
    def __init__(self,
                element):
        # 헤드 생성
        self.head = Node(element)
        # 테일 생성
        self.tail = self.head
        
    '''
    연결리스트 제일 마지막에 추가
    Input  : element(추가할요소)
    Output : True(추가), False(추가하지 못함)
    '''
    def insert_to_tail(self, element):
        # 헤드 유무 확인
        if self.check_head_is_none == True:
            # 헤드가 없는경우
            self.head = Node(element)
            return True
        
        node = self.head
        while node.next:
            node = node.next
        newNode = Node(element)
        node.next = newNode
        newNode.prev = node
        self.tail = newNode
        return True
        
      
    '''
    Input  : element(검색할 요소)
    Output : True(찾음), False(못찾음)
    '''
    def search_from_head(self, element):
        if self.check_head_is_none == True:
            print("No head")
            return False
        
        node = self.head
        while node != None:
            if node.element == element:
                print("SearchResult(fromHead): ",node.element)
                return True
            node = node.next
        
        print("SearchResult(fromHead): no element matched",)
        return False

    '''
    Input  : element(검색할 요소)
    Output : True(찾음), False(못찾음)
    '''
    def search_from_tail(self, element):
        # 헤드가 없으면 테일도 없으므로 같은 연산프로퍼티를 사용한다.
        if self.check_head_is_none == True:
            print("No head")
            return False
        
        node = self.tail
        while node != None:
            if node.element == element:
                print("SearchResult(fromBefore): ",node.element)
                return True
            node = node.prev
        print("SearchResult(fromBefore): no element matched",)
        return False
    
    '''
    Input  : prev_element(추가할 위치), new_element(추가할 요소)
    Output : True(성공적으로 추가), False(추가 실패)
    '''
    def insert_prev(self, prev_element, new_element):
        if self.check_head_is_none == True:
            self.head = Node(prev_element)
            return True
        
        node = self.tail
        while node.element != prev_element:
            node = node.prev
            
            # head까지 도달했는데, 찾는 element가 없는 경우
            if node == None:
                print("insert_prev: 찾는 element가 없습니다.")
                return False
            
        # element가 일치하는 것이 있는 경우
        # | newNode | - | new_prev(검색해서찾은노드) | - | new_prev_next |
        
        # 새롭게 추가할 노드
        newNode = Node(new_element)
        
        # 새롭게 추가할 노드의 prev 가 될 노드
        prev_new = node.prev
        
        # 새롭게 추가할 노드의 prev와 추가될 노드 연결
        prev_new.next = newNode
        newNode.prev = prev_new
        
        # 새롭게 추가할 노드외 next가 될 노드 연결
        newNode.next = node
        node.prev = newNode
        return True
    
    '''
    Input  : next_element(추가할 위치), new_element(추가할 요소)
    Output : True(추가) / False (추가할 위치를 못찾음)
    '''
    def insert_next(self, next_element, new_element):
        if self.check_head_is_none == True:
            self.head = Node(new_element)
            return True
        
        node = self.head
        while node.element != next_element:
            node = node.next
            
            if node == None:
                print("insert_next: 찾는 element가 없습니다.")
                return False
            
        # 탈출 시, 찾은 상태
        print("찾음")
        print(node.next.element)
        
        # 새롭게 추가할 노드
        newNode = Node(new_element)
        
        # 새롭게 추가할 노드의 next(= 검색한 노드의 next)
        new_next_node = node.next    
        
        # 새롭게 추가할 노드의 prev(= 검색한 노드)
        searchedNode = node
        
        # |next_element(추가할 위치의 이전노드)| - | newNode | - | next_element.next |
        # 새롭게 추가할 노드와 prev(검색해서 찾은 노드)로 될 노드 연결
        searchedNode.next = newNode
        newNode.prev = searchedNode
        
        # 새롭게 추가할 노드와 next가 될 노드 연결
        newNode.next = new_next_node
        new_next_node.prev = newNode
        return True

    @property    
    def check_head_is_none(self):
        if self.head == None:
            return True
        else:
            return False
        
    def desc(self):
        if self.check_head_is_none == True:
            print("No Head in this LinkedList")
        else:
            node = self.head
            while node:
                print(node.element)
                node = node.next
                    
```



한번 테스트를 해보겠습니다.



먼저 헤드를 생성해봅니다.

```python
double_linkedList = DoubleLinkedList(0)
double_linkedList.desc()
```

```
0
```

- 잘나오고 있군요.



9개의 데이터를 추가해보겠습니다.

```python
for num in range(1,10):
    double_linkedList.insert_to_tail(num)
double_linkedList.desc()
```

```
0
1
2
3
4
5
6
7
8
9
```



검색을 해보겠습니다.

```python
double_linkedList.search_from_head(5)
```

```
SearchResult(fromHead):  5
```

```python
double_linkedList.search_from_tail(9)
```

```
SearchResult(fromBefore):  9
```



중간에 값을 추가해보겠습니다.

```python
double_linkedList.insert_prev(2,1.5)
double_linkedList.desc()
```

```
0
1
1.5
2
3
4
5
6
7
8
9
```

```python
double_linkedList.insert_to_tail(999)
double_linkedList.desc()
```

```
0
1
1.5
2
3
4
5
6
7
8
9
999
```

```python
double_linkedList.insert_next(1.5, 1.7)
double_linkedList.desc()
```

```
0
1
1.5
1.7
2
3
4
5
6
7
8
9
999
```



연결리스트에 대한 개인적인 경험이 없어서, 조금 나열식으로 정보를 작성하게되었네요. 추가로 제 경험이나 책에서 본 내용이 있으면 추가하도록하겠습니다~!



읽어주셔서 감사합니다.

