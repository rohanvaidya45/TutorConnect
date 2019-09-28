//
//  InstructionsPageViewController.swift
//  betaTutoringApp
//
//  Created by Rahi Kotadia on 6/12/19.
//  Copyright © 2019 RJR. All rights reserved.
//

import UIKit

class InstructionsPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    var pageControl = UIPageControl();
    
    
    lazy var orderedViewControllers : [UIViewController] = {
        return [self.newVC(viewController: "sbHome"),self.newVC(viewController: "sbCall"), self.newVC(viewController: "sbMessaging"),self.newVC(viewController: "sbProfile") ]
    }()
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil;
        }
        
       
        let previousIndex = viewControllerIndex-1;
        guard previousIndex>=0 else{
           // return orderedViewControllers.last;
            return nil;
        }
        
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        
        return orderedViewControllers[previousIndex];
    }
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY-50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count;
        pageControl.currentPage = 0;
        pageControl.tintColor = UIColor.blue;
        pageControl.pageIndicatorTintColor = UIColor.brown;
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil;
        }
        let nextIndex = viewControllerIndex+1;
        guard orderedViewControllers.count != nextIndex else{
            //return orderedViewControllers.first;
            return nil;
        }
        
        guard orderedViewControllers.count > nextIndex else{
            return nil
        }
        
        return orderedViewControllers[nextIndex];
    }
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self;
        self.delegate = self;

        

        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        configurePageControl();
        // Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0];
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
    func newVC(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
