import AdventKit
import Foundation

class Day14: Day {
    struct Chemical: Hashable {
        var name: String
        var amount: Int
    }

    struct Reaction: Hashable {
        var ingredients: [Chemical]
        var product: Chemical
    }

    func parse(component: String) -> Chemical {
        let parts = component.components(separatedBy: .whitespaces)
        return Chemical(name: parts[1], amount: Int(parts[0])!)
    }

    func parse(input: String) -> [Reaction] {
        var reactions: [Reaction] = []
        input.enumerateLines { line in
            let parts = line.components(separatedBy: "=>")
            let ingredientStrings = parts[0].trimmingCharacters(in: .whitespaces).components(separatedBy: ", ")
            let productString = parts[1].trimmingCharacters(in: .whitespaces)
            let ingredients = ingredientStrings.map({ parse(component: $0) })
            let product = parse(component: productString)
            reactions.append(Reaction(ingredients: ingredients, product: product))
        }

        return reactions
    }

    func requirements(for requirements: [String: Int], reactions: [Reaction]) -> Int {
        var reactionsByName: [String: Reaction] = [:]
        for reaction in reactions {
            reactionsByName[reaction.product.name] = reaction
        }

        var requirements = requirements
        var extras: [String: Int] = [:]
        while requirements.count != 1 || requirements["ORE"] == nil {
            let (name, amountNeeded) = requirements.first { (key, _) -> Bool in
                return key != "ORE"
            }!

            let reaction = reactionsByName[name]!
            let numReactionsNeeded = Int(ceil(Double(amountNeeded) / Double(reaction.product.amount)))
            let amountCreated = reaction.product.amount * numReactionsNeeded
            let extraProduct = amountCreated - amountNeeded
            requirements[name] = nil

            if extraProduct > 0 {
                extras[name] = (extras[name] ?? 0) + extraProduct
            }

            for ingredient in reaction.ingredients {
                var amountOfIngredientNeeded = (requirements[ingredient.name] ?? 0) + ingredient.amount * numReactionsNeeded
                if let extra = extras[ingredient.name] {
                    if extra > amountOfIngredientNeeded {
                        extras[ingredient.name] = extra - amountOfIngredientNeeded
                        amountOfIngredientNeeded = 0
                    } else {
                        amountOfIngredientNeeded = amountOfIngredientNeeded - extra
                        extras[ingredient.name] = nil
                    }
                }

                requirements[ingredient.name] = (amountOfIngredientNeeded > 0) ? amountOfIngredientNeeded : nil
            }
        }

        return requirements["ORE"]!
    }

    override func part1() -> String {
        let reactions = parse(input: inputString)
        return requirements(for: ["FUEL": 1], reactions: reactions).description
    }

    override func part2() -> String {
        let reactions = parse(input: inputString)
        var mostFuel = 0
        var increment = 1000000000000
        while increment > 0 {
            let ore = requirements(for: ["FUEL": mostFuel + increment], reactions: reactions)
            if ore > 1000000000000 {
                increment = increment / 10
            } else {
                mostFuel += increment
            }
        }

        return mostFuel.description
    }
}

let test1 = """
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
"""

print("Test 1: \(Day14(input: test1).part1())")

let test2 = """
9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
"""

print("Test 2: \(Day14(input: test2).part1())")

let test3 = """
157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
"""

print("Test 3: \(Day14(input: test3).part1())")

let test4 = """
2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
"""

print("Test 4: \(Day14(input: test4).part1())")

let test5 = """
171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
"""

print("Test 5: \(Day14(input: test5).part1())")

Day14().run()
