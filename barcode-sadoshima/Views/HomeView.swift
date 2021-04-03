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
    
    @State private var isEditing = false
    @State private var isShowingKeyboard = false
    @State private var removeItems = [String]()
    @State private var captureSession = AVCaptureSession()
    @State private var isAnimating = false
    @State private var isFirstTime = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RootView(
                selection: $viewModel.selection,
                isEditing: $isEditing,
                isShowingKeyboard: $isShowingKeyboard,
                isShowingAlert: $viewModel.isShowingAlert,
                removeItems: $removeItems,
                selectedItem: $viewModel.selectedItem,
                alertItem: $viewModel.alertItem,
                isLoading: $viewModel.isLoading,
                onCommitSubject: $viewModel.onCommitSubject,
                captureSession: $captureSession,
                isFirstTime: $isFirstTime,
                showItems: $viewModel.showItems
            )
            
            VStack(spacing: 0) {
                
                if viewModel.isLoading {
                    Spacer()
                    
                    ZStack {
                        Color(.black)
                            .opacity(0.6)
                            .frame(width: 100, height: 100)
                            .cornerRadius(12)
                            .disabled(viewModel.isLoading)
                        
                        Circle()
                            .trim(from: 0, to: 0.6)
                            .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                                    style: StrokeStyle(
                                        lineWidth: 8,
                                        lineCap: .round,
                                        dash: [0.1, 16],
                                        dashPhase: 8))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(self.isAnimating ? 360 : 0))
                            .onAppear() {
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                    self.isAnimating = true
                                }
                            }
                            .onDisappear() {
                                self.isAnimating = false
                            }
                    } // ZStack
                    //.drawingGroup()
                    
                    Spacer()
                }
                
                MotionTabBar(
                    selection: $viewModel.selection,
                    isFirstTime: $isFirstTime,
                    captureSession: $captureSession,
                    selectedItem: $viewModel.selectedItem
                )
                .disabled(viewModel.isLoading)
                .opacity(!isShowingKeyboard ? 1 : 0)
                .offset(y: !isShowingKeyboard ? 0 : 100)
            } // VStack
        } // ZStack
        .onAppear {
            firstVisitSetup()
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
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
                    if viewModel.selection == .scanner {
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
            viewModel.selection = .usage
            UserDefaults.standard.set(true, forKey: CurrentUserDefaults.isFirstVisit)
        }
    }
}
