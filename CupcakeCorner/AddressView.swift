//
//  AddressVIew.swift
//  CupcakeCorner
//
//  Created by Mohanad Ramdan on 04/08/2023.
//

import SwiftUI

struct AddressView: View {
    
    enum OnboardingField: Hashable {
       case toName
       case toAddress
       case toCity
       case toZipcode
    }
    
    @ObservedObject var order: Order
    @FocusState private var fieldInFocus: OnboardingField?
    @State var ispresent = false
    var body: some View {
            Form{
                Section(header: Text("Info:")){
                    TextField("Name:", text: $order.ordering.fullName)
                        .focused($fieldInFocus, equals: .toName)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .toAddress
                        }
                    TextField("Street Address:", text: $order.ordering.streetAddress)
                        .focused($fieldInFocus, equals: .toAddress)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .toCity
                        }
                    TextField("City:", text: $order.ordering.city)
                        .focused($fieldInFocus, equals: .toCity)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .toZipcode
                        }
                    TextField("Zipcode:", text: $order.ordering.zipCode)
                        .submitLabel(.done)
                        .focused($fieldInFocus, equals: .toZipcode)
                }
                Button("Checkout"){
                    ispresent.toggle()
                }
                .foregroundColor(order.ordering.isNotValid ? .black : .accentColor)
                .frame(maxWidth: .infinity)
                .disabled(order.ordering.isNotValid == false)
                .listRowBackground(order.ordering.isNotValid ? Color.yellow.opacity(1) : Color.yellow.opacity(0.5))
                
            }
            .navigationTitle("Address:")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    fieldInFocus = .toName
                }
            }
            .sheet(isPresented: $ispresent){
                CheckoutView(order: order)
                    .presentationDetents(
                        [.medium,.large]
                    )
                    .presentationCornerRadius(40)
            }
            .blur(radius: ispresent ? 0.8 : 0.0)
            .brightness(ispresent ? -0.4 : 0.0)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
