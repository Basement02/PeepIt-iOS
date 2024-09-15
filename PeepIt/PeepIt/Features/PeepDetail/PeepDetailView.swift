//
//  PeepDetailView.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import SwiftUI

struct PeepDetailView: View {

    var body: some View {
        ZStack {
            Color.white

            VStack {
                HStack {
                    backButton
                    Spacer()

                    VStack(spacing: 12) {
                        locationButton
                        timeLabel
                    }

                    Spacer()
                    moreButton
                }
                .padding(.horizontal, 17)

                Spacer()

                VStack(alignment: .trailing, spacing: 28) {
                    reactionButton

                    HStack(spacing: 0) {
                        profileView
                            .padding(.trailing, 8)

                        bubbleView
                            .padding(.trailing, 17)

                        chattingButton
                    }
                }
                .padding(.leading, 29)
                .padding(.trailing, 20)
            }
        }
    }
}

extension PeepDetailView {

    private var backButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var moreButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var locationButton: some View {
        Button {

        } label: {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 156, height: 32)
                .foregroundStyle(Color.gray)
        }
    }

    private var timeLabel: some View {
        Button {

        } label: {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 156, height: 32)
                .foregroundStyle(Color.gray)
        }
    }

    private var profileView: some View {
        Circle()
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.gray)
    }

    private var bubbleView: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(height: 44)
            .foregroundStyle(Color.gray)
    }

    private var chattingButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var reactionButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    PeepDetailView()
}
