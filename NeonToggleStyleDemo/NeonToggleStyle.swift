//
//  NeonToggleStyle.swift
//  NeonToggleStyleDemo
//
//  Created by Evgeny Mitko on 31/07/2023.
//

import SwiftUI

struct NeonToggleStyle: ToggleStyle {
        
    @State var isPressed = false
    @State var isDragging = false
    @State var isOn: Bool = false
    @State var circleXDragOffset: CGFloat = 0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            toggleView(isOn: configuration.$isOn)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPressed = true
                    circleXDragOffset = circleDragOffset(translation: value.translation.width)
                    if value.translation.width != 0 {
                        isDragging = true
                    }
                }
                .onEnded { value in
                    if !isDragging {
                        isOn.toggle()
                    } else if abs(value.translation.width) > circleSize.width / 6 {
                        isOn.toggle()
                    }

                    isPressed = false
                    isDragging = false
                    circleXDragOffset = 0
                }
        )
        .onChange(of: isOn) { oldValue, newValue in
            guard oldValue != newValue else { return }
            withAnimation(.bouncy) {
                configuration.isOn = newValue
            }
        }
        .onChange(of: configuration.isOn) { oldValue, newValue in
            guard oldValue != newValue else { return }
            withAnimation(.bouncy) {
                self.isOn = newValue
            }
        }
        .onAppear {
            isOn = configuration.isOn
        }
        .animation(.default, value: isPressed)
        .animation(.default, value: circleXDragOffset)
    }
    
    
    private func toggleView(isOn: Binding<Bool>) -> some View {
        ZStack {
            ZStack {
                // Toggle Background
                Capsule()
                    .foregroundStyle(.toggleBG)
                    .frame(width: 52, height: 31)
                
                // Toggle Circle Base Layer With Shadow
                Capsule()
                    .frame(width: circleSize.width, height: circleSize.height)
                    .foregroundStyle(.circleBG)
                    .offset(x: circleXOffset + circleXDragOffset - 0.7)
                    .shadow(color: .black, radius: 1, x: 10, y: 4)
                
                // Toggle Circle Base Neon Layer With Shadow
                Capsule()
                    .trim(from: .zero, to: trimAmount)
                    .rotation3DEffect(.degrees(180),axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(180),axis: (x: 1, y: 0, z: 0))
                    .frame(width: circleSize.width, height: circleSize.height)
                    .foregroundStyle(neonGradient)
                    .offset(x: circleXOffset + circleXDragOffset, y: 0.25)

                Capsule()
                    .trim(from: .zero, to: trimAmount)
                    .rotation3DEffect(.degrees(180),axis: (x: 0, y: 1, z: 0))
                    .frame(width: circleSize.width, height: circleSize.height)
                    .foregroundStyle(neonGradient)
                    .offset(x: circleXOffset + circleXDragOffset, y: -0.25)
                    .shadow(color: .black, radius: 1, x: 10, y: 4)

            }
            .clipShape(
                Capsule()
            )
            
            // Toggle Border
            Capsule()
                .stroke(lineWidth: 4)
                .foregroundStyle(.toggleBG
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0.7, x: 1, y: 1))
                    .shadow(.drop(color: .white.opacity(0.2), radius: 1, x: -1, y: -1))
                    .shadow(.inner(color: .black.opacity(0.6), radius: 0.7, x: -1, y: -1))
                    .shadow(.drop(color: .black.opacity(0.6), radius: 2, x: 2, y: 2))

                )
                .frame(width: 55, height: 34)
            
            // Toggle Circle Upper Layer
            Capsule()
                .frame(width: circleSize.width, height: circleSize.height)
                .foregroundStyle(.circleBG
                    .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 0.7, y: 0.7))
                    .shadow(.inner(color: .black.opacity(0.8), radius: 0.5, x: -0.7, y: -0.7))
                )
                .offset(x: circleXOffset + circleXDragOffset - 0.7)

            // Toggle Border Neon Upper Part
            Capsule()
                .trim(from: .zero, to: trimAmount)
                .stroke(neonGradient, style: .init(lineWidth: 2, lineCap: .butt))
                .frame(width: 60, height: 39)
                .rotation3DEffect(.degrees(180),axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(.degrees(180),axis: (x: 1, y: 0, z: 0))
                .offset(x: 0, y: 0.25)
                .shadow(color: .neonGreen.opacity(0.4), radius: 1, x: -1, y: 0)
                .shadow(color: .neonCyan.opacity(0.4), radius: 1, x: 1, y: 0)
            
            // Toggle Border Neon Bottom Part
            Capsule()
                .trim(from: .zero, to: trimAmount)
                .stroke(neonGradient, style: .init(lineWidth: 2, lineCap: .butt))
                .frame(width: 60, height: 39)
                .rotation3DEffect(.degrees(180),axis: (x: 0, y: 1, z: 0))
                .offset(x: 0, y: -0.25)
                .shadow(color: .neonGreen.opacity(0.4), radius: 1, x: -1, y: 0)
                .shadow(color: .neonCyan.opacity(0.4), radius: 1, x: 1, y: 0)
        }
        .overlay {
            VStack {
                HStack {
                    Circle()
                        .frame(width: 3, height: 3)
                        .foregroundStyle(ledColor
                            .shadow(.drop(color: ledColor, radius: 1, x: 0, y: 0))
                            .shadow(.inner(color: .white.opacity(0.3), radius: 1, x: 0, y: 1))
                        )
                    Spacer()
                }
                Spacer()
            }
        }
        
    }
    
    private var ledColor: Color {
        isOn ? .ledGreen : .ledRed
    }
    
    private var neonGradient: LinearGradient {
        return LinearGradient(colors: [.neonCyan, .neonGreen], startPoint: .leading, endPoint: .trailing)
    }
    
    private var neonOpacity: CGFloat {
        trimAmount == 0 ? 0 : 1
    }
    
    private var trimAmount: CGFloat {
        isOn ? 0.5 : 0
    }
    
    private func circleDragOffset(translation: CGFloat) -> CGFloat {
        let maxTranslation: CGFloat = 12
        return max(min(translation, (isOn ? 0 : maxTranslation)), -(!isOn ? 0 : maxTranslation))
    }
    
    private var circleXOffset: CGFloat {
        let standardOffset: CGFloat = 10
        let isOnMultiplier: CGFloat = isOn ? 1 : -1
        let isPressedOffset: CGFloat = isPressed ? 4 : 0
        return standardOffset * isOnMultiplier + isPressedOffset * -isOnMultiplier
    }
    
    private var circleSize: CGSize {
        let height: CGFloat = 27
        let width = isPressed ? height + 8 : height
        return CGSize(width: width, height: height)
    }

}
