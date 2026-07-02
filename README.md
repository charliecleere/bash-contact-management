# Bash Contact Management

A command-line contact management system written in Bash that allows users to add, search, view, sort, and edit contacts stored in a text file.

This project was developed to strengthen core Linux and shell scripting skills, with a focus on command-line argument processing, input validation, error handling, file manipulation, and text processing using standard Linux utilities.

## Key Features

* Add new contacts
* Display contacts in a clean, column-aligned table generated with `awk`
* Search across all fields or a specific field
* Edit existing contacts by search term or ID
* Sort contact listings by selected fields
* Thorough input validation and error handling
* Display record IDs for easier contact management
* Store data in a structured, human-readable text format

## Skills Demonstrated

### Bash Scripting

* Functions
* Conditional logic
* Loops
* Variables
* Command substitution
* Command-line argument parsing with `getopts`

### Command-Line Interface Design

* Multi-flag argument parsing using `getopts`
* Input validation
* User-friendly error messages
* Required and optional argument handling

### File Manipulation

* Reading and writing text files
* Updating existing records
* Structured data storage
* Atomic file updates using temporary files

### Text Processing

* `awk` for formatted table output and field-based record processing
* `grep` for pattern matching and search validation
* `sort` for ordering contact records
* `cut` for field extraction
* Regular expressions (regex)

### Software Development Practices

* Documentation
* Input sanitization
* Error handling
* Structured script organization
* Git version control

## Project Structure

```text
bash-contact-management/
├── .gitattributes
├── .gitignore
├── LICENSE
├── README.md
├── contact_management.sh
└── sample_contacts.txt
```

## Installation

Clone the repository:

```bash
git clone https://github.com/charliecleere/bash-contact-management.git
cd bash-contact-management
```

Make the script executable:

```bash
chmod +x contact_management.sh
```

## Usage

The script requires a contacts file to be specified with the `-c` option.

### Add a Contact

```bash
./contact_management.sh -c sample_contacts.txt -i -f John -l Doe -e john@email.com -n 555-123-4567 -t Friends
```

### View All Contacts

```bash
./contact_management.sh -c sample_contacts.txt -p
```

### Search Contacts

```bash
./contact_management.sh -c sample_contacts.txt -s John
```

### Search a Specific Field

```bash
./contact_management.sh -c sample_contacts.txt -s example.com -S 3
```

### Edit a Contact

```bash
./contact_management.sh -c sample_contacts.txt -E John -f Jonathan
```

### Edit by ID

```bash
./contact_management.sh -c sample_contacts.txt -E -N 1 -f Jonathan
```

## Supported Fields

| Field Number | Field        |
| ------------ | ------------ |
| 0            | All Fields   |
| 1            | First Name   |
| 2            | Last Name    |
| 3            | Email        |
| 4            | Phone Number |
| 5            | Category     |

## Data Format

Contacts are stored using a colon-delimited format:

```text
ID:FirstName:LastName:Email:PhoneNumber:Category
1:John:Doe:john@example.com:555-123-4567:Work
2:Jane:Smith:jane@example.com:555-987-6543:Friends
```

## Sample Data

The repository includes `sample_contacts.txt`, which contains fictional contact records for testing and demonstration purposes.

## What I Learned

This project provided hands-on experience with:

* Building a complete command-line application in Bash
* Designing a flexible argument-parsing system using `getopts`
* Performing field-based searches and updates
* Validating user input before modifying data
* Working with structured text files as a lightweight database
* Creating maintainable and documented shell scripts
* Implementing comprehensive error handling
* Using regular expressions (regex) to validate and search text data

## License

This project is licensed under the MIT License. See the LICENSE file for details.
