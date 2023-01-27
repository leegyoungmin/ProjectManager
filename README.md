# 프로젝트 매니저

- 칸반 형태의 대시 보드를 통해서 프로젝트를 관리할 수 있는 앱입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [개발 환경 및 라이브러리](#-개발환경-및-라이브러리)
4. [Diagram](#-diagram)
5. [폴더 구조](#-폴더-구조)
6. [타임라인](#-타임라인)
7. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
8. [트러블 슈팅](#-트러블-슈팅)
9. [참고 링크](#-참고-링크)

## 🌱 팀 소개
 |[미니](https://github.com/leegyoungmin)|
 |:---:|
| <a href="https://github.com/leegyoungmin"><img height="150" src="https://i.imgur.com/pcJY2Gn.jpg"></a>|

## 💾 개발환경 및 라이브러리
![Badge](https://img.shields.io/badge/SwiftUI-UI_Configure-informational?style=for-the-badge&logo=Swift&logoColor=white)

![Badge4](https://img.shields.io/badge/TCA-Architecture-success?style=for-the-badge)

![Badge2](https://img.shields.io/badge/Core_Data-Local_DataBase-yellow?style=for-the-badge) ![Badge3](https://img.shields.io/badge/iCloud-Remote_Database-orange?style=for-the-badge&logo=iCloud&logoColor=white) 

### 선정 이유

![Badge](https://img.shields.io/badge/SwiftUI-UI_Configure-informational?style=for-the-badge&logo=Swift&logoColor=white)

1. `SwiftUI`는 `UIKit`과 다르게 선언적 구문을 활용하여 UI를 구성하게 됩니다. 기존의 이벤트 중심 프로그래밍에서 선언적 구문을 활용하기에 코드가 간결해지고, 가독성이 향상되어 개발 기간을 단축시킬 수 있습니다.
2. `SwiftUI`는 Grid System을 기반으로 뷰를 구성하게 되며, 코드의 간결성이 증가하고 오류 발생률이 낮아서 유지 관리가 좋습니다.
3. 상태 관리 매커니즘을 기반으로 하며, 주어진 상태 객체의 속성이 변경되면, 이를 통해서 뷰를 다시 랜더링 하게됩니다. 뷰가 상태값에 대해서 바인딩을 하기때문에 상태 전달 코드가 줄어들게 됩니다.

![Badge4](https://img.shields.io/badge/TCA-Architecture-success?style=for-the-badge)

다음 아키텍쳐는 ['SwiftUI에서 MVVM을 지양해야 한다.'라고 생각하게 된 이유](https://qiita.com/karamage/items/8a9c76caff187d3eb838) 라는 문서를 읽어보면서 알게 되었습니다. 해당 문서에서 이야기하는 부분은 MVVM을 채택하게 된 이유에 대해서 이야기 하고 있습니다. `MVVM`이란 뷰와 뷰모델이 바인딩이라는 작업을 통해서 상태값에 대한 유연한 업데이트를 하는 것으로 이야기 할 수 있습니다. 하지만, SwiftUI는 View 자체에 이미 바인딩의 기능을 포함하고 있습니다. 즉, `SwiftUI`의 뷰들의 집합만으로도 `ViewModel`이 하던 바인딩의 작업을 수행할 수 있다는 것입니다. 그렇기 때문에 `ViewModel`의 존재 이유가 없어지는 것입니다.

그렇다면, 이런 `MVVM`을 활용하지 않았을 경우에 발생하는 로직의 구분적인 측면에서 의문점이 발생할 것입니다. 규모가 크지 않은 앱의 경우에는 `MV`만으로도 앱을 구성하는 데 문제가 없을 것입니다. 하지만, 대규모의 앱 같은 경우에는 문제점들이 발생하게 될 것입니다. 이를 해결하기 위해서 `MVI`라는 아키텍쳐를 통해서 해결할 수 있습니다.

![MVI](https://i.imgur.com/G9zAssf.png)

MVI 아키텍쳐란 단방향 데이터 아키텍쳐로서 사용자의 이벤트를 받은 뷰가 `Intent`라는 객체에게 전달하여 모델의 상태 값을 변화시키고 이에 대해서 뷰가 업데이트할 수 있도록 하는 것입니다. 하지만, 위와 같은 상황에서 발생하는 사이드 이펙트나 테스트에 용이하기 위해서 추가적인 구조를 형성하고 있는 아키텍쳐인 `TCA`를 채택하였습니다.

![Badge2](https://img.shields.io/badge/Core_Data-Local_DataBase-yellow?style=for-the-badge)
CoreData를 사용하게 되면, 범용성이 떨어지게 되지만, CloudKit을 활용하여 사용자에게 연속성을 가진 데이터를 제공할 수 있습니다. 또한, FetchResult 프로퍼티 래퍼를 활용하여 손쉽게 데이터 접근할 수 있다는 장점을 가지게 된니다. 하지만, SQLite는 안드로이드와의 호환성을 사용할 수 있다는 장점과 SQL 문법을 활용할 수 있다는 장점이 있게 된다. 이에 대해서 SQL문법을 활용할 줄 모르기 때문에 장점이 단점이 될 수 있다고 생각합니다. 그렇기 때문에, Local DataBase로 CoreData를 사용하려고 합니다.

![Badge3](https://img.shields.io/badge/iCloud-Remote_Database-orange?style=for-the-badge&logo=iCloud&logoColor=white) 

`Realtime DataBase`를 활용하면 외부적인 서버를 구축하지 않아도 사용할 수 있으며, 인터넷이 되지 않는 오프라인의 상황에서도 활용할 수 있다는 장점이 있습니다. 하지만, 복잡한 쿼리를 사용하는 것이 불편하고, 내부적으로 데이터가 많아진다면 속도가 느려지는 단점이 존재합니다. 이는 앱의 성장에 따라 많은 단점으로 다가 올 수 있다고 생각합니다. 사용자의 수가 늘어나고, 저장하는 데이터가 많아지면 많아질 수록 사용자에게 좋지 못한 UX를 제공하게 된다고 생각합니다. 또한, 사용자에 대한 인증에 대해서 따로 구현을 해야 한다는 단점이 존재합니다.

`CloudKit`은 `iCloud` 계정을 통한 사용자에 대한 한정적인 인증을 통해서 데이터 접근을 제어할 수 있다는 장점이 존재합니다. 즉, 추가적인 인증 서비스가 구현되지 않은 상황에서 사용자의 데이터를 보호할 수 있는 방안이 생기게 되는 것입니다. 하지만, 낮은 범용성으로 인해서 다른 플랫폼에서 활용할 수 없다는 것이 매우 큰 단점입니다. 하지만, 이와 같은 문제는 마이그레이션의 과정을 통해서 극복할 수 있다고 생각했습니다. 또한, `CloudKit`을 사용하는 것이 **Apple의 사용자 개인정보 보호에 대한 가치관**과 더욱 맞을 수 있을 것이라고 생각하였습니다.

## 🛠 기능 소개
- 할일을 등록
- 할일을 하는 중, 한 일로 상태를 변경
- 등록된 일을 삭제
- 할일의 마감 기한 표시

## 👀 Diagram
### 1. View 구조
![](https://i.imgur.com/D4Q2Aq9.jpg)

### 2. Reducer 구조
![](https://i.imgur.com/2mAADAj.jpg)

## 🗂 폴더 구조
```bash!
├── ProjectManager
│   ├── AppView
│   │   ├── AppCore.swift
│   │   └── ProjectManagerAppView.swift
│   ├── Assets.xcassets
│   ├── BoardListView
│   │   ├── BoardListComponents.swift
│   │   ├── BoardListState.swift
│   │   └── BoardListView.swift
│   ├── DetailView
│   │   ├── DetailCore.swift
│   │   └── DetailView.swift
│   ├── Model
│   │   └── Project.swift
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   │       └── Contents.json
│   ├── Project.xcdatamodeld
│   │   └── Project.xcdatamodel
│   │       └── contents
│   ├── SheetCoordinator
│   │   ├── NavigationBarView.swift
│   │   └── SheetCore.swift
│   └── Utility
│       ├── Color.swift
│       ├── Date.swift
│       ├── Font.swift
│       └── Image.swift
└── StoreTests
    ├── DetailStoreTest.swift
    ├── Extension.swift
    └── SheetStoreTest.swift
```

## 🕰️ 타임라인
#### STEP 1
|날짜|구현 내용|
|--|--| 
|23.01.09|프로젝트 기본 설정, 사용 라이브러리 조사|
|22.01.10|사용 결정한 라이브러리 설정|

#### STEP 2
|날짜|구현 내용|
|--|--| 
|23.01.12 ~ 01.14|UI 구성 방법 고안 및 구현|
|23.01.15 ~ 01.18|TCA 아키텍쳐 적용|
|23.01.18 ~ 01.19|Reducer 액션 정리|
|23.01.20 ~ 01.26|PR 발송 및 리뷰에 따른 리팩토링|

## 🤔 고민한 점
### Reducer를 구성하는 방법
SwiftUI 내에서 상태를 관리하기 위해서는 `@State`, `@Binding`와 같은 어노테이션을 활용하여서 상태의 변화를 감지하도록 합니다. 하지만, TCA 아키텍쳐는 `Reducer`를 통해서 상태를 변경시키도록 하고, View는 이 상태의 변경에 따른 뷰를 업데이트 하는 역할을 하도록 합니다. 또한, 상태를 변경하기 위해서는 `Reducer`에게 액션을 줄 수 있도록 하여야 합니다.

위와 같은 방식을 활용하기 위해서 부모 `Reducer`와 자식 `Reducer`를 유기적으로 활용하기 위한 방법을 고민하게 되었습니다. 고민을 통해서 부모는 자식을 소유하고 있을 수 있지만, 자식은 부모를 소유하지 않게 구성하였습니다. 그렇게 한 이유는 TCA 아키텍쳐는 단방향 상태 변경 아키텍쳐이기 때문에 양방향으로 자식이 부모가 어떤 `Reducer`인지 알고 있는 것을 적절하지 않다고 생각하였습니다. 위와 같은 방법을 통해서 `Reducer`를 구성하므로써 많은 부분에서 좋은 이점을 가지게 되었습니다.

하지만, 어느정도의 Reducer를 구성하는 것이 적절한지에 대한 판단이 명확하게 서지 않았습니다. 아직은 큰 덩어리의 개념으로 `Reducer`를 구성하였지만, 더 작은 단위로 `Reducer`를 구성하여서 더욱 유기적으로 구성할 수 있다고 판단 했습니다.

### TCA의 List와 일반 List의 활용
TCA는 IdentifiedArrayOf 타입을 통해서 State를 통해서 List를 상태로 가지고 있을 수 있습니다. 이를 통해서 `Reducer`를 구성할 수 있으며, 이를 통해서 직접적인 모델 타입을 구현하지 않고, 데이터를 가지고 있게 구성할 수 있습니다. 또한, 이 상태값을 유기적으로 변경할 수 있습니다.

하지만, 이를 통해서 구현하게 되면 직접적인 타입이 구성되어 있지 않기 때문에 서버의 Response를 구성하는 것이 어렵다고 판단하였습니다. 그래서 일반적인 List를 구성하고 이를 활용하는 방법을 구현하였습니다.

만약, 추가적인 공부를 통해서 서버의 Response로도 구현할 수 있는 방법을 알게 된다면 IdentifiedArrayOf 타입으로 변경해보려고 합니다.

## 🚀 트러블 슈팅
### 상태의 변경에 따른 예상치 못한 뷰 나오는 버그
![](https://i.imgur.com/D6fEHlw.png)

해당 버그는 `Reducer`내의 상태를 변경하는 것에서 뷰를 보여주기 위한 상태값이 삭제됨에 따른 버그였습니다. 상태의 변경을 디버깅하였습니다. 이를 통해서 저장 버튼이 눌리는 액션을 받은 부모 `Reducer` 타입이 값을 저장하기 전에 데이터를 삭제 하는 것을 확인하게 되었습니다. 이를 해결하기 위해서 데이터를 삭제하는 액션을 바로 발동하는 것이 아니라 데이터를 변경 시킨 후에 데이터를 삭제하는 액션으로 연결 시킴으로써 저장하지 못했다면, 데이터를 삭제하는 액션이 발생하지 않도록 하였습니다.

## 🔗 참고 링크
[SwiftUI에서 MVVM 사용을 멈춰야 하는가?](https://green1229.tistory.com/267)
[MVI 패턴과 어울리는 SwiftUI 화면 이동 라이브러리 만들기](https://www.youtube.com/watch?v=rq8KB21d7jQ&start=298)
[아직도 MVVM? 이젠 MVI 시대](https://sungbin.land/%EC%95%84%EC%A7%81%EB%8F%84-mvvm-%EC%9D%B4%EC%A0%A0-mvi-%EC%8B%9C%EB%8C%80-319990c7d60)

