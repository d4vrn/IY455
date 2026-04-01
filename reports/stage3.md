# IY455 Stage 3

| Assessment Details | Please Complete All Details |
| ------------------ | --------------------------- |
| Group              | B                           |
| Module Title       | Implementation Model        |
| Assessment Type    | Coursework                  |
| Module Tutor Name  | Mustafa Ghashim             |
| Student ID Number  | P500796                     |
| Date of Submission | 29/2/2026                   |
| Word Count         | 719                         |

- [x] *I confirm that this assignment is my own work. Where I have referred to academic sources, I have provided in-text citations and included the sources in
  the final reference list.*

- [x] *Where I have used AI, I have cited and referenced appropriately.*

---

## Task 4 – SQL Code and Print Screen of SQL Output

### Query 1 - Current Rentals

**Objective:** Output all borrowers who have current rentals and order them by surname.

**SQL:**

```sql
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus, loanDate, actualReturnDate
    FROM Borrower JOIN Loan L ON Borrower.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    WHERE LL.actualReturnDate IS NULL ORDER BY borrowerLastName;
```

**Output:** 

![Query 1 Output](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query1.png)

---

### Query 2 - Overdue Loans

**Objective:** Create a list that shows all borrowers who have over-due loans and rank them highest to lowest.

**SQL:**

```sql
    # Highest to lowest by the number of loans
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, COUNT(*) AS overDueLoans
    FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line AS LL ON L.loanId = LL.loanId WHERE actualReturnDate IS NULL
    AND CURRENT_DATE > returnDueDate GROUP BY B.borrowerId, borrowerFirstName, borrowerLastName, borrowerAddress
    ORDER BY COUNT(*) DESC;

    # Highest to lowest by the number of days (each loan having different time borrowers may appear more than once)
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerAddress,
    returnDueDate, current_date, DATEDIFF(current_date, returnDueDate) AS daysOverdue
    FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line AS LL ON L.loanId = LL.loanId WHERE actualReturnDate IS NULL
    AND CURRENT_DATE > returnDueDate ORDER BY daysOverdue DESC;
```

**Output:** 

![Query 2 Output / number of loans](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query2(loan_number).png)

![Query 2 Output / days](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query2(loan_days).png)

---

### Query 3 - Comedy Rentals

**Objective:** Display the borrower details and DVDs for all borrowers who have rented comedy movies in the last 4 weeks.

**SQL:**

```sql
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, dvdTitle,
    dvdYear, starringActor, categoryName
    FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    JOIN Copy C ON  LL.copyId = C.copyId
    JOIN DVD D ON C.dvdId = D.dvdId JOIN Rental_Category RC
    ON D.categoryId = RC.categoryId WHERE categoryName = 'Comedy'
    AND L.loanDate >= DATE_SUB(CURDATE(), INTERVAL 4 WEEK);
```

**Output:**

![Query 3 Output](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query3.png)

---

### Query 4 - Highest Fines

**Objective:** Find the borrower who has accumulated the most over-due fines, calculate the total in fines and display their details.

**SQL:**

```sql
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress,
    SUM(fineChargeRate * DATEDIFF(actualReturnDate, returnDueDate))
    totalFine FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    JOIN Copy C ON  LL.copyId = C.copyId
    JOIN DVD D ON C.dvdId = D.dvdId JOIN Rental_Category RC
    ON D.categoryId = RC.categoryId
    WHERE actualReturnDate IS NOT NULL AND actualReturnDate > returnDueDate
    GROUP BY borrowerFirstName, borrowerLastName, borrowerAddress
    ORDER BY totalFine DESC LIMIT 1;
```

**Output:**

![Query 4 Output](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query4.png)

---

### Query 5 - Update Superhero Cost

**Objective:** Update the cost for rentals where the release date is >=2015 to £5.50 and the movie category is superhero.

**SQL:**

```sql
    SELECT categoryName, rentalCost, dvdTitle, dvdYear
    FROM Rental_Category RC
    JOIN DVD D ON RC.categoryId = D.categoryId
    WHERE categoryName = 'Superhero' AND dvdYear >= 2015;

    UPDATE Rental_Category RC
    JOIN DVD D ON RC.categoryId = D.categoryId
    SET rentalCost = 5.50
    WHERE dvdYear >= 2015 AND categoryName = 'Superhero';

    SELECT categoryName, rentalCost, dvdTitle, dvdYear
    FROM Rental_Category RC
    JOIN DVD D ON RC.categoryId = D.categoryId
    WHERE categoryName = 'Superhero' AND dvdYear >= 2015;
```

**Output:**

*before update*

![Query 5 Output / before](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query5(before).png)

*after update*

![Query 5 Output / after](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query5(after).png)

---

### Query 6 - Remove Unloaned DVDs

**Objective:** Remove DVD movies from the system where there are no loans registered for the movie.

**SQL:** 

```sql
    SELECT dvdTitle, starringActor, dvdYear FROM DVD
    WHERE dvdId NOT IN (
    SELECT DISTINCT D.dvdId FROM DVD D
    JOIN Copy C ON D.dvdId = C.dvdId
    JOIN Loan_Line LL ON C.copyId = LL.copyId);

    DELETE C FROM Copy C
    LEFT JOIN Loan_Line LL ON C.copyId = LL.copyId
    WHERE LL.copyId IS NULL;

    DELETE FROM DVD
    WHERE NOT EXISTS (
        SELECT 1 FROM Copy
        WHERE Copy.dvdId = DVD.dvdId
    );

    SELECT * FROM DVD;
```

**Output:**

*before delete*

![Query 6 Output / before pt1](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query6(before)pt1.png)

![Query 6 Output / before pt1](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query6(before)pt2.png)

*after delete*

![Query 6 Output / after](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/query6(after).png)
