//
//  SampleRecipeLibrary.swift
//  Chaser
//
//  Created by Andrew Whipple on 2/6/26.
//

import Foundation
import SwiftUI

struct SampleRecipeSection {
    let title: String
    let recipes: [Recipe]
}

class SampleRecipeLibrary {
    // All sample recipes in one place for easy editing
    static let shared = SampleRecipeLibrary()
    
    private init() {
        // Initialize sample recipes with stable UUIDs
        maiTai.id = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        martini.id = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        margarita.id = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        oldFashioned.id = UUID(uuidString: "00000000-0000-0000-0000-000000000004")!
        negroni.id = UUID(uuidString: "00000000-0000-0000-0000-000000000005")!
        manhattan.id = UUID(uuidString: "00000000-0000-0000-0000-000000000006")!
        sazerac.id = UUID(uuidString: "00000000-0000-0000-0000-000000000007")!
        daiquiri.id = UUID(uuidString: "00000000-0000-0000-0000-000000000008")!
        mojito.id = UUID(uuidString: "00000000-0000-0000-0000-000000000009")!
        cosmopolitan.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!
        moscowMule.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!
        whiskeySour.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000C")!
        gimlet.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000D")!
        lastWord.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000E")!
        espressoMartini.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000F")!
        jungleBird.id = UUID(uuidString: "00000000-0000-0000-0000-000000000010")!
        sidecar.id = UUID(uuidString: "00000000-0000-0000-0000-000000000011")!
        tomCollins.id = UUID(uuidString: "00000000-0000-0000-0000-000000000012")!
        mintJulep.id = UUID(uuidString: "00000000-0000-0000-0000-000000000013")!
        boulevardier.id = UUID(uuidString: "00000000-0000-0000-0000-000000000014")!
        lostLake.id = UUID(uuidString: "00000000-0000-0000-0000-000000000015")!
        corpseReviverNo2.id = UUID(uuidString: "00000000-0000-0000-0000-000000000016")!
        lostWorld.id = UUID(uuidString: "00000000-0000-0000-0000-000000000017")!
        skipperDan.id = UUID(uuidString: "00000000-0000-0000-0000-000000000018")!
        mrPepperMD.id = UUID(uuidString: "00000000-0000-0000-0000-000000000019")!
        mako.id = UUID(uuidString: "00000000-0000-0000-0000-00000000001A")!
        elPresidente.id = UUID(uuidString: "00000000-0000-0000-0000-00000000001B")!
        coffeeDaquiri.id = UUID(uuidString: "00000000-0000-0000-0000-00000000001C")!
        turfClub.id = UUID(uuidString: "00000000-0000-0000-0000-00000000001D")!
        perfection.id = UUID(uuidString: "00000000-0000-0000-0000-00000000001E")!
        lapuLapu.id = UUID(uuidString: "00000000-0000-0000-0000-00000000001F")!
    }
    
    var sections: [SampleRecipeSection] {
        [
            SampleRecipeSection(
                title: "The Classics (you can't go wrong)",
                recipes: [margarita, martini, maiTai, oldFashioned, negroni, manhattan, sidecar, sazerac, daiquiri, mojito, cosmopolitan, moscowMule, whiskeySour, gimlet, espressoMartini, boulevardier, mintJulep]
            ),
            SampleRecipeSection(
                title: "The Favorites (a fun twist)",
                recipes: [lastWord, elPresidente, jungleBird, tomCollins, lostLake, corpseReviverNo2, coffeeDaquiri, turfClub, perfection, lapuLapu]
            ),
            SampleRecipeSection(
                title: "On The House (our special creations)",
                recipes: [lostWorld, skipperDan, mrPepperMD, mako]
            )
        ]
    }
    
    var allRecipes: [Recipe] {
        sections.flatMap { $0.recipes }
    }
    
    // Using lazy var to create instances once with stable IDs
    
