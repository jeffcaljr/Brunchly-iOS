//
//  HomeViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var categoryNames: [String]!
    var categoryImageNames: [String]!
    
    @IBOutlet weak var toolbar: DarkToolbar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutPressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.logout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toolbar.setViewController(viewController: self)
        backgroundImage.addBlurEffect()
        
        
        categoryNames = [""]
        categoryImageNames = MockImageNames
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
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
        
        return categoryImageNames.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryTableViewCell
        
        
        cell.configureCell(name: MockDiscoverData[indexPath.row].0 , caption: MockDiscoverData[indexPath.row].1, backgroundImage: UIImage.resizeImage(image: UIImage(named: categoryImageNames[indexPath.row])!, newWidth: tableView.frame.width) )
        
        return cell
        
    }
    
    //MARK: DZNEmptyDataSet
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No Suggestions"
        let titleFont = UIFont(name: "Avenir Next", size: 28)
        let attrs = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: titleFont]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        var emptyImage = UIImage.resizeImage(image: UIImage(named: "brunchly_b_icon")!, newWidth: 50)
        
        emptyImage = emptyImage.maskWithColor(color: UIColor(hexString: "#F44336")!)!
        
        return emptyImage
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Check back soon for curated brunch suggestions from our editors."
        let titleFont = UIFont(name: "Avenir Next", size: 16)
        let attrs = [NSForegroundColorAttributeName: UIColor(hexString: "#BDBDBD")!, NSFontAttributeName: titleFont]
        return NSAttributedString(string: str, attributes: attrs)
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
