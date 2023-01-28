# -*- coding: utf-8 -*-
"""
Created on Sat Jan 28 00:04:30 2023

@author: nafir
"""
p = int(input("Enter the Prime Number "))
C1 = int(input("Enter First Cipher Text "))
C2 = int(input("Enter Second Cipher Text "))
x = int(input("Enter your Private Key "))

dec_msg = pow((pow(pow(C1, x),-1, p) * C2), 1, p)

dec_msg = str(dec_msg)

lines_1 = [dec_msg]

with open ('dec.txt', 'w') as file:  
    for line_1 in lines_1:  
        file.writelines(line_1)

print("Your decrypted text is : ",dec_msg)