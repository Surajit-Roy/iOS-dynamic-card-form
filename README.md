💳 Card Flip Animation - iOS Swift Project
🚀 A sleek and interactive debit card flip animation in Swift (UIKit) that mimics a real-world card-flipping experience while entering the CVV.

📸 Preview

<img src="/CardFlipAppPOC/assets/card_flip.gif" width="300" height="600">


📌 Features
```
✅ Smooth card flip animation when entering the CVV
✅ Auto-formatted card number & expiry date validation
✅ Mandatory field validation with error messages
✅ Gradient-colored Pay button
✅ Page scrolling resets card fields & ensures proper front-side visibility
```

🛠 Technologies Used
1. Swift (UIKit)
2. CAGradientLayer for button styling
3. UICollectionView for card management
4. UIView Animation for smooth transitions

```
📂 Project Structure
📂 CardFlipApp
 ┣ 📂 controller
 ┃ ┣ 📜 ViewController.swift   # Main logic for card UI & animation
 ┃ ┣ 📜 DebitCardCell.swift   # CollectionView cell with front & back views
 ┣ 📂 view
 ┃ ┣ 📜 Main.storyboard
 ┣ 📂 assets
 ┃ ┣ 📄 card_flip.gif              # Demo GIF
 ┣ 📂 Core
 ┃ ┣ 📜 AppDelegate.swift
 ┃ ┣ 📜 SceneDelegate.swift
 ┣ 📂 model
 ┃ ┣ 📜 DebitCardModel.swift
 ┣ 📂 utils
 ┃ ┣ 📜 ParentController.swift
 ┃ ┣ 📜 Uitilities.swift
 ┣ 📜 README.md
 ┣ 📜 Info.plist
```

📖 How It Works
```
1️⃣ Enter Card Details → Updates card UI live
2️⃣ Tap CVV Field → Card flips to the back side
3️⃣ Leave CVV Field → Card flips back to the front
4️⃣ Scroll Between Cards → Resets input fields & ensures front visibility
```

🚀 Installation & Usage
```
Clone the repository:  git clone https://github.com/Surajit-Roy/iOS-dynamic-card-form.git
Open CardFlipApp.xcodeproj in Xcode
Run on an iOS Simulator or a physical device
```

🎯 To-Do List
 1. Support for SwiftUI
 2. Add Apple Pay Integration
 3. Implement Dark Mode Support

💡 Have suggestions or improvements? Feel free to contribute! 🚀