//
//  FreeFormTextInputView.swift
//  Chaser
//
//  Created by Andrew Whipple on 3/13/25.
//

import SwiftUI


// This is a freeform box launched from DetailEditView with a dismiss/done toolbar that takes a blob of text, runs it through the local llm, parses to JSON, and populates the DetailEditView (overwriting it)

// To start no warning about overwriting existing content, but add that in next once it's working
struct FreeformInputEditView: View {
    @Binding var inputText: String
    
    var body: some View {
        Form {
            TextField("Recipe text", text: $inputText, axis: .vertical)
                .lineLimit(10...)
        }
    }
}


struct FreeformInputEditViewPreview: PreviewProvider {
    static var previews: some View {
        FreeformInputEditView(inputText: .constant(""))
    }
}
