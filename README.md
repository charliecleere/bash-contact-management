# bash-contact-management

A robust command-line contact management system written in Bash. Easily add, search, edit, and display contacts stored in a text file with a clean, formatted output.

## Features

- **Add Contacts**: Insert new contacts with first name, last name, email, phone number, and category
- **Search**: Find contacts by any field or search across all fields
- **Display**: View all contacts in a formatted table, optionally with ID numbers
- **Edit**: Modify existing contacts by ID or search term
- **Sort**: Display contacts sorted by any field
- **Field-Specific Search**: Search within specific contact fields
- **Input Validation**: Built-in validation for emails, phone numbers, and required fields

## Requirements

- Bash 4.0+
- Unix/Linux environment (macOS compatible)
- Write access to your contacts file

## Installation

1. Clone the repository:
```bash
git clone https://github.com/charliecleere/bash-contact-management.git
cd bash-contact-management
```

2. Make the script executable:
```bash
chmod +x contact_management.sh
```

3. Create a contacts file (or use an existing one):
```bash
touch my_contacts.txt
```

## Usage

The script uses command-line flags to perform different operations. All commands require the `-c` flag to specify the contacts file.

### Basic Syntax
```bash
./contact_management.sh -c <file> [operation] [options]
```

### Operations

#### Add a Contact
```bash
./contact_management.sh -c my_contacts.txt -i -f John -l Doe -e john.doe@email.com -n 555-123-4567 -t Friends
```
- `-i`: Insert mode
- `-f`: First name (required)
- `-l`: Last name (required)
- `-e`: Email (required, must be valid format)
- `-n`: Phone number (required, format: XXX-XXX-XXXX)
- `-t`: Category (required)

#### Display All Contacts
```bash
./contact_management.sh -c my_contacts.txt -p
```
- `-p`: Print mode (displays all contacts)
- `-L`: (Optional) Include ID numbers in output
- `-k <field>`: (Optional) Sort by field number (1-5)

#### Search Contacts
```bash
./contact_management.sh -c my_contacts.txt -s "john"
```
- `-s <term>`: Search for term across all fields
- `-S <field>`: (Optional) Limit search to specific field (0=all, 1=first name, 2=last name, 3=email, 4=phone, 5=category)
- `-L`: (Optional) Include ID numbers in output

#### Edit a Contact
```bash
# Edit by search term
./contact_management.sh -c my_contacts.txt -E "John" -f "Jonathan"

# Edit by ID
./contact_management.sh -c my_contacts.txt -E -N 1 -f "Jonathan"
```
- `-E <term>`: Edit mode with search term (or no argument with `-N`)
- `-N <id>`: Edit by ID number instead of search term
- `-f`, `-l`, `-e`, `-n`, `-t`: Choose which field to edit (must specify exactly one)
- `-S <field>`: (Optional) Limit search to specific field

### Field Numbers for Sorting/Searching
- `0`: All fields
- `1`: First name
- `2`: Last name
- `3`: Email
- `4`: Phone number
- `5`: Category

## Examples

### Add multiple contacts
```bash
./contact_management.sh -c contacts.txt -i -f Alice -l Smith -e alice@example.com -n 555-111-2222 -t Work
./contact_management.sh -c contacts.txt -i -f Bob -l Johnson -e bob@example.com -n 555-333-4444 -t Friends
```

### View all contacts sorted by last name
```bash
./contact_management.sh -c contacts.txt -p -k 2 -L
```

### Search for a contact
```bash
./contact_management.sh -c contacts.txt -s "alice" -L
```

### Search only in email field
```bash
./contact_management.sh -c contacts.txt -s "example.com" -S 3
```

### Edit a contact by ID
```bash
./contact_management.sh -c contacts.txt -E -N 1 -e newemail@example.com
```

### Edit a contact by name search
```bash
./contact_management.sh -c contacts.txt -E "Alice" -t "Personal"
```

## Contact File Format

Contacts are stored in a colon-delimited text format:
```
ID:FirstName:LastName:Email:PhoneNumber:Category
1:John:Doe:john.doe@example.com:555-123-4567:Work
2:Jane:Smith:jane.smith@example.com:555-987-6543:Friends
```

**Important**: Contact fields cannot contain colons.

## Error Handling

The script includes comprehensive error checking for:
- Missing required arguments
- Invalid email format
- Invalid phone number format (must be XXX-XXX-XXXX)
- Invalid field numbers
- Duplicate operation flags
- Missing contacts file
- Multiple search results when expecting one

## Tips & Tricks

- **Default sort**: Without `-k`, contacts are sorted by first name (field 1)
- **Show IDs**: Use `-L` flag with `-p` or `-s` to see contact ID numbers (useful for editing)
- **Case-sensitive search**: Searches are case-sensitive; use lowercase for broader matches
- **Backup your contacts**: Keep a backup copy of your contacts file before bulk edits

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Feel free to submit issues or pull requests to improve this contact management tool.
