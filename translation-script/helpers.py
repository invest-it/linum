import json


def continue_translating() -> bool:
    user_input = input("Continue translating? (yes/no): ")
    if user_input.upper() == "NO" or user_input.upper() == "N":
        print("Exiting without translating..")
        return False

    if user_input.upper() == "YES" or user_input.upper() == "Y":
        print("Continuing..")
        return True

    else:
        print("Please enter yes or no.")
        return continue_translating()
