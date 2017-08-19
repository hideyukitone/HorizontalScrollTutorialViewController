//
//  ViewController.swift
//  HorizontalScrollTutorialViewController
//
//  Created by 大國嗣元 on 2017/05/13.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func pressTutorial(_ sender: Any) {
        let controller = HorizontalScrollTutorialViewController(
            tutorialItems: [
                HorizontalScrollTutorialItem(fileName: "test")
                , HorizontalScrollTutorialItem(fileName: "test2")
                , HorizontalScrollTutorialItem(fileName: "test3")
                , HorizontalScrollTutorialItem(fileName: "test4")
            ]
            , titleName: "遊び方")
        
        self.present(controller, animated: true, completion: nil)
    }

}

