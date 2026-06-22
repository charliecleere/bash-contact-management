# Bash Contact Management

A simple command-line contact manager written in Bash. It lets you add, view, search, sort, and edit contacts stored in a colon-delimited text file.

## Features

* Add new contacts
* View all contacts in a formatted table
* Search contacts across all fields or within a specific field
* Edit a contact by ID or by search term
* Sort output by any field
* Validate email addresses and phone numbers

## Requirements

* Bash 4.0 or later
* A Unix-like environment (Linux, macOS, or WSL on Windows)
* Write access to the contacts file

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

2. Make the script executable:

```bash
chmod +x contact_management.sh
```

3. Use a contacts file.

If you are using the included sample file, keep it as a fake-data example only. For your own local data, create a separate file such as `contacts.txt`.

## Usage

All commands require the `-c` option to specify the contacts file.

### Basic syntax

```bash
./contact_management.sh -c <file> [operation] [options]
```

### Add a contact

```bash
./contact_management.sh -c contacts.txt -i -f John -l Doe -e john.doe@email.com -n 555-123-4567 -t Friends
```

Options:

* `-i` insert mode
* `-f` first name
* `-l` last name
* `-e` email
* `-n` phone number
* `-t` category

### Print all contacts

```bash
./contact_management.sh -c contacts.txt -p
```

Optional print options:

* `-L` show ID numbers
* `-k <field>` sort by field number

### Search contacts

```bash
./contact_management.sh -c contacts.txt -s john
```

Optional search options:

* `-S <field>` search within one field only
* `-L` show ID numbers

### Edit a contact

Edit by search term:

```bash
./contact_management.sh -c contacts.txt -E John -f Jonathan
```

Edit by ID:

```bash
./contact_management.sh -c contacts.txt -E -N 1 -f Jonathan
```

Edit options:

* `-E` edit mode
* `-N <id>` edit by ID instead of search term
* Use exactly one of `-f`, `-l`, `-e`, `-n`, or `-t` to choose the field to change
* `-S <field>` limit the search to a specific field

## Field numbers

Use these field numbers with `-S` and `-k`:

* `0` all fields
* `1` first name
* `2` last name
* `3` email
* `4` phone number
* `5` category

## Contact file format

The contact file uses this format:

```text
ID:FirstName:LastName:Email:PhoneNumber:Category
1:John:Doe:john.doe@example.com:555-123-4567:Work
2:Jane:Smith:jane.smith@example.com:555-987-6543:Friends
```

Important:

* Fields cannot contain colons (`:`)
* Each contact must follow the same six-part structure

## Examples

Print sorted by last name with IDs:

```bash
./contact_management.sh -c contacts.txt -p -k 2 -L
```

Search only in email addresses:

```bash
./contact_management.sh -c contacts.txt -s example.com -S 3
```

Edit a category by ID:

```bash
./contact_management.sh -c contacts.txt -E -N 1 -t Work
```

## Notes

* Search is case-sensitive
* The script expects one main operation at a time: `-i`, `-p`, `-s`, or `-E`
* Keep a backup of your contacts file before making large changes

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
