//
//  StreamViewController.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//

import UIKit

class StreamViewController: UIPageViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentViewControllers = [UIViewController]()
    var titles = ["Latest","All","Test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        dataSource = self
        delegate = self
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let latestViewController = storyboard.instantiateViewController(withIdentifier: "ContentViewController")
            as! ContentViewController
        latestViewController.filter = "timeStamp"
        let allViewController = storyboard.instantiateViewController(withIdentifier: "ContentViewController")
            as! ContentViewController
        let testViewController = storyboard.instantiateViewController(withIdentifier: "ContentViewController")
            as! ContentViewController

        
        contentViewControllers = [latestViewController, allViewController, testViewController]
        setViewControllers([contentViewControllers[0]], direction: .forward, animated: false, completion: nil)
        title = titles[0]
    }

}

extension StreamViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = contentViewControllers.index(of: viewController) {
            let newIndex = index - 1
            if newIndex < 0 {
                return nil
            } else {
                return contentViewControllers[newIndex]
            }
            
            
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = contentViewControllers.index(of: viewController) {
            let newIndex = index + 1
            if newIndex >= contentViewControllers.count {
                return nil
            } else {
                return contentViewControllers[newIndex]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first {
                if let index = contentViewControllers.index(of: currentViewController) {
                    title = titles[index]
                    pageControl.currentPage = index
                }
            }
        }
    }
}



