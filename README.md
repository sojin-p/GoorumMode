<img src="https://github.com/sojin-p/GoorumMode/assets/140357450/b5489f90-5f6f-4f96-a5dc-24fdfa8404ff" width="150" height="150"/>

# 구름모드 - 감정 기록 일기
![iPhone Screenshot](https://github.com/sojin-p/GoorumMode/assets/140357450/94d6f43f-6e82-47c0-b0f8-87751f1026f4)
:link: [구름모드 앱스토어](apps.apple.com/app/id6470123259)  

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
| 라이브러리   | `SnapKit` `FSCalendar` `DGCharts` `FirebaseCrashlytics` `RxSwift` |
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
- 다크 모드 지원
	- 눈에 부담을 덜어주는 다크 모드 지원
- 다국어 대응
	- 한국어 외 영어, 일본어를 지원하여 선호 언어로 앱 이용 가능

<Br>

## 고려했던 사항
 - **유지 보수성** 향상 및 코드의 **재사용**
   - **MVVM** 패턴으로 뷰와 비즈니스 로직 분리
   - 공통으로 사용되는 **Utility 모듈화**
- 코드의 **안정성** 향상 및 **최적화**
   - **접근 제어자** `private` 사용으로 코드를 **은닉화**
   - 더 이상 상속되지 않는 클래스에 `final` 사용으로 **컴파일 최적화**
   - **메모리 누수 방지**를 위한 `weak` 사용
   - 로직에 **적합한 자료구조를 선택**하여 메모리 사용량 최소화
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
좋았던 점
- 앱 개발부터 출시, 유지 보수 사이클 경험
- 공수 기간 산정으로 어떤 부분이 오래 걸리는지 파악할 수 있게 되었다.
- 개발 일지 작성으로 같은 문제를 만났을 때 해결하는 데 도움이 됐고, 되돌아볼 수 있어서 좋았다.
- 기분 그림을 볼 때마다 귀엽고 행복하다 :D

아쉬운 점
- VoiceOver 관련
   - 달력 라이브러리로 FSCalendar를 사용하였는데, VoiceOver 테스트 시 일요일에서 1일로 넘어갈 때 자꾸 1970년으로 이동되었다. 결국 달력 포커스 자체를 막고, 달력 헤더에 포커스 시 최다 기분(없으면 최신 기분)을 읽어주도록 구현하였다. 나중에는 직접 달력을 만들어보고 싶다.
   - 오늘로 이동하는 버튼을 DatePicker가 있는 뷰에도 추가하였는데, 버튼이 중복되어 달려있는 느낌이라 아쉽다.
- 시간에 쫓겨 놓친 Realm에 관한 에러 핸들링, 일부 뷰에만 적용한 MVVM
