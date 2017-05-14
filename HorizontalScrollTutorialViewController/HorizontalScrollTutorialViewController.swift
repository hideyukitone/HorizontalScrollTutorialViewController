//
//  HorizontalScrollTutorialViewController.swift
//  HorizontalScrollTutorialViewController
//
//  Created by 大國嗣元 on 2017/05/13.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import UIKit


struct HorizontalScrollTutorialItem {
    let images: [UIImage]
}

class HorizontalScrollTutorialViewController: UIViewController {
    private let scrollView: UIScrollView
    private let bottomLabel: UILabel
    private var viewDidLayoutSubviewsScrollViewWidth: CGFloat?
    
    fileprivate let skipButton: UIButton
    fileprivate let nextButton: UIButton
    fileprivate let pageControl: UIPageControl
    fileprivate let tutorialItems: [HorizontalScrollTutorialItem]
    
    var skipButtonName = "スキップ"
    var nextButtonName = "次へ"
    var doneButtonName = "閉じる"
    var isPrefersStatusBarHidden = true
    
    init(tutorialItems: [HorizontalScrollTutorialItem]) {
        scrollView = UIScrollView(frame: .zero)
        bottomLabel = UILabel(frame: .zero)
        skipButton = UIButton(frame: .zero)
        nextButton = UIButton(frame: .zero)
        pageControl = UIPageControl(frame: .zero)
        self.tutorialItems = tutorialItems
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        bottomLabel.backgroundColor = .black
        self.view.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        skipButton.setTitle(skipButtonName, for: .normal)
        skipButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        skipButton.heightAnchor.constraint(equalTo: bottomLabel.heightAnchor).isActive = true
        skipButton.addTarget(self, action: #selector(self.pressClose), for: .touchUpInside)
        
        nextButton.setTitle(nextButtonName, for: .normal)
        nextButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: skipButton.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: skipButton.heightAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(self.pressNext), for: .touchUpInside)
        
        pageControl.numberOfPages = tutorialItems.count
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: skipButton.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalTo: skipButton.heightAnchor).isActive = true
        pageControl.addTarget(self, action: #selector(self.pressPageControl), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(self.changePageControl), for: UIControlEvents.valueChanged)
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: skipButton.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let viewDidLayoutSubviewsScrollViewWidth = viewDidLayoutSubviewsScrollViewWidth
            , viewDidLayoutSubviewsScrollViewWidth == scrollView.frame.width {
            return
        }
        
        scrollView.subviews.flatMap{$0 as? UIImageView}.forEach{$0.stopAnimating() ; $0.removeFromSuperview()}
        
        for (i, tutorialItem) in tutorialItems.enumerated() {
            let imageView = UIImageView(image: tutorialItem.images.first)
            
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.y = 0
            imageView.frame.origin.x = CGFloat(i) * scrollView.frame.size.width
            imageView.contentMode = .scaleAspectFit
            imageView.tag = i
            
            if tutorialItem.images.count > 1 {
                imageView.animationImages = tutorialItem.images
                imageView.animationDuration = 3
            }
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(tutorialItems.count), height: scrollView.frame.size.height)
        
        movePage(page: 0, animated: false)
        
        viewDidLayoutSubviewsScrollViewWidth = scrollView.frame.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return isPrefersStatusBarHidden
    }
    
    func pressClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pressNext() {
        if skipButton.isHidden {
            pressClose()
        }else {
            movePage(page: pageControl.currentPage + 1, animated: true)
        }
    }
    
    func pressPageControl() {
        movePage(page: pageControl.currentPage, animated: false)
    }
    
    func changePageControl() {
        scrollView.subviews.flatMap{$0 as? UIImageView}.filter{$0.tag == pageControl.currentPage && $0.animationImages?.count ?? 0 > 1}.forEach{$0.stopAnimating() ; $0.startAnimating()}
        
        scrollView.subviews.flatMap{$0 as? UIImageView}.filter{$0.tag != pageControl.currentPage && $0.animationImages?.count ?? 0 > 1}.forEach{$0.stopAnimating()}
    }
    
    private func movePage(page: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * scrollView.frame.size.width, y: 0), animated: animated)
        
        if !animated {
            changePageControl()
        }
    }
}

extension HorizontalScrollTutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x > 0 else {
            pageControl.currentPage = 0
            return
        }
        
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        skipButton.isHidden = pageControl.currentPage == tutorialItems.count - 1
        
        if skipButton.isHidden {
            nextButton.setTitle(doneButtonName, for: .normal)
        }else {
            nextButton.setTitle(nextButtonName, for: .normal)
        }
        
        changePageControl()
    }
}