
import pandas as pd
import matplotlib.pyplot as plt
import  seaborn as sns
                
         
df = pd.read_csv("StudentsPerformance.csv")
print( df.head())    
          
     
print(df.isnull().sum()) 
 
df['gender'] = df['gender'].str.lower()
df['gender'] = df['gender'].replace({'femle': 'female'})

df.dropna(inplace=True) 
  
df.to_csv("Cleaned_StudentsPerformance.csv", index=False)
 
plt.figure(figsize=(8, 5))
sns.histplot(df['math score'], kde=True, color='skyblue')
plt.title("Distribution of Math Scores")
plt.xlabel("Math Score")
plt.ylabel("Count")
plt.savefig("hist_math_score.png")
plt.show()
   
plt.figure(figsize=(8, 5))
sns.boxplot(x='gender', y='math score', data=df)
plt.title("Math Score by Gender")
plt.savefig("boxplot_gender.png")
plt.show()  
       