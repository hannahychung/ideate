//
//  Trait.swift
//  ideate
//
//  Created by Hannah Chung on 3/28/26.
//

import Foundation

    public enum TraitType: CaseIterable {
        case guidance
        case exploration
        case inspiration
        case action
    }

    public struct Trait {
        let type: String
        var strength: Int
    }
