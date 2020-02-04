//
//  PalindromeViewModel.swift
//  isPalindrome
//
//  Created by Dawid Ramone on 04/02/2020.
//  Copyright © 2020 Dawid Ramone. All rights reserved.
//

import Foundation

class PalindromeViewModel: ViewModelForViewController {

    init() {}

    func isPalindrome(input: String?) -> Bool {
        guard let input = input else { return false }
        let lowercase = input.lowercased()
        return lowercase.reversed() == Array(lowercase)
    }
}
