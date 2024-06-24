//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Mohanad Ramdan on 25/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView{
            Form{
                getImage(order: order)
                Section(header: Text("Order Type:")){
                    Picker(selection: $order.ordering.type, label: Text("Pick your favorite type:")){
                        ForEach(0..<Order.types.count, id: \.self){
                            Text(Order.types[$0])
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Stepper("Number of cakes: \(order.ordering.quantity)", value: $order.ordering.quantity, in: 3...20)
                }
                Section(header: Text("extra:")) {
                    Toggle("Any special requests?", isOn: $order.ordering.specialRequestEnabled.animation())

                    if order.ordering.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.ordering.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $order.ordering.addSprinkles)
                    }
                }
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake:")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct getImage: View {
    @ObservedObject var order: Order
    var body: some View{
        AsyncImage(url: URL(string:order.ordering.rightImage)){ image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300,height: 200)
        .frame(maxWidth: .infinity)
        .listRowBackground(EmptyView())
    }
    
}
