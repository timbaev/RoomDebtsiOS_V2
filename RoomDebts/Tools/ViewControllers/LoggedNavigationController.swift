//
//  LoggedNavigationController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LoggedNavigationController: UINavigationController {
    
    // MARK: - Instance Properties
    
    public fileprivate(set) final var isViewAppeared = false
    
    // MARK: - Initializers
    
    deinit {
        Log.i("")
    }
    
    // MARK: - Instance Methods
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Log.i("")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.i("")
        
        self.isViewAppeared = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Log.i(animated)
        
        self.isViewAppeared = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Log.i(animated)
        
        self.isViewAppeared = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.i(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Log.i(animated)
        
        self.isViewAppeared = false
    }
    
    // MARK: -
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        Log.i(String(describing: segue.identifier))
    }
}
