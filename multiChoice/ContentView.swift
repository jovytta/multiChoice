//
//  ContentView.swift
//  multiChoice
//
//  Created by Mac12 on 2025/4/25.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
    let imageName: String 
}

class GameState: ObservableObject {
    private let questionBank: [Question] = [
        Question(text: "Which season can you grow blueberries in Stardew Valley?", 
                options: ["Spring", "Summer", "Fall", "Winter"], 
                correctAnswerIndex: 1,
                imageName: "blueberry"),
        Question(text: "Who is the carpenter in Stardew Valley?", 
                options: ["Robin", "Demetrius", "Lewis", "Clint"], 
                correctAnswerIndex: 0,
                imageName: "robin"),
        Question(text: "What crop gives the most profit per day in Spring?", 
                options: ["Strawberry", "Cauliflower", "Potato", "Rhubarb"], 
                correctAnswerIndex: 0,
                imageName: "strawberry"),
        Question(text: "Which villager loves receiving diamonds as gifts?", 
                options: ["Abigail", "Haley", "Penny", "All of them"], 
                correctAnswerIndex: 3,
                imageName: "haley"),
        Question(text: "What is the name of the mining area in Stardew Valley?", 
                options: ["The Deep Cave", "The Mines", "Crystal Cavern", "Dwarf Halls"], 
                correctAnswerIndex: 1,
                imageName: "mines"),
        Question(text: "Which fish can only be caught when it's raining?", 
                options: ["Tuna", "Sturgeon", "Legend", "Catfish"], 
                correctAnswerIndex: 3,
                imageName: "fishing"),
        Question(text: "What item is needed to unlock the Community Center's Pantry bundle?", 
                options: ["Gold Star Parsnip", "Artisan Goods", "Quality Crops", "Animal Products"], 
                correctAnswerIndex: 2,
                imageName: "community"),
        Question(text: "Which of these is NOT a farm type you can choose at the start of the game?", 
                options: ["Standard Farm", "Riverland Farm", "Mountain Farm", "Desert Farm"], 
                correctAnswerIndex: 3,
                imageName: "farm"),
        Question(text: "What is the maximum number of hearts you can achieve with a villager before marriage?", 
                options: ["8", "10", "12", "14"], 
                correctAnswerIndex: 1,
                imageName: "heart"),
        Question(text: "Which of these crops continues producing after harvesting?", 
                options: ["Potato", "Corn", "Wheat", "Garlic"], 
                correctAnswerIndex: 1,
                imageName: "corn"),
        Question(text: "What is the name of the in-game currency?", 
                options: ["Coins", "Gold", "Dollars", "Stars"], 
                correctAnswerIndex: 1,
                imageName: "gold"),
        Question(text: "Which animal produces wool in Stardew Valley?", 
                options: ["Cow", "Pig", "Sheep", "Duck"], 
                correctAnswerIndex: 2,
                imageName: "sheep"),
        Question(text: "How many seasons are there in a Stardew Valley year?", 
                options: ["3", "4", "5", "6"], 
                correctAnswerIndex: 1,
                imageName: "seasons"),
        Question(text: "What is the main antagonistic company in the game's story?", 
                options: ["Joja Corporation", "Morris Inc.", "Valley Enterprises", "Ferngill Co."], 
                correctAnswerIndex: 0,
                imageName: "joja"),
        Question(text: "Which item allows you to change your profession choices?", 
                options: ["Strange Bun", "Statue of Uncertainty", "Galaxy Soul", "Prismatic Shard"], 
                correctAnswerIndex: 1,
                imageName: "statue")
    ]
    
    @Published var currentQuestions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var selectedAnswerIndex: Int? = nil
    @Published var showResult: Bool = false
    @Published var gameOver: Bool = false
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        currentQuestions = Array(questionBank.shuffled().prefix(10))
        currentQuestionIndex = 0
        score = 0
        selectedAnswerIndex = nil
        showResult = false
        gameOver = false
    }
    
    func selectAnswer(_ index: Int) {
        if selectedAnswerIndex == nil {
            selectedAnswerIndex = index
            showResult = true
            
            if index == currentQuestions[currentQuestionIndex].correctAnswerIndex {
                score += 10
            }
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < currentQuestions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            showResult = false
        } else {
            gameOver = true
        }
    }
    
    var currentQuestion: Question {
        currentQuestions[currentQuestionIndex]
    }
}

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0/255, green: 0/255, blue: 128/255),
                    Color(red: 0/255, green: 0/255, blue: 0/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Text("Question \(gameState.currentQuestionIndex + 1)/10")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.blue.opacity(0.5)))
                    
                    Spacer()
                    
                    Text("Score: \(gameState.score)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.green.opacity(0.5)))
                }
                .padding(.horizontal)
                
                Image(gameState.currentQuestion.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                            .padding(.horizontal, 5)
                    )
                
                Text(gameState.currentQuestion.text)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                            .shadow(radius: 2)
                    )
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(0..<gameState.currentQuestion.options.count, id: \.self) { index in
                        Button(action: {
                            gameState.selectAnswer(index)
                        }) {
                            HStack {
                                Text("\(["A", "B", "C", "D"][index]).")
                                    .fontWeight(.bold)
                                    .frame(width: 30, alignment: .center)
                                    .foregroundColor(.white)
                                
                                Text(gameState.currentQuestion.options[index])
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if gameState.showResult && gameState.selectedAnswerIndex == index {
                                    Image(systemName: index == gameState.currentQuestion.correctAnswerIndex ? 
                                          "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(index == gameState.currentQuestion.correctAnswerIndex ? 
                                                       .green : .red)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(backgroundColor(for: index))
                                    .shadow(radius: 1)
                            )
                        }
                        .disabled(gameState.selectedAnswerIndex != nil)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                if gameState.showResult && !gameState.gameOver {
                    Button(action: {
                        gameState.nextQuestion()
                    }) {
                        Text("Next Question")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0/255, green: 0/255, blue: 128/255))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                    }
                    .padding(.horizontal)
                }
                
                if gameState.gameOver {
                    VStack(spacing: 15) {
                        Text("Game Over!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0/255, green: 0/255, blue: 128/255))
                        
                        Text("Your final score: \(gameState.score)")
                            .font(.title2)
                            .foregroundColor(Color(red: 0/255, green: 0/255, blue: 128/255))
                        
                        Button(action: {
                            gameState.startNewGame()
                        }) {
                            Text("Play Again")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 0/255, green: 0/255, blue: 128/255))
                                )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    private func backgroundColor(for index: Int) -> Color {
        if let selectedIndex = gameState.selectedAnswerIndex, gameState.showResult {
            if index == gameState.currentQuestion.correctAnswerIndex {
                return Color.green.opacity(0.5)
            } else if index == selectedIndex {
                return Color.red.opacity(0.5)
            }
        }
        
        return Color.white.opacity(0.3)
    }
}

#Preview {
    ContentView()
}
