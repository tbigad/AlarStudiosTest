//
//  DataTableViewCell.swift
//  AlarStudiosTest
//
//  Created by Pavel Nadolski on 28.11.2020.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var dataDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UIImageView {
    func load(url: URL, placeholder: UIImage? = nil) {
        DispatchQueue.global().async { [weak self, weak placeholder] in
            let cache = URLCache.shared
            let request = URLRequest(url: url)
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                self?.setImageInMain(image: image)
            } else {
                self?.setImageInMain(image: placeholder)
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        self?.setImageInMain(image: image)
                    }
                }).resume()
            }
        }
    }
    
    private func setImageInMain(image:UIImage?){
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
}
