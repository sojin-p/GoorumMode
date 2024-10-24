//
//  NavigationLazyView.swift
//  GoorumMode
//
//  Created by 박소진 on 10/24/24.
//

import SwiftUI

struct NavigationLazyView<T: View>: View {
    
    let build: () -> T
    
    init(_ build: @autoclosure @escaping () -> T) {
        self.build = build
    }
    
    var body: some View {
        build()
    }
    
}
