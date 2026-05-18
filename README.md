# Manufacturing-Defect-Cost-Analysis
An end-to-end business intelligence project using Excel, SQL Server, Power BI, DAX, and PowerPoint to identify product defect sources and evaluate their impact on profitability.

---

### Process

1. Transfer raw data into SSMS
2. Establish relationships between tables
3. Fix data errors (Cost column in Sales table/cost traceability)
4. Create a Summary View to facilitate further analysis
5. Create Stored Procedures to allow for future data entry
6. Create a live connection to Power BI
7. Create custom measures/tables with DAX
8. Design a dashboard that facilitates root-cause analysis
9. Create and present insights gained through analysis

---

### Tools and Features
- **Excel:** Raw data source
- **T-SQL:** Queries, stored procedures, data cleaning/validation
- **SSMS:** Database, ERD
- **Power BI:** Data visualization, KPIs, analysis
- **DAX:** Custom measures and tables
- **PowerPoint:** Presenting Solution, Insights and Recommendations
  
   
---

## Sections
### [Raw Data](https://github.com/Trevor-Loreth/Manufacturing-Defect-Cost-Analysis/tree/main/Raw%20Data)
- **Zoom Drones.xlsx:** Original Excel dataset used for creating SSMS database.

### [SQL](https://github.com/Trevor-Loreth/Manufacturing-Defect-Cost-Analysis/tree/main/SQL)
- **Stored Procedures:** Several stored procedures were created using T-SQL to INSERT new rows into each table. Each stored procedure works as a repeatable INSERT statement, allowing someone not familiar with SQL to easily execute an INSERT statement. Each stored procedure has built-in error checking to prevent invalid data entry. Additionally, each stored procedure comes with its EXECUTE query, requiring the user to type data in the corresponding column and then run the EXECUTE.
- **Update Costs For Sales Table.sql:** Joins the Inventory, Blades, Motor, and Frame tables to calculate/correct and UPDATE the Cost column in the Sales table.
- **Zoom Drones SSMS Database Diagram.PNG:** A relational database diagram created in SSMS to create and show the relationships between the tables within the database.

### [Power BI](https://github.com/Trevor-Loreth/Manufacturing-Defect-Cost-Analysis/tree/main/Power%20BI)
- **DAX:** This section includes all of my DAX measures and tables used in the various figures within the Dashboard.
  - **Parts Used Table.dax:** This calculated table restructures the inventory data into a single unified parts table. It stacks blades, motors, and frames into one shared format with the product serial number, part type, part serial number, factory, and part cost. This made it easier to analyze factory-level performance across all component types using one consistent table instead of separate blade, motor, and frame tables. The LOOKUPVALUE functions pull the correct factory and unit cost from each component table, while UNION combines the three part categories into one dataset.

  - **Plant Defect Impact table.dax:** This calculated table isolates the parts that were actually responsible for a defect. It starts with the unified Parts Used table, adds return details such as defect status, defect part, refund amount, and return date, then filters the results to only include defective returns where the part type matches the reported defective part. This prevents refund impact from being assigned to every part in a returned product. Instead, only the factory that produced the defective component receives the return and refund impact.
  - **Part Defect Rate.dax:** This measure calculates the percentage of products associated with a selected part, factory, or part type that resulted in a defect. It counts the distinct defective returned products and divides that by the total distinct products in the current Parts Used filter context. TREATAS is used to apply the selected products from Parts Used to the Returns table, allowing defect rates to respond correctly to part-level visuals and slicers.
  - **Refund Amount Caused by Plant.dax:** This measure calculates the total refund amount directly attributed to the plant that produced the defective part. Because it uses the Plant Defect Impact table, the refund amount is only assigned to the factory responsible for the defective component, rather than every factory involved in the returned product.

  - **Defective Returns Caused by Plant.dax:** This measure counts the number of unique defective returned products attributed to each plant. Because it uses the Plant Defect Impact table, each return is only counted for the factory that produced the defective part, preventing the same return from being assigned to unrelated component plants.
  - **Plant Refund Impact.dax:** This measure shows the refund impact as a negative value, making it easier to represent refunds as a reduction to profit. It uses the Plant Defect Impact table, so the negative refund amount is only assigned to the plant responsible for producing the defective component.

  - **Factory with Highest Part Defect Rate.dax:** This measure identifies the factory with the highest part defect rate and displays both the factory name and its defect percentage. It first calculates the defect rate for each factory using the existing Part Defect Rate measure, then uses TOPN to select the highest-ranking factory. The final output is formatted as a dashboard-ready label showing the factory and its defect rate.


  - **Plant with Highest Defective Returns.dax:** This measure identifies the plant with the highest number of defective returns and displays the plant name with the return count. It captures the selected part type from the Parts Used slicer, applies that selection to the Plant Defect Impact table using TREATAS, and then ranks plants by defective return count. TOPN selects the highest-ranking plant, while the final output formats the result as a dashboard-ready label.

  - **Plant with Highest Refund Impact.dax:** This measure identifies the plant with the highest refund impact and displays both the plant name and total refund amount. It captures the selected part type from the Parts Used slicer, applies that filter to the Plant Defect Impact table with TREATAS, and ranks plants by refund amount. TOPN selects the plant with the highest refund total, and the final output formats the result as a dashboard-ready label.

  - **Factory Visible for Selected Part Type.dax:** This measure controls whether a factory should appear in visuals based on the selected part type. It captures the selected part type from the Parts Used slicer, checks which factories in Plant Defect Impact match that selection, and returns the number of matching rows. When used as a visual-level filter set to greater than 0, it hides factories that are not relevant to the selected part type. Used as a filter in Refund and Returns Caused by Plant and Returns and Refund Impact Caused by Plant charts.


  
