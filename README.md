<img src="https://github.com/sojin-p/GoorumMode/assets/140357450/b5489f90-5f6f-4f96-a5dc-24fdfa8404ff" width="150" height="150"/>

# 구름모드 - 감정 기록 일기
![iPhone Screenshot](https://github.com/sojin-p/GoorumMode/assets/140357450/94d6f43f-6e82-47c0-b0f8-87751f1026f4)
:link: [구름모드 앱스토어](https://apps.apple.com/app/id6470123259)  

<Br>

## 목차
:link: [개발 기간 및 환경](#개발-기간-및-환경)  
:link: [사용 기술 및 라이브러리](#사용-기술-및-라이브러리)  
:link: [핵심 기능](#핵심-기능)  
:link: [고려했던 사항](#고려했던-사항)  
:link: [트러블 슈팅](#트러블-슈팅)  
:link: [회고](#회고)  

<Br>

## 개발 기간 및 환경
- 개인 프로젝트
- 23.09.25 ~ 23.10.23 (약 1개월)
- Xcode 14.3.1 / Swfit 5.9 / iOS 16+

<Br>

## 사용 기술 및 라이브러리
| Kind         | Stack                                                          |
| ------------ | -------------------------------------------------------------- |
| 아키텍쳐     | `MVC` `MVVM`                                                     |
| 프레임워크   | `Foundation` `UIKit` `SafariServices`                             |
| 데이터베이스 | `Realm`                                                           |
| 라이브러리   | `RxSwift` `SnapKit` `FSCalendar` `DGCharts` `FirebaseCrashlytics` `FirebaseMessaging` |
| 의존성관리   | `Swift Package Manager`                                           |
| ETC.         | `CodeBasedUI` `DiffableDataSource`                             |  

<Br>

## 핵심 기능
- 일기 기록
	- 간편한 일기 추가, 수정, 삭제 기능
- 달력 뷰
	- 가장 많이 등록한 기분을 확인할 수 있는 효율적인 달력 제공
- VoiceOver 지원
	- 시력 저하 및 시각 장애인 사용자의 접근성 향상
- 실시간 검색
	- 특정 키워드가 포함된 일기 빠르게 찾기
- 차트
	- 일간, 주간, 월간 차트와 각 기분 개수 제공으로 감정 추이를 확인
- Remote 알림
   - 사용자에게 실시간으로 중요한 정보를 제공
- 다크 모드 지원
	- 눈에 부담을 덜어주는 다크 모드 지원
- 다국어 대응
	- 한국어 외 영어, 일본어를 지원하여 선호 언어로 앱 이용 가능

<Br>

## 고려했던 사항
 - **유지 보수성** 향상 및 코드의 **재사용**
   - **MVVM** 아키텍처에서 Custom Observable class를 도입하여 효율적인 데이터 바인딩 구현
   - **Realm Repository** 파일로 데이터 액세스 추상화
   - 앱 전반적으로 사용하는 날짜 데이터를 **싱글톤 패턴**으로 구성하여 코드 중복 방지
   - **BaseViewController**로 반복되는 로직 구조화
   - ReusableViewProtocol을 채택하여 재사용 셀 및 뷰 컨트롤러의 **identifier**를 효율적으로 관리
   - **CustomView**로 공통으로 사용되는 디자인 모듈화
- 코드의 **안정성** 향상 및 **최적화**
   - **접근 제어자** `private` 사용으로 코드를 **은닉화**
   - 더 이상 상속되지 않는 클래스에 `final` 사용으로 **컴파일 최적화**
   - **메모리 누수 방지**를 위한 `weak` 사용
   - 로직에 **적합한 자료구조를 선택**하여 메모리 사용량 최소화
   - 다양한 날짜 데이터 포맷이나 기분 이모지 등을 **열거형**으로 정의하여 안정성 및 가독성 향상
- 편리한 사용자 경험
  - 주요 기능 및 버튼을 **엄지 존**에 배치
  - 접근성 향상을 위한 **VoiceOver** 지원
  - 기분 이미지 선택을 제외한 모든 **텍스트 입력**은 **옵셔널**로 제공
- 간단하고 **직관적인 UI**
  - 직관적인 아이콘과 버튼
  - **원형 차트** 데이터를 **6개로 제한**, 추가적인 데이터는 '기타'로 표기

<Br>

## 트러블 슈팅
1. Realm 일기를 수정하고 나서 삭제할 때 생긴 오류
   - 오류 메시지 : `Can only delete an object from the Realm it belongs to.`
   - **원인** : 유효하지 않은 데이터를 삭제하려고 했기 때문에 발생 
   - **해결** : 먼저 PK 값으로 데이터를 조회 후에 유효할 때만 삭제
```swift
func deleteItem(_ id: ObjectId) {
        
        let item = realm.object(ofType: Mood.self, forPrimaryKey: id)
        
        guard let item else {
            print("유효하지 않은 데이터")
            return
        }
        
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("삭제 오류: \(error)")
        }
        
    }
```  

<Br>

2. 일기 삭제 시 Realm에서는 삭제가 잘 되지만, 런타임 오류 발생
   - 오류 메시지 : `Object has been deleted or invalidated`
   - **원인** : DiffableDataSource는 Snapshot 기반으로, 이전 데이터를 가지고 있다가 데이터가 바뀌면 비교 후 UI를 갱신하는데, Realm은 삭제된 데이터에 접근 자체가 불가하므로 발생 
   - **해결** : applySnapshotUsingReloadData 메서드를 사용하여 바로 갱신
```swift
private func updateSnapshot() {
        
        snapshot = NSDiffableDataSourceSnapshot<Section, Mood>()
        snapshot.appendSections([.today])
        snapshot.appendItems(viewModel.moods.value)
        
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
```

<Br>

3. 일기 추가, 수정 시 해당 셀로 스크롤 되는 함수가 동작하지 않는 이슈
   - **원인** : MVVM으로 리팩토링 하면서 데이터가 바뀌면 Snapshot이 업데이트되게 해주었는데, 스크롤 이후에 Snapshot 코드가 실행되어 발생
   - **해결** : DispatchQueue로 스크롤 함수 실행을 늦춰서 해결
```swift
vc.completionHandler = { [weak self] data in
            self?.viewModel.append(data)
            //MVVM 리팩토링 전 updateSnapshot() 위치
            DispatchQueue.main.async {
                self?.scrollToItem(data: data) //스크롤 함수
            }
        }
```
```swift
//해당 셀로 스크롤하는 함수
private func scrollToItem(data: Mood) {
        if let item = snapshot.indexOfItem(data) {
            let indexPath = IndexPath(item: item, section: 0)
            mainView.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
```

<Br>

4. 차트 데이터가 없을 때 placeholder가 보이지 않는 이슈
   - **원인** : 차트 데이터가 nil 일 때 placeholder가 보이는데, 빈 배열 값이 들어가서 발생
   - **해결** : 차트 데이터가 없을 때 변수에 nil을 할당
```swift
if let data = data, !data.isEmpty {
            pieData = setChartData(data: data)
            chartDataCount = data.count
        } else {
            pieData = nil
            moodData = MoodData(moodCount: [:], sortedMoodName: [], sortedPercent: [])
        }
```

<Br>

## 회고
- 이미지 크기가 메모리에 큰 영향을 미치는 것을 알게 되었다. 메모리 게이지가 660MB까지 상승하는 문제를 발견하고, 이미지 크기를 줄였더니 43MB로 대폭 감소하였다. 이 과정에서 이미지 최적화에 대해 찾아보게 되었고, 다운 샘플링과 리사이징에 대한 개념을 공부할 수 있었다.
- VoiceOver를 켜고 FSCalendar 사용 시 1970년으로 이동하는 버그로 어려움을 겪었다. 지금은 달력 자체에 접근성을 막아두고, 달력 타이틀을 터치하면 DatePicker로 날짜를 선택할 수 있도록 구현하였다. 그러나 이것이 최적의 사용자 경험인지에 대한 의문이 들어, 내년 상반기 안에는 직접 달력을 만들어볼 계획이다.
- 원형 차트를 다루면서 데이터가 많아지면 UI가 복잡해져 사용자 경험이 저하된다는 것을 알게 되었다. 사용자에게 더 나은 시각적 경험을 제공하기 위해서는 데이터 개수를 제한하거나, 기타 항목의 크기를 비교적 작게 만드는 것과 같이 어느 정도 조정이 필요하다는 것을 깨달았다.
- 시간 제약으로 인해 Realm에 대한 에러 핸들링을 충분히 구현하지 못하였다. 추후 코드의 가독성 향상 및 유지 보수를 위해 열거형을 활용하여 에러 핸들링을 구현할 계획이다.
