# Dashboard Design

<img width="767" height="430" alt="Zoom Drones Dashboard" src="https://github.com/user-attachments/assets/afeee0ba-38fd-4e11-b40d-b665d08a2cd6" />



### Contents
- **Plant Output:** Tracks the costs of parts produced by each plant, and the number of parts produced alongside each plant's defect rate.
- **KPIs:** 3 KPI cards that track the factory with the Highest Defect Rate, # of returns, and Refund Impact.
- **Plant Profit Analysis:** Refund amount caused by each plant, alongside the amount of Defective Returns, and the Refund Impact.
- **Slicer:** Filters entire dashboard by part type (Blades, Frame, Motor).

### Breakdown

**Power BI Dashboard:** File that includes my data visualizations from Power BI. Utilized several DAX measures and tables to aid in plant performance analysis. Features 3 KPI cards that highlight the most underperforming plants in the categories of highest defect rate, highest number of returns, and the plant responsible for the highest dollar amount of refunds. Additionally, the Dashboard includes 4 line and stacked column charts aiding in analysis.
  - **Cost of Parts by Plant:** This line and stacked column chart shows the total cost accrued from each plant's parts used and shows the defect rate of each plant. Utilizes DAX table Parts Used Factory column for x-axis, Sum of Part Cost from Parts Used DAX table for y-column, DAX measure Part Defect Rate for y-line, and Part Type from DAX table Parts Used as legend.
  - **Parts Used by Plant:** This line and stacked column chart shows the total number of parts used from each plant and the defect rate of each plant. Utilizes DAX table Parts Used Factory column for x-axis, Count of Part Serial # from DA table Parts Used for y-column, DAX measure Part Defect Rate for y-line, and Part Type from DAX table Parts Used as legend.
  - **Refund and Returns Caused by Plant:** This line and stacked column chart shows the total dollar amount of refunds caused by each plant alongside the number of defective returns. The x-axis uses the Factory column from the DAX Plant Defect Impact table, the DAX measure Refund Amount Caused by Plant is used in the y-column, and Defective Returns Caused by Plant is used in the y-line.
  - **Returns and Refund Impact Caused by Plant:** Essentially, an inverse of the Refund and Returns Caused by Plant chart to provide an alternative visualization of the same data. The y-line is shifted to the y-column, and the DAX measure Plant Refund Impact is used in place of the y-line.
  - **Plant with Highest Part Defect Rate:** A KPI card displaying the plant with the highest part defect rate and the defect rate of that plant. Utilizes the DAX measure Factory with Highest Part Defect Rate.
  - **Plant with Highest Defective Returns:** A KPI card displaying the plant causing the highest number of returns caused by defects, alongside the number of returns. Utilizes the DAX measure Plant with Highest Defective Returns.
  - **Plant with Highest Refund Impact:** A KPI card displaying the plant causing the highest dollar amount of returns, alongside that dollar amount. Utilizes the DAX measure Plant with Highest Refund Impact.
### [DAX](https://github.com/Trevor-Loreth/Manufacturing-Defect-Cost-Analysis/tree/main/Power%20BI/DAX)
