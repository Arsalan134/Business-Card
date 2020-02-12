



import UIKit
import FoldingCell
import FirebaseStorage
import FirebaseUI

class DemoCell: FoldingCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardImageView2: UIImageView!

    var card: Card?

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }

    func set(with card: Card) {
        self.card = card

        cardImageView.sd_setImage(with: Storage.storage().reference().child("\(card.imageURL ?? "")"))
        cardImageView2.sd_setImage(with: Storage.storage().reference().child("\(card.imageURL ?? "")"))
    }
    
    @IBAction func call() {
        if let number = card?.phone {
            guard let number = URL(string: "tel://" + number) else { return }
            UIApplication.shared.open(number)
        }
    }
}

// MARK: - Actions ⚡️

extension DemoCell {


}
