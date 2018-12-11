a = []
a[0], a[1], a[2], a[3] = input().split();
for x in range(3, -1): 
	b = int(a[x], 16)
	c = int(b, 2)
	print(c)