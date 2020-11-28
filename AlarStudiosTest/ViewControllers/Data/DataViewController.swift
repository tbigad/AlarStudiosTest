//
//  DataViewController.swift
//  AlarStudiosTest
//
//  Created by Pavel Nadolski on 28.11.2020.
//

import UIKit

class DataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let code:String
    var places:Places = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DataTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DataTableViewCell.identifier)
    }

    init(code:String) {
        self.code = code
        super.init(nibName: nil, bundle: nil)
        Backend.data(code: code, page: 1, complition: {[weak self] result in
            switch result {
            case .success(let places):
                self?.places.append(contentsOf: places)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DataViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = places[indexPath.item]
        showDetails(item: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DataViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier, for: indexPath) as? DataTableViewCell else { return UITableViewCell() }
        let place = places[indexPath.item]
        cell.dataDescription.text = place.country
        cell.dataName.text = place.name
        return cell
    }
}

extension DataViewController {
    func showDetails(item:DataItem) {
        self.navigationController?.pushViewController(MapViewController(dataItem: item), animated: true)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
