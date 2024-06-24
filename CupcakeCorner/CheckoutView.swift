//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Mohanad Ramdan on 05/08/2023.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @Environment(\.dismiss) private var dismiss
    @State var confirmationMassege = ""
    @State var showAlert = false
    @State var noInternetConnection = ""
    @State var noInternetConnectionShowing = false
    
    
    var body: some View {
            ScrollView{
                Spacer(minLength: 50)
                VStack {
                    getImage(order: order)
                        .cornerRadius(10)
                    VStack{
                        Text("Your order costs \(order.ordering.cost, format: .currency(code: "USD"))")
                            .frame(width: 300,height: 55)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                        Divider()
                            .frame(width: 270)
                        Button("Place Order") {
                            Task{
                                await placeHolder()
                            }
                        }
                        .foregroundColor(.black)
                        .frame(width: 300,height: 55)
                        .background(Color.yellow)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
                
            }
            .navigationTitle("Chechout:")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Your Order!", isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(confirmationMassege)
            }
            .alert("No Internet Connection", isPresented: $noInternetConnectionShowing){
                Button("Retry"){ }
            } message: {
                Text(noInternetConnection)
            }
            
                
    }
    
    func placeHolder() async {
        guard let encoded = try? JSONEncoder().encode(order.ordering) else {
            print("failllllled")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.Ordering.self, from: data)
            confirmationMassege = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showAlert = true
        } catch {
            noInternetConnection = "There is no connection try another wifi or data"
            noInternetConnectionShowing.toggle()
        }
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
