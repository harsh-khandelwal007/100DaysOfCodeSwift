//
//  DetailsView.swift
//  Bookworm
//
//  Created by harsh Khandelwal on 29/10/21.
//

import SwiftUI
import CoreData

struct DetailsView: View {
    //one to hold our Core Data managed object context (so we can delete stuff)
    @Environment(\.managedObjectContext) var moc
    //one to hold our presentation mode (so we can pop the view off the navigation stack)
    @Environment(\.presentationMode) var presentationMode
    //one to control whether we’re showing the delete confirmation alert or not.
    @State private var showingDeleteAlert = false
    
    let book : Book
    
    // MARK: Challenge 3
    var dateFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                        .scaledToFit()

                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(self.book.review ?? "No review")
                    .padding()

                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)

                // MARK: Challenge 3
                HStack{
                    Text("Date Added :- ")

                    Text("\(self.book.currentDate ?? Date() , formatter: self.dateFormatter)")
                        .foregroundColor(.blue)
                }
                .font(.headline)
                .padding(.top, 50)
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(book)

        // uncomment this line if you want to make the deletion permanent
         try? self.moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailsView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        static var previews: some View {
            let book = Book(context: moc)
            book.title = "Test book"
            book.author = "Test author"
            book.genre = "Fantasy"
            book.rating = 4
            book.review = "This was a great book; I really enjoyed it."
            // MARK: Challenge 3
            book.currentDate = Date()

            return NavigationView {
                DetailsView(book: book)
            }
        }
}
