# Bash Contact Management

A command-line contact management system written in Bash that allows users to create, search, display, sort, and edit contacts stored in a text file.

This project was built to demonstrate practical shell scripting skills, including command-line argument parsing, file handling, input validation, error handling, and text processing using standard Unix utilities.

## Features

* Add new contacts to a contact database
* Display all contacts in a formatted table
* Search contacts across all fields or a specific field
* Edit existing contacts by search term or ID number
* Sort contact listings by selected fields
* Optional display of contact IDs
* Email address validation
* Phone number validation
* Comprehensive command-line argument validation
* Structured storage using a plain-text database

## Skills Demonstrated

This project showcases:

* Bash scripting
* Command-line interface (CLI) development
* Command-line argument parsing
* File I/O operations
* Data validation
* Error handling
* Text processing with `awk`, `grep`, and `sort`
* Working with structured text files
* Input sanitization
* Modular script design using functions

## Technologies Used

* Bash
* awk
* grep
* sort

## Installation

Clone the repository:

```bash
git clone https://github.com/your-username/your-repository.git
cd your-repository
```

Make the script executable:

```bash
chmod +x contact_management.sh
```

## Contact File Format

Contacts are stored in a colon-delimited text file using the following format:

```text
ID:FirstName:LastName:Email:PhoneNumber:Category
1:John:Doe:john.doe@example.com:555-123-4567:Work
2:Jane:Smith:jane.smith@example.com:555-987-6543:Friends
```

The repository includes a sample file:

```text
sample_contacts.txt
```

containing fictional contact information for testing and demonstration purposes.

## Usage

All operations require the contact file to be specified using the `-c` option.

### Basic Syntax

```bash
./contact_management.sh -c <contacts_file> [operation] [options]
```

## Operations

### Add a Contact

```bash
./contact_management.sh -c contacts.txt -i -f John -l Doe -e john.doe@email.com -n 555-123-4567 -t Friends
```

### Display Contacts

```bash
./contact_management.sh -c contacts.txt -p
```

Display contacts with IDs:

```bash
./contact_management.sh -c contacts.txt -p -L
```

Sort contacts by a field:

```bash
./contact_management.sh -c contacts.txt -p -k 2
```

### Search Contacts

Search all fields:

```bash
./contact_management.sh -c contacts.txt -s John
```

Search a specific field:

```bash
./contact_management.sh -c contacts.txt -s example.com -S 3
```

### Edit Contacts

Edit by search term:

```bash
./contact_management.sh -c contacts.txt -E John -f Jonathan
```

Edit by ID:

```bash
./contact_management.sh -c contacts.txt -E -N 1 -f Jonathan
```

## Command-Line Options

| Option | Description            |
| ------ | ---------------------- |
| `-c`   | Contact file           |
| `-i`   | Insert a new contact   |
| `-p`   | Print contacts         |
| `-s`   | Search contacts        |
| `-E`   | Edit contacts          |
| `-f`   | First name             |
| `-l`   | Last name              |
| `-e`   | Email address          |
| `-n`   | Phone number           |
| `-t`   | Category               |
| `-L`   | Display contact IDs    |
| `-S`   | Specify search field   |
| `-k`   | Sort by field          |
| `-N`   | Contact ID for editing |

## Field Numbers

The following field numbers can be used with `-S` and `-k`:

| Number | Field        |
| ------ | ------------ |
| 0      | All Fields   |
| 1      | First Name   |
| 2      | Last Name    |
| 3      | Email        |
| 4      | Phone Number |
| 5      | Category     |

## Validation

The script performs validation to help maintain data integrity:

* Email addresses must follow a valid email format
* Phone numbers must follow a valid phone number format
* Required arguments must be provided
* Invalid option combinations are rejected
* Contact records must follow the expected structure

## Project Structure

```text
.
├── .gitattributes
├── .gitignore
├── LICENSE
├── README.md
├── contact_management.sh
└── sample_contacts.txt
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.
