# Import sys module
import sys

# Total number of arguments
print('Total arguments:', len(sys.argv))

#print("Argument values are:")
# Iterate command-line arguments using for loop
#for i in sys.argv:
  #print(i)

# Define a dictionary
customers = {'9876':'Kamal Perera','9873':'Amal Fernando',
'9865':'Vimal Gunasena','9843':'Chamal Sirisena', '9862':'Dumal Zoysa',
'9831':'Nimal Walpola'}

#print("The customer names are:")
# Print the values of the dictionary
#for customer in customers:
    #print(customers[customer])

# Take customer ID as input to search
print("Search customer ID:",sys.argv[1])
name = sys.argv[1]
# Search the ID in the dictionary
for customer in customers:
    if customer == name:
        print(customers[customer])
        break