# -*- coding: utf-8 -*-
"""
Created on Fri Jan 27 23:55:14 2023

@author: nafir
"""



print("Enter Prime Number")

p = int(input())

E1 = int(input("Enter First Encryption Key "))
E2 = int(input("Enter Second Encryption Key "))
rint = int(input("Enter a random Number "))
message = int(input("Enter the message"))

print("Data encryption is happening")

C1 = pow(E1,rint,p)
C2 = message*pow(E2,rint,p)

print("The encrypted text are ",C1," ",C2)

C1 = str(C1)
C2 = str(C2)

lines_1 = [C1," ",C2]

with open ('enc.txt', 'w') as file:  
    for line_1 in lines_1:  
        file.writelines(line_1)