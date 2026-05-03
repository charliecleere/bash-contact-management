#!/bin/bash

insert_option="not included"
insert_chosen_count=0
print_option="not included"
print_chosen_count=0
search_option="not included"
search_chosen_count=0
search_term=""
edit_option="not included"
edit_chosen_count=0
edit_search_term=""
edit_argument="not included"
first_name_chosen_count=0
first_name=""
last_name_chosen_count=0
last_name=""
email_chosen_count=0
email=""
phone_number_chosen_count=0
phone_number=""
category_chosen_count=0
category=""
search_field_chosen_count=0
search_field_option="not included"
search_field_argument="not included"
search_field_num=0
id_chosen_count=0
id_option="not included"
id_argument="not included"
id=""
skip="false"
sort_option="not included"
sort_chosen_count=0
sort_field_num=3
display_id_chosen_count=0
display_id_option="not included"
file_option="not included"
file_chosen_count=0
file=""
temp_file=$(mktemp)

errors=()

while getopts ":ips:E:f:l:e:n:t:S:N:k:Lc:" opt; do
    case $opt in
        i)
            insert_option="included"
            ((insert_chosen_count++))
            if [[ insert_chosen_count -gt 1 ]]; then
                errors+=("Error: The -i (insert) option can only be used once.")
            fi
            ;;
        p)
            print_option="included"
            ((print_chosen_count++))
            if [[ print_chosen_count -gt 1 ]]; then
                errors+=("Error: The -p (print) option can only be used once.")
            fi
            ;;
        s)
            search_option="included"
            ((search_chosen_count++))
            if [[ search_chosen_count -gt 1 ]]; then
                errors+=("Error: The -s (search) option can only be used once.")
            fi
            # An if...else is used here so that when a user accidently makes the program store a flag in the $OPTARG, the 
            # flag won't be stored in search_term. Because of this, search_term will stay empty when this happens, and 
            # therefore, the no search results error (which happens later in the program) will work properly.
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing search term argument. Please provide the search term argument after the -s (search) option.")
                OPTIND=$((OPTIND - 1))
            else
                search_term=$OPTARG
            fi
            ;;
        E)
            edit_option="included"
            ((edit_chosen_count++))
            if [[ edit_chosen_count -gt 1 ]]; then
                errors+=("Error: The -E (edit) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                OPTIND=$((OPTIND - 1))
            else
                edit_argument="included"
                edit_search_term=$OPTARG
            fi
            ;;
        f)
            ((first_name_chosen_count++))
            if [[ first_name_chosen_count -gt 1 ]]; then
                errors+=("Error: The -f (first name) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing first name argument. Please provide the first name argument after the -f (first name) option.")
                OPTIND=$((OPTIND - 1))
            fi
            first_name=$OPTARG
            ;;
        l)
            ((last_name_chosen_count++))
            if [[ last_name_chosen_count -gt 1 ]]; then
                errors+=("Error: The -l (last name) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing last name argument. Please provide the last name argument after the -l (last name) option.")
                OPTIND=$((OPTIND - 1))
            fi
            last_name=$OPTARG
            ;;
        e)
            ((email_chosen_count++))
            if [[ email_chosen_count -gt 1 ]]; then
                errors+=("Error: The -e (email) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing email argument. Please provide the email argument after the -e (email) option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                errors+=("Error: Invalid email argument. Please provide a valid email argument after -e (email) option.")
            fi
            email=$OPTARG
            ;;
        n)
            ((phone_number_chosen_count++))
            if [[ phone_number_chosen_count -gt 1 ]]; then
                errors+=("Error: The -n (phone number) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing phone number argument. Please provide the phone number argument after the -n (phone number) option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
                errors+=("Error: Invalid phone number argument. Please provide a valid phone number argument after the -n (phone number) option. Use the format 123-456-7890.")
            fi
            phone_number=$OPTARG
            ;;
        t)
            ((category_chosen_count++))
            if [[ category_chosen_count -gt 1 ]]; then
                errors+=("Error: The -t (category) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing category argument. Please provide the category argument after the -t (category) option.")
                OPTIND=$((OPTIND - 1))
            fi
            category=$OPTARG
            ;;
        S)
            search_field_option="included"
            ((search_field_chosen_count++))
            search_field_argument="included"
            if [[ search_field_chosen_count -gt 1 ]]; then
                errors+=("Error: The -S (search field) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing field number argument to search in. Please provide the field number argument after the -S (search field) option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[0-9]+$ || $OPTARG -lt 0 || $OPTARG -gt 5 ]]; then
                errors+=("Error: Invalid field number argument. Please provide a field number from 0 to 5 in the argument after the -S (search field) option.")
            fi
            # This is so that 0 is treated as all the fields and 1, 2, 3, 4, and 5 are treated as first name, last name, email, phone, and category, respectively
            if [[ ! $OPTARG == 0 ]]; then
                search_field_num=$((OPTARG + 1))
            else
                search_field_num=$OPTARG
            fi
            ;;
        N)
            id_option="included"
            ((id_chosen_count++))
            id_argument="included"
            if [[ id_chosen_count -gt 1 ]]; then
                errors+=("Error: The -N (ID number) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing ID number argument to edit. Please provide the ID number argument after the -N (ID number) option.")
                OPTIND=$((OPTIND - 1))
                skip="true"  # To skip a later error check
            fi
            id=$OPTARG
            ;;
        k)
            sort_option="included"
            ((sort_chosen_count++))
            if [[ sort_chosen_count -gt 1 ]]; then
                errors+=("Error: The -k (sort) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing field number argument to sort by. Please provide the field number argument after the -k (sort) option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[0-9]+$ || $OPTARG -lt 0 || $OPTARG -gt 5 ]]; then
                errors+=("Error: Invalid field number argument. Please provide a field number from 0 to 5 in the argument after the -k (sort) option.")
            fi
            sort_field_num=$((OPTARG + 1))
            ;;
        L)
            display_id_option="included"
            ((display_id_chosen_count++))
            if [[ display_id_chosen_count -gt 1 ]]; then
                errors+=("Error: The -L (display IDs) option can only be used once.")
            fi
            ;;
        c)  
            file_option="included"
            ((file_chosen_count++))
            if [[ file_chosen_count -gt 1 ]]; then
                errors+=("Error: The -c (contacts file) option can only be used once.")
            fi
            if [[ "$OPTARG" =~ ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing contacts file argument. Please provide the name of the contacts file in the argument after the -c (contacts file) option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! -f "$OPTARG" ]]; then
                errors+=("Error: File does not exist. Please provide a valid file name in the argument after the -c (contacts file) option.")
            fi
            file=$OPTARG
            ;;  
        :)
            case $OPTARG in
                s)
                    search_option="included"
                    ((search_chosen_count++))
                    if [[ search_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -s (search) option can only be used once.")
                    fi
                    errors+=("Error: Missing search term argument. Please provide the search term argument after the -s (search) option.")
                    ;;
                E)
                    edit_option="included"
                    ((edit_chosen_count++))
                    if [[ edit_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -E (edit) option can only be used once.")
                    fi
                    errors+=("Error: Missing edit search term argument. Please provide the edit search term argument after the -E (edit) option.")
                    ;;
                f)
                    ((first_name_chosen_count++))
                    if [[ first_name_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -f (first name) option can only be used once.")
                    fi
                    errors+=("Error: Missing first name argument. Please provide the first name argument after the -f (first name) option.")
                    ;;
                l)
                    ((last_name_chosen_count++))
                    if [[ last_name_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -l (last name) option can only be used once.")
                    fi
                    errors+=("Error: Missing last name argument. Please provide the last name argument after the -l (last name) option.")
                    ;;
                e)
                    ((email_chosen_count++))
                    if [[ email_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -e (email) option can only be used once.")
                    fi
                    errors+=("Error: Missing email argument. Please provide the email argument after the -e (email) option.")
                    ;;
                n)
                    ((phone_number_chosen_count++))
                    if [[ phone_number_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -n (phone number) option can only be used once.")
                    fi 
                    errors+=("Error: Missing phone number argument. Please provide the phone number argument after the -n (phone number) option.")
                    ;;
                t)
                    ((category_chosen_count++))
                    if [[ category_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -t (category) option can only be used once.")
                    fi
                    errors+=("Error: Missing category argument. Please provide the category argument after the -t (category) option.")
                    ;;
                S)
                    search_field_option="included"
                    ((search_field_chosen_count++))
                    if [[ search_field_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -S (search field) option can only be used once.")
                    fi
                    errors+=("Error: Missing field number argument to search in. Please provide the field number argument after the -S (search field) option.")
                    ;;
                N)
                    id_option="included"
                    ((id_chosen_count++))
                    if [[ id_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -N (ID number) option can only be used once.")
                    fi
                    errors+=("Error: Missing ID number argument to edit. Please provide the ID number argument after the -N (ID number) option.")
                    ;;
                k)
                    sort_option="included"
                    ((sort_chosen_count++))
                    if [[ sort_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -k (sort) option can only be used once.")
                    fi
                    errors+=("Error: Missing field number argument to sort by. Please provide the field number argument after the -k (sort) option.")
                    ;;
                c)
                    file_option="included"
                    ((file_chosen_count++))
                    if [[ file_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -c (contacts file) option can only be used once.")
                    fi
                errors+=("Error: Missing contacts file argument. Please provide the name of the contacts file in the argument after the -c (contacts file) option.")
                    ;;
            esac
            ;;
        \?)
            errors+=("Error: -$OPTARG is an invalid option.")  # Maybe, as a second sentence in the error message, add something like "Use -h for help." if you add a instruction manual.
            ;;
    esac
done

if [[ $file_option != "included" ]]; then 
    errors+=("Error: A contacts file is required. Please include the -c (contacts file) option followed by the argument with the name of a contacts file.")
fi

if (( insert_chosen_count + print_chosen_count + search_chosen_count + edit_chosen_count != 1 )); then
    errors+=("Error: Exactly one of the following is required: the -i (insert), -p (print), -s (search), or -E (edit) option.")
fi

if [[ $insert_option == "included" && (-z $first_name || -z $last_name || -z $email || -z $phone_number || -z $category) ]]; then
    errors+=("Error: The -i (insert) option requires the -f (first name), -l (last name), -e (email), -n (phone number), and -t (category) options.")
fi

if [[ $search_field_option == "not included" && $file_chosen_count -eq 1 && ! -z $search_term && -f "$file" ]] && ! grep -q "$search_term" "$file"; then
    errors+=("Error: No search results found for the argument you provided after the -s (search) option.")
fi

if [[ $search_field_option == "included" && $file_chosen_count -eq 1 && ! -z $search_term && -f "$file" ]] && ! awk -F ':' -v search_field_num="$search_field_num" '{print $search_field_num}' "$file" | grep -q "$search_term"; then
    errors+=("Error: No search results found in your specified field for the argument you provided after the -s (search) option.")
fi

if [[ $search_field_argument == "not included" && $file_chosen_count -eq 1 && ! -z $edit_search_term && -f "$file" ]] && ! grep -q "$edit_search_term" "$file"; then
    errors+=("Error: No search results found for the argument you provided after the -E (edit) option.")
fi

if [[ $search_field_argument == "included" && $file_chosen_count -eq 1 && ! -z $edit_search_term && -f "$file" ]] && ! awk -F ':' -v search_field_num="$search_field_num" '{print $search_field_num}' "$file" | grep -q "$edit_search_term"; then
    errors+=("Error: No search results found in your specified field for the argument you provided after the -E (edit) option.")
fi

if [[ $sort_option == "included" && ($insert_option == "included" || $edit_option == "included") ]]; then
    errors+=("Error: The -k (sort) option is not allowed to be used with the -i (insert) or -E (edit) option.")
fi

if [[ $display_id_option == "included" && ! ($print_option == "included" || $search_option == "included") ]]; then
    errors+=("Error: The -L (display IDs) option must be used with either the -p (print) or -s (search) option.")
fi

if [[ $edit_option == "included" ]] && (( $first_name_chosen_count + $last_name_chosen_count + $email_chosen_count + $phone_number_chosen_count + $category_chosen_count != 1 )); then
    errors+=("Error: The -E (edit) option must be used with exactly one of the following: the -f (first name), -l (last name), -e (email), -n (phone number), or -t (category) option.")
fi

if [[ $id_argument == "included" && $skip != "true" && $file_chosen_count -eq 1 && -f "$file" ]] && ! grep -q "^$id:" "$file"; then
    errors+=("Error: The ID argument you provided after the -N (ID number) option was not found.")
fi

if [[ $id_option == "included" && $edit_option == "not included" ]]; then
    errors+=("Error: The -N (ID number) option must be used with the -E (edit) option.")
fi

if [[ $search_field_option == "included" && $id_option == "included" ]]; then
    errors+=("Error: The -S (search field) option cannot be used with the -N (ID number) option.")
fi

if [[ $search_field_option == "included" && ! ($search_option == "included" || $edit_option == "included") ]]; then
    errors+=("Error: The -S (search field) option must be used with either the -s (search) or -E (edit) option.")
fi

if [[ $edit_option == "included" && $edit_argument == "not included" && $search_field_option == "included" ]]; then
    errors+=("Error: When the -S (search field) option is used, the -E (edit) option must include an argument after it.")
fi

if [[ $edit_option == "included" && $edit_argument == "included" && $id_option == "included" ]]; then
    errors+=("Error: When the -N (ID number) option is used, the -E (edit) option cannot include an argument after it.")
fi

if [[ $edit_option == "included" && $edit_argument == "not included" && $id_option == "not included" ]]; then
    errors+=("Error: When the -E (edit) option is used without the -N (ID number) option, it must include an argument after it.")
fi

if [[ ! -z $edit_search_term && $search_field_argument == "not included" && $file_chosen_count -eq 1 && -f "$file" ]] && (( $(grep -c "$edit_search_term" "$file") > 1 )); then
    errors+=("Error: The edit search term after the -E (edit) option matched more than one contact.")
fi

if [[ ! -z $edit_search_term && $search_field_argument == "included" && $file_chosen_count -eq 1 && -f "$file" ]] && (( $(awk -F ':' -v search_field_num="$search_field_num" '{print $search_field_num}' "$file" | grep -c "$edit_search_term") > 1 )); then
    errors+=("Error: The edit search term after the -E (edit) option matched more than one contact within the specified field.")
fi

# So the user cannot break the file format
if [[ "$first_name$last_name$email$phone_number$category" == *:* ]]; then
    errors+=("Error: Contact fields cannot contain colons.")
fi

if [[ ($print_option == "included" || $search_option == "included") && ($first_name_chosen_count -gt 0 || $last_name_chosen_count -gt 0 || $email_chosen_count -gt 0 || $phone_number_chosen_count -gt 0 || $category_chosen_count -gt 0) ]]; then
    errors+=("Error: The -f (first name), -l (last name), -e (email), -n (phone number), and -t (category) options can only be used with the -i (insert) or -E (edit) option.")
fi

if [[ ${#errors[@]} -ne 0 ]]; then
    for error in "${errors[@]}"; do
        echo "$error"
    done
    exit 1
fi

if [[ $insert_option == "included" ]]; then
    max_id=$(cut -d ':' -f 1 "$file" | sort -n | tail -1)
    new_id=$((max_id + 1))
    echo "${new_id}:${first_name}:${last_name}:${email}:${phone_number}:${category}" >> "$file"
elif [[ $print_option == "included" ]]; then
    if [[ $display_id_option == "not included" ]]; then
        sort -t ':' -k "$sort_field_num" "$file" | awk '
        BEGIN {
            FS=":"
            print "CONTACT RECORDS"
            for (i = 0; i < 106; i++) printf "-"
            printf "\n"
            printf "%-30s%-45s%-16s%-15s\n", "Name", "Email", "Phone Number", "Category"
            for (i = 0; i < 106; i++) printf "-"
            printf "\n"
        }
        {
            printf "%-30s%-45s%-16s%-15s\n", $2" "$3, $4, $5, $6
        }
        '
    else
        sort -t ':' -k "$sort_field_num" "$file" | awk '
        BEGIN {
            FS=":"
            print "CONTACT RECORDS"
            for (i = 0; i < 111; i++) printf "-"
            printf "\n"
            printf "%-5s%-30s%-45s%-16s%-15s\n", "ID", "Name", "Email", "Phone Number", "Category"
            for (i = 0; i < 111; i++) printf "-"
            printf "\n"
        }
        {
            printf "%-5s%-30s%-45s%-16s%-15s\n", $1, $2" "$3, $4, $5, $6
        }
        '
    fi
elif [[ $search_option == "included" ]]; then
    if [[ $display_id_option == "not included" ]]; then
        sort -t ':' -k "$sort_field_num" "$file" | awk -v search_term="$search_term" -v search_field_num=$search_field_num '
        BEGIN {
            FS=":"
            print "CONTACT RECORDS"
            for (i = 0; i < 106; i++) printf "-"
            printf "\n"
            printf "%-30s%-45s%-16s%-15s\n", "Name", "Email", "Phone Number", "Category"
            for (i = 0; i < 106; i++) printf "-"
            printf "\n"
        }
        $search_field_num ~ search_term {
            printf "%-30s%-45s%-16s%-15s\n", $2" "$3, $4, $5, $6
        }
        '
    else
        sort -t ':' -k "$sort_field_num" "$file" | awk -v search_term="$search_term" -v search_field_num=$search_field_num '
        BEGIN {
            FS=":"
            print "CONTACT RECORDS"
            for (i = 0; i < 111; i++) printf "-"
            printf "\n"
            printf "%-5s%-30s%-45s%-16s%-15s\n", "ID", "Name", "Email", "Phone Number", "Category"
            for (i = 0; i < 111; i++) printf "-"
            printf "\n"
        }
        $search_field_num ~ search_term {
            printf "%-5s%-30s%-45s%-16s%-15s\n", $1, $2" "$3, $4, $5, $6
        }
        '
    fi
elif [[ $edit_option == "included" ]]; then
    if (( $first_name_chosen_count == 1 )); then
        field_to_edit=2
        edit_replacement=$first_name
    elif (( $last_name_chosen_count == 1 )); then
        field_to_edit=3
        edit_replacement=$last_name
    elif (( $email_chosen_count == 1 )); then
        field_to_edit=4
        edit_replacement=$email
    elif (( $phone_number_chosen_count == 1 )); then
        field_to_edit=5
        edit_replacement=$phone_number
    elif (( $category_chosen_count == 1 )); then
        field_to_edit=6
        edit_replacement=$category
    fi

    if [[ $id_option == "included" ]]; then
        awk -v id="$id" -v edit_replacement="$edit_replacement" -v field_to_edit="$field_to_edit" '
        BEGIN {
            FS=":"
            OFS=":"
        }
        $1 == id {
            $field_to_edit = edit_replacement
        }
        { print }
        ' "$file" > "$temp_file" && mv "$temp_file" "$file"
    else
        awk -v search_field_num="$search_field_num" -v edit_search_term="$edit_search_term" -v edit_replacement="$edit_replacement" -v field_to_edit="$field_to_edit" '
        BEGIN {
            FS=":"
            OFS=":"
        }
        $search_field_num ~ edit_search_term {
            $field_to_edit = edit_replacement
        }
        { print }
        ' "$file" > "$temp_file" && mv "$temp_file" "$file"
    fi
fi