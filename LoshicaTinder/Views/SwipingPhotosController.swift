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
        }
    }
    
    var controllers = [UIViewController]()
    
//    let controllers = [
//        photoController(image: UIImage(named: "like_circle")!),
//        photoController(image: UIImage(named: "super_like_circle")!),
//        photoController(image: UIImage(named: "dismiss_circle")!),
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        
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
