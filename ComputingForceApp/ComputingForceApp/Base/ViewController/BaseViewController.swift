//
//  BaseViewController.swift
//  ComputingForceApp
//
//  Created by 赵龙 on 2023/1/10.
//

import UIKit
import Combine
import LKAlertController
import SwiftEntryKit

class BaseViewController<ViewModelType: BaseViewModel>: UIViewController {
    
    let viewModel: ViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel:ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: viewModel.getXibName(), bundle: nil)
        self.modalPresentationStyle = .fullScreen
        setupCommonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel, storeBindingsIn: &subscriptions)
    }
    
    /// Entry point for data binding in both `view to viewModel` and `viewModel to view` directions.
    open func bind(viewModel: ViewModelType, storeBindingsIn cancellables: inout Set<AnyCancellable>) {
        
    }
    
    private func setupCommonUI() {
        let theme = AppContext.context.theme
        self.view.backgroundColor = theme.backggroundColor
    }
    
    func startLoading() {
        view.endEditing(true)
        ActivityIndicatorManager.manager.startAnimation()
    }
    
    func stopLoading() {
        view.endEditing(true)
        ActivityIndicatorManager.manager.stopAnimation()
    }
    
    func showGenericErrorAlert() {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = .error
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .standardBackground)
        attributes.screenBackground = .color(color: .dimmedLightBackground)
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 25)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2)
            )
        )
        attributes.positionConstraints.verticalOffset = 10
        attributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        
        let image = UIImage(named: "ic_done_all_white_48pt")!.withRenderingMode(.alwaysTemplate)
        let title = Localization.text(key: "Error") ?? ""
        let description = Localization.text(key: "TryAgainLater") ?? ""
        showPopupMessage(attributes: attributes,
                         title: title,
                         titleColor: .text,
                         description: description,
                         descriptionColor: .subText,
                         buttonTitleColor: .white,
                         buttonBackgroundColor: .amber,
                         image: image)
    }
    
    private func showPopupMessage(attributes: EKAttributes,
                                  title: String,
                                  titleColor: EKColor,
                                  description: String,
                                  descriptionColor: EKColor,
                                  buttonTitleColor: EKColor,
                                  buttonBackgroundColor: EKColor,
                                  image: UIImage? = nil) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                    image: image,
                    displayMode: .inferred,
                    size: CGSize(width: 60, height: 60),
                    tint: titleColor,
                    contentMode: .scaleAspectFit
                )
            )
        }
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: AppContext.context.theme.largeBoldFont,
                color: titleColor,
                alignment: .center,
                displayMode: .inferred
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: AppContext.context.theme.mediumFont,
                color: descriptionColor,
                alignment: .center,
                displayMode: .inferred
            ),
            accessibilityIdentifier: "description"
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: Localization.text(key: "Confirm") ?? "",
                style: .init(
                    font: AppContext.context.theme.mediumFont,
                    color: buttonTitleColor,
                    displayMode: .inferred
                )
            ),
            backgroundColor: buttonBackgroundColor,
            highlightedBackgroundColor: buttonTitleColor.with(alpha: 0.05),
            displayMode: .inferred,
            accessibilityIdentifier: "button"
        )
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button) {
                SwiftEntryKit.dismiss()
        }
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
