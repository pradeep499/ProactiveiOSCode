//
//  TableViewCell_Extension.swift
//  Whatsumm
//
//  Created by Sakshi on 3/9/15.
//  Copyright (c) 2015 AppStudioz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        
        var tableViewcell : UIView? = self
        
        while(tableViewcell != nil)
        {
            
            if tableViewcell! is UITableViewCell {
                break
            }
            
            tableViewcell = tableViewcell!.superview
        }
        
        return tableViewcell as? UITableViewCell
    }
    
    func tableViewIndexPath(tableView: UITableView) -> NSIndexPath? {
        
        if let cell = self.tableViewCell() {
            
            return tableView.indexPathForCell(cell)
            
        }
        else {
            
            return nil
            
        }
        
    }
    
}