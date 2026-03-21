# IY455 Stage 1

| Assessment Details | Please Complete All Details |
| ------------------ | --------------------------- |
| Group              | B                           |
| Module Title       | Implementation Model        |
| Assessment Type    | Coursework                  |
| Module Tutor Name  | Mustafa Ghashim             |
| Student ID Number  | P500796                     |
| Date of Submission | 22/2/2026                   |
| Word Count         | 592                         |

- [x] *I confirm that this assignment is my own work. Where I have referred to academic sources, I have provided in-text citations and included the sources in
  the final reference list.*

- [x] *Where I have used AI, I have cited and referenced appropriately.

---

## Task 1 - Database Normalisation

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

### UNF (Un-normalised form)

![UNF Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/UNF.png)

 The original data contains repeating groups — a single loan record holds multiple DVD and Copy details. All fields exist in one flat unstructured table with no defined primary key.

---

### 1NF (First Normal Form)

![](/Users/macbookair/Desktop/Screenshot%202026-03-21%20at%2007.29.50.png)

  Repeating DVD groups were removed by introducing a composite primary key of LoanNo and CopyNo. All values are now atomic, however many fields still only partially depend on part of the composite key.

---

### 2NF (Second Normal Form)

![](/Users/macbookair/Desktop/Screenshot%202026-03-21%20at%2007.30.06.png)

Partial dependencies were removed by splitting the table into five separate tables — BORROWER, LOAN, LOAN_CATEGORY, COPY and DVD. Each non-key attribute now depends on the whole primary key of its table. However the DVD table still contains a transitive dependency between RentalCategory and RentalCost.

---

### 3NF (Third Normal Form)

![](/Users/macbookair/Desktop/Screenshot%202026-03-21%20at%2007.30.48.png)

 The transitive dependency DVDNo → RentalCategory → RentalCost was resolved by extracting a new RENTAL_CATEGORY table. DVD now holds a CategoryID foreign key pointing to it. All non-key attributes in every table now depend directly and only on their primary key.

---

### Decisions and Justifications

**Removing TotalLoanCost from LOAN** The scenario states this is a calculated field equal to the sum of individual DVD rental costs. Storing it would create redundancy as the value can always be derived via a SQL query joining LOAN_LINE, COPY, DVD and RENTAL_CATEGORY. It was therefore removed from the final 3NF design.

**Removing BorrowerTotalFine from BORROWER** Similarly, the scenario defines this as a calculated field representing unpaid fines. It can be derived from the database and storing it risks inconsistency if rental costs change.

**Creating RENTAL_CATEGORY** In 2NF the DVD table contained RentalCategory and RentalCost together, creating a transitive dependency — RentalCost depended on RentalCategory rather than the primary key DVDNo. This was resolved in 3NF by extracting these fields into a separate RENTAL_CATEGORY table, with DVD holding a CategoryID foreign key.

**LOAN_CATEGORY as a junction table with composite key** A loan can include multiple DVD copies, and a copy can appear on multiple loans over time — a many-to-many relationship. LOAN_CATEGORY resolves this by linking LoanNo and CopyNo together. The combination of these two foreign keys forms the composite primary key, as no single copy can appear on the same loan twice. No surrogate ID is needed.

**ReturnDueDate in LOAN_CATEGORY not LOAN** Different DVD copies on the same loan may belong to different rental categories with different durations. ReturnDueDate must therefore be recorded per copy rather than per loan, making LOAN_CATEGORY the correct location for this field.

---

## Task 2 - ERD (Entity Relationship Diagram)

<sup>![](/Users/macbookair/Downloads/ERD.svg)</sup>

---

### References

Connolly, T. and Begg, C. (2014) *Database Systems: A Practical Approach to Design, Implementation and Management*. 6th edn. Harlow: Pearson Education.

Date, C.J. (2003) *An Introduction to Database Systems*. 8th edn. Boston: Addison-Wesley.
