# -*- coding: utf-8 -*-
"""
Created on Sun Feb 12 20:15:51 2023

@author: nafir
"""

print("Enter Prime Number")

p = int(input())

print("Enter Primitive Element")

g = int(input())

E1 = g

print("So your First Encryption key is : ",E1)

x = int(input("Enter your secret key "))

E2 = pow(E1,x,p)

print("Your second Encryption key is : ",E2)

E1 = str(E1)
E2 = str(E2)

lines_1 = [E1," ",E2]

with open ('key.txt', 'w') as file:  
    for line_1 in lines_1:  
        file.writelines(line_1)