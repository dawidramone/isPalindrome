//
//  PalindromeViewController.swift
//  isPalindrome
//
//  Created by Dawid Ramone on 04/02/2020.
//  Copyright © 2020 Dawid Ramone. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift
import RxCocoa

class PalindromeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Czy jest palindromem"
        label.numberOfLines = 0
        label.font.withSize(40)
        return label
    }()

    private let insertTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Wpisz tekst:"
        return label
    }()

    private let palindromeTextFiled: UITextField = {
        let txtFiled = UITextField()
        txtFiled.borderStyle = .roundedRect
        return txtFiled
    }()

    private let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sprawdź", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(20)
        return label
    }()

    private let palindromeViewModel = PalindromeViewModel()

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        addSubviews()
        createConstraints()
        bind()
    }

    private func bind() {
        checkButton.rx.tap
            .asDriver()
            .withLatestFrom(palindromeTextFiled.rx.text.asDriver())
            .map { self.palindromeViewModel.isPalindrome(input: $0) }
            .drive(onNext: { (isPalindrome) in
                self.answerLabel.text = isPalindrome
                ? "Jest Palidromem!"
                : "Nie jest Palidromem!"
    
                self.palindromeTextFiled.text = ""
            })
            .disposed(by: disposeBag)

    }

    private func addSubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(insertTextLabel)
        self.view.addSubview(palindromeTextFiled)
        self.view.addSubview(checkButton)
        self.view.addSubview(answerLabel)
    }

    private func createConstraints() {
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 36)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .greaterThanOrEqual)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)


        insertTextLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 26)
        insertTextLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .equal)
        insertTextLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)

        palindromeTextFiled.autoPinEdge(.top, to: .bottom, of: insertTextLabel)
        palindromeTextFiled.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .equal)
        palindromeTextFiled.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .equal)

        checkButton.autoPinEdge(.top, to: .bottom, of: palindromeTextFiled, withOffset: 8)
        checkButton.autoAlignAxis(toSuperviewAxis: .vertical)
        checkButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .greaterThanOrEqual)
        checkButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .greaterThanOrEqual)

        answerLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        answerLabel.autoPinEdge(.top, to: .bottom, of: checkButton, withOffset: 20)
        answerLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .greaterThanOrEqual)
        answerLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
        answerLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16, relation: .greaterThanOrEqual)
    }
}
