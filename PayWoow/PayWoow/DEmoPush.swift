//
//  DEmoPush.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import DeviceKit
import SDWebImageSwiftUI
import Lottie

struct DEmoPush: View {
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                Button {
//                    api.loadData()
                } label: {
                    Text("Deneme")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                }

                
            }
        }
    }
}


struct PickerField: UIViewRepresentable {
    // MARK: - Public properties
    @Binding var selectionIndex: Int?

    // MARK: - Initializers
    init<S>(_ title: S, data: [String], selectionIndex: Binding<Int?>) where S: StringProtocol {
        self.placeholder = String(title)
        self.data = data
        self._selectionIndex = selectionIndex

        textField = PickerTextField(data: data, selectionIndex: selectionIndex)
    }

    // MARK: - Public methods
    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        textField.placeholder = placeholder
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        if let index = selectionIndex {
            uiView.text = data[index]
        } else {
            uiView.text = ""
        }
    }

    // MARK: - Private properties
    private var placeholder: String
    private var data: [String]
    private let textField: PickerTextField
}

class PickerTextField: UITextField {
    // MARK: - Public properties
    var data: [String]
    @Binding var selectionIndex: Int?

    // MARK: - Initializers
    init(data: [String], selectionIndex: Binding<Int?>) {
        self.data = data
        self._selectionIndex = selectionIndex
        super.init(frame: .zero)

        self.inputView = pickerView
        self.inputAccessoryView = toolbar
        self.tintColor = .clear

        guard let selectionIndex = selectionIndex.wrappedValue else {
            return
        }

        self.pickerView.selectRow(selectionIndex, inComponent: 0, animated: true)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(
            title: "Kapat",
            style: .done,
            target: self,
            action: #selector(donePressed)
        )

        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        return toolbar
    }()

    // MARK: - Private methods
    @objc
    private func donePressed() {
        self.selectionIndex = self.pickerView.selectedRow(inComponent: 0)
        self.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate extension
extension PickerTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionIndex = row
    }
}


struct CountryCodeModel : Codable, Hashable{
    var name: String
    var dial_code : String
    var code : String
    
}

class CountryCodeStore: ObservableObject {
    @Published var list = [CountryCodeModel]()
    
    init(){
        
        let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json")
        let jsonData = NSData(contentsOfMappedFile: path!)
        
        let data = jsonData?.base64EncodedString()
        let base64Encoded = data
        let decodedData = Data(base64Encoded: base64Encoded!)
        let decodedString = String(data: decodedData!, encoding: .utf8)!
        let jsonDecode =  try! JSONDecoder().decode([CountryCodeModel].self, from: decodedData!)
        self.list = jsonDecode
    }
}