- **Power BI Dashboard:** File that includes my data visualizations from Power BI. Utilized several DAX measures and tables to aid in plant performance analysis. Features 3 KPI cards that highlight the most underperforming plants in the categories of highest defect rate, highest number of returns, and the plant responsible for the highest dollar amount of refunds.
  - **Cost of Parts by Plant:** This line and stacked column chart shows the total cost accrued from each plant's parts used and shows the defect rate of each plant. Utilizes DAX table Parts Used Factory column for x-axis, Sum of Part Cost from Parts Used DAX table for y-column, DAX measure Part Defect Rate for y-line, and Part Type from DAX table Parts Used as legend.
  - **Parts Used by Plant:** This line and stacked column chart shows the total number of parts used from each plant and the defect rate of each plant. Utilizes DAX table Parts Used Factory column for x-axis, Count of Part Serial # from DA table Parts Used for y-column, DAX measure Part Defect Rate for y-line, and Part Type from DAX table Parts Used as legend.
  - **Refund and Returns Caused by Plant:** This line and stacked column chart shows the total dollar amount of refunds caused by each plant alongside the number of defective returns. The x-axis uses the Factory column from the DAX Plant Defect Impact table, the DAX measure Refund Amount Caused by Plant is used in the y-column, and Defective Returns Caused by Plant is used in the y-line.
  - **Returns and Refund Impact Caused by Plant:** Essentially, an inverse of the Refund and Returns Caused by Plant chart to provide an alternative visualization of the same data. The y-line is shifted to the y-column, and the DAX measure Plant Refund Impact is used in place of the y-line.
  - **Plant with Highest Part Defect Rate:** A KPI card displaying the plant with the highest part defect rate and the defect rate of that plant. Utilizes the DAX measure Factory with Highest Part Defect Rate.
  - **Plant with Highest Defective Returns:** A KPI card displaying the plant causing the highest number of returns caused by defects, alongside the number of returns. Utilizes the DAX measure Plant with Highest Defective Returns.
  - **Plant with Highest Refund Impact:** A KPI card displaying the plant causing the highest dollar amount of returns, alongside that dollar amount. Utilizes the DAX measure Plant with Highest Refund Impact.

### [PowerPoint](https://github.com/Trevor-Loreth/Manufacturing-Defect-Cost-Analysis/tree/main/PowerPoint)
- **Zoom Drones Project.pptx:** Structured as: Problem -> Request -> Solution -> Insights -> Reccomendations.
  - **Problem:** Excel is not cutting it for data storage. The Cost column in the Sales table is not calculating correctly. Hard to determine which plants are underperforming.
  - **Request:** Convert Excel data into an SSMS database. Fix the Cost column in the Sales table. Create a Power BI dashboard to identify underperforming plants easily. Present findings and recommendations.
  - **Solution:** Transfer raw data into SSMS. Establish relationships between tables. Fix data errors (Cost column in Sales table/cost traceability). Create a Summary View to facilitate further analysis. Create Stored Procedures to allow for future data entry. Create a live connection to Power BI. Create custom measures/tables with DAX. Design a dashboard that facilitates root-cause analysis. Create and present insights gained through analysis
  - **Insights:** Blades: Vancouver WA, is the costliest plant. Frame: Richardson TX, is the costliest plant. Motor: Denver CO, is the costliest plant.
  - **Recommendations:** Blades: Shift production from Vancouver WA, to Tacoma WA. Frame: Shift production from Richardson TX, to Dallas TX. **Key Recommendation:** Motor: shift production from Denver CO, to Portland OR.
