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
    var isGated: Bool = false
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
        sourFormula.id = UUID(uuidString: "00000000-0000-0000-0000-000000000020")!
        lastWordFormula.id = UUID(uuidString: "00000000-0000-0000-0000-000000000021")!
        punchFormula.id = UUID(uuidString: "00000000-0000-0000-0000-000000000022")!
        negroniFormula.id = UUID(uuidString: "00000000-0000-0000-0000-000000000023")!
        oldFashionedFormula.id = UUID(uuidString: "00000000-0000-0000-0000-000000000024")!
    }
    

    var sections: [SampleRecipeSection] {
        [
            SampleRecipeSection(
                title: "The Classics",
                recipes: [margarita, martini, maiTai, oldFashioned, negroni, manhattan, sidecar, sazerac, daiquiri, mojito, cosmopolitan, whiskeySour, gimlet, espressoMartini, boulevardier, mintJulep]
            ),
            SampleRecipeSection(
                title: "The Favorites",
                recipes: [lastWord, elPresidente, jungleBird, tomCollins, lostLake, corpseReviverNo2, coffeeDaquiri, turfClub, perfection, lapuLapu]
            ),
            SampleRecipeSection(
                title: "Originals",
                recipes: [lostWorld, skipperDan, mrPepperMD, mako],
                isGated: true
            ),
            SampleRecipeSection(
                title: "Formulas",
                recipes: [sourFormula, lastWordFormula, oldFashionedFormula, negroniFormula, punchFormula],
                isGated: true
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
                Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 2)
            ],
            instructions: "Shake with pebble ice and lime shell, then open pour into a Mai Tai or rocks glass. Garnish with spent lime shell and mint sprig, making it look like a little island with a palm tree sitting in a lagoon. You could go down an infinite rabbit hole on which rums in particular to use, but generally a pot-still or blended Jamaican rum is a safe bet."
        )
    
    private lazy var martini: Recipe =
        Recipe(
            name: "Martini",
            ingredients: [
                Ingredient(name: "dry vermouth", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2.5)
            ],
            instructions: "Stir with ice, then strain and serve up in a Nick and Nora glass with either an olive or a lemon twist. Feel free to adjust the ratio of gin to vermouth (this is a fairly standard 5/1 gin/vermouth ratio, but try anywhere from 1/1 to 10/1 depending on your preferences.)"
        )
    
    private lazy var margarita: Recipe =
        Recipe(
            name: "Margarita",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup or curaçao", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "tequila", unit: Ingredient.Unit.ounce, amount: 2)
            ],
            instructions: "Shake with ice, then strain into a rocks glass over ice. Garnish with a lime wheel. Optionally salt the rim of the glass. The tequila for a margarita is generally a blanco tequila, but it can be very good with reposado (or even mezcal!)"
        )
    
    private lazy var oldFashioned: Recipe =
        Recipe(
            name: "Old Fashioned",
            ingredients: [
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "bourbon", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2),
            ],
            instructions: "Stir with ice, then strain into a rocks glass over a large ice cube. Garnish with an orange twist."
        )
    
    private lazy var negroni: Recipe =
        Recipe(
            name: "Negroni",
            ingredients: [
                Ingredient(name: "sweet vermouth", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 1),
            ],
            instructions: "Stir with ice, then strain into a rocks glass over a large ice cube. Optionally garnish with an orange or lemon twist."
        )

    private lazy var manhattan: Recipe =
        Recipe(
            name: "Manhattan",
            ingredients: [
                Ingredient(name: "sweet vermouth", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "rye", unit: Ingredient.Unit.ounce, amount: 2.5),
                Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2)
            ],
            instructions: "Stir with ice, then strain into a chilled coupe glass. Optionally garnish with a cherry or orange twist."
        )
    
    private lazy var sazerac: Recipe =
        Recipe(
            name: "Sazerac",
            ingredients: [
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "rye", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "Peychaud's bitters", unit: Ingredient.Unit.dash, amount: 2),
                Ingredient(name: "absinthe rinse", unit: Ingredient.Unit.null, amount: 0)
            ],
            instructions: "Rinse a rocks glass with absinthe, then discard the excess. Stir rye, simple syrup, and Peychaud's bitters with ice, then strain into the prepared glass. Optionally garnish with a lemon twist."
        )

    private lazy var daiquiri: Recipe =
        Recipe(
            name: "Daiquiri",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount:  0.75),
                Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 2),
            ],
            instructions: "Shake with ice, then strain into a coupe or Nick and Nora glass. Optionally garnish with a lime wheel. The Daquiri is a great rum showcase, so try whatever rum you like, but an unaged or lightly aged column-still or blended rum is a safe bet."
        )

    private lazy var mojito: Recipe =
        Recipe(
            name: "Mojito",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "mint leaves", unit: Ingredient.Unit.null, amount: 6),
                Ingredient(name: "soda water", unit: Ingredient.Unit.ounce, amount: 2)
            ],
            instructions: "Muddle mint leaves with lime juice and simple syrup. Add rum and ice, then shake and strain into a highball glass. Top with soda water and garnish with a mint sprig."
        )

    private lazy var cosmopolitan: Recipe =
        Recipe(
            name: "Cosmopolitan",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "cranberry juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "vodka", unit: Ingredient.Unit.ounce, amount: 2),
            ],
            instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lime wheel or lime twist."
        )

    private lazy var moscowMule: Recipe =
        Recipe(
            name: "Moscow Mule",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "vodka", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "ginger beer", unit: Ingredient.Unit.ounce, amount: 4)
            ],
            instructions: "Shake vodka and lime juice with ice, then strain into a copper mug filled with ice. Top with ginger beer and garnish with a lime wedge."
        )

    private lazy var whiskeySour: Recipe =
        Recipe(
            name: "Whiskey Sour",
            ingredients: [
                Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "whiskey", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "(optional) egg white", unit: Ingredient.Unit.null, amount: 1)
            ],
            instructions: "Shake with ice, then strain into a rocks glass filled with ice. Optionally garnish with a lemon wheel."
        )

    private lazy var gimlet: Recipe =
        Recipe(
            name: "Gimlet",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2),
            ],
            instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lime wheel. An alternate version that is different but still quite good is to use 2 oz of gin and 1 oz of Rose's Lime Cordial, and stir instead of shake."
        )
    
    private lazy var lastWord: Recipe =
        Recipe(
            name: "Last Word",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Maraschino liqueur", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "green Chartreuse", unit: Ingredient.Unit.ounce, amount: 0.75),
            ],
            instructions: "Shake with ice, then strain into a coupe glass. No garnish. For a fun twist, substitute gin for mezcal."
        )

    private lazy var espressoMartini: Recipe =
        Recipe(
            name: "Espresso Martini",
            ingredients: [
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "cold brew coffee", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "coffee liqueur", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "vodka", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "mole or chocolate bitters", unit: Ingredient.Unit.dash, amount: 2)
            ],
            instructions: "Shake with ice, then strain into a coupe glass. Garnish with a lemon twist (this is not traditional, but it's much better. If you want to go traditional, garnish with three coffee beans.)"
        )
    
    private lazy var jungleBird: Recipe =
        Recipe(
            name: "Jungle Bird",
            ingredients: [
                Ingredient(name: "pineapple juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 1.5),
                Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.75),
            ],
            instructions: "Shake with ice, then strain into a rocks glass filled with ice. Optionally garnish with a pineapple wedge or mint sprig. A strong flavorful rum like an aged pot-still Jamaican rum or black rum is a safe bet."
        )

    private lazy var sidecar: Recipe =
        Recipe(
            name: "Sidecar",
            ingredients: [
                Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Cointreau", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "cognac", unit: Ingredient.Unit.ounce, amount: 2),
            ],
            instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lemon twist."
        )

    private lazy var tomCollins: Recipe =
        Recipe(
            name: "Tom Collins",
            ingredients: [
                Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "soda water", unit: Ingredient.Unit.ounce, amount: 2)
            ],
            instructions: "Shake gin, lemon juice, and simple syrup with ice, then strain into a highball glass filled with ice. Top with soda water and garnish with a lemon wheel and cherry."
        )

    private lazy var mintJulep: Recipe =
        Recipe(
            name: "Mint Julep",
            ingredients: [
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "bourbon", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "mint leaves", unit: Ingredient.Unit.null, amount: 6)
            ],
            instructions: "Muddle mint leaves with simple syrup. Add bourbon and ice, then stir until chilled. Strain into a julep cup or rocks glass filled with crushed ice. Garnish with a mint sprig."
        )

    private lazy var boulevardier: Recipe =
        Recipe(
            name: "Boulevardier",
            ingredients: [
                Ingredient(name: "sweet vermouth", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "bourbon", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 1),
            ],
            instructions: "Stir with ice, then strain into a rocks glass filled with ice. Optionally garnish with an orange twist."
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
            instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lime wheel or mint sprig. Passionfruit syrup is 1:1 or 1:2 frozen passsionfruit puree to sugar. Credit to Lost Lake in Chicago (RIP)."
        )

    private lazy var corpseReviverNo2: Recipe =
        Recipe(
            name: "Corpse Reviver No. 2",
            ingredients: [
                Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Lillet Blanc", unit: Ingredient.Unit.ounce, amount: 0.75),
            ],
            instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lemon twist."
        )
    
    private lazy var lostWorld: Recipe =
        Recipe(
            name: "Lost World",
            ingredients: [
                Ingredient(name: "passionfruit syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "scotch", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2)
            ],
            instructions: "Shake with ice, then strain into a coupe glass. Optionally garnish with a lime wheel or mint sprig. My riff on a Last Word + a Lost Lake."
        )

    private lazy var skipperDan: Recipe =
        Recipe(
            name: "Skipper Dan",
            ingredients: [
                Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "scotch", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "creme de banane", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "Benedictine", unit: Ingredient.Unit.ounce, amount: 0.75),
            ],
            instructions: "Shake with ice, then strain into a rocks glass over a large ice cube. An herbal tropical-adjacent sort of drink."
        )

    private lazy var mrPepperMD: Recipe =
        Recipe(
            name: "Mr. Pepper MD",
            ingredients: [
                Ingredient(name: "grenadine", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "amaretto", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "cherry liqueur", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "absinthe", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "rye", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "Angostura bitters", unit: Ingredient.Unit.dash, amount: 2)
            ],
            instructions: "Stir with ice, then strain and serve either up in a coupe glass or on the rocks in a rocks glass. Optionally garnish with a cherry. Quite boozy, quite sweet, but a surprising bit like a certain specific soda"
        )

    private lazy var mako: Recipe =
        Recipe(
            name: "Mako",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "orange juice", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "coconut water syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "rum agricole", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "overproof rum", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "Campari", unit: Ingredient.Unit.ounce, amount: 0.5),
            ],
            instructions: "Shake, then strain into a rocks glass with crushed ice. Optionally garnish with a lime wheel or mint sprig. Coconut water syrup is 1:1 coconut water and sugar. Grassy and tropical!"
        )

    private lazy var elPresidente: Recipe =
        Recipe(
            name: "El Presidente",
            ingredients: [
                Ingredient(name: "grenadine", unit: Ingredient.Unit.barspoon, amount: 1),
                Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "dry or blanc vermouth", unit: Ingredient.Unit.ounce, amount: 0.75),
                Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 1.5),
            ],
            instructions: "Stir with ice, then strain into a coupe glass. Optionally garnish with an orange twist. Traditionally this is made with blanc vermouth, which is different from dry vermouth and a bit sweeter. I actually prefer dry vermouth, though I'm in the minority!"
        )

    private lazy var coffeeDaquiri: Recipe =
        Recipe(
            name: "Coffee Daiquiri",
            ingredients: [
                Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "coffee liqueur", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "rum", unit: Ingredient.Unit.ounce, amount: 1),
            ],
            instructions: "Shake with ice, then strain into a coupe glass."
        )

    private lazy var turfClub: Recipe =
        Recipe(
            name: "Turf Club",
            ingredients: [
                Ingredient(name: "dry vermouth", unit: Ingredient.Unit.ounce, amount: 1.5),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 1.5),
                Ingredient(name: "orange bitters", unit: Ingredient.Unit.dash, amount: 3),
                Ingredient(name: "absinthe rinse", unit: Ingredient.Unit.null, amount: 0)
            ],
            instructions: "Rinse a coupe glass with absinthe, then discard the excess. Stir gin, vermouth, and bitters with ice, then strain into the prepared glass. Optionally garnish with a lemon twist."
        )

    private lazy var perfection: Recipe =
        Recipe(
            name: "Perfection",
            ingredients: [
                Ingredient(name: "Maraschino liqueur", unit: Ingredient.Unit.ounce, amount: 0.25),
                Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "Lillet blanc", unit: Ingredient.Unit.ounce, amount: 0.5),
                Ingredient(name: "absinthe", unit: Ingredient.Unit.dash, amount: 4)
            ],
            instructions: "Stir with ice, then strain into a coupe glass. Optionally garnish with an orange twist. Credit to a tiktoker I saw years ago who I've since forgotten."
        )

    private lazy var lapuLapu: Recipe =
        Recipe(
            name: "Lapu Lapu",
            ingredients: [
                Ingredient(name: "orange juice", unit: Ingredient.Unit.ounce, amount: 3),
                Ingredient(name: "lemon juice", unit: Ingredient.Unit.ounce, amount: 2),
                Ingredient(name: "passionfruit syrup", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 1),
                Ingredient(name: "light rum", unit: Ingredient.Unit.ounce, amount: 1.5),
                Ingredient(name: "dark rum", unit: Ingredient.Unit.ounce, amount: 1.5),
                
            ],
            instructions: "Shake with ice, then open pour into a large tiki mug. Credit to the Polynesian Resort at Walt Disney World."
        )

    private lazy var sourFormula: Recipe =
        Recipe(
            name: "Sour formula",
            ingredients: [
                Ingredient(name: "base spirit", unit: Ingredient.Unit.null, amount: 2),
                Ingredient(name: "acid", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "sweet", unit: Ingredient.Unit.null, amount: 1),
            ],
            instructions: "Sours typically have a 2/1/1 ratio of a base spirit, an acid (like citrus juice), and a sweet component (like syrups or sweet liqueuers).\n\nExamples of sours include whisky sours and margaritas (which is effectively a 'tequila sour'!) You can adjust the ratios if you find it too sour or too sweet; another common ratio is 2/0.75/0.75. For a sour, you should typically shake with ice, then serve either on the rocks or up.\n\nA traditional sour is 2 oz base, 1 oz acid, 1 oz sweet.\n\nIf you really want to have fun, start splitting up elements. For instance, note that a traditional Mai Tai is almost exactly a rum sour, but with its 1 oz of sweet split between simple syrup, orgeat, and curaçao."
        )
    
    private lazy var lastWordFormula: Recipe =
        Recipe(
            name: "Last Word formula",
            ingredients: [
                Ingredient(name: "base spirit", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "acid", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "sweet liqueuer", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "herbal liqueuer", unit: Ingredient.Unit.null, amount: 1),
            ],
            instructions: "Credit to the How To Drink YouTube channel, Greg identified that a Last Word cocktail follows a formula that is very repeatable!\n\nLike a sour you want some base spirit and some acidic component, but the Last Word formula adds in sweet liqueuers and herbal liqueuers.\n\nIn a Last Word itself, the four components are gin/lime juice/Maraschino liqueur/Green Chartreuse, but you can see in the 'Originals' section the Lost World and Skipper Dan are other tweaks on the formula.\n\nA traditional Last Word is 0.75 oz of each ingredient, and is shaken with ice, then served up."
        )
    
    private lazy var punchFormula: Recipe =
        Recipe(
            name: "Caribbean Punch formula",
            ingredients: [
                Ingredient(name: "sour", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "sweet", unit: Ingredient.Unit.null, amount: 2),
                Ingredient(name: "strong", unit: Ingredient.Unit.null, amount: 3),
                Ingredient(name: "weak", unit: Ingredient.Unit.null, amount: 4),
            ],
            instructions: "The classic rhyme for a traditional Caribbean (specifically Barbadan) 'punch' recipe is 'one of sour, two of sweet, three of strong, and four of weak'.\n\nIn this case sour and sweet are fairly straightforward (acid and sweeteners), strong refers to a base spirit, and weak is something to lengthen and mellow out the drink. Traditionally 'weak' would be tea or water (as ice is hard to come by the Caribbean in the 1700s!) but it could be a non-acidic juice or anything else you can think of! The only real requirements is to balance out the sour/sweet/strong (meaning it should probably not be overly sour, sweet, or strong/boozy.)\n\nPunches are traditional group beverages served in a large bowl, so scale this up to your party size. If served with ice, you may want to adjust the 'weak' to compensate for the ice melting."
        )
    
    private lazy var negroniFormula: Recipe =
        Recipe(
            name: "Negroni formula",
            ingredients: [
                Ingredient(name: "base spirit", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "strongly flavored liqueur", unit: Ingredient.Unit.null, amount: 1),
                Ingredient(name: "sweet(er) liqueuer", unit: Ingredient.Unit.null, amount: 1),
            ],
            instructions: "Most notable in the actual Negroni, where you have equal parts base spirit (gin), strongly flavored liqueur (Campari), and sweet liquer (sweet vermouth.) You can sub out almost every element of this and get something delicious, provided the flavors work together! Try different amaros instead of Campari, different fruit or sweet liqueurs instead of vermouth, and different base spirits instead of gin. I've recently been enjoying one that uses gin, Amaro Montenegro, and apricot liqueur.\n\nA traditional Negroni is 1 oz of each ingredient, and is typically stirred with ice, then served over a large ice cube in a rocks glass."
        )
    
    private lazy var oldFashionedFormula: Recipe =
        Recipe(
            name: "Old Fashioned formula",
            ingredients: [
                Ingredient(name: "base spirit", unit: Ingredient.Unit.null, amount: 2),
                Ingredient(name: "sweet", unit: Ingredient.Unit.null, amount: 0.25),
                Ingredient(name: "bitters", unit: Ingredient.Unit.dash, amount: 1),
                Ingredient(name: "citrus twist", unit: Ingredient.Unit.null, amount: 1),
            ],
            instructions: "The Old Fashioned as a specific cocktail is traditionally made with bourbon (base spirit), either sugar or simple syrup (sweet), Angostura bitters (bitters), and an orange twist (citrus twist). But the Old Fashioned as a type of cocktail is very flexible! If you like the traditional Old Fashioned but want to explore alternatives, consider sticking with bourbon but swapping sugar or syrup for a sweet liqueur or different syrup, or changing the bitters or the citrus twist. Alternatively, you can keep everything else the same and sub out the base spirit! Or change everything!\n\nYou may be tempted to skip the citrus twist: don't! If you want a fun experiment, next time you make an Old Fashioned style drink, try it first without the twist, then again after spritzing the twist over the drink, and observe how it fundamentally changes the drink.\n\nA traditional Old Fashioned is stirred with ice, then served over a large ice cube in a rocks glass."
        )
    
}
