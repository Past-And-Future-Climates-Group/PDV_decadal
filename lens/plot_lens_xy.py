import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns

#create list of months
Month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
         'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
#create list for made up average temperatures
Avg_Temp = [35, 45, 55, 65, 75, 85, 95, 100, 85, 65, 45, 35]
#create list for made up average percipitation %
Avg_Percipitation_Perc = [.90, .75, .55, .10, .35, .05, .05, .08, .20, .45, .65, .80]
#assign lists to a value
data = {'Month': Month, 'Avg_Temp': Avg_Temp, 'Avg_Percipitation_Perc': Avg_Percipitation_Perc}
#convert dictionary to a dataframe
df = pd.DataFrame(data)
#Print out all rows
df[:12]

#create bar plot for average temps by month
plt.title('Average Temperature by Month')
sns.barplot(x='Month', y='Avg_Temp', data=df, palette='summer')

# create line plot for average percipitation levels
plt.title('Average Percipitation Percentage by Month')
sns.lineplot(x='Month', y='Avg_Percipitation_Perc', data=df, sort=False)

#Create combo chart
fig, ax1 = plt.subplots(figsize=(10,6))
color = 'tab:green'
#bar plot creation
ax1.set_title('Average Percipitation Percentage by Month', fontsize=16)
ax1.set_xlabel('Month', fontsize=16)
ax1.set_ylabel('Avg Temp', fontsize=16, color=color)
ax1 = sns.barplot(x='Month', y='Avg_Temp', data = df, palette='summer')
ax1.tick_params(axis='y')
#specify we want to share the same x-axis
ax2 = ax1.twinx()
color = 'tab:red'
#line plot creation
ax2.set_ylabel('Avg Percipitation %', fontsize=16, color=color)
ax2 = sns.lineplot(x='Month', y='Avg_Percipitation_Perc', data = df, sort=False, color=color)
ax2.tick_params(axis='y', color=color)
#show plot
plt.show()
