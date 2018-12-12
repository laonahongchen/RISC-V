a = [0,0,0,0]
(a[0], a[1], a[2], a[3]) = input().split();
a.reverse()
#print(a[1])
for x in range(4): 
	#print(x)
	#print(a[x])
	b = int(a[x], 16)
	#print(b)
	#c = int(str(b), 2)
	print('{:08b}'.format(b), end="")