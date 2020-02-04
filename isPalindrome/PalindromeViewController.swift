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
        label.text = StringHelper.isPalindrome
        label.numberOfLines = IntHelper.zero
        label.font.withSize(FontSize.big)
        return label
    }()

    private let insertTextLabel: UILabel = {
        let label = UILabel()
        label.text = StringHelper.insertText
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
        button.setTitle(StringHelper.checkButtonName, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(FontSize.medium)
        return label
    }()

    private let viewModel: ViewModelForViewController

    init(viewModel: ViewModelForViewController) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(StringHelper.requiredInitMessage)
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
            .drive(onNext: { [weak self] isPalindrome in
                self?.answerLabel.text = isPalindrome
                    ? StringHelper.itIsPalindrome
                    : StringHelper.noPalindrome
            })
            .disposed(by: disposeBag)

        palindromeTextField.rx.controlEvent(.allTouchEvents)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.answerLabel.text = StringHelper.emptyString
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
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: Constraints.topVertical)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Constraints.small, relation: .greaterThanOrEqual)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Constraints.small, relation: .greaterThanOrEqual)


        insertTextLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: Constraints.large)
        insertTextLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Constraints.small, relation: .equal)
        insertTextLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Constraints.small, relation: .greaterThanOrEqual)

        palindromeTextField.autoPinEdge(.top, to: .bottom, of: insertTextLabel)
        palindromeTextField.autoPinEdge(toSuperviewEdge: .left, withInset: Constraints.small, relation: .equal)
        palindromeTextField.autoPinEdge(toSuperviewEdge: .right, withInset: Constraints.small, relation: .equal)

        checkButton.autoPinEdge(.top, to: .bottom, of: palindromeTextField, withOffset: Constraints.tiny)
        checkButton.autoAlignAxis(toSuperviewAxis: .vertical)
        checkButton.autoPinEdge(toSuperviewEdge: .left, withInset: Constraints.small, relation: .greaterThanOrEqual)
        checkButton.autoPinEdge(toSuperviewEdge: .left, withInset: Constraints.small, relation: .greaterThanOrEqual)

        answerLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        answerLabel.autoPinEdge(.top, to: .bottom, of: checkButton, withOffset: Constraints.medium)
        answerLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Constraints.small, relation: .greaterThanOrEqual)
        answerLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Constraints.small, relation: .greaterThanOrEqual)
        answerLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constraints.small, relation: .greaterThanOrEqual)
    }
}
