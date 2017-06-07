//
//  HomeViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryNames: [String]!
    var categoryImageNames: [String]!
    
    @IBOutlet weak var toolbar: DarkToolbar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutPressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.logout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toolbar.setViewController(viewController: self)
        
        categoryNames = [""]
        categoryImageNames = ["dessert.jpeg", "vegan.jpeg", "casual_brunch.jpg", "romantic.jpeg", "sandwiches.jpeg", "casual_group.jpg", "comfort_food.jpg", "elegant_affair.jpg", "vegan.jpg", "bacon_biscut.jpeg", "business_meeting.jpeg", "colorful_brunch.jpeg", "eggs_chili.jpeg", "hearty.jpeg"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogOut", let welcomeVC = segue.destination as? WelcomeViewController{
            welcomeVC.logout()
        }
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return categoryNames.count
        return categoryImageNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryTableViewCell
        
        cell.configureCell(name: "Testing", caption: "caption would go here", backgroundImage: UIImage.resizeImage(image: UIImage(named: categoryImageNames[indexPath.row])!, newWidth: tableView.frame.width) )
        
        return cell
        
    }
    

}

extension UIImage{
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
