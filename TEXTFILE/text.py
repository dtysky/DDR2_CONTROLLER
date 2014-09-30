import random

fo=open('../textfile_r.dat','w')

so=""

for index in range (10):
	#bank
	tmp=bin(random.randint(0,7))[2:]
	if len(tmp)<3:
		for j in range(3-len(tmp)):
			so+="0";
		so+=tmp+'\n';
	else:
		so+=(tmp+'\n')
	tmp=bin(random.randint(0,1023))[2:]
	if len(tmp)<10:
		for j in range(10-len(tmp)):
			so+="0";
		so+=tmp+'\n';
	else:
		so+=(tmp+'\n')
	tmp=bin(random.randint(0,8191))[2:]
	if len(tmp)<13:
		for j in range(13-len(tmp)):
			so+="0";
		so+=tmp+'\n';
	else:
		so+=(tmp+'\n')
	for i in range(512):
		tmp=bin(random.randint(0,65534))[2:]
		if len(tmp)<16:
			for j in range(16-len(tmp)):
				so+="0";
			so+=tmp+'\n';
		else:
			so+=(tmp+'\n')
	#the end of one frame
	so+="1111111111111111\n"

fo.write(so)
fo.flush()
fo.close()