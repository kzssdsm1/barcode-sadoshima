//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/26.
//

import SwiftUI
import Combine
import AVFoundation
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: HomeViewModel = .init(apiService: APIService())
    
    @State private var tappedItemMidX: CGFloat = 0
    @State private var selection: TabItem = .スキャナー
    @State private var isEditing = false
    @State private var isShowingKeyboard = false
    @State private var showAlert = false
    @State private var removeItems = [String]()
    @State private var selectedItem: Item?
    @State private var captureSession = AVCaptureSession()
    @State private var isAnimating = false
    @State private var isFirstTime = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RootView(
                selection: $selection,
                isEditing: $isEditing,
                isShowingKeyboard: $isShowingKeyboard,
                showAlert: $viewModel.showAlert,
                removeItems: $removeItems,
                selectedItem: $viewModel.selectedItem,
                alertItem: $viewModel.alertItem,
                isLoading: $viewModel.isLoading,
                onCommitSubject: $viewModel.onCommitSubject,
                captureSession: $captureSession,
                isFirstTime: $isFirstTime
            )
            
            MotionTabBar(selection: $selection, isFirstTime: $isFirstTime)
                .disabled(viewModel.isLoading)
                .opacity(!isShowingKeyboard ? 1 : 0)
        } // ZStack
        .onAppear {
            firstVisitSetup()
        }
        .alert(isPresented: $viewModel.showAlert) {
            if !removeItems.isEmpty {
                return Alert(
                    title: Text("削除"),
                    message: (isEditing) ? Text("選択した商品を削除しますか？") : Text("お気に入りリストからこの商品を削除しますか？"),
                    primaryButton: .cancel(Text("キャンセル")) {
                        removeItems = []
                    },
                    secondaryButton: .destructive(Text("削除")) {
                        removeItem()
                    })
            } else {
                return Alert(
                    title: Text(viewModel.alertItem!.title),
                    message: Text(viewModel.alertItem!.message),
                    dismissButton: Alert.Button.default(
                        Text("OK"),
                        action: {
                            viewModel.alertItem = nil
                            DispatchQueue.global(qos: .userInitiated).async {
                                startSession()
                            }
                        })
                )
            }
        } // .alert
        .sheet(item: $viewModel.selectedItem) { item in
            ItemView(input: item)
                .onAppear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        endSession()
                    }
                }
                .onDisappear() {
                    if selection == .スキャナー {
                        DispatchQueue.global(qos: .userInitiated).async {
                            startSession()
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
    } // body
    
    private func removeItem() {
        removeItems.forEach { link in
            guard let item = searchItem(link) else {
                return
            }
            context.delete(item[0])
        }
        
        do {
            try context.save()
            removeItems = []
        } catch {
            fatalError()
        }
    }
    
    private func searchItem(_ link: String) -> [FavoriteItem]? {
        
        let request = NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
        let predicate = NSPredicate(format: "link CONTAINS[C] %@", link)
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    private func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    private func endSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    private func firstVisitSetup(){
        let visit = UserDefaults.standard.bool(forKey: CurrentUserDefaults.isFirstVisit)
        
        if visit {
            isFirstTime = false
        } else {
            isFirstTime = true
            selection = .使い方
            UserDefaults.standard.set(true, forKey: CurrentUserDefaults.isFirstVisit)
        }
    }
}
