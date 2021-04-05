//
//  HideableView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/05.
//

import SwiftUI
import UIKit

extension View {
    func hide(_ hide: Bool) -> some View {
        HideableView(isHidden: .constant(hide), view: self)
    }
    
    func hide(_ isHidden: Binding<Bool>) -> some View {
        HideableView(isHidden: isHidden, view: self)
    }
}

struct HideableView<Content: View>: UIViewRepresentable {
    @Binding var isHidden: Bool
    
    let view: Content
    
    func makeUIView(context: Context) -> ViewContainer<Content> {
        return ViewContainer(isContentHidden: isHidden, child: view)
    }
    
    func updateUIView(_ container: ViewContainer<Content>, context: Context) {
        container.child.rootView = view
        container.isContentHidden = isHidden
    }
    
    class ViewContainer<Content: View>: UIView {
        var child: UIHostingController<Content>
        var didShow = false
        var isContentHidden: Bool {
            didSet {
                addOrRemove()
            }
        }
        
        init(isContentHidden: Bool, child: Content) {
            self.child = UIHostingController(rootView: child)
            self.isContentHidden = isContentHidden
            super.init(frame: .zero)
            addOrRemove()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            child.view.frame = bounds
        }
        
        private func addOrRemove() {
            if isContentHidden && child.view.superview != nil {
                child.view.removeFromSuperview()
            }
            if !isContentHidden && child.view.superview == nil {
                if !didShow {
                    DispatchQueue.main.async {
                        if !self.isContentHidden {
                            self.addSubview(self.child.view)
                            self.didShow = true
                        }
                    }
                } else {
                    addSubview(child.view)
                }
            }
        }
        
    }
}
