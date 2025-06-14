

# **World Game Market Insights: Sales, Trends & Rankings**  
An interactive Shiny dashboard for exploring global video game sales, trends, and rankings.

---

### **Project Overview**

This project is an interactive Shiny web application that visualizes and analyzes the global video game market. Users can explore trends, discover top-selling games, analyze publisher performance, and search for detailed information about specific games. The app is designed for gamers, developers, investors, and data enthusiasts interested in the gaming industry.

---

### **Features**

- **Sales Trends & Top Game:**  
  Visualize sales trends across years, genres, and platforms. Identify the best-selling game and top publisher for selected filters.

- **Top Ranked Games:**  
  Filter and view the highest-selling games based on year, genre, and platform.

- **Explore Your Game:**  
  Search for any game and view detailed sales and ranking information.

- **Modern UI:**  
  Dark mode with custom styling for enhanced readability and user experience.

---

### **Project Structure**

```
.
├── app.R                       
├── data/
│   └── video_games_sales_cleaned.csv   # Cleaned dataset used by the app
├── www/
│   ├── pic.jpg
│   ├── pictwo.jpg
│   └── picthree.jpg
├── data_preprocessing.ipynb    
└── README.md                   
```

---

### **Setup Instructions**

#### **1. 

- **R packages:**  
  - shiny  
  - shinythemes  
  - ggplot2  
  - dplyr  
  - DT

- **Python** (optional, for data preprocessing)
  - pandas

#### **2. Install R Packages**

```r
install.packages(c("shiny", "shinythemes", "ggplot2", "dplyr", "DT"))
```

#### **3. Data Preparation**

- The cleaned dataset (`video_games_sales_cleaned.csv`) should be placed inside the `data/` directory.
- If you need to preprocess or clean the raw data, use the `data_preprocessing.ipynb` notebook .
- dataset link - https://www.kaggle.com/datasets/zahidmughal2343/video-games-sale

#### **4. Running the App**

1. Open `app.R` in RStudio .
2. Ensure your working directory contains the `data/` and `www/` folders.
3. Run the app:

```r
shiny::runApp("app.R")
```

---

### **Usage**

- Use the filters in each tab to explore sales trends, rankings, and detailed information about video games.
- Visualizations include sales by region, time trends, and interactive tables.

---

### **Data Source**

- The dataset contains information on video game sales, including:
  - Name, Platform, Year, Genre, Publisher
  - Sales by region 
  - Global sales totals

---

### **Customization**

- You can update the dataset or images by replacing the files in the `data/` or `www/` folders.
- To adjust the UI or add new features, modify the `app.R` file.

---


---

*Enjoy exploring the world of video games with data!*

