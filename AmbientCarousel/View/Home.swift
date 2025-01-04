//
//  Home.swift
//  AmbientCarousel
//
//  Created by Bruno Mazzocchi on 4/1/25.
//

import SwiftUI

struct Home: View {
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack (spacing: 15) {
                HeaderView()
                
                CarouselView()
                    .zIndex(-1)
            }
        }
        .safeAreaPadding(15)
        
        .background {
            Rectangle()
                .fill(.black.gradient)
                .scaleEffect(y: -1)
                .ignoresSafeArea()
        }
        .onScrollGeometryChange (for: ScrollGeometry.self) {
            $0
        } action: { oldValue, newValue in
            topInset = newValue.contentInsets.top + 100
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(systemName: "xbox.logo")
                .font(.system(size: 35))
                .foregroundColor(.white)
            
            VStack (alignment: .leading, spacing: 6) {
                Text("JohnDoe")
                    .font(.callout)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                HStack (spacing: 6) {
                    Image(systemName: "g.circle.fill")
                        .foregroundColor(.white)
                    
                    Text("36,990")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            
            Spacer(minLength: 10)
            
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
            
            Image(systemName: "bell.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
        }
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func CarouselView() -> some View {
        let spacing: CGFloat = 6
        
        ScrollView(.horizontal) {
            LazyHStack (spacing: spacing) {
                ForEach (images) { model in
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 520)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                }
            }
        }
        .frame(height: 520)
        .background(BackdropCarouselView())
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .onScrollGeometryChange (for: CGFloat.self) {
            let offsetX = $0.contentOffset.x + $0.contentInsets.leading
            let width = $0.containerSize.width + spacing
            
            return offsetX / width
        } action: { oldValue, newValue in
            let maxValue = CGFloat(images.count - 1)
            scrollProgressX = min(max(newValue, 0), maxValue)
        }
    }
    
    @ViewBuilder
    func BackdropCarouselView() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach (images.reversed()) { model in
                    let index = CGFloat(images.firstIndex(where: { $0.id == model.id }) ?? 0) + 1
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .opacity(index - scrollProgressX)
                }
            }
            .compositingGroup()
            .blur(radius: 30, opaque: true)
            .overlay {
                Rectangle()
                    .fill(.black.opacity(0.35))
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .black,
                        .black,
                        .black,
                        .black,
                        .black.opacity(0.5),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
            }
        }
        .containerRelativeFrame(.horizontal)
        .padding(.bottom, -60)
        .padding(.top, -topInset)
        .offset(y: scrollOffsetY < 0 ? scrollOffsetY: 0)
    }
}

#Preview {
    Home()
}
