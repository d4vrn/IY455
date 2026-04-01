USE dvd_loan;

-- ------------------------------------------------------------
-- Query 1: Output all borrowers who have current rentals,
--          ordered by surname (ascending).
-- ------------------------------------------------------------

    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus, loanDate, actualReturnDate
    FROM Borrower JOIN Loan L ON Borrower.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    WHERE LL.actualReturnDate IS NULL ORDER BY borrowerLastName;


-- ------------------------------------------------------------
-- Query 2: List all borrowers with overdue loans,
--          ranked highest to lowest by number of overdue loans.
-- ------------------------------------------------------------

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


-- ------------------------------------------------------------
-- Query 3: Display borrower details and DVDs for all borrowers
--          who have rented comedy movies in the last 4 weeks.
-- ------------------------------------------------------------

    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, dvdTitle,
    dvdYear, starringActor, categoryName
    FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    JOIN Copy C ON  LL.copyId = C.copyId
    JOIN DVD D ON C.dvdId = D.dvdId JOIN Rental_Category RC
    ON D.categoryId = RC.categoryId WHERE categoryName = 'Comedy'
    AND L.loanDate >= DATE_SUB(CURDATE(), INTERVAL 4 WEEK);



-- ------------------------------------------------------------
-- Query 4: Find the borrower who has accumulated the most
--          overdue fines, calculate total fines and display
--          their details.
-- Note: Includes both returned late and still-outstanding loans.
-- ------------------------------------------------------------

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


-- ------------------------------------------------------------
-- Query 5: Update rental cost to £5.50 for superhero movies
--          released in 2015 or later.
-- ------------------------------------------------------------

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



-- ------------------------------------------------------------
-- Query 6: Remove DVD movies from the system where there are
--          no loans registered for the movie.
-- ------------------------------------------------------------

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
