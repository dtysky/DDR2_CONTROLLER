fo=open('textfile.dat','w')

so=""

for i in range(512):
	tmp=bin(i)[2:]
	if len(tmp)<16:
		for j in range(16-len(tmp)):
			so+="0";
		so+=tmp+'\n';
	else:
		so+=(tmp+'\n')


fo.write(so)
fo.flush()
fo.close()