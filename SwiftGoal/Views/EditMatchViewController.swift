//
//  EditMatchViewController.swift
//  SwiftGoal
//
//  Created by Martin Richter on 22/06/15.
//  Copyright (c) 2015 Martin Richter. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit

class EditMatchViewController: UIViewController {

    let viewModel: EditMatchViewModel

    private weak var homeGoalsLabel: UILabel!
    private weak var goalSeparatorLabel: UILabel!
    private weak var awayGoalsLabel: UILabel!
    private weak var homeGoalsStepper: UIStepper!
    private weak var awayGoalsStepper: UIStepper!

    // MARK: Lifecycle

    init(viewModel: EditMatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: Selector("cancelButtonTapped")
        )
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    override func loadView() {
        let view = UIView()

        view.backgroundColor = UIColor.whiteColor()

        let labelFont = UIFont(name: "OpenSans-Semibold", size: 70)

        let homeGoalsLabel = UILabel()
        homeGoalsLabel.font = labelFont
        view.addSubview(homeGoalsLabel)
        self.homeGoalsLabel = homeGoalsLabel

        let goalSeparatorLabel = UILabel()
        goalSeparatorLabel.font = labelFont
        goalSeparatorLabel.text = ":"
        view.addSubview(goalSeparatorLabel)
        self.goalSeparatorLabel = goalSeparatorLabel

        let awayGoalsLabel = UILabel()
        awayGoalsLabel.font = labelFont
        view.addSubview(awayGoalsLabel)
        self.awayGoalsLabel = awayGoalsLabel

        let homeGoalsStepper = UIStepper()
        view.addSubview(homeGoalsStepper)
        self.homeGoalsStepper = homeGoalsStepper

        let awayGoalsStepper = UIStepper()
        view.addSubview(awayGoalsStepper)
        self.awayGoalsStepper = awayGoalsStepper

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        makeConstraints()
    }

    // MARK: Bindings

    func bindViewModel() {
        viewModel.homeGoals <~ homeGoalsStepper.signalProducer()
        viewModel.awayGoals <~ awayGoalsStepper.signalProducer()

        viewModel.formattedHomeGoals.producer
            |> startOn(UIScheduler())
            |> start(next: { [weak self] formattedHomeGoals in
                self?.homeGoalsLabel.text = formattedHomeGoals
            })

        viewModel.formattedAwayGoals.producer
            |> startOn(UIScheduler())
            |> start(next: { [weak self] formattedAwayGoals in
                self?.awayGoalsLabel.text = formattedAwayGoals
            })
    }

    // MARK: Layout

    func makeConstraints() {
        let superview = self.view

        homeGoalsLabel.snp_makeConstraints { make in
            make.trailing.equalTo(goalSeparatorLabel.snp_leading).offset(-20)
            make.baseline.equalTo(goalSeparatorLabel.snp_baseline)
        }

        goalSeparatorLabel.snp_makeConstraints { make in
            make.center.equalTo(superview.snp_center)
        }

        awayGoalsLabel.snp_makeConstraints { make in
            make.leading.equalTo(goalSeparatorLabel.snp_trailing).offset(20)
            make.baseline.equalTo(goalSeparatorLabel.snp_baseline)
        }

        homeGoalsStepper.snp_makeConstraints { make in
            make.top.equalTo(goalSeparatorLabel.snp_baseline).offset(20)
            make.trailing.equalTo(homeGoalsLabel.snp_trailing)
        }

        awayGoalsStepper.snp_makeConstraints { make in
            make.top.equalTo(goalSeparatorLabel.snp_baseline).offset(20)
            make.leading.equalTo(awayGoalsLabel.snp_leading)
        }
    }

    // MARK: User Interaction

    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
