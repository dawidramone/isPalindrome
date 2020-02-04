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

    private let palindromeTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
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

    private let viewModel: ViewModelForViewController

    init(viewModel: ViewModelForViewController) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        addSubviews()
        createConstraints()
        bind()
    }

    private func bind() {
        checkButton.rx.tap
            .asDriver()
            .withLatestFrom(palindromeTextField.rx.text.asDriver())
            .map { self.viewModel.isPalindrome(input: $0) }
            .drive(onNext: { (isPalindrome) in
                self.answerLabel.text = isPalindrome
                ? "Jest Palidromem!"
                : "Nie jest Palidromem!"
            })
            .disposed(by: disposeBag)

        palindromeTextField.rx.controlEvent(.allTouchEvents)
            .asObservable()
            .subscribe(onNext: {
                self.answerLabel.text = ""
            })
            .disposed(by: disposeBag)

        palindromeTextField.rx.text.asObservable()
            .map { $0?.isEmpty ?? true }
            .map { !$0 }
            .bind(to: checkButton.rx.isEnabled)
            .disposed(by: disposeBag)

    }

    private func addSubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(insertTextLabel)
        self.view.addSubview(palindromeTextField)
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

        palindromeTextField.autoPinEdge(.top, to: .bottom, of: insertTextLabel)
        palindromeTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 16, relation: .equal)
        palindromeTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .equal)

        checkButton.autoPinEdge(.top, to: .bottom, of: palindromeTextField, withOffset: 8)
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
