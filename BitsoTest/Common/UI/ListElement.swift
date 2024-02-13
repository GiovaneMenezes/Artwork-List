//
//  ListElement.swift
//  BitsoTest
//
//  Created by Giovane Cavalcante on 13/02/24.
//

import SwiftUI

struct ListElement: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.system(size: 18, weight: .semibold))
            Text(subtitle)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ListElement(title: "Title", subtitle: "Subtitle")
}
