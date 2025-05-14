//
//  PathStore.swift
//  PeepIt
//
//  Created by 김민 on 5/14/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootPathStore {
    
    var body: some Reducer<RootStore.State, RootStore.Action> {
        Reduce { state, action in
            switch action {
            case let .path(pathAction):
                return handlePathNavigation(&state, pathAction)
                
            case .login(.moveToTerm):
                state.path.append(.term(.init()))
                return .none
                
            case .login(.moveToHome):
                state.authState = .authorized
                state.path.removeAll()
                return .none
                
            case .home(.profileButtonTapped):
                state.path.append(.myProfile(.init()))
                return .none
                
            case .home(.sideMenu(.notificationMenuTapped)):
                state.path.append(.notification(.init()))
                return .none
                
            case .home(.uploadButtonTapped):
                state.path.append(.camera(.init()))
                return .none
                
            case .home(.sideMenu(.logoutButtonTapped)):
                return .send(.showPopUp(.logout))
                
            default:
                return .none
            }
        }
    }
    
    func handlePathNavigation(
        _ state: inout RootStore.State,
        _ pathAction: StackActionOf<RootStore.Path>
    ) -> Effect<RootStore.Action> {
        switch pathAction {
        case .element(_, action: .term(.nextButtonTapped)):
            state.path.append(.inputId(.init()))
            return .none
            
        case .element(_, action: .inputId(.nextButtonTapped)):
            state.path.append(.nickname(.init()))
            return .none
            
        case .element(_, action: .nickname(.nextButtonTapped)):
            state.path.append(.inputProfle(.init()))
            return .none
            
        case .element(_, action: .inputProfle(.moveToSMSAuth)):
            state.path.append(.inputPhoneNumber(.init()))
            return .none
            
        case .element(_, action: .inputPhoneNumber(.nextButtonTapped)):
            state.path.append(.inputAuthCode(.init()))
            return .none
            
        case .element(_, action: .inputPhoneNumber(.skipButtonTapped)):
            state.path.append(.welcome(.init()))
            return .none
            
        case let .element(_, action: .inputPhoneNumber(.moveToEnterCode(phone))):
            state.path.append(.inputAuthCode(.init(phoneNumber: phone)))
            return .none
            
        case .element(_, action: .inputAuthCode(.pushToWelcomeView)):
            state.path.append(.welcome(.init()))
            return .none
            
        case .element(_, action: .welcome(.goToHomeButtonTapped)):
            state.authState = .authorized
            state.path.removeAll()
            return .none
            
        case .element(_, action: .myProfile(.uploadButtonTapped)):
            state.path.append(.camera(.init()))
            return .none
            
        case let .element(_, action: .camera(.pushToEdit(image, videoURL))):
            state.path.append(.edit(.init(image: image, videoURL: videoURL)))
            return .none
            
        case let .element(_, action: .edit(.pushToWriteBody(image, videoURL))):
            state.path.append(.write(.init(image: image, videoURL: videoURL)))
            return .none
            
        case .element(_, action: .write(.closeUploadFeature)):
            for _ in 0..<3 { _ = state.path.popLast() }
            return .none
            
        case .element(_, action: .townPeeps(.uploadButtonTapped)):
            state.path.append(.camera(.init()))
            return .none
            
        case .element(_, action: .myProfile(.watchButtonTapped)):
            state.path.removeAll()
            return .none
            
        case let .element(_, action: .townPeeps(.peepCellTapped(idx, peepIdList, page, size))):
            state.path.append(
                .peepDetailList(
                    .init(
                        entryType: .townPeep,
                        currentIdx: idx,
                        showPeepDetailObject: true,
                        showPeepDetailBg: true,
                        size: size,
                        page: page,
                        peepIdList: peepIdList
                    )
                )
            )
            return .none
            
        case let .element(_, action: .notification(.activePeepCellTapped(selectedPeep))),
            let .element(_, action: .myProfile(.peepCellTapped(selectedPeep))),
            let .element(_, action: .otherProfile(.peepCellTapped(selectedPeep))):
            state.path.append(.peepDetail(.init(isMine: true, peepId: selectedPeep.peepId)))
            return .none
            
        case let .element(_, action: .peepDetailList(.profileTapped(id))):
            state.path.append(.otherProfile(.init(userId: id)))
            return .none
            
        default:
            return .none
        }
    }
}
