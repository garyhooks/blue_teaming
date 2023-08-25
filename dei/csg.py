import webbrowser

def main():

    part_one_url = "https://portal.cybersixgill.com/#/search?q=(%20%22"
    part_two_url = "%22)"
    part_three_url = "&dateRange=%3C01%2F01%2F2023%3E-%3C08%2F15%2F2023%3E&org=6113e0e5d5cf5ed48f54bd56"

    with open("users.txt") as email_list:
        for e in email_list:
            email = e.strip()
            full_url = part_one_url + email + part_two_url + part_three_url
            webbrowser.open_new(full_url)

if __name__ == "__main__":
    main()
