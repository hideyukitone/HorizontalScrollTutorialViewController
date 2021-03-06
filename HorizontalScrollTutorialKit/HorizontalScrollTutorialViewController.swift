//
//  HorizontalScrollTutorialViewController.swift
//  HorizontalScrollTutorialViewController
//
//  Created by 大國嗣元 on 2017/05/13.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import UIKit

protocol HorizontalScrollTutorialViewControllerDelegate: class {
    func horizontalScrollTutorialViewControllerDidFinish()
}

open class HorizontalScrollTutorialViewController: UIViewController {
    weak var delegate: HorizontalScrollTutorialViewControllerDelegate?

    private struct TutorialImageInformation {
        let first: UIImage?
        let last: UIImage?
        let count: Int
    }

    private let scrollView: UIScrollView
    private let bottomLabel: UILabel
    private let skipButton: UIButton
    private let nextButton: UIButton
    private let pageControl: UIPageControl
    private let tutorialItems: [HorizontalScrollTutorialItem]
    private var titleName: String?
    private var skipButtonName: String
    private var nextButtonName: String
    private var doneButtonName: String
    private var isPrefersStatusBarHidden: Bool
    private var previousPage: Int?
    private var tutorialImageInformations = [TutorialImageInformation]()
    private var viewDidLayoutSubviewsScrollViewWidth: CGFloat?

    public init(tutorialItems: [HorizontalScrollTutorialItem], titleName: String? = nil, skipButtonName: String = "スキップ", nextButtonName: String = "次へ", doneButtonName: String = "閉じる", isPrefersStatusBarHidden: Bool = true) {
        scrollView = UIScrollView(frame: .zero)
        bottomLabel = UILabel(frame: .zero)
        skipButton = UIButton(frame: .zero)
        nextButton = UIButton(frame: .zero)
        pageControl = UIPageControl(frame: .zero)
        self.tutorialItems = tutorialItems

        self.titleName = titleName
        self.skipButtonName = skipButtonName
        self.nextButtonName = nextButtonName
        self.doneButtonName = doneButtonName
        self.isPrefersStatusBarHidden = isPrefersStatusBarHidden

        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overCurrentContext

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        bottomLabel.backgroundColor = .black
        self.view.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true

        skipButton.setTitle(skipButtonName, for: .normal)
        skipButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        skipButton.titleLabel?.setMinimumFontSize(ofSize: 5)
        self.view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        skipButton.heightAnchor.constraint(equalTo: bottomLabel.heightAnchor).isActive = true
        skipButton.addTarget(self, action: #selector(self.pressClose), for: .touchUpInside)

        nextButton.setTitle(nextButtonName, for: .normal)
        nextButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        nextButton.titleLabel?.setMinimumFontSize(ofSize: 5)
        self.view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: skipButton.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: skipButton.heightAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(self.pressNext), for: .touchUpInside)

        pageControl.isHidden = tutorialItems.count <= 1
        pageControl.numberOfPages = tutorialItems.count
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: skipButton.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalTo: skipButton.heightAnchor).isActive = true
        pageControl.addTarget(self, action: #selector(self.pressPageControl), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(self.changePageControl), for: .valueChanged)

        var topLabel: UILabel? = nil
        if let titleName = titleName {
            topLabel = UILabel(frame: .zero)
            if let topLabel = topLabel {
                topLabel.text = titleName
                topLabel.font = UIFont.systemFont(ofSize: 30)
                topLabel.setMinimumFontSize(ofSize: 5)
                topLabel.textAlignment = .center
                topLabel.textColor = .white
                topLabel.backgroundColor = .black
                self.view.addSubview(topLabel)
                topLabel.translatesAutoresizingMaskIntoConstraints = false
                topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                if #available(iOS 11.0, *) {
                    topLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
                } else {
                    topLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
                }
                topLabel.heightAnchor.constraint(equalTo: bottomLabel.heightAnchor).isActive = true
            }
        }

        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: topLabel?.bottomAnchor ?? self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: topLabel?.bottomAnchor ?? self.topLayoutGuide.bottomAnchor).isActive = true
        }
        scrollView.bottomAnchor.constraint(equalTo: skipButton.topAnchor).isActive = true

        setButton(currentPage: pageControl.currentPage)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let viewDidLayoutSubviewsScrollViewWidth = viewDidLayoutSubviewsScrollViewWidth, viewDidLayoutSubviewsScrollViewWidth == scrollView.frame.width {
            return
        }

        scrollView.subviews.flatMap{ $0 as? UIImageView }.forEach { imageView in
            imageView.stopAnimating()
            imageView.removeFromSuperview()
        }

        tutorialItems.enumerated().forEach { i, tutorialItem in
            var images = tutorialItem.images
            let tutorialImageInformation = TutorialImageInformation(first: images.first, last: images.last, count: images.count)
            let imageView = UIImageView(image: images.first)
            images = []
            tutorialImageInformations.append(tutorialImageInformation)

            imageView.image = tutorialImageInformation.first
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.y = 0
            imageView.frame.origin.x = CGFloat(i) * scrollView.frame.size.width
            imageView.contentMode = .scaleAspectFit
            imageView.tag = i

            imageView.animationDuration = 3
            imageView.animationRepeatCount = 1

            scrollView.addSubview(imageView)
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(tutorialItems.count), height: scrollView.frame.size.height)

        movePage(page: 0, animated: false)

        viewDidLayoutSubviewsScrollViewWidth = scrollView.frame.width
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open var prefersStatusBarHidden: Bool {
        return isPrefersStatusBarHidden
    }

    @objc private func pressClose() {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true) {
            self.delegate?.horizontalScrollTutorialViewControllerDidFinish()
        }
    }

    @objc private func pressNext() {
        if skipButton.isHidden {
            pressClose()
        } else {
            movePage(page: pageControl.currentPage + 1, animated: true)
        }
    }

    @objc private func pressPageControl() {
        movePage(page: pageControl.currentPage, animated: false)
    }

    @objc private func changePageControl() {
        guard previousPage != pageControl.currentPage else { return }

        scrollView.subviews.flatMap{ $0 as? UIImageView }.forEach { imageView in
            imageView.stopAnimating()
            imageView.animationImages = []

            if let previousPage = previousPage, previousPage == imageView.tag {
                imageView.image = tutorialImageInformations[imageView.tag].last
            } else {
                imageView.image = tutorialImageInformations[imageView.tag].first
            }

            guard imageView.tag == pageControl.currentPage && tutorialImageInformations[imageView.tag].count > 1 else { return }

            tutorialItems[imageView.tag].getImagesInBackground { images in
                DispatchQueue.main.async() {
                    imageView.animationImages = images
                    imageView.image = self.tutorialImageInformations[imageView.tag].last
                    imageView.startAnimating()
                }
            }
        }

        previousPage = pageControl.currentPage
    }

    private func movePage(page: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * scrollView.frame.size.width, y: 0), animated: animated)

        if !animated {
            changePageControl()
        }
    }

    private func setButton(currentPage: Int) {
        skipButton.isHidden = currentPage == tutorialItems.count - 1

        if skipButton.isHidden {
            nextButton.setTitle(doneButtonName, for: .normal)
        } else {
            nextButton.setTitle(nextButtonName, for: .normal)
        }
    }
}

extension HorizontalScrollTutorialViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x > 0 else {
            pageControl.currentPage = 0
            return
        }

        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        setButton(currentPage: pageControl.currentPage)
        
        changePageControl()
    }
}

private extension UILabel {
    func setMinimumFontSize(ofSize: CGFloat) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = ofSize / self.font.pointSize
    }
}
