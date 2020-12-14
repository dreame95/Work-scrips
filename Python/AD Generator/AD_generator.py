from random import randint

def generateAccount(numberOfUsers):
    accounts = []
    for i in range(int(numberOfUsers)):
        nameFirst = input("\nWhat is first name of new user: ")
        nameLast = input("What is the last name of new user: ")
        number = ''.join(str(randint(0,9)) for _ in range(4))

        account = nameLast[0:4] + nameFirst[0] + str(number)
        accounts.append(account)
    print("\n")
    print(accounts)



nameFirst = ''
nameLast = ''
number = 0
users = input("How many accounts need generated [Enter a number]: ")

generateAccount(users)

quit = input("\nPress 'Enter' to exit")