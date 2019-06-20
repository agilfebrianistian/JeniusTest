//
//  MasterViewController
//  JeniusTest
//
//  Created by Agil Febrianistian on 14/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit
import SDWebImage

class MasterViewController: UITableViewController {
    
    lazy var presenter: ContactInterface = {
        return ContactsPresenter.init(delegate: self)
    }()
    
    private var contactsResponseData: ContactsResponseData?
    
    var itemCounts : Int = 0
    var isSearching : Bool = false

    var contacts : [ContactResponse] = [ContactResponse]()
    var filteredData : [ContactResponse] = [ContactResponse]()

    @IBOutlet weak var searchBar: UISearchBar!
    
    let _refreshControl = UIRefreshControl.init()
    
    var contactID : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        self.tableView.addSubview(_refreshControl)

        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    @objc func getData(){
        presenter.getContacts()
    }
    
}

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            itemCounts = filteredData.count
        }
        else{
            itemCounts = contacts.count
        }
        return itemCounts
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactCell
        
        var model : ContactResponse?
        
        if isFiltering() {
            model = filteredData[indexPath.row]
        } else {
            model = contacts[indexPath.row]
        }
        
        cell.setup(model!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        var model : ContactResponse?
        
        if isFiltering() {
            model = filteredData[indexPath.row]
        } else {
            model = contacts[indexPath.row]
        }

        contactID = model?.id
        
        self.performSegue(withIdentifier: "toDetailViewController", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewController" {
            guard let controller = segue.destination as? DetailViewController else {
                return
            }
            controller.contactID = self.contactID
        }
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchBar.selectedScopeButtonIndex != 0
        return !searchBarIsEmpty() || searchBarScopeIsFiltering
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = contacts.filter({( model : ContactResponse) -> Bool in
            return model.firstName?.lowercased().contains(searchText.lowercased()) ?? true || model.lastName?.lowercased().contains(searchText.lowercased()) ?? true
        })
        tableView.reloadData()
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
        self.isSearching = isFiltering()
    }
}


extension MasterViewController: ContactDelegate {
    func didSuccessUpdateContact(response: ContactSuccessResponseData) {}
    func didFailedUpdateContact(response: NetworkError) {}
    
    func didSuccessGetContacts(response: ContactsResponseData) {
        self.contacts.removeAll()
        self.contacts.append(contentsOf:response.data)
        
        if self._refreshControl.isRefreshing{
            self._refreshControl.endRefreshing()
        }

        tableView.reloadData()
    }
    
    func didFailedGetContacts(response: NetworkError) {
        showAlert(title: response.error ?? "", message: response.message ?? "")
    }
    
    func didSuccessAddContact(response: ContactSuccessResponseData) {}
    func didFailedAddContact(response: NetworkError) {}
    
    func didSuccessDeleteContact(response: ContactSuccessResponseData) {}
    func didFailedDeleteContact(response: NetworkError) {}
    
    func didSuccessGetContact(response: ContactResponseData) {}
    func didFailedGetContact(response: NetworkError) {}

}


