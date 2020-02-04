//
//  isPalindromeTests.swift
//  isPalindromeTests
//
//  Created by Dawid Ramone on 04/02/2020.
//  Copyright © 2020 Dawid Ramone. All rights reserved.
//

import XCTest
@testable import isPalindrome
class isPalindromeTests: XCTestCase {

    func testIsPalindrome() {
        let palindromeViewModel = PalindromeViewModel()
        let isPalindrome = palindromeViewModel.isPalindrome(input: "rotator")
        XCTAssertEqual(true, isPalindrome)
    }
}
