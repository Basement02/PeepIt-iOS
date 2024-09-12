//
//  ContentView.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<HomeStore>

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()

            VStack {
                HStack {
                    moreButton
                    Spacer()
                    setMyTownButton
                    Spacer()
                    profileButton
                }
                .padding(.horizontal, 17)

                Spacer()

                HStack {
                    currentLocationButton
                    Spacer()
                    uploadPeepButton
                }
                .padding(.horizontal, 17)
            }
        }
        .sheet(isPresented: .constant(true)) {
            PeepPreviewModalView()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .clearModalBackground()
                .presentationDetents([.height(60), .medium])
                .interactiveDismissDisabled()
        }
    }
}

extension ContentView {

    private var moreButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var setMyTownButton: some View {
        Button {

        } label: {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 156, height: 32)
                .foregroundStyle(Color.gray)
        }
    }

    private var profileButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var currentLocationButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var uploadPeepButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    ContentView(
        store: .init(initialState: HomeStore.State()) { HomeStore() }
    )
}
