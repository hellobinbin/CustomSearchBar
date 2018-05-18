//
//  ViewController.swift
//  demo
//
//  Created by nzb on 2018/5/19.
//  Copyright © 2018年 nzb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var searchBar:OuyeelCustomSearchBar = OuyeelCustomSearchBar(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:44))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil
        navigationItem.backBarButtonItem = nil
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ViewController: OuyeelCustomSearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: OuyeelCustomSearchBar) {

    }
    func searchBarSearchButtonClicked(_ searchBar: OuyeelCustomSearchBar) {
        
    }
    func searchBarShouldEndEditing(_ searchBar: OuyeelCustomSearchBar) -> Bool {
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: OuyeelCustomSearchBar) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: OuyeelCustomSearchBar) {
        
    }
    func searchBar(_ searchBar: OuyeelCustomSearchBar, textDidChange searchText: String) {
        
    }
    func searchBarShouldBeginEditing(_ searchBar: OuyeelCustomSearchBar) -> Bool {
        return true
    }
    func searchBar(_ searchBar: OuyeelCustomSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
