//
//  SwipingPhotosController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 18.11.21.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ imageurl -> UIViewController in
                let photoController = photoController(imageUrl: imageurl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            
            setupBarViews()
            
        }
    }
    
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate let diselectedBarColor = UIColor(white: 0, alpha: 0.1)
    
    
    func setupBarViews() {
        cardViewModel.imageUrls.forEach { url in
            let barView = UIView()
            barView.backgroundColor = diselectedBarColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        
        barStackView.subviews[0].backgroundColor = .white
        view.addSubview(barStackView)
        barStackView.distribution = .fillEqually
        barStackView.spacing = 4
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 9, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
    }
    
    var controllers = [UIViewController]()
    
    fileprivate let isCadViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCadViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        if isCadViewMode {
             disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let currentViewController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentViewController) {
            if gesture.location(in: self.view).x > self.view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                changeBarView(index: nextIndex)
            } else {
                let prevIndex = max(index - 1, 0)
                let nextController = controllers[prevIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                changeBarView(index: prevIndex)
            }
        }
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { v in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {
            return nil
        }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {
            return nil   
        }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentViewController}) {
            changeBarView(index: index)
        }
    }
    
    fileprivate func changeBarView(index: Int) {
        barStackView.subviews.forEach { subview in
            subview.backgroundColor = diselectedBarColor
        }
        barStackView.subviews[index].backgroundColor = .white
    }
    
}


class photoController: UIViewController {
    
    let imageView = UIImageView(image: UIImage(named: "like_circle")!)
    
        

    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        imageView.contentMode = .scaleAspectFill
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperView()
        imageView.clipsToBounds = true
    }
    
}