    private lazy var maiTai: Recipe =
        Recipe(
            name: "Mai Tai",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "orgeat", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "jamaican rum", unit: Ingredient.Unit.ounce, amount: 2)
            ],
            instructions: "Shake with pebble ice and lime shell, then open pour into a mai tai or rocks glass. Garnish with spent lime shell and mint sprig, to make it look like a little island with a tree in a lagoon."
        )
    
    private lazy var martini: Recipe =
        Recipe(
            name: "Martini",
            ingredients: [
                Ingredient(name: "dry vermouth", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2.5)
            ],
            instructions: "Stir with ice, then strain and serve up with either olive or lemon twist"
        )
    
    private lazy var margarita: Recipe =
        Recipe(
            name: "Margarita",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup or curaçao", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "tequila", unit: Ingredient.Unit.ounce, amount: 2)
            ],
            instructions: "Shake with ice, then strain into a rocks glass over ice. Garnish with a lime wheel. Optionally salt the rim of the glass."
        )
    
    private lazy var oldFashioned: Recipe =
        Recipe(
            name: "Old Fashioned",
            ingredients: [
                Ingredient(name: "bourbon", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2),
            ],
            instructions: "Stir with ice, then strain into a rocks glass over a large ice cube. Garnish with an orange twist."
        )
    
    private lazy var negroni: Recipe =
        Recipe(
            name: "Negroni",
            ingredients: [
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "sweet vermouth", unit: Ingredient.Unit.ounce, amount: 1)
            ],
            instructions: "Stir with ice, then strain into a rocks glass over a large ice cube. Optionally garnish with an orange or lemon twist."
        )

    private lazy var manhattan: Recipe =
        Recipe(
            name: "Manhattan",
            ingredients: [
                Ingredient(name: "rye", unit: Ingredient.Unit.ounce, amount: 2.5),
                Ingredient(name: "sweet vermouth", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2)
            ],
            instructions: "Stir with ice, then strain into a chilled coupe glass. Optionally garnish with a cherry or orange twist."
        )
    
    private lazy var sazerac: Recipe =
    Recipe(
        name: "Sazerac",
        ingredients: [
            Ingredient(name: "rye", unit: Ingredient.Unit.ounce, amount: 2),
            Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
            Ingredient(name: "Peychaud's bitters", unit: Ingredient.Unit.dash, amount: 2),
            Ingredient(name: "absinthe", unit: Ingredient.Unit.null, amount: 0)
        ],
        instructions: "Rinse a rocks glass with absinthe, then discard the excess. Stir rye, simple syrup, and Peychaud's bitters with ice, then strain into the prepared glass. Garnish with a lemon twist."
    )

    private lazy var daiquiri: Recipe =
    Recipe(
    name: "Daiquiri",
    ingredients: [
        Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount:  0.75)
    ],
    instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lime wheel."
    )   

    private lazy var mojito: Recipe =
    Recipe(
    name: "Mojito",
    ingredients: [
        Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "mint leaves", unit: Ingredient.Unit.null, amount: 6),
        Ingredient(name: "soda water", unit: Ingredient.Unit.ounce, amount: 2)
    ],
    instructions: "Muddle mint leaves with lime juice and simple syrup. Add rum and ice, then shake and strain into a highball glass. Top with soda water and garnish with a mint sprig."
    )   

    private lazy var cosmopolitan: Recipe =
    Recipe(
    name: "Cosmopolitan",
    ingredients: [
        Ingredient(name: "vodka", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "Cointreau", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "cranberry juice", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake with ice and strain into a coupe glass. Optionally garnish with a lime wheel or twist."
    )   

    private lazy var moscowMule: Recipe =
    Recipe(
    name: "Moscow Mule",
    ingredients: [
        Ingredient(name: "vodka", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "ginger beer", unit: Ingredient.Unit.ounce, amount: 4)
    ],
    instructions: "Shake vodka and lime juice with ice, then strain into a copper mug filled with ice. Top with ginger beer and garnish with a lime wedge."
    )

    private lazy var whiskeySour: Recipe =
    Recipe(
    name: "Whiskey Sour",
    ingredients: [
        Ingredient(name: "whiskey", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "(optional) egg white", unit: Ingredient.Unit.null, amount: 1)
    ],
    instructions: "Shake with ice and strain into a rocks glass filled with ice. Optionally garnish with a lemon wheel or cherry."
    )

    private lazy var gimlet: Recipe =
    Recipe(
    name: "Gimlet",
    ingredients: [
        Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake with ice and strain into a coupe glass. Optionally garnish with a lime wheel."
    )   
    
    private lazy var lastWord: Recipe =
    Recipe(
    name: "Last Word",
    ingredients: [
        Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "green Chartreuse", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "maraschino liqueur", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake with ice and strain into a coupe glass. No garnish. For a fun twist, substitute gin for mezcal."
    )

    private lazy var espressoMartini: Recipe =
    Recipe(
    name: "Espresso Martini",
    ingredients: [
        Ingredient(name: "vodka", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "cold brew coffee", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "coffee liqueur", unit: Ingredient.Unit.ounce, amount: 0.5),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "mole or chocolate bitters", unit: Ingredient.Unit.dash, amount: 2)
    ],
    instructions: "Shake with ice and strain into a coupe glass. Garnish with a lemon twist (this is not traditional, but it's much better: if you want to go traditional, garnish with three coffee beans.)"
    )
    
    private lazy var jungleBird: Recipe =
    Recipe(
    name: "Jungle Bird",
    ingredients: [
        Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 1.5),
        Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "pineapple juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25)
    ],
    instructions: "Shake with ice and strain into a rocks glass filled with ice. Optionally garnish with a pineapple wedge or mint sprig."
    )

    private lazy var sidecar: Recipe =
    Recipe(
    name: "Sidecar",
    ingredients: [
        Ingredient(name: "cognac", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "Cointreau", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake with ice and strain into a coupe glass. Optionally garnish with a lemon twist."
    )

    private lazy var tomCollins: Recipe =
    Recipe(
    name: "Tom Collins",
    ingredients: [
        Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "soda water", unit: Ingredient.Unit.ounce, amount: 2)
    ],
    instructions: "Shake gin, lemon juice, and simple syrup with ice, then strain into a highball glass filled with ice. Top with soda water and garnish with a lemon wheel and cherry."
    ) 

    private lazy var mintJulep: Recipe =
    Recipe(
    name: "Mint Julep",
    ingredients: [
        Ingredient(name: "bourbon", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "mint leaves", unit: Ingredient.Unit.null, amount: 6)
    ],
    instructions: "Muddle mint leaves with simple syrup. Add bourbon and ice, then stir until well chilled. Strain into a julep cup or rocks glass filled with crushed ice. Garnish with a mint sprig."
    )

    private lazy var boulevardier: Recipe =
    Recipe(
    name: "Boulevardier",
    ingredients: [
        Ingredient(name: "bourbon", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "sweet vermouth", unit: Ingredient.Unit.ounce, amount: 1)
    ],
    instructions: "Stir with ice and strain into a rocks glass filled with ice. Optionally garnish with an orange twist."
    )

    private lazy var lostLake: Recipe =
    Recipe(
    name: "Lost Lake",
    ingredients: [
        Ingredient(name: "jamaican rum", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "pineapple juice", unit: Ingredient.Unit.ounce, amount: 0.5),
        Ingredient(name: "passionfruit syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "Maraschino liqueur", unit: Ingredient.Unit.ounce, amount: 0.25),

    ],
    instructions: "Shake with ice and strain into a coupe glass. Optionally garnish with a lime wheel or mint sprig. Credit Lost Lake in Chicago (RIP)."
    )

    private lazy var corpseReviverNo2: Recipe =
    Recipe(
    name: "Corpse Reviver No. 2",
    ingredients: [
        Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "Cointreau", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "Lillet Blanc", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake with ice and strain into a coupe glass. Optionally garnish with a lemon twist."
    )
    
    private lazy var lostWorld: Recipe =
    Recipe(
    name: "Lost World",
    ingredients: [
        Ingredient(name: "scotch", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "passionfruit syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2)
    ],
    instructions: "Shake with ice and strain into a coupe glass. Optionally garnish with a lime wheel or mint sprig. My riff on a Last Word + a Lost Lake."
    )

    private lazy var skipperDan: Recipe =
    Recipe(
    name: "Skipper Dan",
    ingredients: [
        Ingredient(name: "scotch", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "creme de banane", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "Benedictine", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake with ice and strain into a rocks glass over a large ice cube. An herbal tropical-adjacent sort of drink."
    )

    private lazy var mrPepperMD: Recipe =
    Recipe(
    name: "Mr. Pepper MD",
    ingredients: [
        Ingredient(name: "rye", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "amaretto", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "absinthe", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "grenadine", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "cherry liqueur", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2)
    ],
    instructions: "Stir with ice then serve either up in a coupe glass or on the rocks in a rocks glass. Optionally garnish with a cherry. Quite boozy, quite sweet, but a surprising bit like a certain specific soda"
    )

    private lazy var mako: Recipe =
    Recipe(
    name: "Mako",
    ingredients: [
        Ingredient(name: "rum agricole", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "overproof rum", unit: Ingredient.Unit.ounce, amount: 0.5),
        Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.5),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "orange juice", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "coconut water syrup", unit: Ingredient.Unit.ounce, amount: 0.75)
    ],
    instructions: "Shake, then strain into a rocks glass with crushed ice. Optionally garnish with a lime wheel or mint sprig. Coconut water syrup is 1:1 coconut water and sugar. Grassy and tropical!"
    ) 

    private lazy var elPresidente: Recipe =
    Recipe(
    name: "El Presidente",
    ingredients: [
        Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 1.5),
        Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.5),
        Ingredient(name: "dry or blanc vermouth", unit: Ingredient.Unit.ounce, amount: 0.75),
        Ingredient(name: "grenadine", unit: Ingredient.Unit.barspoon, amount: 1)
    ],
    instructions: "Stir with ice and strain into a coupe glass. Optionally garnish with an orange twist."
    )

    private lazy var coffeeDaquiri: Recipe =
    Recipe(
    name: "Coffee Daiquiri",
    ingredients: [
        Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "coffee liqueur", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 1),
    ],
    instructions: "Shake with ice and strain into a coupe glass."
    )

    private lazy var turfClub: Recipe =
    Recipe(
    name: "Turf Club",
    ingredients: [
        Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 1.5),
        Ingredient(name: "dry vermouth", unit: Ingredient.Unit.ounce, amount: 1.5),
        Ingredient(name: "orange bitters", unit: Ingredient.Unit.dash, amount: 3),
        Ingredient(name: "absinthe", unit: Ingredient.Unit.null, amount: 0)
    ],
    instructions: "Rinse a coupe glass with absinthe, then discard the excess. Stir gin, vermouth, and bitters with ice, then strain into the prepared glass. Optionally garnish with a lemon twist."
    )

    private lazy var perfection: Recipe =
    Recipe(
    name: "Perfection",
    ingredients: [
        Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "Lillet blanc", unit: Ingredient.Unit.ounce, amount: 0.5),
        Ingredient(name: "Maraschino liqueur", unit: Ingredient.Unit.ounce, amount: 0.25),
        Ingredient(name: "absinthe", unit: Ingredient.Unit.dash, amount: 4)
    ],
    instructions: "Stir with ice and strain into a coupe glass. Optionally garnish with an orange twist. Credit to a tiktoker I saw years ago who I've since forgotten."
    )

    private lazy var lapuLapu: Recipe =
    Recipe(
    name: "Lapu Lapu",
    ingredients: [
        Ingredient(name: "light rum", unit: Ingredient.Unit.ounce, amount: 1.5),
        Ingredient(name: "dark rum", unit: Ingredient.Unit.ounce, amount: 1.5),
        Ingredient(name: "orange juice", unit: Ingredient.Unit.ounce, amount: 3),
        Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 2),
        Ingredient(name: "passionfruit syrup", unit: Ingredient.Unit.ounce, amount: 1),
        Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 1)
    ],
    instructions: "Shake with ice and open pour into a large tiki mug. Credit Polynesian Resort at Walt Disney World."
    )   



    
}
