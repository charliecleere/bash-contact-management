#!/bin/bash

insert_option="not included"
insert_chosen_count=0
print_option="not included"
print_chosen_count=0
search_option="not included"
search_chosen_count=0
search_term=""
first_name_chosen_count=0
first_name=""
last_name_chosen_count=0
last_name=""
email_chosen_count=0
email=""
phone_number_chosen_count=0
phone_number=""
sort_option="not included"
sort_chosen_count=0
field_num=2
file_option="not included"
file_chosen_count=0
file=""

errors=()

while getopts ":ips:f:l:e:n:k:c:" opt; do
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
            # An if...else is used here so that when a user accidently makes the program store a flag in the $OPTARG, the flag won't be stored in search_term. Because of this, search_term will stay empty when this happens, and therefore, the no search results error (which happens later in the program) will work properly.
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing search term. Please provide the search term after the -s option.")
                OPTIND=$((OPTIND - 1))
            else
                search_term=$OPTARG
            fi
            ;;
        f)
            ((first_name_chosen_count++))
            if [[ first_name_chosen_count -gt 1 ]]; then
                errors+=("Error: The -f (first name) option can only be used once.")
            fi
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing first name. Please provide the first name after the -f option.")
                OPTIND=$((OPTIND - 1))
            fi
            first_name=$OPTARG
            ;;
        l)
            ((last_name_chosen_count++))
            if [[ last_name_chosen_count -gt 1 ]]; then
                errors+=("Error: The -l (last name) option can only be used once.")
            fi
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing last name. Please provide the last name after the -l option.")
                OPTIND=$((OPTIND - 1))
            fi
            last_name=$OPTARG
            ;;
        e)
            ((email_chosen_count++))
            if [[ email_chosen_count -gt 1 ]]; then
                errors+=("Error: The -e (email) option can only be used once.")
            fi
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing email address. Please provide the email address after the -e option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                errors+=("Error: Invalid email address. Please provide a valid email address after -e option.")
            fi
            email=$OPTARG
            ;;
        n)
            ((phone_number_chosen_count++))
            if [[ phone_number_chosen_count -gt 1 ]]; then
                errors+=("Error: The -n (phone number) option can only be used once.")
            fi
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing phone number. Please provide the phone number after the -n option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
                errors+=("Error: Invalid phone number. Please provide a valid phone number after the -n option. Use the format 123-456-7890.")
            fi
            phone_number=$OPTARG
            ;;
        k)
            ((sort_chosen_count++))
            if [[ sort_chosen_count -gt 1 ]]; then
                errors+=("Error: The -k (sort) option can only be used once.")
            fi
            sort_option="included"
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing field number to sort by. Please provide the field number after the -k option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! "$OPTARG" =~ ^[0-9]+$ || $OPTARG -lt 1 || $OPTARG -gt 4 ]]; then
                errors+=("Error: Invalid field number. Please provide a number from 1 to 4 after the -k option.")
            fi
            field_num=$OPTARG
            ;;
        c)  
            ((file_chosen_count++))
            if [[ file_chosen_count -gt 1 ]]; then
                errors+=("Error: The -c (contacts file) option can only be used once.")
            fi
            file_option="included"
            if [[ "$OPTARG" == ^-[a-zA-Z]$ ]]; then
                errors+=("Error: Missing contacts file. Please provide the name of the contacts file after the -c option.")
                OPTIND=$((OPTIND - 1))
            elif [[ ! -f "$OPTARG" ]]; then
                errors+=("Error: File does not exist. Please provide a valid file name after the -c option.")
            fi
            file=$OPTARG
            ;;  
        :)
            case $OPTARG in
                s)
                    ((search_chosen_count++))
                    if [[ search_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -s (search) option can only be used once.")
                    fi
                    errors+=("Error: Missing search term. Please provide the search term after the -s option.")
                    ;;
                f)
                    ((first_name_chosen_count++))
                    if [[ first_name_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -f (first name) option can only be used once.")
                    fi
                    errors+=("Error: Missing first name. Please provide the first name after the -f option.")
                    ;;
                l)
                    ((last_name_chosen_count++))
                    if [[ last_name_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -l (last name) option can only be used once.")
                    fi
                    errors+=("Error: Missing last name. Please provide the last name after the -l option.")
                    ;;
                e)
                    ((email_chosen_count++))
                    if [[ email_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -e (email) option can only be used once.")
                    fi
                    errors+=("Error: Missing email address. Please provide the email address after the -e option.")
                    ;;
                n)
                    ((phone_number_chosen_count++))
                    if [[ phone_number_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -n (phone number) option can only be used once.")
                    fi 
                    errors+=("Error: Missing phone number. Please provide the phone number after the -n option.")
                    ;;
                k)
                    ((sort_chosen_count++))
                    if [[ sort_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -k (sort) option can only be used once.")
                    fi
                    sort_option="included"
                    errors+=("Error: Missing field number to sort by. Please provide the field number after the -k option.")
                    ;;
                c)
                    ((file_chosen_count++))
                    if [[ file_chosen_count -gt 1 ]]; then
                        errors+=("Error: The -c (contacts file) option can only be used once.")
                    fi
                    file_option="included"
                    errors+=("Error: Missing contacts file. Please provide the name of the contacts file after the -c option.")
                    ;;
            esac
            ;;
        /?)
            errors+=("Error: -$OPTARG is an invalid option.")  # Maybe, as a second sentence in the error message, add something like "Use -h for help." if you add a instruction manual.
            ;;
    esac
done

if [[ $file_option != "included" ]]; then 
    errors+=("Error: A contacts file is required. Please include the -c option followed by the name of a contacts file.")
fi

if (( insert_chosen_count + print_chosen_count + search_chosen_count != 1 )); then
    errors+=("Error: Exactly one option is required: -i (insert), -p (print), or -s (search).")
fi

if [[ $insert_option == "included" && (-z $first_name || -z $last_name || -z $email || -z $phone_number) ]]; then
    errors+=("Error: The -i (insert) option requires -f (first name), -l (last name), -e (email), and -n (phone number).")
fi

if [[ $file_chosen_count -eq 1 && ! -z $search_term && -f $file ]] && ! grep -q "$search_term" "$file"; then
    errors+=("Error: No search results found for the term you provided after the -s option.")
fi

if [[ $sort_option == "included" && $insert_option == "included" ]]; then
    errors+=("Error: The -k (sort) option is not allowed to be used with the -i (insert) option.")
fi

if [[ ${#errors[@]} -ne 0 ]]; then
    for error in "${errors[@]}"; do
        echo "$error"
    done
    exit 1
fi

if [[ $insert_option == "included" ]]; then
    echo "${first_name}:${last_name}:${email}:${phone_number}" >> $file
elif [[ $print_option == "included" ]]; then
    sort -t ':' -k $field_num $file | awk '
    BEGIN {
        FS=":"
        print "CONTACT RECORDS"
        for (i = 0; i < 89; i++) printf "-"
        printf "\n"
        printf "%-30s %-45s %-12s\n", "Name", "Email", "Phone Number"
        for (i = 0; i < 89; i++) printf "-"
        printf "\n"
    }
    {
        printf "%-30s %-45s %-12s\n", $1" "$2, $3, $4
    }
    '
elif [[ $search_option == "included" ]]; then
    sort -t ':' -k $field_num $file | awk -v search_term="$search_term" '
    BEGIN {
        FS=":"
        print "CONTACT RECORDS"
        for (i = 0; i < 89; i++) printf "-"
        printf "\n"
        printf "%-30s %-45s %-12s\n", "Name", "Email", "Phone Number"
        for (i = 0; i < 89; i++) printf "-"
        printf "\n"
    }
    $0 ~ search_term { 
        printf "%-30s %-45s %-12s\n", $1" "$2, $3, $4
    }
    '
fi