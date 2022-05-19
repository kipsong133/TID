# Duplicate symbol Error

에러 중에서 다음과 같은 에러가 발생할 때가 있습니다.

> 1~N duplicate symbols for architecture arm64
> 

1~N 은 중복된 무언가(앞으로 알아볼) 가 발생했다는 의미입니다.

## Problem

- 프로젝트에 설치한 Framework (Or Library) 에 코드가 중복된 경우, 주로 발생

(말 그대로 중복된 symbol 이 있는 경우)

- 동일한 기능이 두 번 Load 된 경우

## Solution

- 중복된 부분을 제거하거나  두번 로드 되지 않게 맞는 것이 해결책일겁니다.

**해결책 1**

1. Project > Build Setting > Other Linker Flags 로 이동한다.
2. Release 부터 Debug.. 까지 Scheme 만큼 있을텐데, 이부분에서 -Objc 가 있는 부분을 제거합니다.

**해결책 2**

추가한 프레임워크의 중복된 이름이나 코드를 찾아서 변경 및 제거해줍니다.

 위 글은 아래 글들을 참조해서 요약한 내용이니 아래글에서 상세내용을 확인하시면 더 좋습니다.

- [https://leechamin.tistory.com/456](https://leechamin.tistory.com/456)
- [https://fomaios.tistory.com/entry/duplicate-symbols-for-architecture-x8664](https://fomaios.tistory.com/entry/duplicate-symbols-for-architecture-x8664)
- [http://theeye.pe.kr/archives/2465](http://theeye.pe.kr/archives/2465)
- [https://myksb1223.github.io/develop_diary/2018/12/26/duplicate-symbol-error-in-iOS.html](https://myksb1223.github.io/develop_diary/2018/12/26/duplicate-symbol-error-in-iOS.html)
- Other Linker에 있는 -Objc에 대한 글 : [https://syjdev.tistory.com/27](https://syjdev.tistory.com/27)
