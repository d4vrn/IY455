# IY455 – Implementation Model: Final Report

| Assessment Details | Please Complete All Details |
| ------------------ | --------------------------- |
| Group              | B                           |
| Module Title       | Implementation Model        |
| Assessment Type    | Coursework                  |
| Module Tutor Name  | Mustafa Ghashim             |
| Student ID Number  | P500796                     |
| Date of Submission | 29/3/2026                   |
| Word Count         | 3149                        |

- [x] *I confirm that this assignment is my own work. Where I have referred to academic sources, I have provided in-text citations and included the sources in the final reference list.*

- [x] *Where I have used AI, I have cited and referenced appropriately.*

---

## Table of Contents

1. [Introduction](#introduction)
2. [Repository Structure](#repository-structure)
3. [Version Control and Progress](#version-control-and-progress)
4. [Task 1 – Database Normalisation](#task-1--database-normalisation)
5. [Task 2 – Entity Relationship Diagram](#task-2--entity-relationship-diagram)
6. [Task 3 – SQL Code and Print Screen of SQL Output](#task-3--sql-code-and-print-screen-of-sql-output)
7. [Task 4 – SQL Code and Print Screen of SQL Output](#task-4--sql-code-and-print-screen-of-sql-output)
8. [Conclusion](#conclusion)
9. [References](#references)

---

## Introduction

This report documents the full implementation model for the DVD Loan Management System, developed across three stages as part of the IY455 Information Systems Analysis and Design module. The work progresses from initial data analysis through to a fully functional relational database with supporting SQL queries.

Stage 1 covers the normalisation of the raw data and the creation of an Entity Relationship Diagram. Stage 2 introduces the DDL SQL used to build the database and populate it with data. Stage 3 completes the implementation with DML queries designed to retrieve, manipulate and manage data within the system. Throughout the project, version control was maintained using GitHub, with regular commits reflecting the progress made at each stage.

---

## Repository Structure

The repository is organised as follows:

```
IY455/
├── assets/
│   └── images/                   # All screenshots and diagrams
│       └── updated_images/       # Updated ERD and revised diagrams
├── reports/
│   ├── stage1.md                 # Stage 1: Normalisation and ERD
│   ├── stage2.md                 # Stage 2: DDL SQL
│   ├── stage3.md                 # Stage 3: DML SQL queries
│   └── final_report.md           # This document
├── README.md                     # Project overview and structure
├── table.sql                     # DDL: database and table creation
└── queries.sql                   # DML: Task 4 queries
```

All images referenced throughout this report are stored in the `assets/images/` directory. If any image does not render in the current viewing environment, it can be found directly at:

```
https://github.com/d4vrn/IY455/tree/main/assets/images
```

---

## Version Control and Progress

Version control was maintained throughout the project using Git and GitHub. The repository contains 28 commits in total, reflecting work carried out progressively across all three stages. Each commit captures a meaningful change — from initial table design through to finalised DML queries.

### ERD Updates

The ERD was revised between Stage 1 and Stage 3 to reflect structural changes made during implementation. The original diagram was produced during the in-class Stage 1 activity. As the database was built in Stage 2, two changes were identified that required the ERD to be updated:

- **Loan_Category renamed to Loan_Line** — to better reflect its role as a line-item record within a loan
- **actualReturnDate added to Loan_Line** — this field was missing from the original design and is required to calculate overdue fines and distinguish between active and returned loans

The updated ERD can be found in `assets/images/updated_images/` and is shown in Task 2 of this report.

### SQL Development Progress

The `table.sql` file was developed iteratively across Stage 2. As the implementation progressed, inline comments were added to each section of the DDL to explain design decisions and constraints:

- Table creation order follows foreign key dependency — `Rental_Category` and `Borrower` are created first as they are referenced by other tables
- `ENUM` types are used for `dvdStatus` and `borrowerStatus` to restrict values to those defined in the scenario
- `dvdId` uses `VARCHAR` rather than `INT AUTO_INCREMENT` to preserve the original DVD codes from the provided dataset
- `actualReturnDate` is defined as `NULL` to allow records to be inserted at loan time before a return date is known

The `queries.sql` file similarly evolved through multiple commits — early drafts containing exploratory attempts were cleaned up in the final version, keeping only the finalised query for each requirement.

---

## Task 1 – Database Normalisation

### What is Normalisation?

Normalisation is the process of organising a relational database to reduce data redundancy and improve data integrity. It works by decomposing tables into smaller, well-structured tables and defining relationships between them (Connolly and Begg, 2014). The process follows a series of stages known as normal forms, each with increasingly strict rules about how data should be structured.

### Advantages

- **Reduces redundancy** — data is stored in one place only, eliminating unnecessary repetition (Date, 2003)
- **Improves data integrity** — updating a value in one place automatically reflects everywhere it is referenced
- **Easier maintenance** — smaller, focused tables are simpler to modify and extend
- **Avoids update anomalies** — insert, update and delete operations cannot accidentally corrupt related data

### Disadvantages

- **More complex queries** — data spread across multiple tables requires JOIN operations to retrieve (Connolly and Begg, 2014)
- **Performance overhead** — joining many tables can slow down read-heavy systems
- **Increased design time** — identifying and resolving all dependencies requires careful analysis

---

### UNF (Un-Normalised Form)

![UNF Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/UNF.png)

The original data contains repeating groups — a single loan record holds multiple DVD and Copy details. All fields exist in one flat unstructured table with no defined primary key.

---

### 1NF (First Normal Form)

![1NF Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/1NF.png)

Repeating DVD groups were removed by introducing a composite primary key of LoanNo and CopyNo. All values are now atomic, however many fields still only partially depend on part of the composite key.

---

### 2NF (Second Normal Form)

![2NF Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/2NF.png)

Partial dependencies were removed by splitting the table into five separate tables — BORROWER, LOAN, LOAN_LINE, COPY and DVD. Each non-key attribute now depends on the whole primary key of its table. However the DVD table still contains a transitive dependency between RentalCategory and RentalCost.

---

### 3NF (Third Normal Form)

![3NF Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/3NF.png)

The transitive dependency DVDNo → RentalCategory → RentalCost was resolved by extracting a new RENTAL_CATEGORY table. DVD now holds a CategoryID foreign key pointing to it. All non-key attributes in every table now depend directly and only on their primary key.

---

### Decisions and Justifications

**Removing TotalLoanCost from LOAN**
The scenario states this is a calculated field equal to the sum of individual DVD rental costs. Storing it would create redundancy as the value can always be derived via a SQL query joining LOAN_LINE, COPY, DVD and RENTAL_CATEGORY. It was therefore removed from the final 3NF design.

**Removing BorrowerTotalFine from BORROWER**
Similarly, the scenario defines this as a calculated field representing unpaid fines. It can be derived from the database and storing it risks inconsistency if rental costs change.

**Creating RENTAL_CATEGORY**
In 2NF the DVD table contained RentalCategory and RentalCost together, creating a transitive dependency — RentalCost depended on RentalCategory rather than the primary key DVDNo. This was resolved in 3NF by extracting these fields into a separate RENTAL_CATEGORY table, with DVD holding a CategoryID foreign key.

**LOAN_LINE as a junction table with composite key**
A loan can include multiple DVD copies, and a copy can appear on multiple loans over time — a many-to-many relationship. LOAN_LINE resolves this by linking LoanNo and CopyNo together. The combination of these two foreign keys forms the composite primary key, as no single copy can appear on the same loan twice. No surrogate ID is needed.

**ReturnDueDate in LOAN_LINE not LOAN**
Different DVD copies on the same loan may belong to different rental categories with different durations. ReturnDueDate must therefore be recorded per copy rather than per loan, making LOAN_LINE the correct location for this field.

---

## Task 2 – Entity Relationship Diagram

The ERD below reflects the updated 3NF design following revisions made during Stage 3. It captures all six entities — BORROWER, LOAN, LOAN_LINE, COPY, DVD and RENTAL_CATEGORY — along with their attributes, primary keys, foreign keys and cardinalities.

![ERD](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/updated_images/ERD_updated.svg)

### Relationships

- **BORROWER to LOAN** — one borrower can make many loans, but each loan belongs to exactly one borrower (one-to-many)
- **LOAN to LOAN_LINE** — one loan can contain many line items, but each line item belongs to one loan (one-to-many)
- **COPY to LOAN_LINE** — one copy can appear on many loan lines over time, but each loan line references one specific copy (one-to-many)
- **DVD to COPY** — one DVD title can have many physical copies, but each copy belongs to one DVD (one-to-many)
- **RENTAL_CATEGORY to DVD** — one rental category can apply to many DVDs, but each DVD belongs to one category (one-to-many)

The LOAN_LINE table acts as a junction entity resolving the many-to-many relationship between LOAN and COPY.

---

## Task 3 – SQL Code and Print Screen of SQL Output

### Updates from Stage 1 Design

During the implementation stage, two changes were made to the original design:

- **Loan_Category renamed to Loan_Line** — to better reflect its role as a line-item record within a loan, consistent with standard database terminology
- **actualReturnDate added to Loan_Line** — the original design did not include this field. It was added to support overdue fine calculations and to distinguish between DVDs still on loan and those that have been returned

### Database Creation

```sql
CREATE DATABASE IF NOT EXISTS dvd_loan;
USE dvd_loan;
```

---

### Table Creation

```sql
CREATE TABLE Rental_Category (
    categoryId      INT             NOT NULL AUTO_INCREMENT,
    categoryName    VARCHAR(50)     NOT NULL,
    rentalDuration  INT             NOT NULL,
    rentalCost      DECIMAL(5,2)    NOT NULL,
    fineChargeRate  DECIMAL(5,2)    NOT NULL,
    PRIMARY KEY (categoryId)
);

CREATE TABLE Borrower (
    borrowerId        INT           NOT NULL AUTO_INCREMENT,
    borrowerFirstName VARCHAR(50)   NOT NULL,
    borrowerLastName  VARCHAR(50)   NOT NULL,
    borrowerAddress   VARCHAR(255)  NOT NULL,
    borrowerStatus    ENUM('active', 'dormant', 'suspended', 'terminated') NOT NULL,
    PRIMARY KEY (borrowerId)
);

CREATE TABLE DVD (
    dvdId           VARCHAR(10)     NOT NULL,
    dvdTitle        VARCHAR(100)    NOT NULL,
    starringActor   VARCHAR(100)    NOT NULL,
    dvdYear         INT             NOT NULL,
    categoryId      INT             NOT NULL,
    PRIMARY KEY (dvdId),
    FOREIGN KEY (categoryId) REFERENCES Rental_Category(categoryId)
);

CREATE TABLE Copy (
    copyId          INT             NOT NULL AUTO_INCREMENT,
    dvdId           VARCHAR(10)     NOT NULL,
    shelfPosition   VARCHAR(20)     NOT NULL,
    dvdStatus       ENUM('available', 'on loan', 'overdue', 'reserved', 'missing') NOT NULL,
    PRIMARY KEY (copyId),
    FOREIGN KEY (dvdId) REFERENCES DVD(dvdId)
);

CREATE TABLE Loan (
    loanId          INT             NOT NULL AUTO_INCREMENT,
    borrowerId      INT             NOT NULL,
    loanDate        DATE            NOT NULL,
    PRIMARY KEY (loanId),
    FOREIGN KEY (borrowerId) REFERENCES Borrower(borrowerId)
);

CREATE TABLE Loan_Line (
    loanId            INT           NOT NULL,
    copyId            INT           NOT NULL,
    returnDueDate     DATE          NOT NULL,
    actualReturnDate  DATE          NULL,       
    PRIMARY KEY (loanId, copyId),
    FOREIGN KEY (loanId) REFERENCES Loan(loanId),
    FOREIGN KEY (copyId) REFERENCES Copy(copyId)
);
```

---

### Tables

```sql
SHOW TABLES;
```

![Tables](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/tables.png)

---

### Inserting Data

```sql
INSERT INTO Rental_Category (categoryName, rentalDuration, rentalCost, fineChargeRate) VALUES
('Action',      3, 4.00, 1.00),
('Adventure',   7, 3.50, 0.50),
('Animation',   7, 3.50, 0.50),
('Biography',   7, 3.80, 0.50),
('Comedy',      3, 4.50, 1.00),
('Crime',       3, 3.80, 1.00),
('Drama',       7, 4.20, 0.50),
('Horror',      3, 4.00, 1.00),
('Superhero',   1, 4.50, 1.50);

INSERT INTO Borrower (borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus) VALUES
('Ben',     'Jones',    '28 Low Road, Nottingham NG5 3PB',      'active'),
('Sarah',   'Miller',   '14 High Street, Nottingham NG1 2AB',   'active'),
('James',   'Wilson',   '5 Park Lane, Nottingham NG7 4CD',      'active'),
('Emily',   'Davis',    '33 Oak Avenue, Nottingham NG3 5EF',    'dormant'),
('Michael', 'Brown',    '9 Elm Close, Nottingham NG8 6GH',      'active'),
('Laura',   'Taylor',   '21 Maple Road, Nottingham NG2 7IJ',    'suspended'),
('Daniel',  'White',    '7 Cedar Street, Nottingham NG6 8KL',   'active'),
('Sophie',  'Harris',   '15 Birch Way, Nottingham NG4 9MN',     'active');
```

---

### Verifying Data

- Rental_Category table

```sql
SELECT * FROM Rental_Category;
```

![Rental Category](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/rental_category.png)

- Borrower table

```sql
SELECT * FROM Borrower;
```

![Borrower](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/borrower.png)

- DVD table

```sql
SELECT * FROM DVD;
```

![DVD Page 1](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/dvd_p1.png)

![DVD Page 2](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/dvd_p2.png)

![DVD Page 3](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/dvd_p3.png)

- Copy table

```sql
SELECT * FROM Copy;
```

![Copy](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/copy.png)

- Loan table

```sql
SELECT * FROM Loan;
```

![Loan](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/loan.png)

- Loan_Line table (junction table)

```sql
SELECT * FROM Loan_Line;
```

![Loan Line](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/loan_category.png)

The `Loan_Line` table is a junction table, also known as a bridge or associative table. It exists to resolve the many-to-many relationship between `Loan` and `Copy` — a single loan can include multiple DVD copies, and a single copy can appear across many loans over time. Rather than storing a surrogate ID, `Loan_Line` uses a composite primary key made up of `loanId` and `copyId` together, as the same copy cannot appear on the same loan twice. This design is a direct result of the normalisation process and ensures referential integrity is maintained across the database (Connolly and Begg, 2014).

---

## Task 4 – SQL Code and Print Screen of SQL Output

The following queries were written and executed using DataGrip connected to a local MySQL server. Each query addresses a specific requirement from the task brief. All queries conform to the MySQL standard.

---

### Query 1 – Current Rentals

**Objective:** Output all borrowers who have current rentals and order them by surname.

**SQL:**

```sql
SELECT
    borrowerFirstName,
    borrowerLastName,
    borrowerAddress,
    borrowerStatus,
    loanDate,
    actualReturnDate
FROM Borrower
JOIN Loan L ON Borrower.borrowerId = L.borrowerId
JOIN Loan_Line LL ON L.loanId = LL.loanId
WHERE LL.actualReturnDate IS NULL       -- DVD has not been returned yet
ORDER BY borrowerLastName;              -- Sorted alphabetically by surname
```

**Output:**

![Query 1 Output](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query1.png)

---

### Query 2 – Overdue Loans

**Objective:** Create a list that shows all borrowers who have over-due loans and rank them highest to lowest.

Two versions of this query were produced — one ranked by number of overdue loans per borrower, and one ranked by number of days overdue per loan.

**SQL:**

```sql
-- Highest to lowest by the number of overdue loans
SELECT borrowerFirstName, borrowerLastName, borrowerAddress, COUNT(*) AS overDueLoans
FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
JOIN Loan_Line AS LL ON L.loanId = LL.loanId
WHERE actualReturnDate IS NULL
AND CURRENT_DATE > returnDueDate
GROUP BY B.borrowerId, borrowerFirstName, borrowerLastName, borrowerAddress
ORDER BY overDueLoans DESC;

-- Highest to lowest by the number of days overdue
SELECT borrowerFirstName, borrowerLastName, borrowerAddress,
returnDueDate, current_date, DATEDIFF(current_date, returnDueDate) AS daysOverdue
FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
JOIN Loan_Line AS LL ON L.loanId = LL.loanId
WHERE actualReturnDate IS NULL
AND CURRENT_DATE > returnDueDate
ORDER BY daysOverdue DESC;
```

**Output:**

*Ranked by number of overdue loans:*

![Query 2 Output / number of loans](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query2(loan_number).png)

*Ranked by days overdue:*

![Query 2 Output / days](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query2(loan_days).png)

---

### Query 3 – Comedy Rentals

**Objective:** Display the borrower details and DVDs for all borrowers who have rented comedy movies in the last 4 weeks.

**SQL:**

```sql
SELECT
    borrowerFirstName,
    borrowerLastName,
    borrowerAddress,
    dvdTitle,
    dvdYear,
    starringActor,
    categoryName,
    L.loanDate
FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
JOIN Loan_Line LL ON L.loanId = LL.loanId
JOIN Copy C ON LL.copyId = C.copyId
JOIN DVD D ON C.dvdId = D.dvdId
JOIN Rental_Category RC ON D.categoryId = RC.categoryId
WHERE categoryName = 'Comedy'                                   -- Filter by comedy category
AND L.loanDate >= DATE_SUB(CURDATE(), INTERVAL 4 WEEK);         -- Rented within last 4 weeks
```

**Output:**

![Query 3 Output](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query3.png)

---

### Query 4 – Highest Fines

**Objective:** Find the borrower who has accumulated the most over-due fines, calculate the total in fines and display their details.

**SQL:**

```sql
SELECT
    borrowerFirstName,
    borrowerLastName,
    borrowerAddress,
    SUM(
        fineChargeRate * DATEDIFF(
            IFNULL(actualReturnDate, CURDATE()),    -- Use today if DVD not yet returned
            returnDueDate
        )
    ) AS totalFine
FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
JOIN Loan_Line LL ON L.loanId = LL.loanId
JOIN Copy C ON LL.copyId = C.copyId
JOIN DVD D ON C.dvdId = D.dvdId
JOIN Rental_Category RC ON D.categoryId = RC.categoryId
WHERE (actualReturnDate IS NOT NULL AND actualReturnDate > returnDueDate)
   OR (actualReturnDate IS NULL AND returnDueDate < CURDATE())
GROUP BY borrowerFirstName, borrowerLastName, borrowerAddress
ORDER BY totalFine DESC
LIMIT 1;                                -- Return only the borrower with the highest fines
```

**Output:**

![Query 4 Output](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query4.png)

---

### Query 5 – Update Superhero Cost

**Objective:** Update the cost for rentals where the release date is >=2015 to £5.50 and the movie category is superhero.

**SQL:**

```sql
-- Preview records before update
SELECT categoryName, rentalCost, dvdTitle, dvdYear
FROM Rental_Category RC
JOIN DVD D ON RC.categoryId = D.categoryId
WHERE categoryName = 'Superhero' AND dvdYear >= 2015;

-- Apply the update
UPDATE Rental_Category RC
JOIN DVD D ON RC.categoryId = D.categoryId
SET rentalCost = 5.50                   -- New rental price
WHERE dvdYear >= 2015                   -- Released 2015 or later
AND categoryName = 'Superhero';         -- Superhero category only

-- Verify update was applied
SELECT categoryName, rentalCost, dvdTitle, dvdYear
FROM Rental_Category RC
JOIN DVD D ON RC.categoryId = D.categoryId
WHERE categoryName = 'Superhero' AND dvdYear >= 2015;
```

**Output:**

*Before update:*

![Query 5 Output / before](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query5(before).png)

*After update:*

![Query 5 Output / after](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query5(after).png)

---

### Query 6 – Remove Unloaned DVDs

**Objective:** Remove DVD movies from the system where there are no loans registered for the movie.

**SQL:**

```sql
-- Preview DVDs with no loan records before deletion
SELECT dvdTitle, starringActor, dvdYear FROM DVD
WHERE dvdId NOT IN (
    SELECT DISTINCT D.dvdId FROM DVD D
    JOIN Copy C ON D.dvdId = C.dvdId
    JOIN Loan_Line LL ON C.copyId = LL.copyId
);

-- Step 1: Delete copies that have no associated loan records
DELETE C FROM Copy C
LEFT JOIN Loan_Line LL ON C.copyId = LL.copyId
WHERE LL.copyId IS NULL;                -- Copy has never been loaned

-- Step 2: Delete DVDs that now have no copies remaining
-- Note: NOT EXISTS used instead of NOT IN to avoid NULL comparison issues
DELETE FROM DVD
WHERE NOT EXISTS (
    SELECT 1 FROM Copy
    WHERE Copy.dvdId = DVD.dvdId
);

-- Verify remaining DVDs after deletion
SELECT * FROM DVD;
```

**Output:**

*Before delete:*

![Query 6 Output / before p1](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query6(before)p1.png)

![Query 6 Output / before p2](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query6(before)p2.png)

*After delete:*

![Query 6 Output / after](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query6(after).png)

---

## Conclusion

This report has documented the full implementation of the DVD Loan Management System across three stages. The data was successfully normalised from an un-normalised flat table through to third normal form, producing six well-structured tables with clearly defined relationships. An Entity Relationship Diagram was produced and subsequently updated to reflect changes identified during implementation.

The database was built using MySQL with DDL statements defining all tables, constraints and foreign key relationships. Sample data was inserted and verified across all six tables. DML queries were then developed to satisfy all six Task 4 requirements — covering retrieval, aggregation, updates and deletions.

Version control was applied throughout using GitHub, with 28 commits tracking progress from initial setup through to the finalised queries. If this project were to be extended, additional work could include adding supplier information as described in the original scenario, implementing stored procedures for fine calculations, and introducing more comprehensive test data to cover edge cases such as reserved and missing DVD copies.

---

## References

Connolly, T. and Begg, C. (2014) *Database Systems: A Practical Approach to Design, Implementation and Management*. 6th edn. Harlow: Pearson Education.

Date, C.J. (2003) *An Introduction to Database Systems*. 8th edn. Boston: Addison-Wesley.
