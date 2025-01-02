//
//  CardView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct CardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name).font(.headline)
            Spacer()
            HStack {
                Label("\(recipe.ingredients.count)", systemImage: "list.bullet.clipboard.fill")
                    .padding(.trailing, 20)
            }
            .font(.caption)
        }
        .padding()
    }
}


struct CardView_Previews: PreviewProvider {
    static var recipe = Recipe.sampleRecipes[0]
    static var previews: some View {
        CardView(recipe: recipe)
    }
}
