# Data_Pipeline

## Overview  
This project is a full data engineering pipeline that involves data ingestion, transformation, storage, and processing. The goal is to build an end-to-end system that efficiently handles large-scale data and enables insights through structured storage and querying.  

The dataset used in this project is **AdventureWorks**, a sample database from Microsoft that contains sales, product, and customer information. This dataset is commonly used for learning and testing data engineering workflows.


## Project Phases  

### 1. Data Ingestion (Completed ✅)  
#### Description  
The **data ingestion** phase involves extracting raw data from various sources, processing it, and storing it in a structured format. This ensures that data is ready for further transformation and analysis.

#### Components:  
- **Database Schema Design:** Created an ER diagram to structure tables and relationships.  
- **Incremental Data Load:** Implemented incremental data ingestion using SQL scripts.  
- **Triggers & Job Scheduling:** Set up database triggers and scheduled jobs to automate data ingestion.  

#### Files Included:  
- `00_Create_Tables.sql` – Defines the database schema.  
- `01_Incremental_Load.sql` – Implements incremental ingestion.  
- `02_Create_Trigger_And_Job.sql` – Manages job automation and scheduling.  

#### ER Diagram  
![image](https://github.com/user-attachments/assets/bc457e77-02f1-46e0-979d-94dfd7d200ae)

### 2. Data Transformation (To Be Implemented 🛠️)  
_Description to be added once this phase is completed._  

### 3. Data Storage & Management (To Be Implemented 🛠️)  
_Description to be added once this phase is completed._  

### 4. Data Processing & Analytics (To Be Implemented 🛠️)  
_Description to be added once this phase is completed._  

### 5. Deployment & Automation (To Be Implemented 🛠️)  
_Description to be added once this phase is completed._  

## How to Use  
1. Run the provided SQL scripts to set up the database.  
2. Execute ingestion jobs to populate the tables.  
3. Proceed to the next phase of transformation and processing.  

## Next Steps  
- Implement **Data Transformation** logic.  
- Design efficient **Data Storage** mechanisms.  
- Set up **ETL Pipelines** for processing and analytics.  
- Automate the workflow with **Apache Airflow**.  

---  
_This README will be continuously updated as the project progresses._  


