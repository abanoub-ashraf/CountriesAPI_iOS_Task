import UIKit

extension UIViewController {
    
    func showToast(text: String) {
        let toastLabel = UILabel()
        
        toastLabel.text                 = text
        toastLabel.backgroundColor      = UIColor.black
        toastLabel.textColor            = UIColor.gray
        toastLabel.font                 = UIFont.systemFont(ofSize: 20)
        toastLabel.textAlignment        = .center
        toastLabel.numberOfLines        = 0
        toastLabel.alpha                = 1.0
        toastLabel.layer.cornerRadius   = 10
        toastLabel.clipsToBounds        = true
        
        self.view.addSubview(toastLabel)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive     = true
        toastLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive    = true
        toastLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        UIView.animate(
            withDuration: 10.0,
            delay: 0.3,
            options: .transitionCurlDown
        ) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
}
