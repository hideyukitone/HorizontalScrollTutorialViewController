//
//  ViewController.swift
//  HorizontalScrollTutorialViewController
//
//  Created by 大國嗣元 on 2017/05/13.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import UIKit
import HorizontalScrollTutorialKit

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
        return false
    }
    
    @IBAction func pressTutorialForGif(_ sender: Any) {
        let controller = HorizontalScrollTutorialViewController(tutorialItems: [.gif("1"), .gif("2"), .gif("3"), .gif("4")])
        
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func pressTutorialForImages(_ sender: Any) {
        let controller = HorizontalScrollTutorialViewController(
            tutorialItems: [
                .images([#imageLiteral(resourceName: "tutorial1_1"), #imageLiteral(resourceName: "tutorial1_2"), #imageLiteral(resourceName: "tutorial1_3"), #imageLiteral(resourceName: "tutorial1_4")])
                , .images([#imageLiteral(resourceName: "tutorial2_1"), #imageLiteral(resourceName: "tutorial2_2"), #imageLiteral(resourceName: "tutorial2_3"), #imageLiteral(resourceName: "tutorial2_4")])
                , .images([#imageLiteral(resourceName: "tutorial3_1"), #imageLiteral(resourceName: "tutorial3_2"), #imageLiteral(resourceName: "tutorial3_3"), #imageLiteral(resourceName: "tutorial3_4")])
                , .images([#imageLiteral(resourceName: "tutorial4")])
            ]
            , titleName: "遊び方")

        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func pressTutorialForImage(_ sender: Any) {
        let controller = HorizontalScrollTutorialViewController(tutorialItems: [.images([#imageLiteral(resourceName: "subquest_help")])])

        self.present(controller, animated: true, completion: nil)
    }

}

