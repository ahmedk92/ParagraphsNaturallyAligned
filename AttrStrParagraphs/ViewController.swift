//
//  ViewController.swift
//  AttrStrParagraphs
//
//  Created by Ahmed Khalaf on 4/16/20.
//  Copyright © 2020 io.github.ahmedkhalaf. All rights reserved.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let attrStr = NSAttributedString(string: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris eget dapibus nisi, quis aliquet lorem. Nunc id lobortis ex, a interdum augue. Sed vel mi ultricies, aliquam augue vel, varius tellus. Nunc sagittis lacinia mi vitae blandit. Aenean at cursus nisl. Curabitur in pulvinar sem. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur odio quam, porta ac sapien ut, molestie cursus nisi. In vehicula efficitur nisl, a cursus sem feugiat ac. Quisque accumsan interdum dui vel iaculis. Etiam vehicula sed tortor non faucibus. Cras porta massa in mauris malesuada, a consequat augue aliquet. Sed fermentum facilisis est, vitae sodales eros lobortis nec. Maecenas pharetra volutpat magna, ut eleifend libero cursus eu. Donec luctus dui eget justo tincidunt placerat.

            لكن لا بد أن أوضح لك أن كل هذه الأفكار المغلوطة حول استنكار  النشوة وتمجيد الألم نشأت بالفعل، وسأعرض لك التفاصيل لتكتشف حقيقة وأساس تلك السعادة البشرية، فلا أحد يرفض أو يكره أو يتجنب الشعور بالسعادة، ولكن بفضل هؤلاء الأشخاص الذين لا يدركون بأن السعادة لا بد أن نستشعرها بصورة أكثر عقلانية ومنطقية فيعرضهم هذا لمواجهة الظروف الأليمة، وأكرر بأنه لا يوجد من يرغب في الحب ونيل المنال ويتلذذ بالآلام، الألم هو الألم ولكن نتيجة لظروف ما قد تكمن السعاده فيما نتحمله من كد وأسي.

            Donec sed nisl metus. Nulla eget ultricies nisl. Fusce placerat sem eget massa molestie, vitae mattis mi maximus. Ut ullamcorper ipsum sem, sed blandit risus faucibus a. Quisque eu imperdiet augue, in tincidunt orci. Duis ultricies diam quis commodo eleifend. Sed ante ligula, pulvinar at scelerisque sed, mattis ut ipsum. Nulla leo enim, commodo eget sem quis, eleifend molestie augue. Integer quis turpis velit. Nunc porttitor felis vitae ipsum tincidunt, id ullamcorper velit dapibus. Aenean in pulvinar velit. Donec id scelerisque erat. Vivamus efficitur, erat vitae pharetra ultrices, justo nunc lobortis quam, molestie sagittis quam nulla accumsan urna. Mauris sollicitudin erat vel purus eleifend sollicitudin. Pellentesque neque magna, tincidunt hendrerit sodales in, tristique vitae lorem. Phasellus commodo aliquam blandit.
        """, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.darkText
            ]).paragraphsNaturallyAligned
        
        textView.attributedText = attrStr

    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.isEditable = false
        textView.backgroundColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return textView
    }()

}

protocol ParagraphsNaturallyAligned: NSAttributedString {}
extension ParagraphsNaturallyAligned {
    var paragraphsNaturallyAligned: Self {
        let mutable = NSMutableAttributedString(attributedString: self)
        (mutable.string as NSString).enumerateSubstrings(in: NSRange(location: 0, length: length), options: .byParagraphs) { (paragaphContent, paragraphRange, _, _) in
            
            guard let paragaphContent = paragaphContent else { return }
            
            var existingParaghStyle: NSParagraphStyle?
            mutable.enumerateAttribute(.paragraphStyle, in: paragraphRange, options: []) { (value, _, _) in
                if let value = value as? NSParagraphStyle {
                    existingParaghStyle = value
                }
            }
            let newParagraphStyle = existingParaghStyle == nil ? NSMutableParagraphStyle() : existingParaghStyle!.mutableCopy() as! NSMutableParagraphStyle
            let isRTL = paragaphContent.isRTL
            newParagraphStyle.baseWritingDirection = isRTL ? .rightToLeft : .leftToRight
            if newParagraphStyle.alignment != .justified {
                newParagraphStyle.alignment = isRTL ? .right : .left
            }
            
            mutable.addAttribute(.paragraphStyle, value: newParagraphStyle, range: paragraphRange)
            
        }
        return (self is NSMutableAttributedString ? mutable : NSAttributedString(attributedString: mutable)) as! Self
    }
}
extension NSAttributedString: ParagraphsNaturallyAligned {}

extension String {
    var isRTL: Bool {
        guard let dominantLanguage = NLLanguageRecognizer.dominantLanguage(for: self) else { return false }
        let rtlLanguageIds = ["ar", "fa", "he", "ckb-IQ","ckb-IR", "ur", "ckb"] // credits: https://github.com/MoathOthman/MOLH/blob/313691443043f0da83502040f39b852cd9e3e0e8/Sources/MOLH/MOLHLanguage.swift#L120
        return rtlLanguageIds.contains(dominantLanguage.rawValue)
    }
}
