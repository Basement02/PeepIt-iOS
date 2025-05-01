//
//  HomeStore.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeStore {

    @ObservableState
    struct State: Equatable {
        /// 홈 관련 하위 뷰
        var peepPreviewModal = PeepModalStore.State() // 미리보기 핍 모달 관련
        var peepDetail = PeepDetailStore.State() // 핍 상세 관련
        var sideMenu = SideMenuStore.State() // 좌측에서 등장하는 사이드메뉴 관련
        var townVerification = TownVerificationStore.State() // 동네 등록 모달 관련
        var map = HomeMapStore.State() // 지도 관련
        var user = UserStore.State() // 유저 관련

        /// 핍 상세 보여주기 여부
        var showPeepDetail = false
        /// 동네 등록 모달 offsetY 관리
        var townVerificationModalOffset = Constant.screenHeight
        /// 동네 등록 모달 보여줄지 여부
        var showTownVeriModal = false
        /// 사이드 메뉴 등장 시 홈뷰 offsetX 관리
        var mainViewOffset = CGFloat.zero
        /// 홈뷰 offsetX 움직일 때, 색 깔기 위한 변수
        var mainViewMoved = false
        /// 선택된 핍 인덱스 저장
        var selectedPeepIndex: Int? = nil

        /// 핍 페이지 관리
        var page = 0
        var hasNext = true
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case peepDetail(PeepDetailStore.Action)
        case sideMenu(SideMenuStore.Action)
        case peepPreviewModal(PeepModalStore.Action)
        case townVerification(TownVerificationStore.Action)
        case map(HomeMapStore.Action)
        case user(UserStore.Action)

        /// 뷰 등장
        case onAppear
        /// 사이드메뉴 버튼 탭
        case sideMenuButtonTapped
        /// 프로필 버튼 탭
        case profileButtonTapped
        /// 업로드 버튼 탭
        case uploadButtonTapped
        /// 주소 버튼 탭
        case addressButtonTapped
        /// 사이드메뉴 닫기
        case dismissSideMenu
        /// 사이드메뉴 오픈
        case showSideMenu
        /// 핍 상세에서 오브젝트 보여주기 (애니메이션)
        case showDetailObject
        /// 핍 탭
        case peepTapped(idx: Int)

        /// 지도 내 핍 조회 api
        case getPeepsInMap(coord: Coordinate, page: Int)
        case fetchGetPeepsInMapResponse(Result<PagedPeeps, Error>)
    }

    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.memberAPIClient) var memberAPIClient
    @Dependency(\.userProfileStorage) var userProfileStorage

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.peepPreviewModal, action: \.peepPreviewModal) {
            PeepModalStore()
        }

        Scope(state: \.sideMenu, action: \.sideMenu) {
            SideMenuStore()
        }

        Scope(state: \.townVerification, action: \.townVerification) {
            TownVerificationStore()
        }

        Scope(state: \.peepDetail, action: \.peepDetail) {
            PeepDetailStore()
        }

        Scope(state: \.map, action: \.map) {
            HomeMapStore()
        }

        Scope(state: \.user, action: \.user) {
            UserStore()
        }

        Reduce { state, action in

            switch action {

            case .onAppear:
                return .send(.user(.getMyProfile))

            /// 미리보기 모달 관련 처리
            case let .peepPreviewModal(.startEntryAnimation(idx, peeps)):
                state.showPeepDetail = true
                state.selectedPeepIndex = idx
                state.peepDetail.peepList = peeps
                state.peepDetail.currentIdx = idx

                return .none

            case .peepPreviewModal(.showPeepDetail):
                state.peepDetail.showPeepDetailBg = true

                return .run { send in
                    try await Task.sleep(for: .seconds(0.15))
                    await send(.showDetailObject)
                }

            case .showDetailObject:
                state.peepDetail.showPeepDetailObject = true
                return .none

            /// 핍 상세
            case .peepDetail(.backButtonTapped):
                state.showPeepDetail = false
                state.selectedPeepIndex = nil
                state.peepPreviewModal.showPeepDetail = false
                state.peepPreviewModal.selectedIdx = nil
                state.peepPreviewModal.selectedPosition = nil
                return .none

            /// 동네 인증
            case let .townVerification(.modalDragOnChanged(height)):
                state.townVerificationModalOffset = height
                return .none

            case .townVerification(.closeModal):
                state.showTownVeriModal = false
                state.townVerificationModalOffset = Constant.screenHeight
                return .none

            case .townVerification(.dismissButtonTapped):
                return .none // 사용자 정보 업데이트

            /// 홈
            case .addressButtonTapped:
                state.showTownVeriModal = true
                state.townVerificationModalOffset = 0
                return .none

            case .sideMenuButtonTapped:
                state.mainViewMoved = true
                return .none

            case .profileButtonTapped, .uploadButtonTapped:
                return .none

            case .dismissSideMenu:
                state.mainViewMoved = false
                state.sideMenu.sideMenuOffset = -CGFloat(318)
                state.mainViewOffset = 0
                return .none

            case .showSideMenu:
                state.sideMenu.sideMenuOffset = 0
                state.mainViewOffset = CGFloat(318)
                return .none

            case let .peepTapped(idx):
                state.peepPreviewModal.scrollToIdx = idx
                return .none

            /// 지도
            case .map(.closePreviewModal):
                return .send(.peepPreviewModal(.modalScrollDown))

            case let .map(.getMapPeepsFromCenterCoord(coord)):
                return .send(.getPeepsInMap(coord: coord, page: 0))

            /// 프로필
            case .user(.didFinishLoadProfile):
                let coord = state.map.centerCoord
                
                return .send(.getPeepsInMap(coord: coord, page: 0))

            case let .getPeepsInMap(coord, page):

                guard let bCode = state.user.userBCode else {
                    print("동네 인증 정보 없음")
                    return .none
                }

                return .run { send in
                    await send(
                        .fetchGetPeepsInMapResponse(
                            Result { try await peepAPIClient.fetchPeepsInMap(
                                Coordinate(x: coord.x, y: coord.y),
                                    5, // dist
                                    page, // page
                                    15, // size
                                    bCode // bCode
                                )
                            }
                        )
                    )
                }

            // TODO: 모달 핍 페이지네이션
            case let .fetchGetPeepsInMapResponse(result):
                switch result {

                case let .success(result):

                    if result.page == 0 {
                        state.map.mapPeeps = result.content
                        state.peepPreviewModal.peeps = result.content
                    } else {
                        // TODO: - 지도 핍 페이지네이션 처리
                        state.peepPreviewModal.peeps.append(contentsOf: result.content)
                    }

                    state.hasNext = result.hasNext
                    state.page = result.page

                case let .failure(error):
                    if error.asPeepItError() == .noPeep {
                        state.map.mapPeeps.removeAll()
                        state.peepPreviewModal.peeps.removeAll()
                    }
                }

                return .none

            default:
                return .none
            }
        }
    }
}
